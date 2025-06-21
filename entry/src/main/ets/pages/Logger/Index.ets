import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { Loading } from "../../components/Loading/Index"
import { IString } from "../../tracks/logger"
import { logger } from "../../tracks/logger"
import { unit } from "../../utils/unity"


@HMRouter({
  pageUrl: AppRouter.logger,
  singleton: true
})
@ComponentV2
export struct PageLogger {
  @Local time: number = -1
  @Local first: boolean = true
  @Local loading: boolean = true
  @Local bodyHScroller: Scroller = new Scroller()
  @Local bodyVScroller: Scroller = new Scroller()
  @Local readAsString: () => void = this.createReadAsString()
  @Local headHeight: number = unit.vp(56)
  @Local headShadow: boolean = true
  @Local content: IString = {
    filename: '',
    content: '',
    type: '',
  }

  @Builder
  backRouteBuilder() {
    Column() {
      Column() {
        Image($rawfile('images/auth/back.png'))
          .onClick(() => AppRouterMgr.pop())
          .margin({ left: unit.vp(20) })
          .objectFit(ImageFit.Fill)
          .height(unit.vp(36))
          .width(unit.vp(36))
          .draggable(false)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(unit.wmax(640))
      .height('100%')
    }
    .width('100%')
    .height(unit.vp(56))
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  headerAreaBuilder() {
    Column() {
      Column() {
        Column() {
          Text($r('app.string.Run_Logger'))
            .fontWeight(FontWeight.Bold)
            .letterSpacing(unit.vp(3))
            .lineHeight(unit.vp(28))
            .fontSize(unit.vp(20))
            .fontColor(0x130138)
        }
        .padding({ left: unit.vp(32), right: unit.vp(32) })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height('100%')
        .width('100%')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(unit.wmax(640))
      .height('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .alignItems(HorizontalAlign.Center)
    .height(unit.hp(this.headHeight))
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
    .width('100%')
    .shadow({
      color: this.headShadow ? 'rgba(0, 0, 0, 0.038)' : Color.Transparent,
      radius: this.headShadow ? unit.vp2px(10) : 0,
      offsetY: unit.vp2px(1.2),
      offsetX: unit.vp2px(0),
    })
  }

  @Builder
  scrollAreaBuilder() {
    Column() {
      Column() {
        Scroll(this.bodyVScroller) {
          Scroll(this.bodyVScroller) {
            Column() {
              Text(this.content.content)
                .fontFamily('Google.Roboto')
                .copyOption(CopyOptions.LocalDevice)
                .fontWeight(FontWeight.Normal)
                .enableHapticFeedback(true)
                .lineHeight(unit.vp(18))
                .fontSize(unit.vp(12))
                .fontColor(0x303133)
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Start)
            .constraintSize({
              minWidth: '100%',
              minHeight: '100%'
            })
            .padding({
              top: unit.vp(4),
              left: unit.vp(4),
              right: unit.vp(4),
            })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .height('auto')
          .width('100%')
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .scrollable(ScrollDirection.Vertical)
        .margin({ top: unit.vp(56) })
        .scrollBar(BarState.Auto)
        .height('100%')
        .width('100%')
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .width(unit.wmax(640))
      .height('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }

  createReadAsString() {
    return async () => {
      if (this.first) {
        this.content = await logger.readAsString()

        this.time = setTimeout(() => {
          this.loading = false
          this.first = false
        }, 500)

        return
      }

      if (this.loading) {
        return
      }

      clearTimeout(this.time)

      this.loading = true
      this.content = await logger.readAsString()
      this.time = setTimeout(async () => this.loading = false, 300)
    }
  }

  aboutToDisappear() {
    logger.removeWriteListener(this.readAsString)
    clearTimeout(this.time)
  }

  aboutToAppear() {
    logger.addWriteListener(this.readAsString)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.scrollAreaBuilder()
      this.headerAreaBuilder()
      this.backRouteBuilder()

      Loading({
        bgColor: 'rgba(255, 255, 255, 0.65)',
        desc: $r('app.string.Loading_logs_please_wait'),
        state: this.first && this.loading,
      })
    }
    .onAttach(() => setTimeout(() => this.readAsString(), 800))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(Color.Transparent)
    .height('100%')
    .width('100%')
  }
}
