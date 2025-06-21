import { image } from "@kit.ImageKit"
import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
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
import { UIUtils } from "@kit.ArkUI"


@HMRouter({
  pageUrl: AppRouter.home,
  animator: 'RouteNoneAnimator',
  singleton: true
})
@ComponentV2
export struct PageHome {
  @Local headShadow: boolean = false
  @Local headActions: boolean = false
  @Local bodyScroller: Scroller = new Scroller()
  @Local bankOrders: IOrders = store.orders
  @Local loginUser: IUser = store.user
  @Local bankCard: ICard = store.card

  @Computed
  get headHeight() {
    const preset = unit.vp(32)
    const top = unit.px2vp(device.top)
    return Math.max(preset - top, 0) + unit.vp(56)
  }

  @Computed
  get footHeight() {
    const preset = unit.vp(30)
    const bottom = unit.px2vp(device.bottom)
    return Math.max(preset - bottom, 0) + unit.vp(92)
  }

  @Computed
  get loginAvatar() {
    if (this.loginUser.avatar) {
      const avatar = UIUtils.getTarget(this.loginUser.avatar)
      const imgSource = image.createImageSource(avatar.buffer)
      return imgSource.createPixelMapSync()
    }

    return $rawfile('images/home/avatar.png')
  }

  @Builder
  headerActionsBuilder() {
    Column() {
      Row() {
        Column() {
          Column() {
            Image($rawfile('images/home/transfer.png'))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(26))
              .width(unit.vp(26))
              .draggable(false)
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .padding({ top: unit.vp(2) })
          .height(unit.vp(28))
          .width(unit.vp(80))

          Text($r('app.string.Transfer'))
            .fontWeight(FontWeight.Bold)
            .fontSize(unit.vp(13))
            .fontColor(0x2f1155)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          AppRouterMgr.push({
            pageUrl: AppRouter.operater,
            param: 'Transfer'
          })
        })

        Column() {
          Column() {
            Image($rawfile('images/home/payment.png'))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(26))
              .width(unit.vp(26))
              .draggable(false)
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .padding({ top: unit.vp(2) })
          .height(unit.vp(28))
          .width(unit.vp(80))

          Text($r('app.string.Payment'))
            .fontWeight(FontWeight.Bold)
            .fontSize(unit.vp(13))
            .fontColor(0x2f1155)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          AppRouterMgr.push({
            pageUrl: AppRouter.operater,
            param: 'Payment'
          })
        })

        Column() {
          Column() {
            Image($rawfile('images/home/topup.png'))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(26))
              .width(unit.vp(26))
              .draggable(false)
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .padding({ top: unit.vp(2) })
          .height(unit.vp(28))
          .width(unit.vp(80))

          Text($r('app.string.Top_up'))
            .fontWeight(FontWeight.Bold)
            .fontSize(unit.vp(13))
            .fontColor(0x2f1155)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          AppRouterMgr.push({
            pageUrl: AppRouter.operater,
            param: 'Top_up'
          })
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height(this.headHeight)
    .opacity(this.headActions ? 1 : 0)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .enabled(this.headActions)
    .animation({
      curve: Curve.Linear,
      duration: this.headActions ? 480 : 300,
    })
  }

  @Builder
  headerTitleBuilder() {
    Column() {
      Row() {
        Column() {
          Text($r('app.string.Digital_Wallet'))
            .fontWeight(FontWeight.Bold)
            .fontSize(unit.vp(24))
            .fontColor(0x130138)
            .margin({
              top: unit.vp(5)
            })

          Text($r('app.string.available'))
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.vp(16))
            .fontColor(0xbdbdbd)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)

        Column() {
          Image(this.loginAvatar)
            .objectFit(ImageFit.Fill)
            .height(unit.vp(44))
            .width(unit.vp(44))
            .draggable(false)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .borderRadius('50%')
        .height(unit.vp(44))
        .width(unit.vp(44))
        .clip(true)
      }
      .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.profile }))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height(this.headHeight)
    .opacity(this.headActions ? 0 : 1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .enabled(!this.headActions)
    .animation({
      curve: Curve.Linear,
      duration: this.headActions ? 300 : 480,
    })
  }

  @Builder
  headerAreaBuilder() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        this.headerTitleBuilder()
        this.headerActionsBuilder()
      }
      .height('100%')
      .width('100%')
    }
    .shadow({
      color: this.headShadow ? 'rgba(0, 0, 0, 0.038)' : Color.Transparent,
      radius: this.headShadow ? unit.vp2px(10) : 0,
      offsetY: unit.vp2px(1.2),
      offsetX: unit.vp2px(0),
    })
    .padding({
      top: this.headHeight - unit.vp(56),
      left: unit.vp(32),
      right: unit.vp(32),
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .height(unit.hp(this.headHeight))
    .backgroundColor(Color.White)
    .width('100%')
    .id('header')
  }

  @Builder
  scrollAreaBuilder() {
    Scroll(this.bodyScroller) {
      Column() {
        this.userBankCardBuilder()
        this.transactionsBuilder()
      }
      .constraintSize({ minHeight: '100%' })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(Color.White)
      .width('100%')
    }
    .alignRules({
      top: { anchor: "header", align: VerticalAlign.Bottom },
      left: { anchor: "__container__", align: HorizontalAlign.Start },
    })
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ bottom: this.headHeight + this.footHeight })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .onDidScroll(() => {
      const offset = this.bodyScroller.currentOffset()
      this.headShadow = offset.yOffset >= unit.vp(42)
      this.headActions = offset.yOffset >= unit.vp(42)
    })
  }

  @Builder
  userBankCardBuilder() {
    Column() {
      Column() {
        Text($r('app.string.Balance'))
          .fontWeight(FontWeight.Bold)
          .lineHeight(unit.vp(20))
          .fontSize(unit.vp(16))
          .fontColor(0xffffff)

        Text(money.USD(this.bankCard.balance))
          .fontWeight(FontWeight.Bold)
          .lineHeight(unit.vp(28))
          .fontSize(unit.vp(20))
          .fontColor(0xdfdfdf)

        Column() {
          Text($r('app.string.Citibank'))
            .fontWeight(FontWeight.Bold)
            .lineHeight(unit.vp(35))
            .fontSize(unit.vp(22))
            .fontColor(0xf0f0f0)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.End)
        .margin({ top: unit.vp(10) })
        .width('100%')
      }
      .padding({
        top: unit.vp(32),
        left: unit.vp(38),
        right: unit.vp(35),
      })
      .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.card }))
      .backgroundImage($rawfile('images/home/card.png'))
      .backgroundImageSize(ImageSize.FILL)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .margin({ top: unit.vp(42) })
      .height(unit.vp(140))
      .width(unit.vp(310))

      Column() {
        Row() {
          Column() {
            Column() {
              Image($rawfile('images/home/transfer.png'))
                .objectFit(ImageFit.Fill)
                .height(unit.vp(28))
                .width(unit.vp(28))
                .draggable(false)
            }
            .shadow({
              color: 'rgba(39, 34, 70, 0.15)',
              radius: unit.vp2px(12),
              offsetY: unit.vp2px(4),
              offsetX: unit.vp2px(0),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: unit.vp(16) })
            .backgroundColor(Color.White)
            .borderRadius(unit.vp(20))
            .height(unit.vp(48))
            .width(unit.vp(48))

            Text($r('app.string.Transfer'))
              .fontWeight(FontWeight.Normal)
              .fontSize(unit.vp(13))
              .fontColor(0x8438FF)
          }
          .width(unit.vp(80))
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            AppRouterMgr.push({
              pageUrl: AppRouter.operater,
              param: 'Transfer'
            })
          })

          Column() {
            Column() {
              Image($rawfile('images/home/payment.png'))
                .objectFit(ImageFit.Fill)
                .height(unit.vp(28))
                .width(unit.vp(28))
                .draggable(false)
            }
            .shadow({
              color: 'rgba(39, 34, 70, 0.15)',
              radius: unit.vp2px(12),
              offsetY: unit.vp2px(4),
              offsetX: unit.vp2px(0),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: unit.vp(16) })
            .backgroundColor(Color.White)
            .borderRadius(unit.vp(20))
            .height(unit.vp(48))
            .width(unit.vp(48))

            Text($r('app.string.Payment'))
              .fontWeight(FontWeight.Normal)
              .fontSize(unit.vp(13))
              .fontColor(0x8438FF)
          }
          .width(unit.vp(80))
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            AppRouterMgr.push({
              pageUrl: AppRouter.operater,
              param: 'Payment'
            })
          })

          Column() {
            Column() {
              Image($rawfile('images/home/topup.png'))
                .objectFit(ImageFit.Fill)
                .height(unit.vp(28))
                .width(unit.vp(28))
                .draggable(false)
            }
            .shadow({
              color: 'rgba(39, 34, 70, 0.15)',
              radius: unit.vp2px(12),
              offsetY: unit.vp2px(4),
              offsetX: unit.vp2px(0),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: unit.vp(16) })
            .backgroundColor(Color.White)
            .borderRadius(unit.vp(20))
            .height(unit.vp(48))
            .width(unit.vp(48))

            Text($r('app.string.Top_up'))
              .fontWeight(FontWeight.Normal)
              .fontSize(unit.vp(13))
              .fontColor(0x8438FF)
          }
          .width(unit.vp(80))
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            AppRouterMgr.push({
              pageUrl: AppRouter.operater,
              param: 'Top_up'
            })
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .width('100%')
      }
      .padding({ left: unit.vp(52), right: unit.vp(52) })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .margin({ top: unit.vp(36) })
      .width('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({ top: unit.vp(22) })
    .width('100%')
  }

  @Builder
  transactionsBuilder() {
    Column() {
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

  @Builder
  bottomTabbarBuilder() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($rawfile('images/tabbar/bg.png'))
          .position({ top: unit.vp(32), left: unit.vp(24) })
          .objectFit(ImageFit.Fill)
          .height(unit.vp(52))
          .width(unit.vp(280))
          .draggable(false)

        Row() {
          Image($rawfile('images/tabbar/home_select.png'))
            .objectFit(ImageFit.Fill)
            .height(unit.vp(28))
            .width(unit.vp(28))
            .onClick(Empty.fn)
            .draggable(false)

          Image($rawfile('images/tabbar/chart.png'))
            .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.stats }))
            .objectFit(ImageFit.Fill)
            .height(unit.vp(28))
            .width(unit.vp(28))
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
      bottom: Math.max(this.footHeight - unit.vp(92), 0),
    })
    .alignRules({
      bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
      left: { anchor: "__container__", align: HorizontalAlign.Start }
    })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor('rgba(255, 255, 255, 0.88)')
    .height(unit.hp(this.footHeight))
    .width('100%')
  }

  aboutToAppear() {
    store.visited()
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
      .width(unit.wmax(640))
      .height('100%')
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height('100%')
    .width('100%')
  }
}