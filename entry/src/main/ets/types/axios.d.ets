interface ApiResult<T> extends Promise<AxiosResponseResult<T>> {}

interface AxiosResponseResult<T = Unknown> {
  code: string | undefined
  message: string | undefined | null
  result: T
}