import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { dater } from "../../formats/dater"
import { store } from "../../globals/store"
import { ICard } from "../../models/card"
import { size } from "../../utils/size"


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
  @Local headOffset: number = size.vp(50)
  @Local headHeight: number = size.vp(156)
  @Local headShadow: boolean = false

  @Builder
  backRouteBuilder() {
    Column() {
      Column() {
        Image($rawfile('images/auth/back.png'))
          .onClick(() => AppRouterMgr.pop())
          .margin({ left: size.vp(20) })
          .objectFit(ImageFit.Fill)
          .height(size.vp(36))
          .width(size.vp(36))
          .draggable(false)
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

  @Builder
  headerAreaBuilder() {
    Column() {
      Column() {
        Column() {
          Text($r('app.string.Bank_Card'))
            .fontWeight(FontWeight.Bold)
            .letterSpacing(size.vp(3))
            .lineHeight(size.vp(28))
            .fontSize(size.vp(20))
            .fontColor(0x130138)
        }
        .padding({ top: this.headOffset, left: size.vp(32), right: size.vp(32) })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height('100%')
        .width('100%')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(size.wmax(640))
      .height('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.headBgColor)
    .height(size.hp(this.headHeight))
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .shadow({
      color: this.headShadow ? 'rgba(0, 0, 0, 0.038)' : Color.Transparent,
      radius: this.headShadow ? vp2px(10) : 0,
      offsetY: vp2px(1.2),
      offsetX: vp2px(0),
    })
  }

  @Builder
  scrollAreaBuilder() {
    Column() {
      Column() {
        Scroll(this.bodyScroller) {
          Stack({ alignContent: Alignment.Top }) {
            Column()
              .height(`calc(100% + ${size.vp(62.5)}vp)`)
              .width('100%')

            Column() {
              this.cardContentBuilder()
              this.cardButtonBuilder()
            }
            .padding({ top: size.vp(156) })
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
      .width(size.wmax(640))
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
            .position({ right: size.vp(38.5), bottom: size.vp(21) })
            .objectFit(ImageFit.Fill)
            .height(size.vp(44))
            .width(size.vp(29))
        }
        .rotate({ angle: this.isExpand ? 90 : 0, centerX: '50%', centerY: '50%' })
        .height(this.isExpand ? size.vp(305) : size.vp(340))
        .width(this.isExpand ? size.vp(215) : size.vp(240))
        .margin({ bottom: this.isExpand ? size.vp(13) : size.vp(40) })
        .animation({
          duration: 480,
          curve: Curve.Linear,
          onFinish: () => setTimeout(() => this.isAnimating = false, 150)
        })

        if (!this.isAnimating) {
          Column() {
            Image($rawfile('images/card/shadow.png'))
              .objectFit(ImageFit.Fill)
              .height(size.vp(79))
              .width(size.vp(206))
          }
          .position({ bottom: this.isExpand ? size.vp(15) : 0 })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
        }
      }

      Column() {
        Row() {
          Text($r('app.string.CardNo'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14.8))
            .fontColor(0xbdbdbd)
            .width(size.vp(80))

          Text(this.card.cardNo)
            .fontWeight(FontWeight.Normal)
            .letterSpacing(size.vp(1.2))
            .fontSize(size.vp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: size.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(size.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Type'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14.8))
            .fontColor(0xbdbdbd)
            .width(size.vp(80))

          Text($r(`app.string.${this.card.cardType}`))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: size.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(size.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Bank'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14.8))
            .fontColor(0xbdbdbd)
            .width(size.vp(80))

          Text($r(`app.string.${this.card.bankName}`))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: size.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(size.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Status'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14.8))
            .fontColor(0xbdbdbd)
            .width(size.vp(80))

          Text(this.card.status === 'Y' ? $r('app.string.Available') : $r('app.string.Unavailable'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14))
            .fontColor(0x303133)
        }
        .margin({ bottom: size.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(size.vp(20))
        .width('100%')

        Row() {
          Text($r('app.string.Valid'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14.8))
            .fontColor(0xbdbdbd)
            .width(size.vp(80))

          Text(dater.format(this.card.expiryDate, { dateStyle: 'medium' }))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(14))
            .fontColor(0x303133)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height(size.vp(20))
        .width('100%')
      }
      .width('100%')
      .padding({
        left: size.vp(35),
        right: size.vp(35),
      })
      .opacity(this.isExpand ? 1 : 0)
      .height(this.isExpand ? size.vp(172) : 0)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .animation({
        duration: 480,
        curve: Curve.Linear,
        onFinish: () => setTimeout(() => this.isAnimating = false, 150)
      })
    }
    .margin({
      top: this.isExpand ? size.vp(-36) : 0,
      bottom: this.isExpand ? size.vp(56) : size.vp(48),
    })
    .padding({
      left: this.isExpand ? size.vp(30) : size.vp(17),
      right: this.isExpand ? size.vp(30) : size.vp(17),
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
        .letterSpacing(size.vp(1.2))
        .borderRadius(size.vp(20))
        .fontSize(size.vp(16))
        .fontColor(0x5b259f)
        .stateStyles({
          pressed: {
            .backgroundColor('rgba(69, 25, 125, 0.05)')
          }
        })
        .padding({
          top: size.vp(10),
          left: size.vp(30),
          right: size.vp(30),
          bottom: size.vp(10),
        })
        .onClick(() => {
          if (!this.isAnimating) {
            this.isExpand = !this.isExpand;
            this.isAnimating = true
          }
        })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
  }

  onDidScroll() {
    this.headHeight = size.vp(156) - (this.bodyScroller.currentOffset().yOffset * 1.6)
    this.headHeight = Math.min(this.headHeight, size.vp(156))
    this.headHeight = Math.max(this.headHeight, size.vp(56))

    this.headOffset = size.vp(50) - (this.bodyScroller.currentOffset().yOffset / 1.25)
    this.headOffset = Math.min(this.headOffset, size.vp(50))
    this.headOffset = Math.max(this.headOffset, size.vp(0))

    this.headBgColor = this.headHeight < size.vp(60) ? Color.White : Color.Transparent
    this.headShadow = this.headHeight <= size.vp(56)
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
