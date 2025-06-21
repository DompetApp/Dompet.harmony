import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { Dialog } from "../../components/Dialog/Index"
import { AppRouterMgr } from "../../router/manager"
import { WebviewMeta } from "../../models/web"
import { event } from "../../globals/event"
import { unit } from "../../utils/unity"


@HMRouter({
  pageUrl: AppRouter.settings,
  singleton: true
})
@ComponentV2
export struct PageSettings {
  @Local context: UIContext = this.getUIContext()
  @Local bodyScroller: Scroller = new Scroller()
  @Local headHeight: number = unit.vp(156)
  @Local headShadow: boolean = false

  @Builder
  logoutBuilder() {
    Column() {
      Row() {
        Text($r('app.string.Do_you_want_to_logout'))
          .letterSpacing(unit.vp(1.2))
          .fontWeight(FontWeight.Bold)
          .fontSize(unit.vp(16))
          .fontColor(0xf34d4d)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
      .margin({ bottom: unit.vp(5) })
      .height('auto')
      .width('100%')

      Row() {
        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Text($r('app.string.System_Cancel'))
            .letterSpacing(unit.vp(1.2))
            .fontSize(unit.vp(15))
            .fontColor(0x9f9f9f)
        }
        .onClick(() => Dialog.hide())
        .backgroundColor(Color.Transparent)
        .borderRadius(unit.vp(22))
        .height(unit.vp(40))
        .padding({
          left: unit.vp(12),
          right: unit.vp(12)
        })

        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Text($r('app.string.Logout'))
            .fontWeight(FontWeight.Medium)
            .letterSpacing(unit.vp(1.2))
            .fontSize(unit.vp(15))
            .fontColor(0x606266)
        }
        .onClick(() => {
          event.logout()
          Dialog.hide()
        })
        .backgroundColor(Color.Transparent)
        .borderRadius(unit.vp(22))
        .height(unit.vp(40))
        .padding({
          left: unit.vp(12),
          right: unit.vp(12)
        })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.End)
      .margin({ top: unit.vp(15) })
      .width('100%')
    }
    .padding({
      top: unit.vp(30),
      left: unit.vp(30),
      right: unit.vp(30),
      bottom: unit.vp(10),
    })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
    .height('auto')
    .width('100%')
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
          Text($r('app.string.My_Settings'))
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
        Scroll(this.bodyScroller) {
          Stack({ alignContent: Alignment.Top }) {
            Column()
              .height(`calc(100% + ${unit.vp(62.5)}vp)`)
              .width('100%')

            Column() {
              Row() {
                Column() {
                  Image($rawfile('images/settings/profile.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(26) })
                .backgroundColor(Color.White)
                .borderRadius(unit.vp(22))
                .height(unit.vp(44))
                .width(unit.vp(44))
                .clip(true)
                .shadow({
                  color: 'rgba(39, 34, 70, 0.08)',
                  radius: unit.vp2px(12),
                  offsetY: unit.vp2px(4),
                  offsetX: unit.vp2px(0),
                })

                Column() {
                  Text($r('app.string.Person_Profile'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.vp(16))
                    .fontColor(0x130138)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
                .height(unit.vp(44))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/settings/right.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(30))
                    .width(unit.vp(30))
                    .draggable(false)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.End)
                .height(unit.vp(44))
                .width(unit.vp(38))
              }
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.profile }))
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .margin({ bottom: unit.vp(30) })
              .height(unit.vp(44))
              .width('100%')

              Row() {
                Column() {
                  Image($rawfile('images/settings/notification.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(26) })
                .backgroundColor(Color.White)
                .borderRadius(unit.vp(22))
                .height(unit.vp(44))
                .width(unit.vp(44))
                .clip(true)
                .shadow({
                  color: 'rgba(39, 34, 70, 0.08)',
                  radius: unit.vp2px(12),
                  offsetY: unit.vp2px(4),
                  offsetX: unit.vp2px(0),
                })

                Column() {
                  Text($r('app.string.Message_Notification'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.vp(16))
                    .fontColor(0x130138)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
                .height(unit.vp(44))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/settings/right.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(30))
                    .width(unit.vp(30))
                    .draggable(false)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.End)
                .height(unit.vp(44))
                .width(unit.vp(38))
              }
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.notification }))
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .margin({ bottom: unit.vp(30) })
              .height(unit.vp(44))
              .width('100%')

              Row() {
                Column() {
                  Image($rawfile('images/settings/card.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(26) })
                .backgroundColor(Color.White)
                .borderRadius(unit.vp(22))
                .height(unit.vp(44))
                .width(unit.vp(44))
                .clip(true)
                .shadow({
                  color: 'rgba(39, 34, 70, 0.08)',
                  radius: unit.vp2px(12),
                  offsetY: unit.vp2px(4),
                  offsetX: unit.vp2px(0),
                })

                Column() {
                  Text($r('app.string.My_Bank_Card'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.vp(16))
                    .fontColor(0x130138)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
                .height(unit.vp(44))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/settings/right.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(30))
                    .width(unit.vp(30))
                    .draggable(false)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.End)
                .height(unit.vp(44))
                .width(unit.vp(38))
              }
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.card }))
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .margin({ bottom: unit.vp(30) })
              .height(unit.vp(44))
              .width('100%')

              Row() {
                Column() {
                  Image($rawfile('images/settings/langs.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(26) })
                .backgroundColor(Color.White)
                .borderRadius(unit.vp(22))
                .height(unit.vp(44))
                .width(unit.vp(44))
                .clip(true)
                .shadow({
                  color: 'rgba(39, 34, 70, 0.08)',
                  radius: unit.vp2px(12),
                  offsetY: unit.vp2px(4),
                  offsetX: unit.vp2px(0),
                })

                Column() {
                  Text($r('app.string.Switch_Language'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.vp(16))
                    .fontColor(0x130138)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
                .height(unit.vp(44))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/settings/right.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(30))
                    .width(unit.vp(30))
                    .draggable(false)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.End)
                .height(unit.vp(44))
                .width(unit.vp(38))
              }
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.langs }))
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .margin({ bottom: unit.vp(30) })
              .height(unit.vp(44))
              .width('100%')

              Row() {
                Column() {
                  Image($rawfile('images/settings/logger.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(26) })
                .backgroundColor(Color.White)
                .borderRadius(unit.vp(22))
                .height(unit.vp(44))
                .width(unit.vp(44))
                .clip(true)
                .shadow({
                  color: 'rgba(39, 34, 70, 0.08)',
                  radius: unit.vp2px(12),
                  offsetY: unit.vp2px(4),
                  offsetX: unit.vp2px(0),
                })

                Column() {
                  Text($r('app.string.Run_Logger'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.vp(16))
                    .fontColor(0x130138)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
                .height(unit.vp(44))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/settings/right.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(30))
                    .width(unit.vp(30))
                    .draggable(false)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.End)
                .height(unit.vp(44))
                .width(unit.vp(38))
              }
              .onClick(() => AppRouterMgr.push({ pageUrl: AppRouter.logger }))
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .margin({ bottom: unit.vp(30) })
              .height(unit.vp(44))
              .width('100%')

              Row() {
                Column() {
                  Image($rawfile('images/settings/help.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .margin({ right: unit.vp(26) })
                .backgroundColor(Color.White)
                .borderRadius(unit.vp(22))
                .height(unit.vp(44))
                .width(unit.vp(44))
                .clip(true)
                .shadow({
                  color: 'rgba(39, 34, 70, 0.08)',
                  radius: unit.vp2px(12),
                  offsetY: unit.vp2px(4),
                  offsetX: unit.vp2px(0),
                })

                Column() {
                  Text($r('app.string.About_App'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.vp(16))
                    .fontColor(0x130138)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
                .height(unit.vp(44))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/settings/link.png'))
                    .margin({ right: unit.vp(8) })
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(20))
                    .width(unit.vp(20))
                    .draggable(false)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.End)
                .height(unit.vp(44))
                .width(unit.vp(38))
              }
              .onClick(() => {
                AppRouterMgr.push({
                  pageUrl: AppRouter.webview,
                  param: WebviewMeta.fromJson({
                    title: 'Dompet App',
                    url: 'https://juejin.cn/post/7505713576683405327',
                  })
                })
              })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .margin({ bottom: unit.vp(30) })
              .height(unit.vp(44))
              .width('100%')

              Column() {
                Column() {
                  Image($rawfile('images/settings/logout.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(36))
                    .width(unit.vp(36))
                    .draggable(false)
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .padding({ right: unit.vp(3) })
                .borderRadius(unit.vp(32))
                .height(unit.vp(64))
                .width(unit.vp(64))
                .border({
                  color: 0xe0e0e0,
                  style: BorderStyle.Solid,
                  width: unit.vp(0.8),
                })

                Text($r('app.string.Logout'))
                  .margin({ top: unit.vp(12) })
                  .fontWeight(FontWeight.Medium)
                  .letterSpacing(unit.vp(3))
                  .fontSize(unit.vp(16))
                  .fontColor(0x5b259f)
              }
              .width('100%')
              .margin({ top: unit.vp(25) })
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .onClick(() => {
                Dialog.custom({
                  autoCancel: false,
                  builder: () => this.logoutBuilder(),
                  offset: { dx: 0, dy: unit.vp(-30) },
                  width: unit.vp(300),
                })
              })
            }
            .padding({
              top: unit.vp(156),
              left: unit.vp(32),
              right: unit.vp(32),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Start)
            .backgroundColor(Color.White)
            .width('100%')
          }
          .height('auto')
          .width('100%')
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .onDidScroll((offset) => this.onDidScroll(offset))
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

  onDidScroll(_: number) {
    this.headHeight = unit.vp(156) - (this.bodyScroller.currentOffset().yOffset * 1.6)
    this.headHeight = Math.min(this.headHeight, unit.vp(156))
    this.headHeight = Math.max(this.headHeight, unit.vp(56))
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
