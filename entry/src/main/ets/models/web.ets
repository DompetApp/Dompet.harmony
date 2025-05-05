import { crypto } from "../utils/crypto"

@ObservedV2
export class WebviewMeta implements IWebviewMeta {
  static uuid() {
    const msg = Math.random().toString()
    return crypto.md5(msg) as string
  }

  @Trace key: string = ''
  @Trace url: string = ''
  @Trace html: string = ''
  @Trace title: string = ''
  @Trace query: Recorder = {}
  @Trace popup: boolean = false
  @Trace loading: boolean = false
  @Trace fromUrl: boolean = false
  @Trace fromHtml: boolean = false
  @Trace fromLocal: boolean = false
  @Trace checkHttps: boolean = false
  @Trace checkUrl: boolean = false

  static fromJson(json?: Partial<IWebviewMeta> | null) {
    const uuid = WebviewMeta.uuid
    const instance = new WebviewMeta()
    instance.key = json?.key ?? uuid()
    instance.url = json?.url ?? ''
    instance.html = json?.html ?? ''
    instance.title = json?.title ?? ''
    instance.query = json?.query ?? {}
    instance.popup = json?.popup ?? false
    instance.loading = json?.loading ?? false
    instance.fromUrl = json?.fromUrl ?? false
    instance.fromHtml = json?.fromHtml ?? false
    instance.fromLocal = json?.fromLocal ?? false
    instance.checkHttps = json?.checkHttps ?? false
    instance.checkUrl = json?.checkUrl ?? false
    return instance
  }

  public toUpdate(json?: Partial<IWebviewMeta> | null) {
    if (json != null) {
      this.key = json.key ?? this.key
      this.url = json.url ?? this.url
      this.html = json.html ?? this.html
      this.title = json.title ?? this.title
      this.query = json.query ?? this.query
      this.popup = json.popup ?? this.popup
      this.loading = json.loading ?? this.loading
      this.fromUrl = json.fromUrl ?? this.fromUrl
      this.fromHtml = json.fromHtml ?? this.fromHtml
      this.fromLocal = json.fromLocal ?? this.fromLocal
      this.checkHttps = json.checkHttps ?? this.checkHttps
      this.checkUrl = json.checkUrl ?? this.checkUrl
    }
    return this
  }

  static toClone(json?: Partial<IWebviewMeta> | null) {
    const uuid = WebviewMeta.uuid
    const instance = new WebviewMeta()
    instance.key = json?.key ?? uuid()
    instance.url = json?.url ?? ''
    instance.html = json?.html ?? ''
    instance.title = json?.title ?? ''
    instance.query = json?.query ?? {}
    instance.popup = json?.popup ?? false
    instance.loading = json?.loading ?? false
    instance.fromUrl = json?.fromUrl ?? false
    instance.fromHtml = json?.fromHtml ?? false
    instance.fromLocal = json?.fromLocal ?? false
    instance.checkHttps = json?.checkHttps ?? false
    instance.checkUrl = json?.checkUrl ?? false
    return instance
  }
}

export interface IWebviewMeta extends Recorder {
  key: string
  url: string
  html: string
  title: string
  query: Recorder
  popup: boolean
  loading: boolean
  fromUrl: boolean
  fromHtml: boolean
  fromLocal: boolean
  checkHttps: boolean
  checkUrl: boolean
}
