import { isString, isObject } from "@hitro/ark"
import { IPromiser, toPromise } from "@hitro/ark"
import { AppRouterMgr } from "../router/manager"
import { AppRouter } from "../router/constants"
import { WebviewMeta } from "../models/web"
import { IScheme } from "../models/scheme"
import { store } from "../globals/store"


export class AppSchemer {
  timer: number | null = null
  promiser: IPromiser<boolean> = toPromise()

  public async timeout(promiser: IPromiser<boolean>) {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }

    this.timer = setTimeout(() => {
      if (!promiser.completed) {
        promiser.resolve(false)
      }

      if (this.timer) {
        clearTimeout(this.timer)
        this.timer = null
      }
    }, 90000)
  }

  public async waiting(promiser: IPromiser<boolean>) {
    const status = await store.home.promise

    if (!promiser.completed) {
      promiser.resolve(status)
    }

    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
  }

  public async forward(scheme?: IScheme | null) {
    if (!isString(scheme?.url) || !scheme?.url) {
      return
    }

    if (this.promiser.completed != true) {
      this.promiser.resolve(false)
      clearTimeout(this.timer)
      this.timer = null
    }

    this.promiser = toPromise()
    this.waiting(this.promiser)
    this.timeout(this.promiser)

    this.promiser.then((ready) => {
      if (ready != true || !AppRouter.authorize.includes(scheme.url)) {
        return
      }

      if (scheme.url !== AppRouter.webview) {
        AppRouterMgr.push({ pageUrl: scheme.url, param: scheme.param })
        return
      }

      if (scheme.param instanceof WebviewMeta) {
        AppRouterMgr.push({ pageUrl: scheme.url, param: scheme.param })
        return
      }

      if (isObject(scheme.param)) {
        AppRouterMgr.push({
          pageUrl: scheme.url,
          param: WebviewMeta.fromJson({
            key: isString(scheme.param.key) ? scheme.param.key as string : '',
            url: isString(scheme.param.url) ? scheme.param.url as string : '',
            html: isString(scheme.param.html) ? scheme.param.html as string : '',
            title: isString(scheme.param.title) ? scheme.param.title as string : '',
            query: isObject(scheme.param.query) ? scheme.param.query as Recorder : {},
            checkHttps: scheme.param.checkHttps == true,
            checkUrl: scheme.param.checkUrl == true,
            fromHtml: scheme.param.fromHtml == true,
            fromUrl: scheme.param.fromUrl == true,
            loading: scheme.param.loading == true,
            popup: scheme.param.popup == true,
          })
        })

        return
      }
    })
  }

  public close() {
    if (!this.promiser.completed) {
      this.promiser.resolve(false)
    }

    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
  }

  public init() {
    this.promiser.resolve(false)
    this.timer = null
  }
}

export const schemer = new AppSchemer()
