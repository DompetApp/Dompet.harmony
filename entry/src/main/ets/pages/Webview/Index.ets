import { webview } from "@kit.ArkWeb"
import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { HMLifecycleState } from "@hadss/hmrouter"
import { IHMLifecycleOwner } from "@hadss/hmrouter"
import { WebviewTool } from "../../pages/Webview/Tool"
import { HMWBridger } from "../../pages/Webview/bridger"
import { Loading } from "../../components/Loading/Index"
import { IWebviewMeta } from "../../models/web"
import { device } from "../../configure/device"
import { unit } from "../../utils/unity"
import { call } from "@kit.TelephonyKit"
import { util } from "@kit.ArkTS"


@HMRouter({
  pageUrl: AppRouter.webview,
  singleton: false,
})
@ComponentV2
export struct PageWebview {
  @Local rawScriptAccess: boolean = false
  @Local domStorageAccess: boolean = true
  @Local documentEndScripts: Array<ScriptItem> = []
  @Local documentStartScripts: Array<ScriptItem> = []
  @Local webviewController: webview.WebviewController = new webview.WebviewController()
  @Local lifecycleOwner: IHMLifecycleOwner | null = AppRouterMgr.getCurrentLifecycleOwner()
  @Local webviewBridger: HMWBridger = new HMWBridger(this.webviewController) as Unknown
  @Local webviewMeta: IWebviewMeta = AppRouterMgr.getCurrentParam() as Unknown
  @Local webviewCtx: Context = this.getUIContext().getHostContext() as Unknown
  @Local backward: Unknown = this.createBackward(true)

  async loadUrl() {
    const url = this.webviewMeta.url.trim()
    const html = this.webviewMeta.html.trim()
    const checkUrl = this.webviewMeta.checkUrl === true
    const checkHttps = this.webviewMeta.checkHttps === true

    if (this.webviewMeta.fromLocal && checkUrl && !checkHttps) {
      this.webviewController.loadUrl($rawfile('webview/htmls/errorHttps.html'))
      return
    }

    if (this.webviewMeta.fromUrl && checkUrl && checkHttps) {
      this.webviewController.loadUrl(url)
      return
    }

    if (this.webviewMeta.fromLocal && !checkUrl) {
      this.webviewController.loadUrl($rawfile('webview/htmls/errorUrl.html'))
      return
    }

    if (this.webviewMeta.fromHtml) {
      this.webviewController.loadData(html, 'text/html', 'UTF-8', 'data')
      return
    }
  }

  async loadAgent() {
    const dompet = ' DompetApp/1.0'
    const preset = this.webviewController.getUserAgent()
    this.webviewController.setCustomUserAgent(preset + dompet)
  }

  async loadScripts() {
    if (this.webviewMeta.fromLocal) {
      this.rawScriptAccess = true
      return
    }

    const states: Promise<string>[] = []

    const scripts: Array<string> = [
      'webview/scripts/vconsole.min.js',
      'webview/scripts/harmony.min.js',
      'webview/scripts/webview.min.js',
      'webview/scripts/vdebug.min.js',
      'webview/scripts/meta.min.js',
    ]

    for (const file of scripts) {
      const decoder = new util.TextDecoder()
      const promise = this.webviewCtx.resourceManager.getRawFileContent(file)
      states.push(promise.then(code => decoder.decodeToString(code)).catch(() => ''))
    }

    const p = Promise.all(states)

    p.then((scripts) => {
      this.rawScriptAccess = true

      for (const script of scripts) {
        this.documentEndScripts.push({
          scriptRules: ['*'],
          script: script,
        })
      }
    })
  }

  async parseRequest() {
    this.loading(true)

    const url = this.webviewMeta.url.trim()
    const html = this.webviewMeta.html.trim()
    const fromUrl = this.webviewMeta.fromUrl === true
    const fromHtml = this.webviewMeta.fromHtml === true
    const checkUrl = this.webviewMeta.checkUrl === true
    const checkHttps = this.webviewMeta.checkHttps === true

    if (url && fromUrl && checkUrl && !checkHttps) {
      this.webviewMeta.fromLocal = true
      this.webviewMeta.fromHtml = false
      this.webviewMeta.fromUrl = true
      return
    }

    if (url && fromUrl && checkUrl && checkHttps) {
      this.webviewMeta.fromLocal = false
      this.webviewMeta.fromHtml = false
      this.webviewMeta.fromUrl = true
      return
    }

    if (url && fromUrl && !checkUrl) {
      this.webviewMeta.fromLocal = true
      this.webviewMeta.fromHtml = false
      this.webviewMeta.fromUrl = true
      return
    }

    if (html && fromHtml) {
      this.webviewMeta.fromLocal = false
      this.webviewMeta.fromHtml = true
      this.webviewMeta.fromUrl = false
      return
    }
  }

  async aboutToAppear() {
    webview.WebviewController.setWebDebuggingAccess(device.bundleInfo.appInfo.debug)
    this.lifecycleOwner?.addObserver(HMLifecycleState.onBackPressed, this.backward)
    this.parseRequest()
    this.loadScripts()
  }

  async registerScripts() {
    this.webviewController.registerJavaScriptProxy(this.webviewBridger, 'harmony_webview', ['caller'])
  }

  async aboutToDisappear() {
    this.lifecycleOwner?.removeObserver(HMLifecycleState.onBackPressed, this.backward)
    this.webviewController.deleteJavaScriptRegister('harmony_webview')
    this.webviewBridger.destroy()
  }

  async titling(title: string) {
    title = title?.trim() ?? ''

    const isEmpty = title == ''
    const isBlank = title == 'about:blank'
    const isHtmlContent = title.startsWith('data:text/html') == true
    const isFromHttps = title.startsWith('https://') == true
    const isFromHttp = title.startsWith('http://') == true

    if (!isEmpty && !isBlank && !isHtmlContent && !isFromHttps && !isFromHttp) {
      this.webviewMeta.title = title === '' ? this.webviewMeta.title : title
    }

    if (this.webviewMeta.title == '') {
      this.webviewMeta.title = 'Webview...'
    }
  }

  async loading(loading: boolean) {
    this.webviewMeta.loading = loading === true
  }

  async popuping(popuping: boolean) {
    this.webviewMeta.popup = popuping && !device.isLandscape
  }

  public createBackward(prevent?: boolean) {
    return () => {
      this.webviewController.accessBackward() ? this.webviewController.backward() : AppRouterMgr.pop()
      return prevent
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Flex({ direction: FlexDirection.Column }) {
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
          .onClick(this.createBackward())
          .height(unit.vp(56))
          .width(unit.vp(56))

          Row() {
            Text(this.webviewMeta.title)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .fontSize(unit.fp(18))
              .fontColor(0x303133)
              .maxLines(1)
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .height(unit.vp(56))
          .layoutWeight(1)

          Row() {
            Row() {
              Column()
                .backgroundColor(0x333333)
                .borderRadius('50%')
                .height(unit.vp(5))
                .width(unit.vp(5))

              Column()
                .margin({ left: unit.vp(3), right: unit.vp(3) })
                .backgroundColor(0x333333)
                .borderRadius('50%')
                .height(unit.vp(7))
                .width(unit.vp(7))

              Column()
                .backgroundColor(0x333333)
                .borderRadius('50%')
                .height(unit.vp(5))
                .width(unit.vp(5))
            }
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .height(unit.vp(26))
            .width(unit.vp(44))
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .height(unit.vp(56))
          .width(unit.vp(56))
          .onClick(() => {
            if (!this.webviewMeta.loading) {
              this.popuping(true)
            }
          })
        }
        .width('100%')
        .height(unit.hp(unit.vp(56)))
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

        Column() {
          Stack({ alignContent: Alignment.TopStart }) {
            if (this.rawScriptAccess) {
              Web({ src: '', controller: this.webviewController })
                .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
                .runJavaScriptOnDocumentStart(this.documentStartScripts)
                .runJavaScriptOnDocumentEnd(this.documentEndScripts)
                .domStorageAccess(this.domStorageAccess)
                .onControllerAttached(() => {
                  this.registerScripts()
                  this.loadAgent()
                  this.loadUrl()
                })
                .onInterceptRequest((e) => {
                  const url = e.request.getRequestUrl()

                  if (url === 'https://linpengteng.github.io/resource/dompet-app/home.png') {
                    const response = new WebResourceResponse()
                    response.setResponseData($rawfile('webview/images/app.png'))
                    response.setResponseMimeType('image/png')
                    response.setResponseEncoding('utf-8')
                    response.setResponseIsReady(true)
                    response.setReasonMessage('OK')
                    response.setResponseCode(200)
                    return response
                  }

                  return null
                })
                .onProgressChange((e) => {
                  if (e.newProgress === 100) {
                    this.loading(false)
                  }
                })
                .onLoadIntercept((e) => {
                  const url = e.data.getRequestUrl()

                  if (url.startsWith('tel://')) {
                    call.makeCall(url.replace(/\D+/, ''))
                    return true
                  }

                  return false
                })
                .onTitleReceive((e) => {
                  this.titling(e.title)
                })
                .onErrorReceive(() => {
                  this.loading(false)
                })
                .onPageEnd(() => {
                  this.loading(false)
                })
            }

            Loading({
              bgColor: 'rgba(255, 255, 255, 0.8)',
              desc: $r('app.string.Webview_Loading'),
              state: this.webviewMeta.loading,
            })
          }
          .height('100%')
          .width('100%')
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .backgroundColor(Color.White)
        .height('100%')
        .width('100%')
        .flexShrink(1)
        .flexGrow(1)
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .backgroundColor(Color.White)
      .height('100%')
      .width('100%')

      if (this.webviewMeta.popup) {
        WebviewTool({
          webviewController: this.webviewController,
          visible: this.webviewMeta.popup,
          closed: () => {
            this.popuping(false)
          }
        })
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor(Color.White)
    .height('100%')
    .width('100%')
  }
}
