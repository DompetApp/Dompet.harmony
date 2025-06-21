import { image } from "@kit.ImageKit"
import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { YearBalanceChart } from "../Stats/Chart"
import { device } from "../../configure/device"
import { IOrders } from "../../models/order"
import { IOrder } from "../../models/order"
import { dater } from "../../formats/dater"
import { money } from "../../formats/money"
import { store } from "../../globals/store"
import { ICard } from "../../models/card"
import { IUser } from "../../models/user"
import { Empty } from "../../utils/empty"
import { unit } from "../../utils/unity"


@HMRouter({
  pageUrl: AppRouter.stats,
  singleton: true
})
@ComponentV2
export struct PageStats {
  @Local bodyScroller: Scroller = new Scroller()
  @Local bankOrders: IOrders = store.orders
  @Local loginUser: IUser = store.user
  @Local bankCard: ICard = store.card
  @Local showHeader: boolean = false

  @Computed
  get loginAvatar() {
    if (this.loginUser.avatar) {
      const width = unit.vp2px(unit.vp(44))
      const height = unit.vp2px(unit.vp(44))
      const imgSize: image.Size = { width: width, height: height }
      return image.createPixelMapSync(this.loginUser.avatar.buffer, { size: imgSize })
    }

    return $rawfile('images/home/avatar.png')
  }

  @Builder
  headerAreaBuilder() {
    if (device.isPortrait) {
      Row() {
        Text($r('app.string.Balance'))
          .letterSpacing(unit.vp(1.2))
          .fontWeight(FontWeight.Bold)
          .lineHeight(unit.vp(28))
          .fontSize(unit.vp(20))
          .fontColor(0x130138)

        Text(money.usd2(this.bankCard.balance))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .letterSpacing(unit.vp(1.2))
          .fontWeight(FontWeight.Bold)
          .minFontSize(unit.vp(15))
          .maxFontSize(unit.vp(26))
          .textAlign(TextAlign.End)
          .fontSize(unit.vp(22))
          .fontColor(0x9038ff)
          .layoutWeight(1)
          .maxLines(1)
      }
      .padding({
        left: unit.vp(32),
        right: unit.vp(32),
      })
      .shadow({
        color: this.showHeader ? 'rgba(0, 0, 0, 0.038)' : Color.Transparent,
        radius: this.showHeader ? unit.vp2px(10) : 0,
        offsetY: unit.vp2px(1.2),
        offsetX: unit.vp2px(0),
      })
      .width('100%')
      .height(unit.hp(unit.vp(56)))
      .opacity(this.showHeader ? 1 : 0)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)
      .animation({
        curve: Curve.Linear,
        duration: 300,
      })
    }
  }

  @Builder
  scrollAreaBuilder() {
    Scroll(this.bodyScroller) {
      Column() {
        this.yearBalanceBuilder()
        this.transactionsBuilder()
      }
      .constraintSize({ minHeight: '100%' })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(Color.White)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ bottom: device.isPortrait ? unit.vp(92) : 0 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .onDidScroll(() => {
      const offset = this.bodyScroller.currentOffset()
      this.showHeader = offset.yOffset >= unit.vp(298)
    })
  }

  @Builder
  yearBalanceBuilder() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          Text($r('app.string.Balance'))
            .fontSize(unit.wmax(640) * unit.sr(18))
            .fontWeight(FontWeight.Bold)
            .fontColor(0x130138)
        }
        .margin({
          top: !device.isPortrait ? unit.vp(30) : unit.vp(10),
          left: !device.isPortrait ? unit.px2vp(device.top) + unit.vp(5) : unit.vp(30)
        })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .height(unit.vp(22))
        .width('100%')

        YearBalanceChart()
      }
      .height('100%')
      .width('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height(device.isPortrait ? unit.vp(165) : '100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .padding({ top: unit.vp(10) })
    .width('100%')
  }

  @Builder
  transactionsBuilder() {
    if (device.isPortrait) {
      Column() {
        Column() {
          Text($r('app.string.Balance'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.vp(16))
            .fontColor(0x8b98b1)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: unit.vp(16) })
        .height(unit.vp(20))
        .width('100%')

        Column() {
          Text(money.USD(this.bankCard.balance))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Bold)
            .minFontSize(unit.vp(24))
            .maxFontSize(unit.vp(35))
            .fontSize(unit.vp(35))
            .fontColor(0x9038ff)
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: unit.vp(42) })
        .height(unit.vp(44))
        .width('100%')

        Row() {
          Text($r('app.string.Transactions'))
            .letterSpacing(-unit.vp(0.35))
            .fontWeight(FontWeight.Bold)
            .fontSize(unit.vp(18))
            .fontColor(0x130138)

          Text($r('app.string.Money'))
            .fontWeight(FontWeight.Bold)
            .fontSize(unit.vp(14))
            .fontColor(0x130138)
        }
        .margin({
          left: unit.vp(4),
          right: unit.vp(4),
          bottom: unit.vp(25),
        })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .height(unit.vp(21))
        .width('100%')

        List({ space: unit.vp(21) }) {
          ForEach(this.bankOrders.list, (item: IOrder) => {
            ListItem() {
              Row() {
                Column() {
                  Image(
                    item.icon !== 'me' || !this.loginUser.avatar
                      ? $rawfile(`images/payer/${item.icon}.png`)
                      : this.loginAvatar
                  )
                    .objectFit(ImageFit.Fill)
                    .draggable(false)
                    .height('100%')
                    .width('100%')
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(15) })
                .borderRadius(unit.vp(15))
                .height(unit.vp(39))
                .width(unit.vp(39))
                .clip(true)

                Column() {
                  Row() {
                    Text($r(`app.string.${item.name}`))
                      .fontWeight(FontWeight.Bold)
                      .fontSize(unit.vp(16))
                      .fontColor(0x000000)

                    Text(money.usd(item.money))
                      .letterSpacing(unit.vp(-0.6))
                      .fontWeight(FontWeight.Bold)
                      .fontSize(unit.vp(16))
                      .fontColor(0x363853)
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .alignItems(VerticalAlign.Center)
                  .margin({ bottom: unit.vp(2) })
                  .height(unit.vp(19))
                  .width('100%')

                  Row() {
                    Text($r(`app.string.${item.type}`))
                      .fontWeight(FontWeight.Normal)
                      .fontSize(unit.vp(14))
                      .fontColor(0x909399)

                    Text(dater.format(item.date, { dateStyle: 'medium' }))
                      .fontWeight(FontWeight.Bold)
                      .fontSize(unit.vp(12))
                      .fontColor(0xababab)
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .alignItems(VerticalAlign.Center)
                  .height(unit.vp(18))
                  .width('100%')
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .layoutWeight(1)
              }
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Center)
              .height(unit.vp(39))
              .width('100%')
            }
            .width('100%')
          }, (item: IOrder) => `${item.id}`)
        }
        .scrollBar(BarState.Off)
        .height('auto')
        .width('100%')
        .padding(0)
        .margin(0)
      }
      .padding({ left: unit.vp(32), right: unit.vp(32) })
      .margin({ top: unit.vp(42), bottom: unit.vp(15) })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .width('100%')
    }
  }

  @Builder
  bottomTabbarBuilder() {
    if (device.isPortrait) {
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Image($rawfile('images/tabbar/bg.png'))
            .position({ top: unit.vp(32), left: unit.vp(24) })
            .objectFit(ImageFit.Fill)
            .height(unit.vp(52))
            .width(unit.vp(280))
            .draggable(false)

          Row() {
            Image($rawfile('images/tabbar/home.png'))
              .onClick(() => AppRouterMgr.pop({ pageUrl: AppRouter.home }))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(28))
              .width(unit.vp(28))
              .draggable(false)

            Image($rawfile('images/tabbar/chart_select.png'))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(28))
              .width(unit.vp(28))
              .onClick(Empty.fn)
              .draggable(false)

            Image($rawfile('images/tabbar/notification.png'))
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.notification }))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(28))
              .width(unit.vp(28))
              .draggable(false)

            Image($rawfile('images/tabbar/settings.png'))
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.settings }))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(28))
              .width(unit.vp(28))
              .draggable(false)
          }
          .shadow({
            color: 'rgba(39, 34, 70, 0.098)',
            radius: unit.vp2px(12),
            offsetX: unit.vp2px(0),
            offsetY: unit.vp2px(8),
          })
          .padding({
            top: unit.vp(25),
            left: unit.vp(40),
            right: unit.vp(40),
            bottom: unit.vp(25),
          })
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(0x2f1155)
          .borderRadius(unit.vp(30))
          .height(unit.vp(78))
          .width('100%')
        }
        .height('100%')
        .width('100%')
      }
      .padding({
        top: unit.vp(10),
        left: unit.vp(24),
        right: unit.vp(24),
      })
      .alignRules({
        bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
        left: { anchor: "__container__", align: HorizontalAlign.Start }
      })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .backgroundColor('rgba(255, 255, 255, 0.88)')
      .height(unit.hp(unit.vp(92)))
      .width('100%')
    }
  }

  build() {
    Column() {
      RelativeContainer() {
        this.scrollAreaBuilder()
        this.headerAreaBuilder()
        this.bottomTabbarBuilder()
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .backgroundColor(Color.White)
      .height('100%')
      .width('100%')
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height('100%')
    .width('100%')
  }
}
