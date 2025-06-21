import { AppRouterMgr } from "../../router/manager"
import { ScanResult } from "../Scanner/-service"
import { unit } from "../../utils/unity"


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
        .height(unit.vp(56))
        .width(unit.vp(56))
        .onClick(() => {
          if (!this.running) {
            AppRouterMgr.pop()
          }
        })

        Row() {
          Text($r('app.string.Scanner_Scan_Code_Result'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .fontSize(unit.vp(18))
            .fontColor(0x303133)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .layoutWeight(1)

        Row()
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .height(unit.vp(56))
          .width(unit.vp(56))
      }
      .width('100%')
      .height(unit.hp(unit.vp(56)))
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Scroll() {
        Column() {
          Text(this.scanResult.originalValue || $r('app.string.Scanner_Scan_Code_Result_Unknown'))
            .wordBreak(WordBreak.BREAK_ALL)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .fontSize(unit.vp(14))
            .fontColor(0x606266)
        }
        .padding({
          top: unit.vp(25),
          left: unit.vp(32),
          right: unit.vp(32),
          bottom: unit.vp(25)
        })
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .constraintSize({ minHeight: `calc(100% - ${unit.vp(56)}vp)` })
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .margin({ top: unit.vp(56) })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .translate({ x: this.translateX })
    .backgroundColor(0xfcfcfc)
    .height('100%')
    .width('100%')
  }
}