import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"


@HMRouter({
  pageUrl: AppRouter.settings,
  singleton: true
})
@ComponentV2
export struct PageSettings {
  build() {

  }
}