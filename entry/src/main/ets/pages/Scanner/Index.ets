import { common } from "@kit.AbilityKit"
import { scanCore } from "@kit.ScanKit"
import { uiObserver } from "@kit.ArkUI"
import { AppRouterMgr } from "../../router/manager"
import { HMParamType, HMRouter } from "@hadss/hmrouter"
import { AppNav, AppRouter } from "../../router/constants"
import { ScanService, ScanOptions, ViewControl, ScannerCodes } from "./-service"
import { MediaPlayer, ScannerView, ScannerLine, ScannerInfo } from "./-service"
import { ScanResults, ScanResult, ScanCallback } from "./-service"
import { Dialog } from "../../components/Dialog/Index"
import { device } from "../../configure/device"
import { grant } from "../../utils/grant"
import { unit } from "../../utils/unity"
import { Album } from "./-album"


@HMRouter({
  pageUrl: AppRouter.scanner,
  singleton: true,
})
@ComponentV2
export struct PageScanner {
  @Local timerId: number = -1
  @Local showDialog: boolean = false
  @Local scanResult: ScanResult | null = null
  @Local scanService: ScanService = ScanService.getInstance()
  @Local scanResults: ScanResults = this.scanService.storeScanResults
  @Local scanParams: Unknown = AppRouterMgr.getCurrentParam(HMParamType.routeParam)
  @Local scanParser: (_?: ScanResult) => boolean = typeof this.scanParams == 'function' ? this.scanParams : (() => true)
  private scanOptions: ScanOptions = { scanTypes: [scanCore.ScanType.ALL], enableMultiMode: true, enableAlbum: true }
  private uiContext: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  private mediaPlayer: MediaPlayer = MediaPlayer.getInstance(this.uiContext)
  private scanCallback = this.createScanCallback()
  private navCallback = this.createNavCallback()
  private viewControl: ViewControl = {
    width: unit.px2vp(device.width),
    height: unit.px2vp(device.height),
    surfaceId: '',
  }

  @Computed
  get isSupportFlashlight() {
    return this.scanService.isFlashlight || this.scanService.isSensorLight
  }

  parseScanResult(data?: ScanResult) {
    if (this.scanParser(data) === true) {
      this.scanResult = data || null
      return
    }

    AppRouterMgr.pop({
      param: data
    })
  }

  createScanCallback() {
    const callback: ScanCallback = async (error, result) => {
      if (this.scanService.retryOnError(error, this.scanOptions, this.viewControl, this.scanCallback)) {
        return
      }

      if (!this.scanService.isScanned && !this.scanService.isOpenAlbum && this.scanService.isPageShow) {
        if (this.scanService.isSelectPicture) {
          this.scanResults.data = Array.isArray(result) && result.length >= 1 ? [result[0]] : []
          this.scanResults.code = (error && error.code) ? error.code : 200
          this.scanResults.size = this.scanResults.data.length
        }

        if (!this.scanService.isSelectPicture) {
          this.scanResults.data = Array.isArray(result) ? result : []
          this.scanResults.code = (error && error.code) ? error.code : 200
          this.scanResults.size = this.scanResults.data.length
        }

        if (this.scanService.isSelectPicture || result.length > 0) {
          this.scanService.releaseCamera()

          this.scanService.isScanned = true

          if (this.scanResults.size < 1) {
            this.mediaPlayer.play()
            Dialog.show({
              title: $r('app.string.System_Prompt'),
              message: $r('app.string.Scanner_Unrecognized_Code'),
              cancelText: $r('app.string.Scanner_Exit'),
              confirmText: $r('app.string.Scanner_Rescan'),
              confirm: (): Unknown => this.retryScanner(),
              cancel: (): Unknown => AppRouterMgr.pop(),
            })
          }

          if (this.scanResults.size > 1) {
            this.scanService.isScanLine = false
            this.mediaPlayer.play()
          }

          if (this.scanResults.size === 1) {
            this.mediaPlayer.play()
            this.scanService.isScanLine = false
            this.parseScanResult(this.scanResults.data[0])
          }
        }

        if (!this.scanService.isSelectPicture && result.length <= 0) {
          this.scanService.isOpenAlbum = false
          this.retryScanner()
        }
      }
    }
    return callback
  }

  createNavCallback() {
    const callback: Callback<NavDestinationInfo> = (info) => {
      if (info.name === AppRouter.scanner && info.state === uiObserver.NavDestinationState.ON_HIDDEN) {
        this.scanService.resetTryCount()
        this.scanService.releaseCamera()
      }

      if (info.name === AppRouter.scanner && info.state === uiObserver.NavDestinationState.ON_SHOWN) {
        this.scanService.isPageShow = true

        if (!this.showDialog) {
          this.showDialog = true

          grant.requestPermissions(['ohos.permission.CAMERA'])
            .then(state => {
              if (state === true) {
                this.scanService.isGranted = true
                this.startScanner()
                return
              }

              this.scanService.isGranted = false
              this.viewControl.surfaceId = ''
              this.showDialog = false
              AppRouterMgr.pop()
            })
        }
      }
    }
    return callback
  }

  aboutToDisappear() {
    uiObserver.off('navDestinationUpdate', { navigationId: AppNav.root }, this.navCallback)
    this.scanService.destroy()
    this.scanResult = null
  }

  listenPageState() {
    uiObserver.on('navDestinationUpdate', { navigationId: AppNav.root }, this.navCallback)
  }

  aboutToAppear() {
    this.listenPageState()
  }

  retryScanner() {
    this.scanResult = null
    this.showDialog = false

    if (this.viewControl.surfaceId) {
      this.viewControl.width = unit.px2vp(device.width)
      this.viewControl.height = unit.px2vp(device.height)
      this.scanService.resetCamera(this.scanOptions, this.viewControl, this.scanCallback)
    }
  }

  startScanner() {
    this.scanResult = null
    this.showDialog = false

    if (this.viewControl.surfaceId) {
      this.viewControl.width = unit.px2vp(device.width)
      this.viewControl.height = unit.px2vp(device.height)
      this.scanService.initCamera(this.scanOptions, this.viewControl, this.scanCallback)
    }
  }

  @Builder
  ScanViewBuilder() {
    if (this.scanService.isGranted) {
      ScannerView({
        initialize: (surfaceId) => {
          this.viewControl.width = unit.px2vp(device.width)
          this.viewControl.height = unit.px2vp(device.height)
          this.viewControl.surfaceId = surfaceId
          this.startScanner()
        },
        viewSize: {
          width: unit.px2vp(device.width),
          height: unit.px2vp(device.height)
        },
      })
    }
  }

  @Builder
  ScanLineBuilder() {
    if (this.scanService.isScanLine) {
      Column() {
        ScannerLine({ isScanned: this.scanService.isScanned, isOpenAlbum: this.scanService.isOpenAlbum })
          .margin({ top: unit.vp(120), bottom: unit.vp(10) })
          .height(`calc(100% - ${unit.vp(150)}vp)`)
          .constraintSize({ maxHeight: 420 })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .width('100%')
    }
  }

  @Builder
  ScanTitleBuilder() {
    Column() {
      Column() {
        Text($r('app.string.Scanner_Scan_Code'))
          .fontColor($r('sys.color.ohos_id_color_primary_contrary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxWidth: 500 })
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Center)
          .fontFamily('HarmonyHeiTi')
          .fontSize(unit.vp(18))
          .width('100%')
      }
      .visibility(this.scanResults.size > 0 ? Visibility.Hidden : Visibility.Visible)
      .margin({ top: unit.vp(80), bottom: unit.vp(30) })
      .padding({ left: unit.vp(24), right: unit.vp(24) })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')

      if (this.scanService.isScanNothing) {
        Row() {
          Text($r('app.string.Scanner_Unrecognized_Code'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontFamily('HarmonyHeiTi')
            .fontSize(unit.vp(14))
            .padding(unit.vp(8))
        }
        .margin({ top: unit.vp(16) })
        .borderRadius(unit.vp(16))
        .backgroundColor(0xfcfcfc)
      }
    }
  }

  @Builder
  ScanFeatureBuilder() {
    if (!this.scanService.isScanned) {
      Column() {
        Column() {
          SymbolGlyph(this.scanService.isFlashlight ? $r('sys.symbol.flashlight_on') : $r('sys.symbol.flashlight_off'))
            .margin({ top: unit.vp(3), bottom: unit.vp(10) })
            .fontColor([$r('sys.color.font_on_primary')])
            .fontWeight(FontWeight.Normal)
            .fontSize(unit.vp(24))
            .stateStyles({
              pressed: {
                .opacity(0.4)
              },
              normal: {
                .opacity(1)
              }
            })

          Text(this.scanService.isFlashlight ? $r('app.string.Scanner_Tap_Close') : $r('app.string.Scanner_Tap_Open'))
            .fontColor($r('sys.color.icon_on_primary'))
            .textAlign(TextAlign.Center)
            .fontFamily('HarmonyHeiTi')
            .fontSize(unit.vp(12))
        }
        .height(unit.vp(80))
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: device.isPortrait ? '25%' : 10 })
        .visibility(this.isSupportFlashlight ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => this.scanService.changeFlashlight())

        if (this.scanOptions.enableAlbum) {
          Column() {
            Column() {
              SymbolGlyph($r('sys.symbol.picture'))
                .fontColor([$r('sys.color.font_on_primary')])
                .fontWeight(FontWeight.Regular)
                .fontSize(unit.vp(24))
            }
            .margin({ top: unit.vp(3), bottom: unit.vp(10) })
            .backgroundColor('rgba(250, 250, 250, 0.55)')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .borderRadius(unit.vp(48))
            .height(unit.vp(48))
            .width(unit.vp(48))
            .clip(true)

            Text($r('app.string.Scanner_Gallery'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r('sys.color.font_on_primary'))
              .textAlign(TextAlign.Center)
              .fontFamily('HarmonyHeiTi')
              .fontSize(unit.vp(12))
          }
          .margin({ bottom: device.isPortrait ? '12%' : 10 })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick(async () => {
            if (!this.scanService.isScanned) {
              this.scanService.isScanned = false
              this.scanService.isScanLine = false
              this.scanService.isOpenAlbum = true
              this.scanService.isDecodeGallery = true
              this.scanService.isSelectPicture = false

              await this.scanService.releaseCamera()

              Album.open(this.scanOptions, this.scanCallback, () => {
                this.scanService.isOpenAlbum = false
              })
            }
          })
        }
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.End)
    }
  }

  @Builder
  ScanTopToolBuilder() {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      SymbolGlyph($r('sys.symbol.xmark'))
        .fontColor([$r('sys.color.font_on_primary')])
        .fontWeight(FontWeight.Normal)
        .fontSize(unit.vp(24))
    }
    .width(unit.vp(40))
    .height(unit.vp(40))
    .backgroundColor('rgba(255,255,255,0.15)')
    .margin({ top: unit.vp(20), left: unit.vp(20) })
    .onClick(() => this.scanResults.size > 1 ? this.retryScanner() : AppRouterMgr.pop())
  }

  @Builder
  ScanMultiBuilder() {
    if (this.scanResults.size > 1) {
      ScannerCodes({
        parseResult: (result) => {
          this.scanService.resetScanData()
          this.parseScanResult(result)
        }
      })
    }
  }

  @Builder
  ScanResultBuilder() {
    if (this.scanResult) {
      ScannerInfo({ scanResult: this.scanResult })
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.ScanViewBuilder()
      this.ScanLineBuilder()
      this.ScanTitleBuilder()
      this.ScanMultiBuilder()
      this.ScanFeatureBuilder()
      this.ScanTopToolBuilder()
      this.ScanResultBuilder()
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(this.scanService.isGranted ? Color.Transparent : Color.Black)
    .height('100%')
    .width('100%')
  }
}