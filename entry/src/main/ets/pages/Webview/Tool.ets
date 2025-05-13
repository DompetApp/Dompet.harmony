import { image } from "@kit.ImageKit"
import { webview } from "@kit.ArkWeb"
import { common } from "@kit.AbilityKit"
import { systemShare } from "@kit.ShareKit"
import { pasteboard } from "@kit.BasicServicesKit"
import { uniformTypeDescriptor } from "@kit.ArkData"
import { Toast } from "../../components/Toast/Index"
import { AppRouterMgr } from "../../router/manager"
import { device } from "../../configure/device"
import { Empty } from "../../utils/empty"
import { size } from "../../utils/size"


@ComponentV2
export struct WebviewTool {
  @Local device: Unknown = device
  @Local offsetY: string = '100%'
  @Local running: boolean = false
  @Local bgColor: string = 'rgba(0,0,0,0.1)'
  @Local context: UIContext = this.getUIContext()
  @Require @Param webviewController: webview.WebviewController = new webview.WebviewController()
  @Require @Param visible: boolean = false
  @Event closed: () => void = Empty.fn

  @Monitor('device.isLandscape')
  onDeviceLandscapeChange(m: IMonitor) {
    if (m.value()?.now === true) {
      this.visible && this.back()
    }
  }

  @Builder
  toolGridBuilder(types: string[]) {
    Scroll() {
      Column() {
        Grid() {
          ForEach(types, (type: string) => {
            this.toolItemBuilder(type)
          })
        }
        .columnsTemplate(`repeat(auto-stretch, ${size.vp(50)})`)
        .columnsGap(size.vp(15))
        .rowsGap(size.vp(16))
        .padding({
          left: size.vp(3),
          right: size.vp(3)
        })
      }
      .constraintSize({ minHeight: Math.min(size.vp(150), size.vh(30)) })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .width('100%')
    }
    .scrollBar(BarState.Off)
    .height('auto')
    .width('100%')
  }

  @Builder
  toolItemBuilder(type: string) {
    GridItem({ style: GridItemStyle.NONE }) {
      Column() {
        Column() {
          Image(this.getItemImage(type))
            .objectFit(ImageFit.Fill)
            .height(size.vp(28))
            .width(size.vp(28))
            .draggable(false)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(size.vp(15))
        .height(size.vp(50))
        .width(size.vp(50))
        .clip(true)

        Column() {
          Text(this.getItemTitle(type))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Bold)
            .fontSize(size.vp(10))
            .fontColor(0x606266)
            .maxLines(2)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .padding({ top: size.vp(8) })
        .width(size.vp(50))
      }
      .width('100%')
      .height('auto')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => this.onItemClick(type))
    }
  }

  getItemTitle(type: string) {
    switch (type) {
      case 'back': {
        return $r('app.string.Webview_Back_App')
      }
      case 'clear': {
        return $r('app.string.Webview_Clear_Cache')
      }
      case 'refresh': {
        return $r('app.string.Webview_Refresh_Page')
      }
      case 'browser': {
        return $r('app.string.Webview_Open_Browser')
      }
      case 'debug': {
        return $r('app.string.Webview_Turn_Debug')
      }
      case 'share': {
        return $r('app.string.Webview_Share_Website')
      }
      case 'link': {
        return $r('app.string.Webview_Copy_Link')
      }
      default: {
        return ''
      }
    }
  }

  getItemImage(type: string) {
    switch (type) {
      case 'back': {
        return $rawfile('webview/images/home.png')
      }
      case 'clear': {
        return $rawfile('webview/images/clear.png')
      }
      case 'refresh': {
        return $rawfile('webview/images/refresh.png')
      }
      case 'browser': {
        return $rawfile('webview/images/browser.png')
      }
      case 'debug': {
        return $rawfile('webview/images/debug.png')
      }
      case 'share': {
        return $rawfile('webview/images/share.png')
      }
      case 'link': {
        return $rawfile('webview/images/link.png')
      }
      default: {
        return ''
      }
    }
  }

  onItemClick(type: string) {
    Promise.resolve().then(async () => {
      if (type === 'back') {
        AppRouterMgr.pop()
      }

      if (type === 'clear') {
        webview.WebStorage.deleteAllData()
        webview.WebDataBase.deleteHttpAuthCredentials()
        webview.GeolocationPermissions.deleteAllGeolocation()
        webview.WebCookieManager.clearAllCookiesSync()
        this.webviewController.removeCache(true)
        this.webviewController.scrollTo(0, 0)
        this.webviewController.refresh()
        this.back()
      }

      if (type === 'refresh') {
        this.webviewController.removeCache(false)
        this.webviewController.scrollTo(0, 0)
        this.webviewController.refresh()
        this.back()
      }

      if (type == 'browser') {
        const url = this.webviewController.getUrl()
        const ctx = getContext(this) as common.UIAbilityContext

        if (url.startsWith('https://') || url.startsWith('http://')) {
          ctx.openLink(url, { appLinkingOnly: false })
          this.back()
        }
      }

      if (type == 'debug') {
        const event = 'CallOpenVConsoleDebug'
        const source = `window.dispatchEvent(new CustomEvent("${event}"))`
        this.webviewController.runJavaScript(source)
        this.back()
      }

      if (type == 'share') {
        const url = this.webviewController.getUrl()
        const title = this.webviewController.getTitle()
        const pixelMap = this.webviewController.getFavicon()

        const arrayBuffer = await image.createImagePacker().packToData(pixelMap, {
          format: 'image/webp',
          quality: 90,
        })

        const shareData = new systemShare.SharedData({
          utd: uniformTypeDescriptor.UniformDataType.HYPERLINK,
          thumbnail: new Uint8Array(arrayBuffer),
          content: url,
          title: title,
        })

        const context = getContext(this) as common.UIAbilityContext
        const controller = new systemShare.ShareController(shareData)

        controller.show(context, {
          previewMode: systemShare.SharePreviewMode.DEFAULT,
          selectionMode: systemShare.SelectionMode.SINGLE
        })

        this.back()
      }

      if (type === 'link') {
        const url = this.webviewController.getUrl()
        const mimeType = pasteboard.MIMETYPE_TEXT_PLAIN
        const pasteboardData = pasteboard.createData(mimeType, url)
        const systemPasteboard = pasteboard.getSystemPasteboard()

        systemPasteboard.setData(pasteboardData).then(() => {
          Toast.show({ message: $r('app.string.Webview_Copy_Successful') })
        })
      }
    })
  }

  aboutToAppear() {
    this.start()
  }

  start() {
    this.running = true

    const options: AnimateParam = {
      duration: 300,
      curve: Curve.Linear,
      onFinish: () => this.running = false
    }

    this.context.animateTo(options, () => {
      this.bgColor = 'rgba(0, 0, 0, 0.48)'
      this.offsetY = '0%'
    })
  }

  back() {
    if (!this.running) {
      this.running = true

      const options: AnimateParam = {
        duration: 300,
        curve: Curve.Linear,
        onFinish: () => {
          this.running = false
          this.closed()
        }
      }

      this.context.animateTo(options, () => {
        this.bgColor = 'rgba(0,0,0,0.1)'
        this.offsetY = '100%'
      })
    }
  }

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.BottomStart }) {
        Column() {
          Row() {
            Text($r('app.string.Webview_Settings'))
              .letterSpacing(Math.max(size.vp(1.2), 1.2))
              .fontWeight(FontWeight.Bold)
              .fontSize(size.vp(16))
              .fontColor(0x303133)
          }
          .padding({ left: size.vp(8), right: size.vp(8) })
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .width('100%')

          Divider()
            .margin({ top: size.vp(15), bottom: size.vp(15) })
            .strokeWidth(size.vp(0.6))
            .color(0xcfcfcf)

          Column() {
            this.toolGridBuilder([
              'back',
              'clear',
              'refresh',
              'browser',
              'debug',
              'share',
              'link',
            ])
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .height('auto')
          .width('100%')

          Divider()
            .margin({ top: size.vp(20), bottom: size.vp(15) })
            .strokeWidth(size.vp(0.6))
            .color(0xcfcfcf)

          Column() {
            Text($r('app.string.System_Cancel'))
              .letterSpacing(Math.max(size.vp(1.2), 1.2))
              .fontWeight(FontWeight.Bold)
              .fontSize(size.vp(16))
              .fontColor(0x646e93)
          }
          .padding({
            top: size.vp(5),
            left: size.vp(25),
            right: size.vp(25),
            bottom: Math.max(size.vp(20) - px2vp(device.bottom), 0)
          })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick(() => this.back())
          .height('auto')
          .width('100%')
        }
        .borderRadius({ topLeft: size.vp(15), topRight: size.vp(15) })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .translate({ y: this.offsetY })
        .justifyContent(FlexAlign.End)
        .backgroundColor(0xebebeb)
        .padding(size.vp(15))
        .onClick(Empty.fn)
        .width('100%')
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .backgroundColor(this.bgColor)
      .onClick(() => this.back())
      .height('100%')
      .width('100%')
    }
  }
}
