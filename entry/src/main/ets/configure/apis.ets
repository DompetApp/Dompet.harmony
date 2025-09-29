import { AxiosProxyRequestConfig } from "../configure/axios"
import { request as $request } from "../configure/axios"
import { taskpool } from "@kit.ArkTS"


@Concurrent
async function AxiosRunner(type: string, config: Unknown) {
  switch (type) {
    case '$request': {
      return await $request<Unknown>(config)
    }

    default:
      return
  }
}

export const createProxyer = (type: string) => {
  const proxy = <T>(config: AxiosProxyRequestConfig): Promise<AxiosResponseResult<T>> => {
    return taskpool.execute(AxiosRunner, type, config).catch((err: Unknown) => Promise.reject(err)) as Unknown
  }

  const wrap = (method?: string) => {
    return <T = Unknown>(url?: string, config: AxiosProxyRequestConfig = {}): Promise<AxiosResponseResult<T>> => {
      config.method = method ?? config.method
      config.url = url ?? config.url
      return proxy(config)
    }
  }

  proxy.options = wrap('options')
  proxy.delete = wrap('delete')
  proxy.post = wrap('post')
  proxy.put = wrap('put')
  proxy.get = wrap('get')

  return proxy
}

export const request = createProxyer('$request')
