import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { Toast } from "../../components/Toast/Index"
import { store } from "../../globals/store"
import { unit } from "../../utils/unity"


@HMRouter({
  pageUrl: AppRouter.langs,
  singleton: true
})
@ComponentV2
export struct PageLangs {
  @Local bodyScroller: Scroller = new Scroller()
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
          Text($r('app.string.Language'))
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
              .height(`calc(100% + ${unit.vp(100)}vp)`)
              .width('100%')

            Column() {
              Column() {
                Text($r('app.string.Follow_System_Language'))
                  .fontWeight(this.isDefault() ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.isDefault() ? 0x8438FF : 0x808288)
                  .fontSize(unit.vp(16))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(unit.vp(15))
              .border({
                color: this.isDefault() ? 0x8438FF : 'rgba(0, 0, 0, 0.26)',
                width: this.isDefault() ? unit.vp(1.4) : unit.vp(1.2)
              })
              .onClick(() => this.changeLocaler('default'))
              .margin({ bottom: unit.vp(25) })
              .padding(unit.vp(20))
              .height(unit.vp(64))
              .width('100%')

              Column() {
                Text($r('app.string.Chinese_zh_CN'))
                  .fontWeight(this.isZhCN() ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.isZhCN() ? 0x8438FF : 0x808288)
                  .fontSize(unit.vp(16))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(unit.vp(15))
              .border({
                color: this.isZhCN() ? 0x8438FF : 'rgba(0, 0, 0, 0.26)',
                width: this.isZhCN() ? unit.vp(1.4) : unit.vp(1.2)
              })
              .onClick(() => this.changeLocaler('zh-CN'))
              .margin({ bottom: unit.vp(25) })
              .padding(unit.vp(20))
              .height(unit.vp(64))
              .width('100%')

              Column() {
                Text($r('app.string.English_en_US'))
                  .fontWeight(this.isEnUS() ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.isEnUS() ? 0x8438FF : 0x808288)
                  .fontSize(unit.vp(16))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(unit.vp(15))
              .border({
                color: this.isEnUS() ? 0x8438FF : 'rgba(0, 0, 0, 0.26)',
                width: this.isEnUS() ? unit.vp(1.4) : unit.vp(1.2)
              })
              .onClick(() => this.changeLocaler('en-US'))
              .margin({ bottom: unit.vp(25) })
              .padding(unit.vp(20))
              .height(unit.vp(64))
              .width('100%')
            }
            .padding({
              top: unit.vp(188),
              left: unit.vp(48),
              right: unit.vp(48),
              bottom: unit.vp(35),
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

  changeLocaler(locale?: string) {
    locale ??= 'default'

    if (store.locale === locale) {
      return
    }

    store.localer(locale).then(async () => {
      if (locale === 'default') {
        Toast.show({ message: $r('app.string.You_switched_to_device_system_language') })
      }

      if (locale === 'zh-CN') {
        Toast.show({ message: $r('app.string.You_switched_to_Chinese_zh_CN') })
      }

      if (locale === 'en-US') {
        Toast.show({ message: $r('app.string.You_switched_to_English_en_US') })
      }
    })
  }

  onDidScroll(_: number) {
    this.headHeight = unit.vp(156) - this.bodyScroller.currentOffset().yOffset
    this.headHeight = Math.min(this.headHeight, unit.vp(156))
    this.headHeight = Math.max(this.headHeight, unit.vp(56))
    this.headShadow = this.headHeight <= unit.vp(56)
  }

  isDefault() {
    return /^default$/i.test(store.locale)
  }

  isEnUS() {
    return /^en[\w-]*US$/i.test(store.locale)
  }

  isZhCN() {
    return /^zh[\w-]*CN$/i.test(store.locale)
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
