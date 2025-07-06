import { IHMInterceptorChain } from "@hadss/hmrouter"
import { IHMInterceptor } from "@hadss/hmrouter"
import { HMInterceptor } from "@hadss/hmrouter"
import { AppRouterMgr } from "../router/manager"
import { AppRouter } from "../router/constants"
import { logger } from "../tracks/logger"
import { store } from "../globals/store"


@HMInterceptor({ interceptorName: 'RouteGlobalInterceptor', global: true })
export class RouteGlobalInterceptor implements IHMInterceptor {
  async intercept(chain: IHMInterceptorChain) {
    const route = chain.getRouterInfo()
    const ready = await store.ready.promise

    if (!ready && AppRouter.authorize.includes(route.targetName!)) {
      AppRouterMgr.reset({ pageUrl: AppRouter.login })
      return chain.onIntercept()
    }

    if (ready && AppRouter.anonymous.includes(route.targetName!)) {
      return chain.onIntercept()
    }

    if (route.type && route.srcName && route.targetName) {
      logger.info(`RouteGlobalInterceptor: from ${route.srcName} to ${route.targetName} (${route.type})`)
    }

    await chain.onContinue()
  }
}