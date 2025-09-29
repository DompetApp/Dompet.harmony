import { HMDefaultGlobalAnimator, HMNavigation } from "@hadss/hmrouter"
import { RouterDefaultModifier } from "../router/modifier"
import { AppRouter } from "../router/constants"
import { AppNav } from "../router/constants"

import "../globals/definer"


@Entry
@ComponentV2
struct Index {
  routerDefaultModifier = new RouterDefaultModifier()

  build() {
    Column() {
      HMNavigation({
        navigationId: AppNav.root,
        homePageUrl: AppRouter.login,
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.routerDefaultModifier,
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}