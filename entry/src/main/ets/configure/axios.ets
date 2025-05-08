import { CreateAxiosDefaults, AxiosInstance, AxiosRequestConfig } from "@ohos/axios"
import { InternalAxiosRequestConfig, AxiosResponse } from "@ohos/axios"
import { SafeDateTimeFormat, logger } from "logger"
import { Toast } from "../components/Toast/Index"
import { AppConnect } from "../globals/define"
import { persistent } from "./persistent"
import Axios from "@ohos/axios"


/**
 * 定义 Axios 类型
 */
interface AxiosDefaultConfig extends CreateAxiosDefaults {
  logger?: boolean | null
}

interface AxiosProxyRequestConfig extends AxiosRequestConfig {
  logger?: boolean | null
}

interface AxiosReturnRequestConfig extends InternalAxiosRequestConfig {
  responseTime?: string | null
  requestTime?: string | null
  logger?: boolean | null
}

interface AxiosReturnResponseConfig extends Omit<AxiosResponse, 'config'> {
  config: AxiosReturnRequestConfig
}

interface AxiosReturnResponseError extends Partial<AxiosReturnResponseConfig> {
  response?: AxiosReturnResponseConfig
}


/**
 * 创建 Axios 实例
 */
const createAxiosInstance = (config: AxiosDefaultConfig) => {
  const proxy = <T>(config: AxiosProxyRequestConfig) => axios(config) as Promise<AxiosResponseResult<T>>
  const axios = createAxiosInterceptor(Axios.create(config))
  proxy.options = axios.options
  proxy.request = axios.request
  proxy.delete = axios.delete
  proxy.post = axios.post
  proxy.put = axios.put
  proxy.get = axios.get
  return proxy
}


/**
 * 创建 Axios 拦截器
 */
const createAxiosInterceptor = (axios: AxiosInstance) => {
  axios.interceptors.request.use(
    (config: AxiosReturnRequestConfig) => {
      config.requestTime = SafeDateTimeFormat.dateAndTime()
      config.headers['token'] ??= persistent.read('token')
      return config
    },
  )
  axios.interceptors.response.use(
    (response: AxiosReturnResponseConfig) => {
      response.config.requestTime ??= SafeDateTimeFormat.dateAndTime()
      response.config.responseTime ??= SafeDateTimeFormat.dateAndTime()

      const responseType = response.config.responseType
      const status = response.status as number

      if (status < 200 || status > 300) {
        return Promise.reject(response)
      }

      if (responseType === 'ARRAY_BUFFER') {
        return response
      }

      return response.data
    },
  )
  axios.interceptors.response.use(
    (response: AxiosReturnResponseConfig) => response,
    (error: AxiosReturnResponseError) => {
      let status = 500 as string | number
      let message = null as string | undefined | null

      const response = error.response ?? error
      const promise = Promise.reject(error)
      const stack = new Error().stack

      try {
        status = error.response?.status || error.status || status
        status = error.response?.data?.code || error.data?.code || status
        message = error.response?.data?.message || error.data?.message || null
      } catch {
      }

      if (error.config?.logger === true) {
        const cfg = error.config
        const url: string = (cfg.url ?? '').replace(/^\/+/, '/')
        const base: string = (cfg.baseURL ?? '').replace(/\/+$/, '')
        const headers: ESObject = cfg.headers ?? null
        const queryParams: ESObject = cfg.params ?? null
        const responseTime: string = cfg.responseTime ?? SafeDateTimeFormat.dateAndTime()
        const requestTime: string = cfg.requestTime ?? SafeDateTimeFormat.dateAndTime()
        const bodyData: ESObject = cfg.data ?? null
        const method: string = cfg.method ?? 'get'

        const detail: ESObject = Object({
          axios: `network request failed`,
          path: `${url.startsWith('http') ? url : base + url}`,
          method: method,
          headers: headers,
          bodyData: bodyData,
          queryParams: queryParams,
          requestTime: requestTime,
          responseTime: responseTime,
          responseData: response.data,
          responseError: error instanceof Error && error.message || message,
        })

        logger.error(detail, null, stack)
      }

      if (error.toString().toLowerCase().indexOf('timeout') > -1) {
        Toast.show({ message: $r('app.string.System_Network_Timeout') })
        return promise
      }

      Toast.show({ message: message ? message : $r('app.string.System_Abnormality') })
      return promise
    }
  )
  return axios
}


/**
 * 实例 Axios - request
 */
export const request = createAxiosInstance({
  baseURL: AppConnect.ApiBaseUrl || '/',
  timeout: 30000,
  logger: true,
})

