import { AttributeUpdater } from "@kit.ArkUI"
import { HMAnimatorHandle } from "@hadss/hmrouter"
import { IHMAnimator } from "@hadss/hmrouter"
import { HMAnimator } from "@hadss/hmrouter"
import { Empty } from "../utils/empty"


@HMAnimator({ animatorName: 'RouteNoneAnimator' })
export class RouteNoneAnimator implements IHMAnimator {
  effect(enterHandle: HMAnimatorHandle, exitHandle: HMAnimatorHandle) {
    enterHandle.finish(Empty.fn)
    exitHandle.finish(Empty.fn)
    enterHandle.start(Empty.fn)
    exitHandle.start(Empty.fn)
    enterHandle.duration = 0
    exitHandle.duration = 0
  }
}

@HMAnimator({ animatorName: 'RouteDownUpAnimator' })
export class RouteDownUpAnimator implements IHMAnimator {
  effect(enterHandle: HMAnimatorHandle, exitHandle: HMAnimatorHandle) {
    enterHandle.start((modifier: AttributeUpdater<NavDestinationAttribute>) => {
      modifier.attribute?.translate({ y: '100%' }).opacity(0.4)
    })

    enterHandle.finish((modifier: AttributeUpdater<NavDestinationAttribute>) => {
      modifier.attribute?.translate({ y: 0 }).opacity(1)
    })

    enterHandle.onFinish((modifier: AttributeUpdater<NavDestinationAttribute>) => {
      modifier.attribute?.translate({ y: 0 }).opacity(1)
    })

    exitHandle.start((modifier: AttributeUpdater<NavDestinationAttribute>) => {
      modifier.attribute?.translate({ y: 0 }).opacity(1)
    })

    exitHandle.finish((modifier: AttributeUpdater<NavDestinationAttribute>) => {
      modifier.attribute?.translate({ y: '100%' }).opacity(0.4)
    })

    exitHandle.onFinish((modifier: AttributeUpdater<NavDestinationAttribute>) => {
      modifier.attribute?.translate({ y: 0 }).opacity(1)
    })

    enterHandle.duration = 500
    exitHandle.duration = 500
  }
}