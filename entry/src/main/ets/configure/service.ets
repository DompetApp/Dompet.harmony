import Axios from "@ohos/axios"

export interface IUserCredential {
  refresh_token: string
  access_token: string
  token_type: string
  expires_in: number
  id_token: string
  scope: string
}

export interface IUserProfile {
  phoneCountryCode: string
  purePhoneNumber: string
  displayNameFlag: number
  headPictureURL: string
  mobileNumber: string
  displayName: string
  unionID: string
  openID: string
  email: string
}

export class Servicer {
  static async getUserCredential(code: string) {
    const credential: IUserCredential = {
      refresh_token: '',
      access_token: '',
      token_type: '',
      expires_in: 0,
      id_token: '',
      scope: '',
    }

    const params: Recorder = Object({
      grant_type: 'authorization_code',
      client_secret: '',
      client_id: '',
      code: code,
    })

    return Axios.post('https://oauth-login.cloud.huawei.com/oauth2/v3/token', params).then((response: Unknown) => {
      credential.refresh_token = response.data.refresh_token
      credential.access_token = response.data.access_token
      credential.token_type = response.data.token_type
      credential.expires_in = response.data.expires_in
      credential.id_token = response.data.id_token
      credential.scope = response.data.scope
      return credential
    })
  }

  static async getUserProfile(token: string) {
    const profile: IUserProfile = {
      phoneCountryCode: '',
      purePhoneNumber: '',
      displayNameFlag: 1,
      headPictureURL: '',
      mobileNumber: '',
      displayName: '',
      unionID: '',
      openID: '',
      email: '',
    }

    const params: Recorder = Object({
      access_token: token,
      getNickName: 1,
    })

    return Axios.post('https://account.cloud.huawei.com/rest.php?nsp_svc=GOpen.User.getInfo', params)
      .then((response: Unknown) => {
        profile.phoneCountryCode = response.data.phoneCountryCode
        profile.purePhoneNumber = response.data.purePhoneNumber
        profile.displayNameFlag = response.data.displayNameFlag
        profile.headPictureURL = response.data.headPictureURL
        profile.mobileNumber = response.data.mobileNumber
        profile.displayName = response.data.displayName
        profile.unionID = response.data.unionID
        profile.openID = response.data.openID
        profile.email = response.data.email
        return profile
      })
  }
}
