import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"


@HMRouter({
  pageUrl: AppRouter.notification,
  singleton: true
})
@ComponentV2
export struct PageNotification {
  build() {

  }
}