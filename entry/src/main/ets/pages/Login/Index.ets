import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { LoginByPassword } from "../Login/UPassword"
import { LoginByAccount } from "../Login/UAccount"
import { FocusMgr } from "../../utils/focus"
import { size } from "../../utils/size"


@HMRouter({
  pageUrl: AppRouter.login,
  animator: 'RouteNoneAnimator',
  singleton: true
})
@ComponentV2
export struct PageLogin {
  @Local focusMgr: FocusMgr = new FocusMgr(this.getUIContext())
  @Local visitRegister: () => void = this.createRegisterRouter()
  @Local switchMode: () => void = this.createSwitchMode()
  @Local isAnimating: boolean = false
  @Local isQuickMode: boolean = true

  createRegisterRouter() {
    return () => {
      AppRouterMgr.push({ pageUrl: AppRouter.register })
    }
  }

  createSwitchMode() {
    return () => {
      this.isQuickMode = !this.isQuickMode
      this.isAnimating = true
    }
  }

  aboutToDisappear() {
    this.focusMgr.blur()
  }

  @Builder
  backBuilder() {
    Column() {
      Column() {
        Image($rawfile('images/auth/back.png'))
          .onClick(() => this.switchMode())
          .margin({ left: size.vp(20) })
          .objectFit(ImageFit.Fill)
          .height(size.vp(36))
          .width(size.vp(36))
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(size.wmax(640))
      .height('100%')
    }
    .width('100%')
    .height(size.vp(56))
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll() {
        Column() {
          Stack({ alignContent: Alignment.Top }) {
            LoginByAccount({ switchMode: this.switchMode })
              .height(this.isQuickMode ? 'auto' : '100%')
              .constraintSize({ minHeight: '100%' })
              .backgroundColor(0xf1f3f5)

            LoginByPassword({ visitRegister: this.visitRegister })
              .translate({ x: this.isQuickMode ? '100%' : '0%' })
              .height(!this.isQuickMode ? 'auto' : '100%')
              .constraintSize({ minHeight: '100%' })
              .backgroundColor(0xf1f3f5)
              .animation({
                duration: 300,
                curve: Curve.Linear,
                onFinish: () => this.isAnimating = false
              })

            if (!this.isAnimating && !this.isQuickMode) {
              this.backBuilder()
            }
          }
          .width(size.wmax(640))
          .height('auto')
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .constraintSize({ minHeight: '100%' })
        .width('100%')
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .scrollBar(BarState.Off)
      .height('100%')
      .width('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onClick(() => this.focusMgr.blur())
    .backgroundColor(0xf1f3f5)
    .height('100%')
    .width('100%')
  }
}