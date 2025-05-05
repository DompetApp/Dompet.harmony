import { Empty } from "../utils/empty"
import { logger } from "../tracks/logger"
import { webSocket } from "@kit.NetworkKit"
import { connection } from "@kit.NetworkKit"
import { AppConnect } from "../globals/define"
import { CtxManager } from "../configure/context"
import { persistent } from "../configure/persistent"
import { ISocketSubscribe } from "../models/socket"
import { SocketSubscribe } from "../models/socket"
import { SocketCallback } from "../models/socket"


export class Socketor {
  static net: connection.NetConnection = connection.createNetConnection()
  static web: webSocket.WebSocket | null = null
  static queues: ISocketSubscribe[] = []
  static network: boolean = false
  static created: boolean = false
  static showed: boolean = false
  static pinged: boolean = false
  static enable: boolean = false
  static times: number = 5000
  static timer: number = -1
  static pings: number = 0

  static async init() {
    Socketor.NetWatcher()
    Socketor.StageWatcher()
  }

  static async start() {
    clearTimeout(Socketor.timer)

    Socketor.timer = setTimeout(Socketor.start, Socketor.times)

    if (!Socketor.enable) {
      return
    }

    if (!Socketor.network) {
      return
    }

    if (!Socketor.showed) {
      return
    }

    if (!Socketor.created) {
      await Socketor.connectWebSocket().catch(Empty.fn)
      Socketor.times = 5000
      Socketor.pings = 0
    }

    if (Socketor.created) {
      if (Socketor.pinged) {
        Socketor.times = 5000
        Socketor.pings = 0
      }

      if (!Socketor.pinged) {
        Socketor.pings++
        Socketor.times = 1000

        if (Socketor.pings > 3) {
          Socketor.times = 5000
          Socketor.pings = 0
        }
      }

      Socketor.web?.send(JSON.stringify({
        type: 'ping',
        data: null
      }))
    }
  }

  static async close() {
    return Socketor.closeWebSocket().catch(Empty.fn)
  }

  static async NetWatcher() {
    Socketor.net.register(Empty.fn)

    Socketor.net.on('netLost', (data: connection.NetHandle) => {
      if (data.netId >= 100) {
        Socketor.network = false
      }
    })

    Socketor.net.on('netAvailable', (data: connection.NetHandle) => {
      if (data.netId >= 100) {
        Socketor.network = true
        Socketor.start()
      }
    })

    Socketor.net.on('netUnavailable', () => {
      Socketor.network = false
    })
  }

  static async StageWatcher() {
    if (CtxManager.abilityContext) {
      CtxManager.abilityContext.getApplicationContext().on('abilityLifecycle', {
        onAbilityBackground: () => Socketor.showed = false,
        onAbilityForeground: () => {
          Socketor.showed = true
          Socketor.start()
        },
        onWindowStageInactive: Empty.fn,
        onWindowStageDestroy: Empty.fn,
        onWindowStageActive: Empty.fn,
        onWindowStageCreate: Empty.fn,
        onAbilityContinue: Empty.fn,
        onAbilityDestroy: Empty.fn,
        onAbilityCreate: Empty.fn,
      })
    }
  }

  static async resetWebSocket() {
    clearTimeout(Socketor.timer)

    if (Socketor.web) {
      Socketor.web.off('open')
      Socketor.web.off('close')
      Socketor.web.off('error')
      Socketor.web.off('message')
      await Socketor.web.close().catch(Empty.fn)
    }

    Socketor.created = false
    Socketor.pinged = false
    Socketor.times = 5000
    Socketor.pings = 0
    Socketor.web = null

    Socketor.start()
  }

  static async closeWebSocket() {
    clearTimeout(Socketor.timer)

    if (Socketor.web) {
      Socketor.web.off('open')
      Socketor.web.off('close')
      Socketor.web.off('error')
      Socketor.web.off('message')
      await Socketor.web.close().catch(Empty.fn)
    }

    Socketor.created = false
    Socketor.pinged = false
    Socketor.enable = false
    Socketor.times = 5000
    Socketor.pings = 0
    Socketor.web = null
  }

  static async connectWebSocket() {
    if (Socketor.web) {
      await Socketor.closeWebSocket().catch(Empty.fn)
    }

    Socketor.web = webSocket.createWebSocket()
    Socketor.pings = 0
    Socketor.times = 5000
    Socketor.enable = true
    Socketor.pinged = false

    Socketor.web.on('error', (_: Unknown) => {
      if (Socketor.created) {
        Socketor.resetWebSocket().catch(Empty.fn)
      }
    })

    Socketor.web.on('open', async (error: Unknown, event: Recorder) => {
      if (error != undefined) {
        Socketor.resetWebSocket().catch(Empty.fn)
        return
      }

      Socketor.pings = 0
      Socketor.times = 5000
      Socketor.pinged = true
      Socketor.created = true
      await Socketor.notifySocketSubscribe('connected').catch(Empty.fn)
      await Socketor.start().catch(Empty.fn)
    })

    Socketor.web.on('close', async (error: Unknown, event: webSocket.CloseResult) => {
      if (error != undefined) {
        return
      }

      if (Socketor.created) {
        Socketor.resetWebSocket().catch(Empty.fn)
      }
    })

    Socketor.web.on('message', async (error: Unknown, event: string | ArrayBuffer) => {
      if (error != undefined) {
        return
      }

      try {
        let type: string | null = null
        let data: Unknown | null = null
        let json: Recorder | null = null

        if (typeof event === 'string') {
          json = JSON.parse(event)
          data = json?.data
          type = json?.type
        }

        switch (type) {
          case 'ping': {
            Socketor.pinged = data == 'success'
            break
          }
        }
      } catch (e) {
        logger.error(`Socketor.web onmessage: ${e}`)
      }
    })

    const header: Object = Object({ token: persistent.read<string>(AppConnect.ApiToken) })

    const promise = Socketor.web.connect(`${AppConnect.WssBaseUrl}`, { header: header })

    return promise.catch(Empty.fn)
  }

  static async notifySocketSubscribe(type: string, data?: Unknown) {
    for (const ref of Socketor.queues) {
      if (ref.type == type) {
        try {
          ref.callback(type, data)
        } catch {
          /* e */
        }
      }
    }
  }

  static async registerSocketSubscribe(type: string, callback: SocketCallback) {
    for (const ref of Socketor.queues) {
      if (ref.type == type && ref.callback == callback) {
        return
      }
    }

    Socketor.queues.push(new SocketSubscribe(type, callback))
  }

  static async unregisterSocketSubscribe(type: string, callback: SocketCallback) {
    const query = (ref: ISocketSubscribe) => ref.type == type && ref.callback == callback
    const index = Socketor.queues.findIndex(query)

    if (index > -1) {
      Socketor.queues.splice(index, 1)
    }
  }
}
