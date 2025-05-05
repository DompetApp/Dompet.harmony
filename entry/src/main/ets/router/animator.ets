import { HMAnimatorHandle } from "@hadss/hmrouter"
import { TranslateOption } from "@hadss/hmrouter"
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
    enterHandle.finish((translateOption: TranslateOption) => {
      translateOption.y = '0'
    })

    enterHandle.start((translateOption: TranslateOption) => {
      translateOption.y = '100%'
    })

    exitHandle.finish((translateOption: TranslateOption) => {
      translateOption.y = '100%'
    })

    exitHandle.start((translateOption: TranslateOption) => {
      translateOption.y = '0'
    })

    enterHandle.duration = 500
    exitHandle.duration = 500
  }
}