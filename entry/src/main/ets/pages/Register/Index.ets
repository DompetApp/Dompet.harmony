import { common } from "@kit.AbilityKit"
import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { appAccount } from "@kit.BasicServicesKit"
import { AppRouterMgr } from "../../router/manager"
import { Dialog } from "../../components/Dialog/Index"
import { Toast } from "../../components/Toast/Index"
import { WebviewMeta } from "../../models/web"
import { FocusMgr } from "../../utils/focus"
import { crypto } from "../../utils/crypto"
import { i18n } from "@kit.LocalizationKit"
import { event } from "../../globals/event"
import { Empty } from "../../utils/empty"
import { User } from "../../models/user"
import { size } from "../../utils/size"
import Axios from "@ohos/axios"


@HMRouter({
  pageUrl: AppRouter.register,
  singleton: true
})
@ComponentV2
export struct PageRegister {
  @Local uid: string = ''
  @Local name: string = ''
  @Local email: string = ''
  @Local phone: string = ''
  @Local password: string = ''
  @Local avatarUri: string = ''
  @Local confirmPwd: string = ''
  @Local context: common.UIAbilityContext = getContext(this) as Unknown
  @Local focusMgr: FocusMgr = new FocusMgr(this.getUIContext())
  @Local selected: boolean = false
  @Local loading: boolean = false

  @Builder
  backBuilder() {
    Column() {
      Column() {
        Image($rawfile('images/auth/back.png'))
          .onClick(() => AppRouterMgr.pop())
          .margin({ left: size.vp(20) })
          .objectFit(ImageFit.Fill)
          .height(size.vp(36))
          .width(size.vp(36))
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(size.wmax(640))
      .height('100%')
    }
    .width('100%')
    .height(size.vp(56))
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  scrollBuilder() {
    Scroll() {
      Column() {
        Column() {
          Column() {
            Row() {
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
            Stack({ alignContent: Alignment.TopStart }) {
              TextInput({ text: $$this.phone, placeholder: $r('app.string.Please_input_phone_number') })
                .onSubmit(() => this.focusMgr.focus('register_pwd'))
                .constraintSize({ minHeight: size.vp(52) })
                .placeholderFont({ size: size.vp(13) })
                .enterKeyType(EnterKeyType.Next)
                .padding({ left: size.vp(68) })
                .inputFilter('^[0-9]{0,11}$')
                .backgroundColor(Color.White)
                .type(InputType.PhoneNumber)
                .placeholderColor(0x909399)
                .borderRadius(size.vp(20))
                .fontSize(size.vp(14))
                .fontColor(0x303133)
                .id('register_phone')
                .maxLength(11)

              Row() {
                Text('+86')
                  .fontWeight(FontWeight.Regular)
                  .fontSize(size.vp(14))
                  .fontColor(0x000000)

                Divider()
                  .position({
                    top: size.vp(18),
                    right: size.vp(5)
                  })
                  .strokeWidth(size.vp(1.4))
                  .height(size.vp(16))
                  .color(0xcfcfcf)
                  .vertical(true)
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .height(size.vp(52))
              .width(size.vp(58))
            }
            .height('auto')
            .width('100%')

            Stack({ alignContent: Alignment.TopStart }) {
              TextInput({ text: $$this.password, placeholder: $r('app.string.Please_input_password') })
                .onSubmit(() => this.focusMgr.focus('register_confirm_pwd'))
                .constraintSize({ minHeight: size.vp(52) })
                .placeholderFont({ size: size.vp(13) })
                .enterKeyType(EnterKeyType.Next)
                .padding({ left: size.vp(68) })
                .backgroundColor(Color.White)
                .placeholderColor(0x909399)
                .borderRadius(size.vp(20))
                .type(InputType.Password)
                .showPasswordIcon(false)
                .fontSize(size.vp(14))
                .fontColor(0x303133)
                .id('register_pwd')

              Row() {
                SymbolGlyph($r('sys.symbol.lock'))
                  .fontWeight(FontWeight.Regular)
                  .fontSize(size.vp(18.5))
                  .fontColor([0x000000])

                Divider()
                  .position({
                    top: size.vp(18),
                    right: size.vp(5)
                  })
                  .strokeWidth(size.vp(1.4))
                  .height(size.vp(16))
                  .color(0xcfcfcf)
                  .vertical(true)
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .height(size.vp(52))
              .width(size.vp(58))
            }
            .margin({ top: size.vp(16) })
            .height('auto')
            .width('100%')

            Stack({ alignContent: Alignment.TopStart }) {
              TextInput({ text: $$this.confirmPwd, placeholder: $r('app.string.Please_input_confirm_password') })
                .constraintSize({ minHeight: size.vp(52) })
                .placeholderFont({ size: size.vp(13) })
                .enterKeyType(EnterKeyType.Next)
                .padding({ left: size.vp(68) })
                .backgroundColor(Color.White)
                .id('register_confirm_pwd')
                .placeholderColor(0x909399)
                .borderRadius(size.vp(20))
                .type(InputType.Password)
                .showPasswordIcon(false)
                .fontSize(size.vp(14))
                .fontColor(0x303133)

              Row() {
                SymbolGlyph($r('sys.symbol.lock'))
                  .fontWeight(FontWeight.Regular)
                  .fontSize(size.vp(18.5))
                  .fontColor([0x000000])

                Divider()
                  .position({
                    top: size.vp(18),
                    right: size.vp(5)
                  })
                  .strokeWidth(size.vp(1.4))
                  .height(size.vp(16))
                  .color(0xcfcfcf)
                  .vertical(true)
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .height(size.vp(52))
              .width(size.vp(58))
            }
            .margin({ top: size.vp(16) })
            .height('auto')
            .width('100%')
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .padding({ left: size.vp(15), right: size.vp(15) })
          .constraintSize({ maxWidth: size.vp(340) })
          .height('auto')
          .width('100%')

          Column() {
            Button({ type: ButtonType.Normal, stateEffect: true }) {
              Row() {
                if (this.loading) {
                  LoadingProgress()
                    .margin({ right: size.vp(6) })
                    .height(size.vp(24))
                    .width(size.vp(24))
                    .color(Color.White)

                  Text($r('app.string.Logging_in'))
                    .fontWeight(FontWeight.Medium)
                    .letterSpacing(size.vp(0.5))
                    .fontColor(0xffffff)
                    .fontSize(14)
                }

                if (!this.loading) {
                  Text($r('app.string.Account_Registration'))
                    .fontWeight(FontWeight.Medium)
                    .letterSpacing(size.vp(0.5))
                    .fontColor(0xffffff)
                    .fontSize(14)
                }
              }
            }
            .backgroundColor(this.loading ? 0xeb9fab : 0xce0e2d)
            .onClick(() => this.registerUser())
            .margin({ bottom: size.vp(18) })
            .borderRadius(size.vp(20))
            .enabled(!this.loading)
            .height(size.vp(40))
            .width('100%')
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .padding({ left: size.vp(15), right: size.vp(15) })
          .constraintSize({ maxWidth: size.vp(330) })
          .margin({ top: size.vh(6) })
          .height('auto')
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
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .constraintSize({ minHeight: '100%' })
      .width('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .scrollBar(BarState.Off)
    .height('100%')
    .width('100%')
  }

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

  async aboutToDisappear() {
    this.focusMgr.blur()
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

  async registerUser() {
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

    if (!this.checkConfirmPwd()) {
      Toast.show({ message: $r('app.string.The_confirm_password_is_incorrect') })
      return
    }

    if (!await this.checkAgreements()) {
      return
    }

    try {
      this.loading = true

      const appAccountMgr = appAccount.createAppAccountManager()
      const appAccounts = await appAccountMgr.getAccountsByOwner(this.context.abilityInfo.bundleName)

      for (const account of appAccounts) {
        if (account.owner === this.context.abilityInfo.bundleName && account.name === this.phone) {
          Toast.show({ message: $r('app.string.This_account_has_already_been_registered') })
          this.loading = false
          return
        }
      }

      await appAccountMgr.createAccount(this.phone)

      await appAccountMgr.setCredential(this.phone, 'password', crypto.md5(this.password))

      this.uid = crypto.md5(this.phone)
      this.name = this.phone

      this.loginUser()
    } catch {
      Toast.show({ message: $r('app.string.Failed_to_register_user') })
      this.loading = false
    }
  }

  async loginUser() {
    const user = await event.createUser(User.from({
      avatar: await this.getAccountAvatar(this.avatarUri).catch(() => null),
      email: this.email,
      phone: this.phone,
      name: this.name,
      uid: this.uid,
    }))

    if (!user) {
      Toast.show({ message: $r('app.string.Failed_to_login_user') })
      this.loading = false
      return
    }

    await event.login().catch(Empty.fn)
    this.loading = false
  }

  checkConfirmPwd() {
    return this.confirmPwd === this.password
  }

  checkPassword() {
    return /^.{6,}$/.test(this.password)
  }

  isInChinese() {
    const region = i18n.System.getSystemRegion()
    return region.startsWith('CN')
  }

  checkPhone() {
    return /^\d{11}$/.test(this.phone)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.scrollBuilder()
      this.backBuilder()
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onClick(() => this.focusMgr.blur())
    .backgroundColor(0xf1f3f5)
    .height('100%')
    .width('100%')
  }
}