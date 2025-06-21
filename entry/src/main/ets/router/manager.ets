import { HMRouterMgr } from "@hadss/hmrouter"
import { HMRouterPathInfo } from "@hadss/hmrouter"
import { HMRouterPathCallback } from "@hadss/hmrouter"
import { AppNav, AppRouter } from "../router/constants"
import { IWebviewMeta } from "../models/web"
import { WebviewMgr } from "../utils/web"


export class AppRouterMgr extends HMRouterMgr {
  static async replace(pathInfo: HMRouterPathInfo, callback?: HMRouterPathCallback) {
    if (pathInfo && pathInfo.navigationId == undefined) {
      pathInfo.navigationId = AppNav.root
    }

    if (pathInfo.pageUrl === AppRouter.webview) {
      const param: IWebviewMeta = pathInfo.param = WebviewMgr.format(pathInfo.param) as Unknown
      const stack: NavPathStack = HMRouterMgr.getPathStack(pathInfo.navigationId!) as Unknown
      const params: IWebviewMeta[] = stack.getParamByName(AppRouter.webview) as Unknown
      const indexs: number[] = stack.getIndexByName(AppRouter.webview) as Unknown
      const place: number = params.findIndex(p => p.key === param.key) as number
      const index: number = indexs[place] ?? -1 as number
      const last: number = stack.size() - 1 as number

      if (index > -1 && index === last) {
        return
      }

      if (index > -1 && index < last) {
        stack.removeByIndexes([index])
      }
    }

    return HMRouterMgr.replaceAsync(pathInfo, callback)
  }

  static async reset(pathInfo: HMRouterPathInfo, callback?: HMRouterPathCallback) {
    if (pathInfo.pageUrl === AppRouter.webview) {
      pathInfo.param = WebviewMgr.format(pathInfo.param) as Unknown
    }

    pathInfo.navigationId = pathInfo.navigationId ?? AppNav.root
    HMRouterMgr.getPathStack(pathInfo.navigationId)?.clear()
    return HMRouterMgr.replaceAsync(pathInfo, callback)
  }

  static async push(pathInfo: HMRouterPathInfo, callback?: HMRouterPathCallback) {
    if (pathInfo && pathInfo.navigationId == undefined) {
      pathInfo.navigationId = AppNav.root
    }

    if (pathInfo.pageUrl === AppRouter.webview) {
      const param: IWebviewMeta = pathInfo.param = WebviewMgr.format(pathInfo.param) as Unknown
      const stack: NavPathStack = HMRouterMgr.getPathStack(pathInfo.navigationId!) as Unknown
      const params: IWebviewMeta[] = stack.getParamByName(AppRouter.webview) as Unknown
      const indexs: number[] = stack.getIndexByName(AppRouter.webview) as Unknown
      const place: number = params.findIndex(p => p.key === param.key) as number
      const index: number = indexs[place] ?? -1 as number
      const last: number = stack.size() - 1 as number

      if (index > -1 && index === last) {
        return
      }

      if (index > -1 && index < last) {
        stack.removeByIndexes([index])
      }
    }

    return HMRouterMgr.pushAsync(pathInfo, callback)
  }

  static async pop(pathInfo?: HMRouterPathInfo, skiped?: number) {
    if (pathInfo && pathInfo.navigationId == undefined) {
      pathInfo.navigationId = AppNav.root
    }

    if (pathInfo?.pageUrl === AppRouter.webview) {
      const param: IWebviewMeta = pathInfo.param = WebviewMgr.format(pathInfo.param) as Unknown
      const stack: NavPathStack = HMRouterMgr.getPathStack(pathInfo.navigationId!) as Unknown
      const params: IWebviewMeta[] = stack.getParamByName(AppRouter.webview) as Unknown
      const indexs: number[] = stack.getIndexByName(AppRouter.webview) as Unknown
      const place: number = params.findIndex(p => p.key === param.key) as number
      const index: number = indexs[place] ?? -1 as number
      const last: number = stack.size() - 1 as number

      if (index > -1 && index === last) {
        return
      }

      if (index > -1 && index < last) {
        stack.popToIndex(index)
        return
      }
    }

    return HMRouterMgr.popAsync(pathInfo, skiped)
  }
}
