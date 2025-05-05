import { request } from "../configure/axios"

export class AuthApi {
  /**
   * 登录用户
   */
  static login<T = null, D = Recorder>(data?: D): ApiResult<T> {
    return request<T>({
      url: '/auth/login',
      method: 'post',
      data: data,
    })
  }

  /**
   * 注册用户
   */
  static register<T = Recorder, D = Recorder>(data?: D): ApiResult<T> {
    return request<T>({
      url: '/auth/register',
      method: 'post',
      data: data,
    })
  }
}
