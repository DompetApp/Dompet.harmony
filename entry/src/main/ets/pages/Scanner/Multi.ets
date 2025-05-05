import { ScanResults, ScanService, ScanResult } from "./-service"
import { device } from "../../configure/device"
import { size } from "../../utils/size"
import { curves } from "@kit.ArkUI"


@ComponentV2
export struct ScannerCodes {
  @Event parseResult: (result: ScanResult) => void
  @Local scanService: ScanService = ScanService.getInstance()
  @Local scanResults: ScanResults = this.scanService.storeScanResults
  @Local multiCodeScanLocation: Array<Array<number>> = []
  @Local multiCodeScanResult: Array<ScanResult> = []
  @Local multiSelectedIndex: number = -1
  @Local multiCodeOpacity: number = 0
  @Local multiCodeScale: number = 0.3
  @Local singleCodeScale: number = 0.3
  @Local singleCodeOpacity: number = 0
  @Local fadeOutOpacity: number = 1
  @Local fadeOutScale: number = 1
  @Local singleCodeX: number = 0
  @Local singleCodeY: number = 0
  @Local destroyed: boolean = false

  aboutToDisappear() {
    this.destroyed = true
  }

  aboutToAppear() {
    for (const item of this.scanResults.data) {
      this.multiCodeScanResult.push(item)

      if (item.scanCodeRect) {
        this.multiCodeScanLocation.push([
          item.scanCodeRect.left,
          item.scanCodeRect.top,
          item.scanCodeRect.right,
          item.scanCodeRect.bottom
        ])
      }
    }
  }

  multiToAppear() {
    this.multiCodeScale = 0.3

    const options: AnimateParam = {
      delay: 0,
      duration: 350,
      iterations: 1,
      playMode: PlayMode.Alternate,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => this.multiCodeBreathe()
    }

    animateTo(options, () => {
      this.multiCodeScale = 1
      this.multiCodeOpacity = 1
    })
  }

  multiCodeBreathe() {
    const options: AnimateParam = {
      delay: 100,
      duration: 300,
      iterations: 4,
      playMode: PlayMode.Alternate,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => {
        if (!this.destroyed && this.multiSelectedIndex == -1) {
          setTimeout((): void => this.multiCodeBreathe(), 400)
          this.multiCodeScale = 1
        }
      }
    }

    animateTo(options, () => {
      this.multiCodeScale = 0.8
    })
  }

  getOffsetX(location: number[]) {
    const left: number = location[0]
    const right: number = location[2]
    return (left + right) / 2
  }

  getOffsetY(location: number[]) {
    const top: number = location[1]
    const bottom: number = location[3]
    return (top + bottom) / 2 - px2vp(device.top)
  }

  openMultiCode(index: number) {
    this.singleCodeX = this.getOffsetX(this.multiCodeScanLocation[index])
    this.singleCodeY = this.getOffsetY(this.multiCodeScanLocation[index])
    this.multiSelectedIndex = index
    this.singleCodeOpacity = 0
    this.singleCodeScale = 0.3
    this.fadeOutOpacity = 0
    this.fadeOutScale = 0.3

    const options: AnimateParam = {
      delay: 0,
      duration: 240,
      iterations: 2,
      playMode: PlayMode.Alternate,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => {
        setTimeout(() => {
          this.parseResult(this.multiCodeScanResult[index])
        }, 200)
      }
    }

    const start = () => {
      animateTo(options, () => {
        this.singleCodeOpacity = 1
        this.singleCodeScale = 0.9
      })
    }

    setTimeout(start, 20)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Text('扫描到多个码，请选择一个打开')
          .fontColor($r('sys.color.ohos_id_color_primary_contrary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxWidth: 500 })
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Center)
          .fontFamily('HarmonyHeiTi')
          .fontSize(size.vp(18))
          .width('100%')
      }
      .margin({ top: size.vp(80), bottom: size.vp(30) })
      .padding({ left: size.vp(24), right: size.vp(24) })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')

      if (this.multiSelectedIndex === -1) {
        ForEach(this.multiCodeScanLocation, (arr: Array<number>, index: number) => {
          Row() {
            Image($rawfile('scanner/found.svg'))
              .width(size.vp(40))
              .height(size.vp(40))
              .opacity(this.multiCodeOpacity)
              .scale({ x: this.multiCodeScale, y: this.multiCodeScale })
              .onAppear(() => {
                if (index === 0) {
                  this.multiToAppear()
                }
              })
              .onClick(() => {
                this.openMultiCode(index)
              })
          }
          .position({
            x: this.getOffsetX(arr),
            y: this.getOffsetY(arr)
          })
          .width(size.vp(40))
          .height(size.vp(40))
          .markAnchor({ x: size.vp(20), y: size.vp(20) })
          .scale({ x: this.fadeOutScale, y: this.fadeOutScale })
          .opacity(this.fadeOutOpacity)
        })
      }

      if (this.multiSelectedIndex !== -1) {
        Image($rawfile('scanner/selected.svg'))
          .scale({ x: this.singleCodeScale, y: this.singleCodeScale })
          .position({ x: this.singleCodeX, y: this.singleCodeY })
          .markAnchor({ x: size.vp(20), y: size.vp(20) })
          .opacity(this.singleCodeOpacity)
          .height(size.vp(40))
          .width(size.vp(40))
          .draggable(false)
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height('100%')
    .width('100%')
  }
}