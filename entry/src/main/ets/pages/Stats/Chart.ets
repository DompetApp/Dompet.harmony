import { device } from "../../configure/device"
import { IYearOrder } from "../../models/order"
import { YearOrder } from "../../models/order"
import { IOrders } from "../../models/order"
import { IOrder } from "../../models/order"
import { store } from "../../globals/store"
import { webview } from "@kit.ArkWeb"
import { display } from "@kit.ArkUI"


@ComponentV2
export struct YearBalanceChart {
  @Local years: number[] = []
  @Local moneys: number[] = []
  @Local documentEndScripts: Array<ScriptItem> = []
  @Local documentStartScripts: Array<ScriptItem> = []
  @Local webviewController: webview.WebviewController = new webview.WebviewController()
  @Local bankOrders: IOrders = store.orders
  @Local maxMoney: number = -Infinity
  @Local minMoney: number = Infinity
  @Local attached: boolean = false

  @Computed
  get deviceOrientation() {
    return device.orientation
  }

  @Monitor('deviceOrientation')
  onChangeOrientation() {
    this.render()
  }

  aboutToAppear() {
    this.converter()
  }

  converter() {
    let number = 0
    const groups: IYearOrder[] = []
    const reverses: IOrder[] = [...this.bankOrders.list].reverse()

    const max = (a: number, b: number) => a > b ? a : b
    const min = (a: number, b: number) => a < b ? a : b

    for (const order of reverses) {
      const date = new Date(order.date)
      const year = date.getFullYear()
      const money = order.money

      number += money

      const yearOrder = groups.find(order => order.year === year)

      if (!yearOrder) {
        groups.push(YearOrder.from({ year, money: number }))
      } else {
        yearOrder.money = number
      }
    }

    this.years = groups.map(order => order.year)
    this.moneys = groups.map(order => order.money)
    this.minMoney = this.moneys.length > 0 ? this.moneys.reduce(min) : 0
    this.maxMoney = this.moneys.length > 0 ? this.moneys.reduce(max) : 0
  }

  render() {
    if (this.attached) {
      const left = device.orientation === display.Orientation.LANDSCAPE_INVERTED ? `${px2vp(device.top) + 5}` : '25'
      const right = device.orientation === display.Orientation.LANDSCAPE ? `${px2vp(device.top) + 5}` : '25'

      this.webviewController.runJavaScript(`
        render({
          grid: {
            top: '1%',
            left: '${left}',
            right: '${right}',
            bottom: '0',
          },
          min: ${this.minMoney},
          max: ${this.maxMoney},
          years: [${this.years.join(',')}],
          moneys: [${this.moneys.join(',')}],
          animation: true,
        })
      `)
    }
  }

  build() {
    Column() {
      Web({ src: $rawfile('chart/echart.line.html'), controller: this.webviewController })
        .runJavaScriptOnDocumentStart(this.documentStartScripts)
        .runJavaScriptOnDocumentEnd(this.documentEndScripts)
        .onControllerAttached(() => this.attached = true)
        .backgroundColor('transparent')
        .onPageEnd(() => this.render())
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }
}