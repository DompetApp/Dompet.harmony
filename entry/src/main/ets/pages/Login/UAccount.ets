import { i18n } from "@kit.LocalizationKit"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import authentication from "@hms.core.authentication"
import { Dialog } from "../../components/Dialog/Index"
import { Toast } from "../../components/Toast/Index"
import { WebviewMeta } from "../../models/web"
import { event } from "../../globals/event"
import { Empty } from "../../utils/empty"
import { User } from "../../models/user"
import { size } from "../../utils/size"
import Axios from "@ohos/axios"


@ComponentV2
export struct LoginByAccount {
  @Local uid: string = ''
  @Local name: string = ''
  @Local email: string = ''
  @Local phone: string = ''
  @Local openID: string = ''
  @Local unionID: string = ''
  @Local nickName: string = ''
  @Local avatarUri: string = ''
  @Local anonymousPhone: string = ''
  @Event switchMode: () => void = Empty.fn
  @Local context: Context = getContext(this) as Unknown
  @Local selected: boolean = false
  @Local guesting: boolean = false
  @Local loading: boolean = false

  @Builder
  dialogBuilder(resolve: (_: boolean) => void) {
    Column() {
      Row() {
        Text($r('app.string.User_Agreement_And_Privacy_Policy'))
          .fontWeight(FontWeight.Bold)
          .fontSize(size.vp(20))
          .fontColor(0x303133)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
      .height('auto')
      .width('100%')

      Column() {
        Text() {
          Span($r('app.string.I_have_read_and_agree'))
            .fontWeight(FontWeight.Normal)
            .fontColor(0x020202)

          Span(this.isInChinese() ? "《" : " 《")
            .fontWeight(FontWeight.Medium)
            .fontColor(0xd01431)

          Span($r('app.string.Huawei_Account_Authentication_Agreement'))
            .fontWeight(FontWeight.Medium)
            .fontColor(0xd01431)

          Span(this.isInChinese() ? "》" : "》 ")
            .fontWeight(FontWeight.Medium)
            .fontColor(0xd01431)

          Span($r('app.string.And'))
            .fontWeight(FontWeight.Normal)
            .fontColor(0x020202)

          Span(this.isInChinese() ? "《" : " 《")
            .fontWeight(FontWeight.Medium)
            .fontColor(0xd01431)

          Span($r('app.string.Dompet_Wallet_Privacy_Policy'))
            .fontWeight(FontWeight.Medium)
            .fontColor(0xd01431)

          Span(this.isInChinese() ? "》" : "》 ")
            .fontWeight(FontWeight.Medium)
            .fontColor(0xd01431)

          Span("。")
            .fontWeight(FontWeight.Normal)
            .fontColor(0x020202)
        }
        .lineHeight(size.vp(24))
        .fontSize(size.vp(15))
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .margin({ top: size.vp(15) })
      .width('100%')

      Row() {
        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Text($r('app.string.Cancel'))
            .fontSize(size.vp(15))
            .fontColor(0x1f1f1f)
        }
        .onClick(() => {
          resolve(this.selected)
          Dialog.hide()
        })
        .backgroundColor(Color.Transparent)
        .borderRadius(size.vp(22))
        .height(size.vp(40))
        .width('48%')

        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Text($r('app.string.Agree_And_SignIn'))
            .fontSize(size.vp(15))
            .fontColor(0xffffff)
        }
        .onClick(() => {
          this.selected = true
          resolve(this.selected)
          Dialog.hide()
        })
        .backgroundColor(0xcf0e2c)
        .borderRadius(size.vp(22))
        .height(size.vp(40))
        .width('48%')
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(VerticalAlign.Center)
      .margin({ top: size.vp(15) })
      .width('100%')
    }
    .padding({
      top: size.vp(20),
      left: size.vp(20),
      right: size.vp(20),
      bottom: size.vp(20)
    })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
    .height('auto')
    .width('100%')
  }

  async getAccountAvatar(avatar: string) {
    if (!avatar) {
      return null
    }

    return Axios.get(avatar).then((response: Unknown) => {
      return new Uint8Array(response.data)
    })
  }

  async getAnonymousPhone() {
    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest()
    const controller = new authentication.AuthenticationController()

    authRequest.scopes = ['quickLoginAnonymousPhone']
    authRequest.forceAuthorization = false

    return controller.executeRequest(authRequest)
      .then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
        this.anonymousPhone = (response.data?.extraInfo?.quickLoginAnonymousPhone ?? '') as string
        this.avatarUri = response.data?.avatarUri ?? ''
        this.nickName = response.data?.nickName ?? ''
        this.unionID = response.data?.unionID ?? ''
        this.openID = response.data?.openID ?? ''
        this.email = response.data?.email ?? ''
      })
  }

  async checkAgreements() {
    if (!this.selected) {
      return new Promise<boolean>(resolve => {
        Dialog.custom({
          autoCancel: false,
          builder: () => this.dialogBuilder(resolve),
          offset: { dx: 0, dy: size.vp(-35) },
          width: size.vp(320),
        })
      })
    }

    return true
  }

  async loginByAccount() {
    if (!await this.checkAgreements()) {
      return
    }

    this.loading = true
  }

  async loginByGuest() {
    if (!await this.checkAgreements()) {
      return
    }

    this.uid = 'Guest_Uid'
    this.name = 'Guest_User'
    this.phone = 'Guest_Phone'
    this.email = 'anonymous@guest.com'
    this.guesting = true

    this.loginUser()
  }

  async loginUser() {
    const user = await event.createUser(User.from({
      avatar: await this.getAccountAvatar(this.avatarUri).catch(() => null),
      phone: this.phone,
      email: this.email,
      name: this.name,
      uid: this.uid,
    }))

    if (!user) {
      Toast.show({ message: $r('app.string.Failed_to_login_user') })
      this.guesting = false
      this.loading = false
      return
    }

    await event.login().catch(Empty.fn)
    this.guesting = false
    this.loading = false
  }

  aboutToAppear() {
    // this.getAnonymousPhone()
  }

  isInChinese() {
    const region = i18n.System.getSystemRegion()
    return region.startsWith('CN')
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Column() {
          Row() {
            if (!this.avatarUri) {
              Column() {
                Image($r('app.media.startIcon'))
                  .height(size.vp(66))
                  .width(size.vp(66))
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(size.vp(20))
              .padding(size.vp(7))
              .height(size.vp(80))
              .width(size.vp(80))
            }

            if (this.avatarUri) {
              Image(this.avatarUri)
                .backgroundColor(Color.White)
                .borderRadius(size.vp(40))
                .height(size.vp(80))
                .width(size.vp(80))
            }
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .margin({ top: size.vh(6) })
          .constraintSize({
            minHeight: size.vp(150),
            maxHeight: size.vp(180)
          })
          .height('40%')
          .width('100%')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height('auto')
        .width('100%')

        Column() {
          Text(this.anonymousPhone || '******')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .fontSize(size.vp(36))
            .fontColor(0x303133)

          Text($r('app.string.Bind_HuaweiId_Number'))
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.Center)
            .margin({ top: size.vp(12) })
            .fontSize(size.vp(12.4))
            .fontColor(0x909399)
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .height('auto')
        .width('100%')

        Column() {
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row() {
              if (this.loading || this.guesting) {
                LoadingProgress()
                  .margin({ right: size.vp(6) })
                  .height(size.vp(24))
                  .width(size.vp(24))
                  .color(Color.White)
              }

              Text(
                this.loading || this.guesting
                  ? $r('app.string.Logging_in')
                  : $r('app.string.Huawei_Account_OneTap_Login')
              )
                .fontWeight(FontWeight.Medium)
                .letterSpacing(size.vp(0.5))
                .fontColor(0xffffff)
                .fontSize(14)
            }
          }
          .backgroundColor(this.loading || this.guesting ? 0xeb9fab : 0xce0e2d)
          .enabled(!this.loading && !this.guesting)
          .margin({ bottom: size.vp(18) })
          .borderRadius(size.vp(20))
          .height(size.vp(40))
          .width('100%')

          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row() {
              Text($r('app.string.Other_Login_Methods'))
                .fontColor(this.loading || this.guesting ? 0x909399 : 0x303133)
                .fontWeight(FontWeight.Normal)
                .letterSpacing(size.vp(0.5))
                .fontSize(14)
            }
          }
          .enabled(!this.loading && !this.guesting)
          .onClick(() => this.switchMode())
          .margin({ bottom: size.vp(18) })
          .backgroundColor(0xe6e7e9)
          .borderRadius(size.vp(20))
          .height(size.vp(40))
          .width('100%')
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .constraintSize({ maxWidth: size.vp(330) })
        .margin({ top: size.vh(8) })
        .padding({
          left: size.vp(15),
          right: size.vp(15)
        })
        .height('auto')
        .width('100%')

        Column() {
          Text($r('app.string.Guest_Mode'))
            .enabled(!this.loading && !this.guesting)
            .onClick(() => this.loginByGuest())
            .fontWeight(FontWeight.Medium)
            .letterSpacing(size.vp(0.5))
            .fontColor(0x909399)
            .fontSize(14)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .height(size.vh(24))
        .width('100%')
      }
      .padding({ bottom: size.vp(30) })
      .height('auto')
      .width('100%')

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Row() {
          Checkbox({ name: 'privacyCheckbox' })
            .onChange(value => this.selected = value)
            .selectedColor(0xce0e2d)
            .select(this.selected)
            .height(size.vp(15))
            .width(size.vp(15))
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .height(size.vp(18))
        .width(size.vp(24))

        Row() {
          Text() {
            Span($r('app.string.I_have_read_and_agree'))
              .fontWeight(FontWeight.Normal)
              .fontSize(size.vp(12))
              .fontColor(0x909399)

            Span(this.isInChinese() ? "《" : " 《")
              .fontWeight(FontWeight.Medium)
              .fontSize(size.vp(12))
              .fontColor(0x303133)

            Span($r('app.string.Huawei_Account_Authentication_Agreement'))
              .fontWeight(FontWeight.Medium)
              .fontSize(size.vp(12))
              .fontColor(0x303133)
              .onClick(() => {
                AppRouterMgr.push({
                  pageUrl: AppRouter.webview,
                  param: WebviewMeta.fromJson({
                    title: this.context.resourceManager.getStringByNameSync('Huawei_Account_Authentication_Agreement'),
                    url: 'https://privacy.consumer.huawei.com/legal/id/authentication-terms.htm?code=CN&language=zh-CN',
                    key: 'privacy'
                  })
                })
              })

            Span(this.isInChinese() ? "》" : "》 ")
              .fontWeight(FontWeight.Medium)
              .fontSize(size.vp(12))
              .fontColor(0x303133)

            Span(this.isInChinese() ? "《" : " 《")
              .fontWeight(FontWeight.Medium)
              .fontSize(size.vp(12))
              .fontColor(0x303133)

            Span($r('app.string.Dompet_Wallet_Privacy_Policy'))
              .fontWeight(FontWeight.Medium)
              .fontSize(size.vp(12))
              .fontColor(0x303133)
              .onClick(Empty.fn)

            Span(this.isInChinese() ? "》" : "》 ")
              .fontWeight(FontWeight.Medium)
              .fontSize(size.vp(12))
              .fontColor(0x303133)
          }
        }
        .onClick(() => this.selected = !this.selected)
        .constraintSize({ minHeight: size.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height('auto')
      }
      .padding({ left: size.vp(20), right: size.vp(20) })
      .position({ left: 0, bottom: 0 })
      .width('100%')
    }
    .constraintSize({ minHeight: '100%' })
    .height('auto')
    .width('100%')
  }
}
