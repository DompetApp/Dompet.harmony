import { CreateAxiosDefaults, AxiosRequestConfig, InternalAxiosRequestConfig } from "@ohos/axios"
import { AxiosInstance, AxiosResponse, AxiosError } from "@ohos/axios"
import { SafeDateTimeFormat, logger } from "logger"
import { AppConnect } from "../globals/connect"
import { persistent } from "./persistent"
import { Toast } from "../globals/emiter"
import { crypto } from "../utils/crypto"
import { Cacher } from "../utils/cacher"
import { Empty } from "../utils/empty"
import Axios from "@ohos/axios"


/**
 * 定义 Axios 类型
 */
export interface AxiosDefaultCacher extends Recorder {
  logger: (err: AxiosReturnResponseError, res?: AxiosReturnResponseConfig) => void
  query: (err: AxiosReturnResponseError) => Promise<AxiosReturnResponseConfig | undefined>
  cache: (res: AxiosReturnResponseConfig) => Promise<AxiosReturnResponseConfig>
}

export interface AxiosDefaultConfig extends CreateAxiosDefaults {
  logger?: boolean | null
  cache?: boolean | null
  retry?: number | null
  code?: string | null
}

export interface AxiosProxyRequestConfig extends AxiosRequestConfig {
  logger?: boolean | null
  cache?: boolean | null
  retry?: number | null
  code?: string | null
}

export interface AxiosReturnRequestConfig extends InternalAxiosRequestConfig {
  responsed?: string | null
  requested?: string | null
  logger?: boolean | null
  cache?: boolean | null
  retry?: number | null
  code?: string | null
}

export interface AxiosReturnResponseConfig extends Omit<AxiosResponse, 'config'> {
  config: AxiosReturnRequestConfig
}

export interface AxiosReturnResponseError extends Omit<AxiosError, 'config' | 'response'> {
  response?: AxiosReturnResponseConfig
  config: AxiosReturnRequestConfig
}


/**
 * 创建 Axios 拦截器
 */
const createAxiosInterceptor = (axios: AxiosInstance, cacher: AxiosDefaultCacher) => {
  axios.interceptors.request.use((config: AxiosReturnRequestConfig) => {
    config.headers['token'] ??= persistent.read('token', '')
    config.requested ??= SafeDateTimeFormat.dateAndTime()
    config.responsed = null
    config.cache ??= false
    config.retry ??= -1
    return config
  })

  axios.interceptors.response.use(async (response: AxiosReturnResponseConfig) => {
    response.config.requested ??= SafeDateTimeFormat.dateAndTime()
    response.config.responsed ??= SafeDateTimeFormat.dateAndTime()

    if (response.config.responseType === 'ARRAY_BUFFER') {
      return response
    }

    if (response.config.responseType === 'array_buffer') {
      return response
    }

    if (response.config.cache == true) {
      await cacher.cache(response).catch(Empty.fn)
    }

    return response.data
  })

  axios.interceptors.response.use(null, async (error: AxiosReturnResponseError) => {
    let message: Resource | string | undefined | null
    let response: AxiosReturnResponseConfig | undefined

    if (error.toString().toLowerCase().indexOf('timeout') == -1) {
      message = $r('app.string.System_Abnormality')
    }

    if (error.toString().toLowerCase().indexOf('timeout') > -1) {
      if (error.config?.retry && error.config.retry >= 1) {
        return Promise.reject(error)
      }

      message = $r('app.string.System_Network_Timeout')
    }

    if (error.config && !error.config.requested) {
      error.config.requested = SafeDateTimeFormat.dateAndTime()
    }

    if (error.config && !error.config.responsed) {
      error.config.responsed = SafeDateTimeFormat.dateAndTime()
    }

    if (error.config && error.config.cache) {
      response = await cacher.query(error)
    }

    if (error.config?.logger === true) {
      cacher.logger(error, response)
    }

    if (!response && message) {
      Toast.show({ message: message })
    }

    return response
      ? Promise.resolve(response)
      : Promise.reject(error)
  })

  axios.interceptors.response.use(null, async (error: AxiosReturnResponseError) => {
    if (error.toString().toLowerCase().indexOf('timeout') === -1) {
      return Promise.reject(error)
    }

    if (error.config?.retry && error.config.retry >= 1) {
      await new Promise<void>(resolve => setTimeout(resolve, 100))
      error.config.retry = error.config.retry - 1
      return axios(error.config)
    }

    return Promise.reject(error)
  })

  return axios
}


/**
 * 创建 Axios 实例
 */
const createAxiosInstance = (config: AxiosDefaultConfig) => {
  const proxy = <T>(config: AxiosProxyRequestConfig) => axios(config) as Promise<AxiosResponseResult<T>>
  const axios = createAxiosInterceptor(Axios.create(config), createAxiosCacher(config))
  proxy.options = axios.options
  proxy.delete = axios.delete
  proxy.post = axios.post
  proxy.put = axios.put
  proxy.get = axios.get
  return proxy
}


/**
 * 创建 Axios 缓存器
 */
const createAxiosCacher = (_: AxiosDefaultConfig) => {
  const $logger = async (err: AxiosReturnResponseError, res?: AxiosReturnResponseConfig) => {
    if (!err.config) {
      return
    }

    err.config.logger = null
    err.config.retry = null
    err.config.cache = null
    err.config.code = null

    const path: string = Axios.getUri(err.config)
    const request: Unknown = err.request ?? null
    const response: Unknown = err.response ?? null
    const queryExtra: Unknown = { requested: err.config.requested, responsed: err.config.responsed }
    const queryParams: ESObject = err.config.params ?? null
    const bodyData: ESObject = err.config.data ?? null
    const method: string = err.config.method ?? 'get'

    const detail: ESObject = Object({
      axios: `network request failed`,
      path: path,
      method: method,
      request: request,
      response: response,
      bodyData: bodyData,
      queryExtra: queryExtra,
      queryParams: queryParams,
      responseUsage: res != null ? 'Cached' : 'Unknown',
      errorMessage: err.message ?? null,
      errorCause: err.cause ?? null,
      errorCode: err.code ?? null,
      status: err.status ?? null,
    })

    logger.error(detail, undefined, err.stack ?? new Error().stack)
  }

  const $query = async (err: AxiosReturnResponseError) => {
    if (!err.config || !err.config.url) {
      return
    }

    try {
      const url = Axios.getUri(err.config)
      const code = err.config.code?.toString()
      const cache = err.config.cache ?? false
      const unique = crypto.md5(code ?? url.toString())
      const cacher = cache ? new Cacher(`axios_cache_${unique}`) : null
      const string: string | null = cache ? await cacher!.read() : null
      const source: string | null = string ? crypto.decode(string, 'XDompetTH90JK373') : null
      const storage: Recorder | null = source ? JSON.parse(source) : null

      if (cache == true && cacher != null && storage != null) {
        const response: AxiosReturnResponseConfig = {
          data: cacher.decode(storage.data, storage.decode),
          config: storage.config,
          status: storage.status,
          headers: storage.headers,
          request: storage.request,
          statusText: storage.statusText,
        }

        return response
      }
    } catch (e) {
      /* e */
    }

    return
  }

  const $cache = async (res: AxiosReturnResponseConfig) => {
    if (!res.config.url) {
      return res
    }

    try {
      const url = Axios.getUri(res.config)
      const code = res.config.code?.toString()
      const cache = res.config.cache ?? false
      const unique = crypto.md5(code ?? url.toString())

      res.config.logger = null
      res.config.retry = null
      res.config.cache = null
      res.config.code = null

      if (cache == true && unique.trim()) {
        const cacher = new Cacher(`axios_cache_${unique}`)

        const encode = JSON.stringify({
          data: cacher.encode(res.data),
          decode: res.data instanceof ArrayBuffer ? 'ArrayBuffer' : null,
          config: res.config,
          status: res.status,
          headers: res.headers,
          request: res.request,
          statusText: res.statusText,
        })

        await cacher.write(crypto.encode(encode, 'XDompetTH90JK373'))
      }
    } catch (e) {
      /* e */
    }

    return res
  }

  const $cacher: AxiosDefaultCacher = {
    logger: $logger,
    query: $query,
    cache: $cache,
  }

  return $cacher
}


/**
 * 实例 Axios - request
 */
export const request = createAxiosInstance({
  baseURL: AppConnect.ApiBaseUrl || '/',
  timeout: 9000,
  logger: true,
  retry: 0,
})
