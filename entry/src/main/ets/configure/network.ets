import { connection } from "@kit.NetworkKit"
import { Empty } from "../utils/empty"


@ObservedV2
export class AppNetwork {
  @Trace connect: connection.NetConnection | null = null
  @Trace success: boolean = false

  async onUnavailable() {
    this.connect?.on('netUnavailable', () => {
      this.success = false
    })
  }

  async onAvailable() {
    this.connect?.on('netAvailable', (data: connection.NetHandle) => {
      if (data.netId >= 100) {
        this.success = true
      }
    })
  }

  async onLost() {
    this.connect?.on('netLost', (data: connection.NetHandle) => {
      if (data.netId >= 100) {
        this.success = false
      }
    })
  }

  async close() {
    if (this.connect) {
      this.connect.unregister(Empty.fn)
      this.connect = null
    }
  }

  async init() {
    if (!this.connect) {
      this.connect = connection.createNetConnection()
      this.connect.register(Empty.fn)
      this.onUnavailable()
      this.onAvailable()
      this.onLost()
    }
  }
}

export const Network = new AppNetwork()