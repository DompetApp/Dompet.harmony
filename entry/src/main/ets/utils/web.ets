import { IWebviewMeta } from "../models/web"
import { WebviewMeta } from "../models/web"

export class WebviewMgr {
  static encodeUrlParams(code: Unknown) {
    try {
      return encodeURIComponent(code)
    } catch {
      return code.toString() as string
    }
  }

  static decodeUrlParams(code: Unknown) {
    try {
      return decodeURIComponent(code)
    } catch {
      return code.toString() as string
    }
  }

  static checkHttps(meta: IWebviewMeta) {
    const regex = /^https:\/\/(?:\S+)|^https?:\/\/127\.0\.0\.1(?:\S+)/
    return regex.test(meta.url ?? '')
  }

  static checkUrl(meta: IWebviewMeta) {
    const regex = /^https?:\/\/([\w-]+\.)+[\w-]+(?:\/[\w- .\/?%&=]*)?/
    return regex.test(meta.url ?? '')
  }

  static parseUrl(meta: IWebviewMeta) {
    const params: Recorder = {} as Recorder
    const query: Recorder = meta.query ?? {}
    const url: string = meta.url ?? ''

    const queryIndex = url.indexOf('?')
    const hashIndex = url.indexOf('#')
    const hasQuery = queryIndex !== -1
    const hasHash = hashIndex !== -1

    if (!hasQuery) {
      let temp = ''

      for (const arr of Object.entries<Recorder>(query)) {
        const decodedKey = WebviewMgr.decodeUrlParams(arr[0])
        const decodedValue = WebviewMgr.decodeUrlParams(arr[1])
        params[decodedKey] = decodedValue
      }

      for (const arr of Object.entries<Recorder>(params)) {
        const encodedKey = WebviewMgr.encodeUrlParams(arr[0])
        const encodedValue = WebviewMgr.encodeUrlParams(arr[1])
        temp = `${encodedKey}=${encodedValue}&${temp}`
      }

      if (temp !== '') {
        temp = temp.trim()
        temp = temp.replace(/&+$/, '')
      }

      if (temp !== '') {
        return `${url}?${temp}`
      }

      return url
    }

    if (hasQuery && !hasHash) {
      let temp = ''
      const path = url.substring(0, queryIndex)
      const search = url.substring(queryIndex + 1)

      search.split('&').forEach((string) => {
        const index = string.indexOf('=')
        const one = index > -1 ? string.substring(0, index) : ''
        const two = index > -1 ? string.substring(index + 1) : ''

        const value = WebviewMgr.decodeUrlParams(two)
        const key = WebviewMgr.decodeUrlParams(one)

        if (key.trim() !== '') {
          params[key] = value
        }
      })

      for (const arr of Object.entries<Recorder>(query)) {
        const decodedKey = WebviewMgr.decodeUrlParams(arr[0])
        const decodedValue = WebviewMgr.decodeUrlParams(arr[1])
        params[decodedKey] = decodedValue
      }

      for (const arr of Object.entries<Recorder>(params)) {
        const encodedKey = WebviewMgr.encodeUrlParams(arr[0])
        const encodedValue = WebviewMgr.encodeUrlParams(arr[1])
        temp = `${encodedKey}=${encodedValue}&${temp}`
      }

      if (temp !== '') {
        temp = temp.trim()
        temp = temp.replace(/&+$/, '')
      }

      if (temp !== '') {
        return `${path}?${temp}`
      }

      return path
    }

    if (hasQuery && hasHash && queryIndex < hashIndex) {
      let temp = ''
      const hash = url.substring(hashIndex)
      const path = url.substring(0, queryIndex)
      const search = url.substring(queryIndex + 1, hashIndex)

      search.split('&').forEach((string) => {
        const index = string.indexOf('=')
        const one = index > -1 ? string.substring(0, index) : ''
        const two = index > -1 ? string.substring(index + 1) : ''

        const value = WebviewMgr.decodeUrlParams(two)
        const key = WebviewMgr.decodeUrlParams(one)

        if (key.trim() !== '') {
          params[key] = value
        }
      })

      for (const arr of Object.entries<Recorder>(query)) {
        const decodedKey = WebviewMgr.decodeUrlParams(arr[0])
        const decodedValue = WebviewMgr.decodeUrlParams(arr[1])
        params[decodedKey] = decodedValue
      }

      for (const arr of Object.entries<Recorder>(params)) {
        const encodedKey = WebviewMgr.encodeUrlParams(arr[0])
        const encodedValue = WebviewMgr.encodeUrlParams(arr[1])
        temp = `${encodedKey}=${encodedValue}&${temp}`
      }

      if (temp !== '') {
        temp = temp.trim()
        temp = temp.replace(/&+$/, '')
      }

      if (temp !== '') {
        return `${path}?${temp}${hash}`
      }

      return `${path}?${hash}`
    }

    if (hasQuery && hasHash && queryIndex > hashIndex) {
      let temp = ''
      const path = url.substring(0, queryIndex)
      const search = url.substring(queryIndex + 1)

      search.split('&').forEach((string) => {
        const index = string.indexOf('=')
        const one = index > -1 ? string.substring(0, index) : ''
        const two = index > -1 ? string.substring(index + 1) : ''

        const value = WebviewMgr.decodeUrlParams(two)
        const key = WebviewMgr.decodeUrlParams(one)

        if (key.trim() !== '') {
          params[key] = value
        }
      })

      for (const arr of Object.entries<Recorder>(query)) {
        const decodedKey = WebviewMgr.decodeUrlParams(arr[0])
        const decodedValue = WebviewMgr.decodeUrlParams(arr[1])
        params[decodedKey] = decodedValue
      }

      for (const arr of Object.entries<Recorder>(params)) {
        const encodedKey = WebviewMgr.encodeUrlParams(arr[0])
        const encodedValue = WebviewMgr.encodeUrlParams(arr[1])
        temp = `${encodedKey}=${encodedValue}&${temp}`
      }

      if (temp !== '') {
        temp = temp.trim()
        temp = temp.replace(/&+$/, '')
      }

      if (temp !== '') {
        return `${path}?${temp}`
      }

      return path
    }

    return ''
  }

  static format(meta: IWebviewMeta) {
    meta = WebviewMeta.fromJson(meta)

    if (meta.html?.trim()) {
      meta = WebviewMeta.fromJson({
        url: meta.url,
        key: meta.key,
        html: meta.html,
        title: meta.title,
        query: meta.query,
        checkHttps: false,
        checkUrl: false,
        fromLocal: false,
        fromHtml: true,
        fromUrl: false,
        loading: false,
        popup: false,
      })
    }

    if (meta.url?.trim()) {
      meta = WebviewMeta.fromJson({
        url: WebviewMgr.parseUrl(meta),
        key: meta.key,
        html: meta.html,
        title: meta.title,
        query: meta.query,
        checkHttps: WebviewMgr.checkHttps(meta),
        checkUrl: WebviewMgr.checkUrl(meta),
        fromLocal: false,
        fromHtml: false,
        fromUrl: true,
        loading: false,
        popup: false,
      })
    }

    return meta
  }
}
