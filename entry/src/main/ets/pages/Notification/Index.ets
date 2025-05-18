import { HMRouter } from "@hadss/hmrouter"
import { AppRouter } from "../../router/constants"
import { AppRouterMgr } from "../../router/manager"
import { GroupMessage } from "../../models/message"
import { IGroupMessage } from "../../models/message"
import { IMessages } from "../../models/message"
import { IMessage } from "../../models/message"
import { dater } from "../../formats/dater"
import { money } from "../../formats/money"
import { store } from "../../globals/store"
import { event } from "../../globals/event"
import { Empty } from "../../utils/empty"
import { size } from "../../utils/size"


@HMRouter({
  pageUrl: AppRouter.notification,
  singleton: true
})
@ComponentV2
export struct PageNotification {
  @Local bodyScroller: Scroller = new Scroller()
  @Local messages: IMessages = store.messages
  @Local headHeight: number = size.vp(156)
  @Local headShadow: boolean = false

  @Computed
  get msgGroups() {
    const msgGroups: IGroupMessage[] = []

    for (const msg of this.messages.list) {
      const year = new Date(msg.date).getFullYear()
      const newGroup = GroupMessage.from({ year: year, messages: [] })

      const group = msgGroups.find((msg) => msg.year == year) || newGroup

      if (group == newGroup) {
        msgGroups.push(newGroup)
      }

      group.messages.push(msg)
    }

    return msgGroups
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
  headerAreaBuilder() {
    Column() {
      Column() {
        Column() {
          Text($r('app.string.Notification'))
            .fontWeight(FontWeight.Bold)
            .letterSpacing(size.vp(3))
            .lineHeight(size.vp(28))
            .fontSize(size.vp(20))
            .fontColor(0x130138)
        }
        .padding({ left: size.vp(32), right: size.vp(32) })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height('100%')
        .width('100%')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width(size.wmax(640))
      .height('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .alignItems(HorizontalAlign.Center)
    .height(size.hp(this.headHeight))
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
    .width('100%')
    .shadow({
      color: this.headShadow ? 'rgba(0, 0, 0, 0.038)' : Color.Transparent,
      radius: this.headShadow ? vp2px(10) : 0,
      offsetY: vp2px(1.2),
      offsetX: vp2px(0),
    })
  }

  @Builder
  scrollAreaBuilder() {
    Column() {
      Column() {
        Scroll(this.bodyScroller) {
          Stack({ alignContent: Alignment.Top }) {
            Column()
              .height(`calc(100% + ${size.vp(100)}vp)`)
              .width('100%')

            Column() {
              ForEach(this.msgGroups, (group: IGroupMessage) => {
                Column() {
                  Column() {
                    Text(group.year === new Date().getFullYear() ? $r('app.string.This_year') : `${group.year}`)
                      .letterSpacing(group.year === new Date().getFullYear() ? 3 : 1)
                      .fontWeight(FontWeight.Bold)
                      .fontSize(size.vp(14.8))
                      .fontColor(0x363853)
                  }
                  .alignItems(HorizontalAlign.Center)
                  .justifyContent(FlexAlign.Center)
                  .margin({ bottom: size.vp(15) })
                  .height(size.vp(20))
                  .width('100%')

                  ForEach(group.messages, (msg: IMessage) => {
                    Column() {
                      Stack({ alignContent: Alignment.TopStart }) {
                        Row() {
                          Column() {
                            Column() {
                              Text(dater.format(msg.date, {
                                dateStyle: 'medium',
                                timeStyle: 'short',
                                hourCycle: 'h23',
                              }))
                                .fontWeight(FontWeight.Normal)
                                .fontSize(size.vp(12))
                                .fontColor(0xafafaf)
                            }
                            .alignItems(HorizontalAlign.Start)
                            .justifyContent(FlexAlign.Center)
                            .height(size.vp(20))
                            .width('100%')

                            Column() {
                              Text($r(`app.string.${msg.desc}`, msg.from || msg.to))
                                .textOverflow({ overflow: TextOverflow.Ellipsis })
                                .wordBreak(WordBreak.BREAK_WORD)
                                .fontWeight(FontWeight.Medium)
                                .lineHeight(size.vp(22))
                                .fontSize(size.vp(14.5))
                                .fontColor(0x363853)
                                .maxLines(2)
                            }
                            .alignItems(HorizontalAlign.Start)
                            .justifyContent(FlexAlign.Start)
                            .width('100%')

                            Column() {
                              Text(money.usd(msg.money))
                                .fontWeight(FontWeight.Medium)
                                .fontSize(size.vp(12))
                                .fontColor(0x606266)
                            }
                            .alignItems(HorizontalAlign.Start)
                            .justifyContent(FlexAlign.Center)
                            .height(size.vp(21))
                            .width('100%')
                          }
                          .alignItems(HorizontalAlign.Start)
                          .justifyContent(FlexAlign.Start)
                          .width(size.vp(220))

                          Image($rawfile(`images/notification/${msg.money > 0 ? 'income.png' : 'expenditure.png'}`))
                            .objectFit(ImageFit.Fill)
                            .height(size.vp(20))
                            .width(size.vp(20))
                            .draggable(false)
                        }
                        .shadow({
                          color: 'rgba(0, 0, 0, 0.058)',
                          radius: vp2px(20),
                          offsetY: vp2px(3),
                          offsetX: vp2px(3),
                        })
                        .padding({
                          top: size.vp(10),
                          left: size.vp(28),
                          right: size.vp(20),
                          bottom: size.vp(10),
                        })
                        .justifyContent(FlexAlign.SpaceBetween)
                        .alignItems(VerticalAlign.Center)
                        .backgroundColor(Color.White)
                        .borderRadius(size.vp(17))
                        .width('100%')

                        if (msg.isRead == 'N') {
                          Column()
                            .position({ top: 0, right: size.vp(9) })
                            .backgroundColor(0xf34d4d)
                            .borderRadius('50%')
                            .height(size.vp(7))
                            .width(size.vp(7))
                        }
                      }
                      .padding(size.vp(1))
                      .height('auto')
                      .width('100%')
                      .onClick(() => {
                        if (msg.isRead == 'N') {
                          this.readMessage(msg)
                        }
                      })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .justifyContent(FlexAlign.Start)
                    .margin({ bottom: size.vp(10) })
                    .width('100%')
                  }, (item: IMessage) => `${item.id}`)
                }
                .margin({ bottom: size.vp(20) })
                .padding({ bottom: size.vp(1.2) })
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Start)
                .width(size.vp(312))
              })
            }
            .padding({
              top: size.vp(156),
              left: size.vp(32),
              right: size.vp(32),
            })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Start)
            .backgroundColor(Color.White)
            .width('100%')
          }
          .height('auto')
          .width('100%')
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .onDidScroll((offset) => this.onDidScroll(offset))
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

  readMessage(message: IMessage) {
    event.readUserMessage(message).catch(Empty.fn)
  }

  onDidScroll(_: number) {
    this.headHeight = size.vp(156) - this.bodyScroller.currentOffset().yOffset
    this.headHeight = Math.min(this.headHeight, size.vp(156))
    this.headHeight = Math.max(this.headHeight, size.vp(56))
    this.headShadow = this.headHeight <= size.vp(56)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.scrollAreaBuilder()
      this.headerAreaBuilder()
      this.backRouteBuilder()
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(0xffffff)
    .height('100%')
    .width('100%')
  }
}
