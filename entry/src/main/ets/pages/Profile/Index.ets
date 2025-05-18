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
import { size } from "../../utils/size"
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
          .margin({ left: size.vp(20) })
          .objectFit(ImageFit.Fill)
          .height(size.vp(36))
          .width(size.vp(36))
          .draggable(false)
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
                  .letterSpacing(size.vp(1))
                  .fontSize(size.vp(11.2))
                  .fontColor(Color.White)
              }
              .backgroundColor('rgba(47, 17, 86, 0.75)')
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .padding({ bottom: size.vp(3) })
              .height(size.vp(24))
              .width('100%')
            }
            .backgroundColor('rgba(234, 233, 229, 0.85)')
            .onClick(() => this.pickNewAvatar())
            .margin({ bottom: size.vp(10) })
            .borderRadius(size.vp(48))
            .height(size.vp(96))
            .width(size.vp(96))
            .clip(true)

            Row() {
              TextInput({ text: $$this.name, placeholder: $r('app.string.Please_enter_your_name') })
                .padding({
                  top: size.vp(0),
                  left: size.vp(10),
                  right: size.vp(10),
                  bottom: size.vp(0)
                })
                .placeholderColor(this.user.name ? 0x130138 : 0x9f9f9f)
                .placeholderFont({ size: size.vp(16) })
                .backgroundColor(Color.White)
                .focusable(!this.readonly)
                .borderRadius(size.vp(0))
                .fontSize(size.vp(18))
                .fontColor(0x130138)
                .height(size.vp(18))
                .width('auto')
                .id('name')

              Column() {
                Image($rawfile('images/profile/edit.png'))
                  .margin({ top: size.vp(1.5) })
                  .objectFit(ImageFit.Fill)
                  .height(size.vp(20))
                  .width(size.vp(20))
                  .draggable(false)
              }
              .onClick(() => this.changeUserName())
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .height(size.vp(42))
              .width(size.vp(22))
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .margin({ bottom: size.vp(42) })
            .height(size.vp(42))

            Column() {
              Row() {
                Column() {
                  Text($r('app.string.Phone'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(size.vp(56))

                Column() {
                  Text(this.user.phone)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: size.vp(10) })
              .constraintSize({ minHeight: size.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Column() {
                  Text($r('app.string.Email'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(size.vp(56))

                Column() {
                  Text(this.user.email)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: size.vp(10) })
              .constraintSize({ minHeight: size.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Column() {
                  Text($r('app.string.Date'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(size.vp(56))

                Column() {
                  Text(this.user.createDate)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: size.vp(10) })
              .constraintSize({ minHeight: size.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Column() {
                  Text($r('app.string.State'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width(size.vp(56))

                Column() {
                  Text(this.user.activate !== 'Y' ? $r('app.string.unavailable') : $r('app.string.available'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize(size.vp(15))
                    .fontColor(0x130138)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ bottom: size.vp(10) })
              .constraintSize({ minHeight: size.vp(30) })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
            .constraintSize({
              minWidth: size.vp(100),
              minHeight: size.vp(44),
            })

            Text($r('app.string.Update'))
              .onClick(() => this.updateUser())
              .backgroundColor(Color.Transparent)
              .fontWeight(FontWeight.Medium)
              .letterSpacing(size.vp(1.2))
              .borderRadius(size.vp(20))
              .fontSize(size.vp(15))
              .fontColor(0x5b259f)
              .stateStyles({
                pressed: {
                  .backgroundColor('rgba(69, 25, 125, 0.05)')
                }
              })
              .margin({
                top: size.vp(56),
                bottom: size.vp(30),
              })
              .padding({
                top: size.vp(12),
                left: size.vp(35),
                right: size.vp(35),
                bottom: size.vp(12),
              })
          }
          .padding({
            top: size.vp(110),
            left: size.vp(30),
            right: size.vp(30),
            bottom: size.vp(18)
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
      .width(size.wmax(640))
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
