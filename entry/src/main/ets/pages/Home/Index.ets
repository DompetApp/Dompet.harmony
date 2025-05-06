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
import { size } from "../../utils/size"
import { UIUtils } from "@kit.ArkUI"


@HMRouter({
  pageUrl: AppRouter.home,
  animator: 'RouteNoneAnimator',
  singleton: true
})
@ComponentV2
export struct PageHome {
  @Local showShadow: boolean = false
  @Local showActions: boolean = false
  @Local scroller: Scroller = new Scroller()
  @Local bankOrders: IOrders = store.orders
  @Local loginUser: IUser = store.user
  @Local bankCard: ICard = store.card

  @Computed
  get headHeight() {
    const preset = size.vp(32)
    const top = px2vp(device.top)
    return Math.max(preset - top, 0) + size.vp(56)
  }

  @Computed
  get footHeight() {
    const preset = size.vp(30)
    const bottom = px2vp(device.bottom)
    return Math.max(preset - bottom, 0) + size.vp(92)
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
              .height(size.vp(26))
              .width(size.vp(26))
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .padding({ top: size.vp(2) })
          .height(size.vp(28))
          .width(size.vp(80))

          Text($r('app.string.Transfer'))
            .fontWeight(FontWeight.Bold)
            .fontSize(size.vp(13))
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
              .height(size.vp(26))
              .width(size.vp(26))
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .padding({ top: size.vp(2) })
          .height(size.vp(28))
          .width(size.vp(80))

          Text($r('app.string.Payment'))
            .fontWeight(FontWeight.Bold)
            .fontSize(size.vp(13))
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
              .height(size.vp(26))
              .width(size.vp(26))
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .padding({ top: size.vp(2) })
          .height(size.vp(28))
          .width(size.vp(80))

          Text($r('app.string.Top_up'))
            .fontWeight(FontWeight.Bold)
            .fontSize(size.vp(13))
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
    .opacity(this.showActions ? 1 : 0)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .enabled(this.showActions)
    .animation({
      curve: Curve.Linear,
      duration: this.showActions ? 480 : 300,
    })
  }

  @Builder
  headerTitleBuilder() {
    Column() {
      Row() {
        Column() {
          Text($r('app.string.Digital_Wallet'))
            .fontWeight(FontWeight.Bold)
            .fontSize(size.vp(24))
            .fontColor(0x130138)
            .margin({
              top: size.vp(5)
            })

          Text($r('app.string.available'))
            .fontWeight(FontWeight.Normal)
            .fontSize(size.vp(16))
            .fontColor(0xbdbdbd)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)

        Column() {
          Image(this.loginAvatar)
            .objectFit(ImageFit.Fill)
            .height(size.vp(44))
            .width(size.vp(44))
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .borderRadius('50%')
        .height(size.vp(44))
        .width(size.vp(44))
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
    .opacity(this.showActions ? 0 : 1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .enabled(!this.showActions)
    .animation({
      curve: Curve.Linear,
      duration: this.showActions ? 300 : 480,
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
    .padding({
      top: this.headHeight - size.vp(56),
      left: size.vp(32),
      right: size.vp(32),
    })
    .shadow({
      color: this.showShadow ? 'rgba(0, 0, 0, 0.038)' : Color.Transparent,
      radius: this.showShadow ? vp2px(10) : 0,
      offsetY: vp2px(1.2),
      offsetX: vp2px(0),
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .height(size.hp(this.headHeight))
    .backgroundColor(Color.White)
    .width('100%')
    .id('header')
  }

  @Builder
  scrollAreaBuilder() {
    Scroll(this.scroller) {
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
      const offset = this.scroller.currentOffset()
      this.showShadow = offset.yOffset >= size.vp(42)
      this.showActions = offset.yOffset >= size.vp(42)
    })
  }

  @Builder
  userBankCardBuilder() {
    Column() {
      Column() {
        Text($r('app.string.Balance'))
          .fontWeight(FontWeight.Bold)
          .lineHeight(size.vp(20))
          .fontSize(size.vp(16))
          .fontColor(0xffffff)

        Text(money.USD(this.bankCard.balance))
          .fontWeight(FontWeight.Bold)
          .lineHeight(size.vp(28))
          .fontSize(size.vp(20))
          .fontColor(0xdfdfdf)

        Column() {
          Text($r('app.string.Citibank'))
            .fontWeight(FontWeight.Bold)
            .lineHeight(size.vp(35))
            .fontSize(size.vp(22))
            .fontColor(0xf0f0f0)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.End)
        .margin({ top: size.vp(10) })
        .width('100%')
      }
      .padding({
        top: size.vp(32),
        left: size.vp(38),
        right: size.vp(35),
      })
      .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.card }))
      .backgroundImage($rawfile('images/home/card.png'))
      .backgroundImageSize(ImageSize.FILL)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .margin({ top: size.vp(42) })
      .height(size.vp(140))
      .width(size.vp(310))

      Column() {
        Row() {
          Column() {
            Column() {
              Image($rawfile('images/home/transfer.png'))
                .objectFit(ImageFit.Fill)
                .height(size.vp(28))
                .width(size.vp(28))
            }
            .shadow({
              color: 'rgba(39, 34, 70, 0.15)',
              radius: vp2px(12),
              offsetY: vp2px(4),
              offsetX: vp2px(0),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: size.vp(16) })
            .backgroundColor(Color.White)
            .borderRadius(size.vp(20))
            .height(size.vp(48))
            .width(size.vp(48))

            Text($r('app.string.Transfer'))
              .fontWeight(FontWeight.Normal)
              .fontSize(size.vp(13))
              .fontColor(0x8438FF)
          }
          .width(size.vp(80))
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
                .height(size.vp(28))
                .width(size.vp(28))
            }
            .shadow({
              color: 'rgba(39, 34, 70, 0.15)',
              radius: vp2px(12),
              offsetY: vp2px(4),
              offsetX: vp2px(0),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: size.vp(16) })
            .backgroundColor(Color.White)
            .borderRadius(size.vp(20))
            .height(size.vp(48))
            .width(size.vp(48))

            Text($r('app.string.Payment'))
              .fontWeight(FontWeight.Normal)
              .fontSize(size.vp(13))
              .fontColor(0x8438FF)
          }
          .width(size.vp(80))
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
                .height(size.vp(28))
                .width(size.vp(28))
            }
            .shadow({
              color: 'rgba(39, 34, 70, 0.15)',
              radius: vp2px(12),
              offsetY: vp2px(4),
              offsetX: vp2px(0),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: size.vp(16) })
            .backgroundColor(Color.White)
            .borderRadius(size.vp(20))
            .height(size.vp(48))
            .width(size.vp(48))

            Text($r('app.string.Top_up'))
              .fontWeight(FontWeight.Normal)
              .fontSize(size.vp(13))
              .fontColor(0x8438FF)
          }
          .width(size.vp(80))
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
      .padding({ left: size.vp(52), right: size.vp(52) })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .margin({ top: size.vp(36) })
      .width('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({ top: size.vp(22) })
    .width('100%')
  }

  @Builder
  transactionsBuilder() {
    Column() {
      Row() {
        Text($r('app.string.Transactions'))
          .letterSpacing(-size.vp(0.35))
          .fontWeight(FontWeight.Bold)
          .fontSize(size.vp(18))
          .fontColor(0x130138)

        Text($r('app.string.Money'))
          .fontWeight(FontWeight.Bold)
          .fontSize(size.vp(14))
          .fontColor(0x130138)
      }
      .margin({
        left: size.vp(4),
        right: size.vp(4),
        bottom: size.vp(25),
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .height(size.vp(21))
      .width('100%')

      List({ space: size.vp(21) }) {
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
                  .height('100%')
                  .width('100%')
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .margin({ right: size.vp(15) })
              .height(size.vp(39))
              .width(size.vp(39))
              .clip(true)

              Column() {
                Row() {
                  Text($r(`app.string.${item.name}`))
                    .fontWeight(FontWeight.Bold)
                    .fontSize(size.vp(16))
                    .fontColor(0x000000)

                  Text(money.usd(item.money))
                    .letterSpacing(size.vp(-0.6))
                    .fontWeight(FontWeight.Bold)
                    .fontSize(size.vp(16))
                    .fontColor(0x363853)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)
                .margin({ bottom: size.vp(2) })
                .height(size.vp(19))
                .width('100%')

                Row() {
                  Text($r(`app.string.${item.type}`))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(size.vp(14))
                    .fontColor(0x909399)

                  Text(dater.format(item.date, { dateStyle: 'medium' }))
                    .fontWeight(FontWeight.Bold)
                    .fontSize(size.vp(12))
                    .fontColor(0xababab)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)
                .height(size.vp(18))
                .width('100%')
              }
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Start)
              .layoutWeight(1)
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .height(size.vp(39))
            .width('100%')
          }
          .width('100%')
        })
      }
      .scrollBar(BarState.Off)
      .height('auto')
      .width('100%')
      .padding(0)
      .margin(0)
    }
    .padding({ left: size.vp(32), right: size.vp(32) })
    .margin({ top: size.vp(42), bottom: size.vp(15) })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }

  @Builder
  bottomTabbarBuilder() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($rawfile('images/tabbar/bg.png'))
          .position({ top: size.vp(32), left: size.vp(24) })
          .objectFit(ImageFit.Fill)
          .height(size.vp(52))
          .width(size.vp(280))

        Row() {
          Image($rawfile('images/tabbar/home_select.png'))
            .objectFit(ImageFit.Fill)
            .height(size.vp(28))
            .width(size.vp(28))
            .onClick(Empty.fn)

          Image($rawfile('images/tabbar/chart.png'))
            .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.stats }))
            .objectFit(ImageFit.Fill)
            .height(size.vp(28))
            .width(size.vp(28))

          Image($rawfile('images/tabbar/notification.png'))
            .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.notification }))
            .objectFit(ImageFit.Fill)
            .height(size.vp(28))
            .width(size.vp(28))

          Image($rawfile('images/tabbar/settings.png'))
            .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.settings }))
            .objectFit(ImageFit.Fill)
            .height(size.vp(28))
            .width(size.vp(28))
        }
        .shadow({
          color: 'rgba(39, 34, 70, 0.098)',
          radius: vp2px(12),
          offsetX: vp2px(0),
          offsetY: vp2px(8),
        })
        .padding({
          top: size.vp(25),
          left: size.vp(40),
          right: size.vp(40),
          bottom: size.vp(25),
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .backgroundColor(0x2f1155)
        .borderRadius(size.vp(30))
        .height(size.vp(78))
        .width('100%')
      }
      .height('100%')
      .width('100%')
    }
    .padding({
      top: size.vp(10),
      left: size.vp(24),
      right: size.vp(24),
      bottom: Math.max(this.footHeight - size.vp(92), 0),
    })
    .alignRules({
      bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
      left: { anchor: "__container__", align: HorizontalAlign.Start }
    })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor('rgba(255, 255, 255, 0.88)')
    .height(size.hp(this.footHeight))
    .width('100%')
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
      .width(size.wmax(640))
      .height('100%')
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height('100%')
    .width('100%')
  }
}