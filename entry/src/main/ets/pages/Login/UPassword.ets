import { common } from "@kit.AbilityKit"
import { i18n } from "@kit.LocalizationKit"
import { authentication } from "@kit.AccountKit"
import { appAccount } from "@kit.BasicServicesKit"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { CacheImager } from "../../components/Imager/Index"
import { Dialog } from "../../components/Dialog/Index"
import { Toast } from "../../components/Toast/Index"
import { Servicer } from "../../configure/service"
import { WebviewMeta } from "../../models/web"
import { FocusMgr } from "../../utils/focus"
import { crypto } from "../../utils/crypto"
import { event } from "../../globals/event"
import { Empty } from "../../utils/empty"
import { User } from "../../models/user"
import { unit } from "../../utils/unity"
import Axios from "@ohos/axios"


@ComponentV2
export struct LoginByPassword {
  @Local uid: string = ''
  @Local name: string = ''
  @Local email: string = ''
  @Local phone: string = ''
  @Local openID: string = ''
  @Local unionID: string = ''
  @Local nickName: string = ''
  @Local password: string = ''
  @Local avatarUri: string = ''
  @Local authorizationCode: string = ''
  @Event visitRegister: () => void = Empty.fn
  @Local context: common.UIAbilityContext = this.getUIContext().getHostContext() as Unknown
  @Local focusMgr: FocusMgr = new FocusMgr(this.getUIContext())
  @Local selected: boolean = false
  @Local phoneing: boolean = false
  @Local guesting: boolean = false
  @Local loading: boolean = false

  @Builder
  dialogBuilder(resolve: (_: boolean) => void) {
    Column() {
      Row() {
        Text($r('app.string.User_Agreement_And_Privacy_Policy'))
          .fontWeight(FontWeight.Bold)
          .fontSize(unit.fp(20))
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
        .lineHeight(unit.fp(24))
        .fontSize(unit.fp(15))
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .margin({ top: unit.vp(15) })
      .width('100%')

      Row() {
        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Text($r('app.string.System_Cancel'))
            .fontSize(unit.fp(15))
            .fontColor(0x1f1f1f)
        }
        .onClick(() => {
          resolve(this.selected)
          Dialog.hide()
        })
        .backgroundColor(Color.Transparent)
        .borderRadius(unit.vp(22))
        .height(unit.vp(40))
        .width('48%')

        Button({ type: ButtonType.Normal, stateEffect: false }) {
          Text($r('app.string.AgreeSignIn'))
            .fontSize(unit.fp(15))
            .fontColor(0xffffff)
        }
        .onClick(() => {
          this.selected = true
          resolve(this.selected)
          Dialog.hide()
        })
        .backgroundColor(0xcf0e2c)
        .borderRadius(unit.vp(22))
        .height(unit.vp(40))
        .width('48%')
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(VerticalAlign.Center)
      .margin({ top: unit.vp(15) })
      .width('100%')
    }
    .padding({
      top: unit.vp(20),
      left: unit.vp(20),
      right: unit.vp(20),
      bottom: unit.vp(20)
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

  async getAccountPhone() {
    try {
      this.phoneing = true

      const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest()
      const controller = new authentication.AuthenticationController(this.context)

      authRequest.scopes = ['profile']
      authRequest.permissions = ['serviceauthcode']
      authRequest.forceAuthorization = true

      this.authorizationCode = await controller.executeRequest(authRequest)
        .then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
          this.email = response.data?.email ?? ''
          this.openID = response.data?.openID ?? ''
          this.unionID = response.data?.unionID ?? ''
          this.nickName = response.data?.nickName ?? ''
          this.avatarUri = response.data?.avatarUri ?? ''
          return response.data?.authorizationCode ?? ''
        })

      const credential = await Servicer.getUserCredential(this.authorizationCode)
      const profile = await Servicer.getUserProfile(credential.access_token)

      if (!profile.purePhoneNumber) {
        throw new Error('profile.purePhoneNumber is empty')
      }

      this.avatarUri = profile.headPictureURL ?? this.avatarUri
      this.name = profile.displayName ?? this.nickName ?? this.phone
      this.phone = profile.purePhoneNumber
      this.email = profile.email
    } catch {
      Toast.show({ message: $r('app.string.Failed_to_get_mobile_phone_number') })
    }

    this.phoneing = false
    this.guesting = false
    this.loading = false
  }

  async checkAgreements() {
    if (!this.selected) {
      return new Promise<boolean>(resolve => {
        Dialog.custom({
          autoCancel: false,
          builder: () => this.dialogBuilder(resolve),
          offset: { dx: 0, dy: unit.vp(-35) },
          width: unit.vp(320),
        })
      })
    }

    return true
  }

  async loginByPassword() {
    if (!this.checkPhone()) {
      Toast.show({
        message: this.phone
          ? $r('app.string.The_phone_format_is_incorrect')
          : $r('app.string.The_phone_is_empty')
      })
      return
    }

    if (!this.checkPassword()) {
      Toast.show({
        message: this.password
          ? $r('app.string.The_password_is_less_characters', 6)
          : $r('app.string.The_password_is_empty')
      })
      return
    }

    if (!await this.checkAgreements()) {
      return
    }

    try {
      this.loading = true

      const bundleName = this.context.abilityInfo.bundleName
      const appAccountMgr = appAccount.createAppAccountManager()
      const appAccounts = await appAccountMgr.getAccountsByOwner(this.context.abilityInfo.bundleName)

      if (!appAccounts.some(account => account.owner === bundleName && account.name === this.phone)) {
        Toast.show({ message: $r('app.string.This_account_has_not_been_registered_yet') })
        this.phoneing = false
        this.guesting = false
        this.loading = false
        return
      }

      if (crypto.md5(this.password) !== await appAccountMgr.getCredential(this.phone, 'password')) {
        Toast.show({ message: $r('app.string.The_password_is_incorrect') })
        this.phoneing = false
        this.guesting = false
        this.loading = false
        return
      }

      this.uid = crypto.md5(this.phone)
      this.name ??= this.phone

      this.loginUser()
    } catch {
      Toast.show({ message: $r('app.string.Failed_to_login_user') })
      this.phoneing = false
      this.guesting = false
      this.loading = false
    }
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
      this.phoneing = false
      this.guesting = false
      this.loading = false
      return
    }

    await event.login().catch(Empty.fn)
    this.phoneing = false
    this.guesting = false
    this.loading = false
  }

  checkPassword() {
    return /^.{6,}$/.test(this.password)
  }

  isInChinese() {
    const region = i18n.System.getSystemLanguage()
    return /zh|cn/i.test(region)
  }

  checkPhone() {
    return /^\d{11}$/.test(this.phone)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Column() {
          Row() {
            Column() {
              CacheImager({
                imagerOptions: {
                  loadSrc: $r('app.media.startIcon'),
                  objectFit: ImageFit.Fill,
                },
                adaptiveHeight: unit.vp(66),
                adaptiveWidth: unit.vp(66),
                loading: false,
                error: false,
              })
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(unit.vp(20))
            .padding(unit.vp(7))
            .height(unit.vp(80))
            .width(unit.vp(80))
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .margin({ top: unit.vh(6) })
          .constraintSize({
            minHeight: unit.vp(150),
            maxHeight: unit.vp(180)
          })
          .height('40%')
          .width('100%')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height('auto')
        .width('100%')

        Column() {
          Stack({ alignContent: Alignment.TopStart }) {
            TextInput({ text: $$this.phone, placeholder: $r('app.string.Please_input_phone_number') })
              .onSubmit(() => this.focusMgr.focus('login_pwd'))
              .constraintSize({ minHeight: unit.vp(52) })
              .placeholderFont({ size: unit.vp(13) })
              .enterKeyType(EnterKeyType.Next)
              .padding({ left: unit.vp(68) })
              .inputFilter('^[0-9]{0,11}$')
              .backgroundColor(Color.White)
              .type(InputType.PhoneNumber)
              .placeholderColor(0x909399)
              .borderRadius(unit.vp(20))
              .fontSize(unit.fp(14))
              .fontColor(0x303133)
              .id('login_phone')
              .maxLength(11)

            Row() {
              Text('+86')
                .fontWeight(FontWeight.Regular)
                .fontSize(unit.fp(14))
                .fontColor(0x000000)

              Divider()
                .position({
                  top: unit.vp(18),
                  right: unit.vp(5)
                })
                .strokeWidth(unit.vp(1.4))
                .height(unit.vp(16))
                .color(0xcfcfcf)
                .vertical(true)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .height(unit.vp(52))
            .width(unit.vp(58))
          }
          .height('auto')
          .width('100%')

          Stack({ alignContent: Alignment.TopStart }) {
            TextInput({ text: $$this.password, placeholder: $r('app.string.Please_input_password') })
              .constraintSize({ minHeight: unit.vp(52) })
              .placeholderFont({ size: unit.vp(13) })
              .enterKeyType(EnterKeyType.Next)
              .padding({ left: unit.vp(68) })
              .backgroundColor(Color.White)
              .placeholderColor(0x909399)
              .borderRadius(unit.vp(20))
              .type(InputType.Password)
              .showPasswordIcon(false)
              .fontSize(unit.fp(14))
              .fontColor(0x303133)
              .id('login_pwd')

            Row() {
              SymbolGlyph($r('sys.symbol.lock'))
                .fontWeight(FontWeight.Regular)
                .fontSize(unit.fp(18.5))
                .fontColor([0x000000])

              Divider()
                .position({
                  top: unit.vp(18),
                  right: unit.vp(5)
                })
                .strokeWidth(unit.vp(1.4))
                .height(unit.vp(16))
                .color(0xcfcfcf)
                .vertical(true)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .height(unit.vp(52))
            .width(unit.vp(58))
          }
          .margin({ top: unit.vp(16) })
          .height('auto')
          .width('100%')
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .padding({ left: unit.vp(15), right: unit.vp(15) })
        .constraintSize({ maxWidth: unit.vp(340) })
        .height('auto')
        .width('100%')

        Column() {
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row() {
              if (this.loading || this.guesting) {
                LoadingProgress()
                  .margin({ right: unit.vp(6) })
                  .height(unit.vp(24))
                  .width(unit.vp(24))
                  .color(Color.White)

                Text($r('app.string.Logging_in'))
                  .fontWeight(FontWeight.Medium)
                  .letterSpacing(unit.vp(0.5))
                  .fontColor(0xffffff)
                  .fontSize(14)
              }

              if (!this.loading && !this.guesting && !this.phoneing) {
                Text(this.checkPhone() ? $r('app.string.Account_Login') : $r('app.string.Get_the_local_phone_number'))
                  .fontWeight(FontWeight.Medium)
                  .letterSpacing(unit.vp(0.5))
                  .fontColor(0xffffff)
                  .fontSize(14)
              }

              if (!this.loading && !this.guesting && this.phoneing) {
                Text($r('app.string.Getting_phone_number'))
                  .fontWeight(FontWeight.Medium)
                  .letterSpacing(unit.vp(0.5))
                  .fontColor(0xffffff)
                  .fontSize(14)
              }
            }
          }
          .onClick(() => this.checkPhone() ? this.loginByPassword() : this.getAccountPhone())
          .backgroundColor(this.loading || this.guesting || this.phoneing ? 0xeb9fab : 0xce0e2d)
          .enabled(!this.loading && !this.guesting)
          .margin({ bottom: unit.vp(18) })
          .borderRadius(unit.vp(20))
          .height(unit.vp(40))
          .width('100%')

          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row() {
              Text($r('app.string.Go_To_Register'))
                .fontColor(this.loading || this.guesting ? 0x909399 : 0x303133)
                .fontWeight(FontWeight.Normal)
                .letterSpacing(unit.vp(0.5))
                .fontSize(14)
            }
          }
          .enabled(!this.loading && !this.guesting || this.phoneing)
          .onClick(() => this.visitRegister())
          .margin({ bottom: unit.vp(18) })
          .backgroundColor(0xe6e7e9)
          .borderRadius(unit.vp(20))
          .height(unit.vp(40))
          .width('100%')
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding({ left: unit.vp(15), right: unit.vp(15) })
        .constraintSize({ maxWidth: unit.vp(330) })
        .margin({ top: unit.vh(6) })
        .height('auto')
        .width('100%')

        Column() {
          Text($r('app.string.Guest_Mode'))
            .enabled(!this.loading && !this.guesting || this.phoneing)
            .onClick(() => this.loginByGuest())
            .backgroundColor(Color.Transparent)
            .fontWeight(FontWeight.Medium)
            .letterSpacing(unit.vp(0.5))
            .borderRadius(unit.vp(20))
            .fontSize(unit.fp(14))
            .fontColor(0x909399)
            .stateStyles({
              pressed: {
                .backgroundColor(0xe6e7e9)
              }
            })
            .padding({
              top: unit.vp(10),
              left: unit.vp(22),
              right: unit.vp(22),
              bottom: unit.vp(10),
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .height(unit.vh(24))
        .width('100%')
      }
      .padding({ bottom: unit.vp(30) })
      .height('auto')
      .width('100%')

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Row() {
          Checkbox({ name: 'privacyCheckbox' })
            .onChange(value => this.selected = value)
            .selectedColor(0xce0e2d)
            .select(this.selected)
            .height(unit.vp(15))
            .width(unit.vp(15))
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .height(unit.vp(18))
        .width(unit.vp(24))

        Row() {
          Text() {
            Span($r('app.string.I_have_read_and_agree'))
              .fontWeight(FontWeight.Normal)
              .fontSize(unit.fp(12))
              .fontColor(0x909399)

            Span(this.isInChinese() ? "《" : " 《")
              .fontWeight(FontWeight.Medium)
              .fontSize(unit.fp(12))
              .fontColor(0x303133)

            Span($r('app.string.Huawei_Account_Authentication_Agreement'))
              .fontWeight(FontWeight.Medium)
              .fontSize(unit.fp(12))
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
              .fontSize(unit.fp(12))
              .fontColor(0x303133)

            Span(this.isInChinese() ? "《" : " 《")
              .fontWeight(FontWeight.Medium)
              .fontSize(unit.fp(12))
              .fontColor(0x303133)

            Span($r('app.string.Dompet_Wallet_Privacy_Policy'))
              .fontWeight(FontWeight.Medium)
              .fontSize(unit.fp(12))
              .fontColor(0x303133)
              .onClick(Empty.fn)

            Span(this.isInChinese() ? "》" : "》 ")
              .fontWeight(FontWeight.Medium)
              .fontSize(unit.fp(12))
              .fontColor(0x303133)
          }
        }
        .onClick(() => this.selected = !this.selected)
        .constraintSize({ minHeight: unit.vp(18) })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height('auto')
      }
      .padding({ left: unit.vp(20), right: unit.vp(20) })
      .position({ left: 0, bottom: 0 })
      .width('100%')
    }
    .constraintSize({ minHeight: '100%' })
    .height('auto')
    .width('100%')
  }
}