import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { Toast } from "../../components/Toast/Index"
import { store } from "../../globals/store"
import { size } from "../../utils/size"


@HMRouter({
  pageUrl: AppRouter.langs,
  singleton: true
})
@ComponentV2
export struct PageLangs {
  @Local bodyScroller: Scroller = new Scroller()
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
          Text($r('app.string.Language'))
            .fontWeight(FontWeight.Bold)
            .letterSpacing(size.vp(3))
            .lineHeight(size.vp(28))
            .fontSize(size.vp(20))
            .fontColor(0x130138)
        }
        .padding({ left: size.vp(32), right: size.vp(32) })
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
    .height(size.hp(this.headHeight))
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
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
              .height(`calc(100% + ${size.vp(100)}vp)`)
              .width('100%')

            Column() {
              Column() {
                Text($r('app.string.Follow_System_Language'))
                  .fontWeight(this.isDefault() ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.isDefault() ? 0x8438FF : 0x808288)
                  .fontSize(size.vp(16))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(size.vp(15))
              .border({
                color: this.isDefault() ? 0x8438FF : 'rgba(0, 0, 0, 0.26)',
                width: this.isDefault() ? size.vp(1.4) : size.vp(1.2)
              })
              .onClick(() => this.changeLocaler('default'))
              .margin({ bottom: size.vp(25) })
              .padding(size.vp(20))
              .height(size.vp(64))
              .width('100%')

              Column() {
                Text($r('app.string.Chinese_zh_CN'))
                  .fontWeight(this.isZhCN() ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.isZhCN() ? 0x8438FF : 0x808288)
                  .fontSize(size.vp(16))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(size.vp(15))
              .border({
                color: this.isZhCN() ? 0x8438FF : 'rgba(0, 0, 0, 0.26)',
                width: this.isZhCN() ? size.vp(1.4) : size.vp(1.2)
              })
              .onClick(() => this.changeLocaler('zh-CN'))
              .margin({ bottom: size.vp(25) })
              .padding(size.vp(20))
              .height(size.vp(64))
              .width('100%')

              Column() {
                Text($r('app.string.English_en_US'))
                  .fontWeight(this.isEnUS() ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.isEnUS() ? 0x8438FF : 0x808288)
                  .fontSize(size.vp(16))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(size.vp(15))
              .border({
                color: this.isEnUS() ? 0x8438FF : 'rgba(0, 0, 0, 0.26)',
                width: this.isEnUS() ? size.vp(1.4) : size.vp(1.2)
              })
              .onClick(() => this.changeLocaler('en-US'))
              .margin({ bottom: size.vp(25) })
              .padding(size.vp(20))
              .height(size.vp(64))
              .width('100%')
            }
            .padding({
              top: size.vp(188),
              left: size.vp(48),
              right: size.vp(48),
              bottom: size.vp(35),
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
      .width(size.wmax(640))
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
    this.headHeight = size.vp(156) - this.bodyScroller.currentOffset().yOffset
    this.headHeight = Math.min(this.headHeight, size.vp(156))
    this.headHeight = Math.max(this.headHeight, size.vp(56))
    this.headShadow = this.headHeight <= size.vp(56)
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
