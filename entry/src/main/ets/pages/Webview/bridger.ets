import { webview } from "@kit.ArkWeb"
import { AppNav } from "../../router/constants"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { BridgeResult } from "../../models/bridger"


export class HMWBridger {
  public webviewController: webview.WebviewController | null = null

  constructor(webviewController?: webview.WebviewController | null) {
    this.webviewController = webviewController || null
  }

  async caller(type: string, ...rest: Unknown[]): Promise<BridgeResult> {
    if (type === 'CallNavigateBack') {
      return this.navigateBack(...rest)
    }

    if (type === 'CallNavigateTo') {
      return this.navigateTo(...rest)
    }

    if (type === 'CallRedirectTo') {
      return this.redirectTo(...rest)
    }

    if (type === 'CallScanQRCode') {
      return this.scanQRCode(...rest)
    }

    if (type === 'CallRelaunch') {
      return this.relaunch(...rest)
    }

    return BridgeResult.failure()
  }

  async navigateBack(options: Recorder = {}): Promise<BridgeResult> {
    let delta: number | null = options.delta ?? 1

    if (typeof delta !== 'number') {
      return BridgeResult.failure({ message: '[delta] was not provided or invalid' })
    }

    if (delta >= 1) {
      delta = delta - 1
    }

    if (delta >= 0) {
      const stack: NavPathStack = AppRouterMgr.getPathStack(AppNav.root) as Unknown
      const names: Array<string> = [...stack.getAllPathName()].reverse() as Unknown
      const index: number = names.findIndex(name => name !== AppRouter.webview)
      delta = delta < index ? delta : index - 1
    }

    if (delta >= 0) {
      try {
        await AppRouterMgr.pop(undefined, delta)
        return BridgeResult.success()
      } catch {
        /* e */
      }
    }

    return BridgeResult.failure()
  }

  async navigateTo(options: Recorder = {}): Promise<BridgeResult> {
    const page: string | null = options.page

    if (typeof page !== 'string') {
      return BridgeResult.failure({ message: '[page] was not provided or invalid' })
    }

    try {
      await AppRouterMgr.push({ pageUrl: page })
      return BridgeResult.success()
    } catch {
      /* e */
    }

    return BridgeResult.failure()
  }

  async redirectTo(options: Recorder = {}): Promise<BridgeResult> {
    const page: string | null = options.page

    if (typeof page !== 'string') {
      return BridgeResult.failure({ message: '[page] was not provided or invalid' })
    }

    try {
      await AppRouterMgr.replace({ pageUrl: page })
      return BridgeResult.success()
    } catch {
      /* e */
    }

    return BridgeResult.failure()
  }

  async scanQRCode(options: Recorder = {}): Promise<BridgeResult> {
    return new Promise<BridgeResult>(resolve => {
      AppRouterMgr.push({
        pageUrl: AppRouter.scanner,
        param: () => false,
      }, {
        onResult: (info) => {
          const result: Unknown = info.result
          const content: Unknown = result ? result.originalValue : null
          resolve(info.result ? BridgeResult.success({ result: content }) : BridgeResult.failure())
        }
      })
    })
  }

  async relaunch(options: Recorder = {}): Promise<BridgeResult> {
    const page: string | null = options.page

    if (typeof page !== 'string') {
      return BridgeResult.failure({ message: '[page] was not provided or invalid' })
    }

    try {
      await AppRouterMgr.reset({ pageUrl: page })
      return BridgeResult.success()
    } catch {
      /* e */
    }

    return BridgeResult.failure()
  }
}
