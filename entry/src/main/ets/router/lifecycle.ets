import { window } from "@kit.ArkUI"
import { HMLifecycle } from "@hadss/hmrouter"
import { IHMLifecycle } from "@hadss/hmrouter"
import { HMLifecycleContext } from "@hadss/hmrouter"
import { CtxManager } from "../configure/context"
import { AppRouter } from "../router/constants"


@HMLifecycle({ lifecycleName: 'RouteGlobalLifecycle', global: true })
export class RouteGlobalLifecycle implements IHMLifecycle {
  onBackPressed(ctx: HMLifecycleContext) {
    const context = ctx.navContext
    const pathStack = context?.pathStack

    if (pathStack && pathStack?.size() <= 1) {
      return true
    }

    return false
  }

  onShown(ctx: HMLifecycleContext) {
    window.getLastWindow(CtxManager.abilityContext).then(windowClass => {
      const context = ctx.navContext
      const pathName = context?.pathInfo.name!
      const flipping = AppRouter.flippings.includes(pathName)

      flipping
        ? windowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED)
        : windowClass.setPreferredOrientation(window.Orientation.PORTRAIT)
    })
  }
}