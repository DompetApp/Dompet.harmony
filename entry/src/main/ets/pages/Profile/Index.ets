import { fileIo } from "@kit.CoreFileKit"
import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { Toast } from "../../components/Toast/Index"
import { FocusMgr } from "../../utils/focus"
import { store } from "../../globals/store"
import { event } from "../../globals/event"
import { IUser } from "../../models/user"
import { Empty } from "../../utils/empty"
import { unit } from "../../utils/unity"
import { image } from "@kit.ImageKit"
import { UIUtils } from "@kit.ArkUI"


@HMRouter({
  pageUrl: AppRouter.profile,
  singleton: true
})
@ComponentV2
export struct PageProfile {
  @Local name: string = ''
  @Local user: IUser = store.user
  @Local avatar: Uint8Array | null = null
  @Local focusMgr: FocusMgr = new FocusMgr(this.getUIContext())
  @Local readonly: boolean = true

  @Computed
  get userAvatar() {
    if (this.avatar) {
      const avatar = UIUtils.getTarget(this.avatar)
      const imgSource = image.createImageSource(avatar.buffer)
      return imgSource.createPixelMapSync()
    }

    if (this.user.avatar) {
      const avatar = UIUtils.getTarget(this.user.avatar)
      const imgSource = image.createImageSource(avatar.buffer)
      return imgSource.createPixelMapSync()
    }

    return $rawfile('images/home/avatar.png')
  }

  @Builder
  backRouteBuilder() {
    Column() {
      Column() {
        Image($rawfile('images/auth/back.png'))
          .onClick(() => AppRouterMgr.pop())
          .margin({ left: unit.vp(20) })
          .objectFit(ImageFit.Fill)
          .height(unit.vp(36))
          .width(unit.vp(36))
          .draggable(false)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(unit.wmax(640))
      .height('100%')
    }
    .width('100%')
    .height(unit.vp(56))
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  scrollAreaBuilder() {
    Column() {
      Column() {
        Scroll() {
          Column() {
            Stack({ alignContent: Alignment.Bottom }) {
              Image(this.userAvatar)
                .objectFit(ImageFit.Fill)
                .draggable(false)
                .height('100%')
                .width('100%')

              Column() {
                Text($r('app.string.Change'))
                  .fontWeight(FontWeight.Normal)
                  .letterSpacing(unit.vp(1))
                  .fontSize(unit.fp(11.2))
                  .fontColor(Color.White)
              }
              .backgroundColor('rgba(47, 17, 86, 0.75)')
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .padding({ bottom: unit.vp(3) })
              .height(unit.vp(24))
              .width('100%')
            }
            .backgroundColor('rgba(234, 233, 229, 0.85)')
            .onClick(() => this.pickNewAvatar())
            .margin({ bottom: unit.vp(10) })
            .borderRadius(unit.vp(48))
            .height(unit.vp(96))
            .width(unit.vp(96))
            .clip(true)

            Row() {
              TextInput({ text: $$this.name, placeholder: $r('app.string.Please_enter_your_name') })
                .padding({
                  top: unit.vp(0),
                  left: unit.vp(10),
                  right: unit.vp(10),
                  bottom: unit.vp(0)
                })
                .placeholderColor(this.user.name ? 0x130138 : 0x9f9f9f)
                .placeholderFont({ size: unit.vp(16) })
                .backgroundColor(Color.White)
                .focusable(!this.readonly)
                .borderRadius(unit.vp(0))
                .fontSize(unit.fp(18))
                .fontColor(0x130138)
                .height(unit.vp(18))
                .width('auto')
                .id('name')

              Column() {
                Image($rawfile('images/profile/edit.png'))
                  .margin({ top: unit.vp(1.5) })
                  .objectFit(ImageFit.Fill)
                  .height(unit.vp(20))
                  .width(unit.vp(20))
                  .draggable(false)
              }
              .onClick(() => this.changeUserName())
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .height(unit.vp(42))
              .width(unit.vp(22))
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .margin({ bottom: unit.vp(42) })
            .height(unit.vp(42))

            Column() {
              Row() {
                Column() {
                  Text($r('app.string.Phone'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(unit.vp(56))

                Column() {
                  Text(this.user.phone)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: unit.vp(10) })
              .constraintSize({ minHeight: unit.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Column() {
                  Text($r('app.string.Email'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(unit.vp(56))

                Column() {
                  Text(this.user.email)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: unit.vp(10) })
              .constraintSize({ minHeight: unit.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Column() {
                  Text($r('app.string.Date'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(unit.vp(56))

                Column() {
                  Text(this.user.createDate)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: unit.vp(10) })
              .constraintSize({ minHeight: unit.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Column() {
                  Text($r('app.string.State'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(unit.vp(56))

                Column() {
                  Text(this.user.activate !== 'Y' ? $r('app.string.unavailable') : $r('app.string.available'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(unit.fp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: unit.vp(10) })
              .constraintSize({ minHeight: unit.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
            .constraintSize({
              minWidth: unit.vp(100),
              minHeight: unit.vp(44),
            })

            Text($r('app.string.Update'))
              .onClick(() => this.updateUser())
              .backgroundColor(Color.Transparent)
              .fontWeight(FontWeight.Medium)
              .letterSpacing(unit.vp(1.2))
              .borderRadius(unit.vp(20))
              .fontSize(unit.fp(15))
              .fontColor(0x5b259f)
              .stateStyles({
                pressed: {
                  .backgroundColor('rgba(69, 25, 125, 0.05)')
                }
              })
              .margin({
                top: unit.vp(56),
                bottom: unit.vp(30),
              })
              .padding({
                top: unit.vp(12),
                left: unit.vp(35),
                right: unit.vp(35),
                bottom: unit.vp(12),
              })
          }
          .padding({
            top: unit.vp(110),
            left: unit.vp(30),
            right: unit.vp(30),
            bottom: unit.vp(18)
          })
          .constraintSize({ minHeight: '100%' })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .scrollBar(BarState.Off)
        .height('100%')
        .width('100%')
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .width(unit.wmax(640))
      .height('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }

  async aboutToAppear() {
    this.name = this.user.name
    this.avatar = this.user.avatar
    this.readonly = !!this.user.name
  }

  async aboutToDisappear() {
    this.focusMgr.blur()
  }

  async changeUserName() {
    this.focusMgr.focus('name')
    this.readonly = false
  }

  async pickNewAvatar() {
    const photoPicker = new photoAccessHelper.PhotoViewPicker()
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()

    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.isPhotoTakingSupported = false
    photoSelectOptions.isEditSupported = false
    photoSelectOptions.maxSelectNumber = 1

    const promise = photoPicker.select(photoSelectOptions).then(async photoSelectResult => {
      const file = fileIo.openSync(photoSelectResult.photoUris[0], fileIo.OpenMode.READ_ONLY)
      const imgSource = image.createImageSource(file.fd)

      const pixelMap = await imgSource.createPixelMap({
        desiredPixelFormat: 3,
        editable: true,
      })

      const imagePacker: image.ImagePacker = image.createImagePacker()
      const imageOptions: image.PackingOption = { format: "image/jpeg", quality: 100 }
      this.avatar = new Uint8Array(await imagePacker.packToData(pixelMap, imageOptions))
    })

    promise.catch(Empty.fn)
  }

  async updateUser() {
    this.focusMgr.blur()

    this.readonly = true

    if (this.name === this.user.name && this.avatar === this.user.avatar) {
      Toast.show({ message: $r('app.string.Update_user_successfully') })
      return
    }

    await event.updateUser(
      this.user.from({
        avatar: this.avatar,
        name: this.name,
      }),
    )

    Toast.show({ message: $r('app.string.Update_user_successfully') })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.scrollAreaBuilder()
      this.backRouteBuilder()
    }
    .onClick(() => this.focusMgr.blur())
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(0xffffff)
    .height('100%')
    .width('100%')
  }
}
