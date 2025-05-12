import { window } from "@kit.ArkUI"
import { HMLifecycle } from "@hadss/hmrouter"
import { IHMLifecycle } from "@hadss/hmrouter"
import { HMLifecycleContext } from "@hadss/hmrouter"
import { CtxManager } from "../configure/context"
import { AppRouter } from "../router/constants"


@HMLifecycle({ lifecycleName: 'RouteGlobalLifecycle', global: true })
export class RouteGlobalLifecycle implements IHMLifecycle {
  onBackPressed(_: HMLifecycleContext) {
    return false
  }

  onShown(ctx: HMLifecycleContext) {
    window.getLastWindow(CtxManager.uiAbilityContext).then(windowClass => {
      const context = ctx.navContext
      const pathName = context?.pathInfo.name!
      const flipping = AppRouter.flippings.includes(pathName)

      flipping
        ? windowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED)
        : windowClass.setPreferredOrientation(window.Orientation.PORTRAIT)
    })
  }
}