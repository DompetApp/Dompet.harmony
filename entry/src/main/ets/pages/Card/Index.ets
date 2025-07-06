import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { dater } from "../../formats/dater"
import { store } from "../../globals/store"
import { ICard } from "../../models/card"
import { unit } from "../../utils/unity"


@HMRouter({
  pageUrl: AppRouter.card,
  singleton: true
})
@ComponentV2
export struct PageCard {
  @Local card: ICard = store.card
  @Local isExpand: boolean = false
  @Local isAnimating: boolean = false
  @Local bodyScroller: Scroller = new Scroller()
  @Local headBgColor: ResourceColor = Color.Transparent
  @Local headOffset: number = unit.vp(50)
  @Local headHeight: number = unit.vp(156)
  @Local headShadow: boolean = false

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
          Text($r('app.string.Bank_Card'))
            .fontWeight(FontWeight.Bold)
            .letterSpacing(unit.vp(3))
            .lineHeight(unit.fp(28))
            .fontSize(unit.fp(20))
            .fontColor(0x130138)
        }
        .padding({ top: this.headOffset, left: unit.vp(32), right: unit.vp(32) })
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
    .backgroundColor(this.headBgColor)
    .height(unit.hp(this.headHeight))
    .justifyContent(FlexAlign.Start)
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
        Scroll(this.bodyScroller) {
          Stack({ alignContent: Alignment.Top }) {
            Column()
              .height(`calc(100% + ${unit.vp(62.5)}vp)`)
              .width('100%')

            Column() {
              this.cardContentBuilder()
              this.cardButtonBuilder()
            }
            .padding({ top: unit.vp(156) })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Start)
            .width('100%')
          }
          .height('auto')
          .width('100%')
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .onDidScroll((_) => this.onDidScroll())
        .scrollBar(BarState.Off)
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

  @Builder
  cardContentBuilder() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Stack({ alignContent: Alignment.Center }) {
          Image($rawfile('images/card/bg.png'))
            .objectFit(ImageFit.Fill)
            .height('100%')
            .width('100%')

          Image($rawfile('images/card/visa.png'))
            .position({ right: unit.vp(38.5), bottom: unit.vp(21) })
            .objectFit(ImageFit.Fill)
            .height(unit.vp(44))
            .width(unit.vp(29))
        }
        .rotate({ angle: this.isExpand ? 90 : 0, centerX: '50%', centerY: '50%' })
        .margin({ bottom: this.isExpand ? unit.vp(13) : unit.vp(40) })
        .height(this.isExpand ? unit.vp(305) : unit.vp(340))
        .width(this.isExpand ? unit.vp(215) : unit.vp(240))
        .animation({
          duration: 480,
          curve: Curve.Linear,
          onFinish: () => setTimeout(() => this.isAnimating = false, 150)
        })

        if (!this.isAnimating) {
          Column() {
            Image($rawfile('images/card/shadow.png'))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(79))
              .width(unit.vp(206))
          }
          .position({ bottom: this.isExpand ? unit.vp(15) : 0 })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
        }
      }

      Column() {
        Row() {
          Text($r('app.string.CardNo'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14.8))
            .fontColor(0xbdbdbd)
            .width(unit.vp(80))

          Text(this.card.cardNo)
            .fontWeight(FontWeight.Normal)
            .letterSpacing(unit.vp(1.2))
            .fontSize(unit.fp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: unit.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(unit.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Type'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14.8))
            .fontColor(0xbdbdbd)
            .width(unit.vp(80))

          Text($r(`app.string.${this.card.cardType}`))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: unit.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(unit.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Bank'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14.8))
            .fontColor(0xbdbdbd)
            .width(unit.vp(80))

          Text($r(`app.string.${this.card.bankName}`))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: unit.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(unit.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Status'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14.8))
            .fontColor(0xbdbdbd)
            .width(unit.vp(80))

          Text(this.card.status === 'Y' ? $r('app.string.Available') : $r('app.string.Unavailable'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: unit.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(unit.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Valid'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14.8))
            .fontColor(0xbdbdbd)
            .width(unit.vp(80))

          Text(dater.format(this.card.expiryDate, { dateStyle: 'medium' }))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.fp(14))
            .fontColor(0x303133)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(unit.vp(20))
        .width('100%')
      }
      .width('100%')
      .padding({
        left: unit.vp(35),
        right: unit.vp(35),
      })
      .opacity(this.isExpand ? 1 : 0)
      .height(this.isExpand ? unit.vp(172) : 0)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .animation({
        duration: 480,
        curve: Curve.Linear,
        onFinish: () => setTimeout(() => this.isAnimating = false, 150)
      })
    }
    .margin({
      top: this.isExpand ? unit.vp(-36) : 0,
      bottom: this.isExpand ? unit.vp(56) : unit.vp(48),
    })
    .padding({
      left: this.isExpand ? unit.vp(30) : unit.vp(17),
      right: this.isExpand ? unit.vp(30) : unit.vp(17),
    })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .animation({
      duration: 480,
      curve: Curve.Linear,
      onFinish: () => setTimeout(() => this.isAnimating = false, 150)
    })
  }

  @Builder
  cardButtonBuilder() {
    Column() {
      Text(this.isExpand ? $r('app.string.Hide') : $r('app.string.Display'))
        .backgroundColor(Color.Transparent)
        .fontWeight(FontWeight.Medium)
        .letterSpacing(unit.vp(1.2))
        .borderRadius(unit.vp(20))
        .fontSize(unit.fp(16))
        .fontColor(0x5b259f)
        .stateStyles({
          pressed: {
            .backgroundColor('rgba(69, 25, 125, 0.05)')
          }
        })
        .padding({
          top: unit.vp(10),
          left: unit.vp(30),
          right: unit.vp(30),
          bottom: unit.vp(10),
        })
        .onClick(() => {
          if (!this.isAnimating) {
            this.isExpand = !this.isExpand
            this.isAnimating = true
          }
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
  }

  onDidScroll() {
    this.headHeight = unit.vp(156) - (this.bodyScroller.currentOffset().yOffset * 1.6)
    this.headHeight = Math.min(this.headHeight, unit.vp(156))
    this.headHeight = Math.max(this.headHeight, unit.vp(56))

    this.headOffset = unit.vp(50) - (this.bodyScroller.currentOffset().yOffset / 1.25)
    this.headOffset = Math.min(this.headOffset, unit.vp(50))
    this.headOffset = Math.max(this.headOffset, unit.vp(0))

    this.headBgColor = this.headHeight < unit.vp(60) ? Color.White : Color.Transparent
    this.headShadow = this.headHeight <= unit.vp(56)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.scrollAreaBuilder()
      this.headerAreaBuilder()
      this.backRouteBuilder()
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(0xffffff)
    .height('100%')
    .width('100%')
  }
}
