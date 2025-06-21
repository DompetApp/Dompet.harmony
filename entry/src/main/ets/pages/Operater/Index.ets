import { audio } from "@kit.AudioKit"
import { media } from "@kit.MediaKit"
import { image } from "@kit.ImageKit"
import { UIUtils } from "@kit.ArkUI"
import { dateFormat } from "@hitro/ark"
import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { Toast } from "../../components/Toast/Index"
import { IPayOperate } from "../../models/operate"
import { PayOperate } from "../../models/operate"
import { Message } from "../../models/message"
import { money } from "../../formats/money"
import { event } from "../../globals/event"
import { store } from "../../globals/store"
import { Order } from "../../models/order"
import { IUser } from "../../models/user"
import { unit } from "../../utils/unity"


@HMRouter({
  pageUrl: AppRouter.operater,
  singleton: true
})
@ComponentV2
export struct PageOperater {
  @Local type: string = AppRouterMgr.getCurrentParam() as Unknown
  @Local operate: IPayOperate | null = null
  @Local showShadow: boolean = false
  @Local loginUser: IUser = store.user
  @Local options: IPayOperate[] = []
  @Local money: number = 0.0

  @Computed
  get loginAvatar() {
    if (this.loginUser.avatar) {
      const buffer = UIUtils.getTarget(this.loginUser.avatar).buffer
      const imgSource = image.createImageSource(buffer as Unknown)
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
            Column() {
              Text(money.USD(this.money))
                .fontWeight(FontWeight.Bold)
                .fontSize(unit.vp(32))
                .fontColor(0x2f1155)
            }
            .margin({
              top: unit.vp(100),
              bottom: unit.vp(44),
            })
            .padding({
              left: unit.vp(32),
              right: unit.vp(32),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .width('100%')

            Stack({ alignContent: Alignment.TopStart }) {
              Row() {
                Row() {
                  if (this.operate) {
                    this.operateBuilder({
                      id: this.operate.id,
                      type: this.operate.type,
                      from: this.operate.from,
                      to: this.operate.to,
                    })
                  }
                }
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Top)
                .height(unit.vp(64))
                .layoutWeight(1)

                Column() {
                  Image($rawfile('images/operater/down.png'))
                    .objectFit(ImageFit.Fill)
                    .height(unit.vp(24))
                    .width(unit.vp(24))
                    .draggable(false)
                }
                .padding({ left: unit.vp(15), right: unit.vp(6) })
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Center)
                .height('100%')
              }
              .onClick(() => this.showShadow = !this.showShadow)
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(0xf2f2f2)
              .borderRadius(unit.vp(20))
              .padding({
                top: unit.vp(20),
                left: unit.vp(30),
                right: unit.vp(24),
                bottom: unit.vp(20),
              })
              .height('100%')
              .width('100%')

              Column() {
                ForEach(this.options, (operate: IPayOperate) => {
                  Row() {
                    this.operateBuilder({
                      id: operate.id,
                      type: operate.type,
                      from: operate.from,
                      to: operate.to,
                    })
                  }
                  .onClick(() => {
                    this.change(operate.id)
                  })
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.Start)
                  .height(unit.vp(50))
                  .width('100%')
                })
              }
              .shadow({
                color: 'rgba(0, 0, 0, 0.05)',
                radius: unit.vp2px(5),
                offsetY: unit.vp2px(3),
                offsetX: unit.vp2px(0),
              })
              .padding({ left: unit.vp(30), right: unit.vp(24) })
              .height(this.showShadow ? unit.vp(50 * this.options.length) : 0)
              .animation({ curve: Curve.Linear, duration: 240 })
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(unit.vp(20))
              .margin({ top: 66 })
              .width('100%')
              .clip(true)
            }
            .margin({ bottom: unit.vp(42) })
            .height(unit.vp(64))
            .width(unit.vp(311))
            .clip(false)
            .zIndex(10)

            Column() {
              Grid() {
                ForEach(Array.from({ length: 12 }), (_: Unknown, index) => {
                  GridItem() {
                    Column() {
                      if (index <= 9) {
                        Text(index !== 9 ? `${index + 1}` : '0')
                          .fontWeight(FontWeight.Medium)
                          .fontSize(unit.vp(24))
                          .fontColor(0x363853)
                      }

                      if (index === 10) {
                        Image($rawfile('images/operater/delete.png'))
                          .objectFit(ImageFit.Fill)
                          .height(unit.vp(27))
                          .width(unit.vp(25))
                          .draggable(false)
                      }

                      if (index === 11) {
                        Image($rawfile('images/operater/clear.png'))
                          .objectFit(ImageFit.Fill)
                          .height(unit.vp(24))
                          .width(unit.vp(24))
                          .draggable(false)
                      }
                    }
                    .onClick(() => this.onKeyboardDown(index))
                    .alignItems(HorizontalAlign.Center)
                    .justifyContent(FlexAlign.Center)
                    .backgroundColor(Color.White)
                    .borderRadius(unit.vp(20))
                    .enabled(!this.showShadow)
                    .height(unit.vp(60))
                    .width(unit.vp(60))
                    .stateStyles({
                      pressed: {
                        .backgroundColor(0xf0f0f0)
                      }
                    })
                  }
                })
              }
              .columnsTemplate('1fr 1fr 1fr')
              .columnsGap(unit.vp(35))
              .rowsGap(unit.vp(20))
              .width('100%')
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Start)
            .margin({ bottom: unit.vp(64) })
            .width(unit.vp(250))

            Button($r(`app.string.${this.type}`), { type: ButtonType.Normal, stateEffect: true })
              .onClick(() => this.payMoney())
              .fontWeight(FontWeight.Medium)
              .borderRadius(unit.vp(20))
              .backgroundColor(0x5b259f)
              .enabled(!this.showShadow)
              .fontColor(Color.White)
              .fontSize(unit.vp(20))
              .height(unit.vp(60))
              .width(unit.vp(180))
          }
          .constraintSize({ minHeight: '100%' })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .backgroundColor(Color.White)
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

  @Builder
  iconAvatarBuilder(obj: Unknown) {
    if (this.type !== 'Transfer' && obj.icon?.toLowerCase() === 'me') {
      Image(!this.loginUser.avatar ? $rawfile(`images/payer/${obj.icon.toLowerCase()}.png`) : this.loginAvatar)
        .margin({ right: unit.vp(4) })
        .objectFit(ImageFit.Fill)
        .borderRadius('50%')
        .height(unit.vp(20))
        .width(unit.vp(20))
        .draggable(false)
    }

    if (obj.icon && obj.icon.toLowerCase() !== 'me') {
      Image($rawfile(`images/payer/${obj.icon.toLowerCase()}.png`))
        .margin({ right: unit.vp(4) })
        .objectFit(ImageFit.Fill)
        .borderRadius('50%')
        .height(unit.vp(20))
        .width(unit.vp(20))
        .draggable(false)
    }
  }

  @Builder
  operateBuilder(operate: IPayOperate) {
    Row() {
      Column() {
        this.iconAvatarBuilder({
          icon: this.type == 'Top_up'
            ? operate.from
            : operate.to
        })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .height('100%')

      Column() {
        Text(this.type == 'Top_up' ? $r(`app.string.${operate.from}`) : $r(`app.string.${operate.to}`))
          .fontWeight(FontWeight.Bold)
          .fontSize(unit.vp(16))
          .fontColor(0x363853)
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .height('100%')

      if (this.type == 'Transfer' && this.operate!.from !== this.operate!.to) {
        Row() {
          Column() {
            Image($rawfile('images/operater/left.png'))
              .objectFit(ImageFit.Fill)
              .height(unit.vp(26))
              .width(unit.vp(24))
              .draggable(false)
          }
          .padding({ left: unit.vp(15), right: unit.vp(15) })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('100%')

          Column() {
            this.iconAvatarBuilder({ icon: operate.from })
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('100%')

          Column() {
            Text($r(`app.string.${operate.from}`))
              .fontWeight(FontWeight.Bold)
              .fontSize(unit.vp(16))
              .fontColor(0x363853)
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('100%')
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .height('100%')
      }
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }

  onKeyboardDown(num: number) {
    if (this.showShadow) {
      this.showShadow = false
      return
    }

    if (num <= 9) {
      this.addition(num !== 9 ? `${num + 1}` : '0')
    }

    if (num === 10) {
      this.delete()
    }

    if (num === 11) {
      this.clear()
    }
  }

  addition(num: string) {
    try {
      let cache = 0.0
      let money = Number.parseInt(`${this.money}`)

      if (money != 0) {
        cache = Number.parseInt(`${money}${num}`)
      }

      if (money == 0) {
        cache = Number.parseInt(num)
      }

      if (cache > 999999.0) {
        Toast.show({ message: $r('app.string.The_amount_entered_cannot_exceed', 999999.00) })
      }

      if (cache <= 999999.0) {
        this.money = cache
      }
    } catch (e) {
      /* e */
    }
  }

  delete(num?: string) {
    try {
      let money = Number.parseInt(`${this.money}`)
      let input = `${money}`

      if (input != '') {
        input = input.substring(0, input.length - 1)
      }

      if (input != '') {
        this.money = Number.parseInt(input)
      }

      if (input == '') {
        this.money = 0.0
      }
    } catch (e) {
      /* e */
    }
  }

  clear(num?: string) {
    this.money = 0.0
  }

  change(id: string) {
    this.operate = this.options.find((opt) => opt.id === id)!
    this.showShadow = false
  }

  aboutToDisappear() {
    this.showShadow = false
  }

  aboutToAppear() {
    this.initialize()
  }

  initialize() {
    if (this.type === 'Transfer') {
      this.operate = new PayOperate('1', 'David', 'Me', 'Payment')

      this.options = [
        new PayOperate('1', 'David', 'Me', 'Payment'),
        new PayOperate('2', 'Emma', 'Me', 'Payment'),
        new PayOperate('3', 'Me', 'David', 'Receipt'),
        new PayOperate('4', 'Me', 'Emma', 'Receipt'),
      ]
    }

    if (this.type === 'Payment') {
      this.operate = new PayOperate('5', 'David', 'Me', 'Payment')

      this.options = [
        new PayOperate('5', 'David', 'Me', 'Payment'),
        new PayOperate('6', 'Emma', 'Me', 'Payment'),
        new PayOperate('7', 'Netflix', 'Me', 'Payment'),
        new PayOperate('8', 'PayPal', 'Me', 'Payment'),
      ]
    }

    if (this.type === 'Top_up') {
      this.operate = new PayOperate('9', 'Me', 'David', 'Receipt')

      this.options = [
        new PayOperate('9', 'Me', 'David', 'Receipt'),
        new PayOperate('10', 'Me', 'Emma', 'Receipt'),
        new PayOperate('11', 'Me', 'Me', 'Receipt'),
      ]
    }
  }

  playAudio() {
    const audioRendererInfo: audio.AudioRendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_RINGTONE,
      rendererFlags: 0
    }

    return media.createSoundPool(5, audioRendererInfo).then(async sound => {
      const rawFd = await this.getUIContext().getHostContext()!.resourceManager.getRawFd('medias/pay.wav')
      const loaded = new Promise<void>((resolve) => sound.on('loadComplete', () => resolve()))
      const played = new Promise<void>((resolve) => sound.on('playFinished', () => resolve()))
      const soundId = await sound.load(rawFd.fd, rawFd.offset, rawFd.length)

      const promise = await loaded.then(() => sound.play(soundId))

      played.finally(async () => {
        await sound.unload(soundId)
        await sound.release()
      })

      return promise
    })
  }

  payMoney() {
    if (!this.operate) {
      return
    }

    if (this.money <= 0.0) {
      return
    }

    if (this.showShadow === true) {
      this.showShadow = false
      return
    }

    Promise.resolve().then(async () => {
      try {
        let desc = ''
        let user = ''
        let receive = true

        const now = new Date()
        const type = this.type
        const operate = this.operate!
        const format = 'yyyy-MM-dd HH:mm:ss'
        const date = dateFormat(now, format)
        const from = operate.from
        const to = operate.to

        if (type == 'Top_up') {
          user = from
          desc = user !== 'Me' ? 'You_received_a_top_up_from' : 'You_top_up_some_money'
          receive = true
        }

        if (type == 'Payment') {
          user = to
          desc = 'You_paid_money_to'
          receive = false
        }

        if (type == 'Transfer') {
          user = operate.type === 'Receipt' ? from : to
          desc = operate.type === 'Receipt' ? 'You_received_a_transfer_from' : 'You_transferred_money_to'
          receive = operate.type === 'Receipt'
        }

        const order = Order.from({
          icon: user.toLowerCase(),
          name: user,
          type: type,
          date: date,
          money: receive ? this.money : -this.money,
        })

        const message = Message.from({
          to: receive ? undefined : to,
          from: receive ? from : undefined,
          type: type,
          desc: desc,
          date: date,
          money: receive ? this.money : -this.money,
        })

        await event.createUserMessage(message)
        await event.createUserOrder([order])

        await this.playAudio()

        Toast.show({ message: $r(`app.string.${desc}`, user) })

        this.money = 0.0
      } catch (e) {
        Toast.show({ message: e.toString() })
      }
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.scrollAreaBuilder()
      this.backRouteBuilder()
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onClick(() => this.showShadow = false)
    .backgroundColor(0xffffff)
    .height('100%')
    .width('100%')
  }
}
