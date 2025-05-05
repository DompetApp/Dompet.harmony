import { HMInterceptor } from "@hadss/hmrouter"
import { IHMInterceptor } from "@hadss/hmrouter"
import { HMInterceptorInfo } from "@hadss/hmrouter"
import { HMInterceptorAction } from "@hadss/hmrouter"
import { AppRouterMgr } from "../router/manager"
import { AppRouter } from "../router/constants"
import { store } from "../globals/store"


@HMInterceptor({ interceptorName: 'RouteGlobalInterceptor', global: true })
export class RouteGlobalInterceptor implements IHMInterceptor {
  handle(info: HMInterceptorInfo): HMInterceptorAction {
    if (!store.logined && AppRouter.authorize.includes(info.targetName!)) {
      AppRouterMgr.reset({ pageUrl: AppRouter.login })
      return HMInterceptorAction.DO_REJECT
    }

    if (store.logined && AppRouter.anonymous.includes(info.targetName!)) {
      return HMInterceptorAction.DO_REJECT
    }

    return HMInterceptorAction.DO_NEXT
  }
}