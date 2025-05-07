import { AppRouterMgr } from "../../router/manager"
import { ScanResult } from "../Scanner/-service"
import { size } from "../../utils/size"


@ComponentV2
export struct ScannerInfo {
  @Require @Param scanResult: ScanResult
  @Local context: UIContext = this.getUIContext()
  @Local translateX: string | number = '100%'
  @Local running: boolean = false

  aboutToAppear() {
    this.running = true

    const options: AnimateParam = {
      duration: 300,
      curve: Curve.Linear,
      onFinish: () => this.running = false
    }

    this.context.animateTo(options, () => {
      this.translateX = 0
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        Row() {
          Text() {
            SymbolSpan($r('sys.symbol.chevron_left'))
              .fontWeight(FontWeight.Medium)
              .fontSize(32)
          }
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .height(size.vp(56))
        .width(size.vp(56))
        .onClick(() => {
          if (!this.running) {
            AppRouterMgr.pop()
          }
        })

        Row() {
          Text('扫码结果')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .fontSize(size.vp(18))
            .fontColor(0x303133)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .layoutWeight(1)

        Row()
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .height(size.vp(56))
          .width(size.vp(56))
      }
      .width('100%')
      .height(size.vh(size.vp(56)))
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Scroll() {
        Column() {
          Text(this.scanResult.originalValue || '扫码结果未知')
            .wordBreak(WordBreak.BREAK_ALL)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .fontSize(size.vp(14))
            .fontColor(0x606266)
        }
        .padding({
          top: size.vp(25),
          left: size.vp(32),
          right: size.vp(32),
          bottom: size.vp(25)
        })
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .constraintSize({ minHeight: '100%' })
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .margin({ top: size.vp(56) })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .translate({ x: this.translateX })
    .backgroundColor(0xfcfcfc)
    .height('100%')
    .width('100%')
  }
}