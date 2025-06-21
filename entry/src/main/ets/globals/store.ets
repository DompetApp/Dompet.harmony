import { UIUtils } from "@kit.ArkUI"
import { toPromise } from "@hitro/ark"
import { i18n } from "@kit.LocalizationKit"
import { persistent } from "../configure/persistent"
import { IMessages, IMessage, Messages } from "../models/message"
import { IOrders, IOrder, Orders } from "../models/order"
import { ICard, Card } from "../models/card"
import { IUser, User } from "../models/user"


@ObservedV2
export class AppStore {
  @Trace locale: string = 'default'
  @Trace expired: number = 0
  @Trace logined: boolean = false
  @Trace messages: IMessages = UIUtils.makeObserved(Messages.init())
  @Trace orders: IOrders = UIUtils.makeObserved(Orders.init())
  @Trace card: ICard = UIUtils.makeObserved(Card.init())
  @Trace user: IUser = UIUtils.makeObserved(User.init())
  @Trace ready = toPromise<boolean>()
  @Trace home = toPromise<boolean>()

  // Auth / Locale
  public async init() {
    this.locale = persistent.read('locale', this.locale)
    this.expired = persistent.read('expired', this.expired)
    this.logined = persistent.read('logined', this.logined)

    this.logined = this.logined && Date.now() < this.expired

    if (!this.logined) {
      this.ready.resolve(false)
    }

    if (this.locale) {
      this.localer(this.locale)
    }
  }

  public async login() {
    const date = new Date()
    const time = date.getTime() + 604800000

    if (this.ready.completed) {
      this.ready = toPromise()
    }

    this.expired = time
    this.logined = true
    this.ready.resolve(true)

    persistent.write('expired', time)
    persistent.write('logined', true)

    return this.ready.promise
  }

  public async logout() {
    const time = Date.now()

    if (this.ready.completed) {
      this.ready = toPromise()
    }

    if (this.home.completed) {
      this.home = toPromise()
    }

    this.expired = time
    this.logined = false
    this.ready.resolve(false)

    persistent.write('expired', time)
    persistent.write('logined', false)

    return this.ready.promise
  }

  public async visited() {
    if (this.home.completed) {
      this.home = toPromise()
    }

    this.home.resolve(true)

    return this.home.promise
  }

  public async localer(locale?: string) {
    locale = locale || 'default'

    if (locale === this.locale) {
      return
    }

    if (locale !== this.locale) {
      i18n.System.setAppPreferredLanguage(locale)
      this.locale = i18n.System.getAppPreferredLanguage()
    }

    if (locale !== this.locale) {
      i18n.System.setAppPreferredLanguage(this.locale)
    }

    if (locale !== 'default') {
      persistent.write('locale', this.locale)
    }

    if (locale === 'default') {
      i18n.System.setAppPreferredLanguage('default')
      persistent.write('locale', 'default')
      this.locale = 'default'
    }
  }

  // Store business
  public async storeMessages(list: Array<IMessage>) {
    this.messages.change(list)
  }

  public async storeOrders(list: Array<IOrder>) {
    this.orders.change(list)
  }

  public async storeCard(card?: ICard | null) {
    if (card != null) {
      this.card.change(card)
    }
  }

  public async storeUser(user?: IUser | null) {
    if (user != null) {
      this.user.change(user)
    }
  }

  // Clear business
  public async clearMessage() {
    this.messages.clear()
  }

  public async clearOrder() {
    this.orders.clear()
  }

  public async clearCard() {
    this.card.clear()
  }

  public async clearUser() {
    this.user.clear()
  }
}

export const store = new AppStore()
