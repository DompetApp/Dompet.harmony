import { Sqliter } from "../configure/sqlite"
import { AppRouterMgr } from "../router/manager"
import { AppRouter } from "../router/constants"
import { UserDatabaser } from "../database/user"
import { AppDatabaser } from "../database/app"
import { IMessage } from "../models/message"
import { IOrder } from "../models/order"
import { ICard } from "../models/card"
import { IUser } from "../models/user"
import { store } from "./store"

export class AppEvent {
  // Auth
  public async login() {
    await Sqliter.initUserDatabase()

    const messages = await this.queryUserMessages()
    const orders = await this.queryUserOrders()
    const card = await this.queryUserCard()
    const user = await this.recentUser()

    await store.storeMessages(messages)
    await store.storeOrders(orders)
    await store.storeCard(card!)
    await store.storeUser(user!)
    await store.login()

    AppRouterMgr.reset({
      pageUrl: AppRouter.home,
      param: null,
    })
  }

  public async logout() {
    await Sqliter.closeUserDatabase()

    await store.clearMessage()
    await store.clearOrder()
    await store.clearCard()
    await store.clearUser()
    await store.logout()

    AppRouterMgr.reset({
      pageUrl: AppRouter.login,
      param: null,
    })
  }

  // User
  public async recentUser() {
    return AppDatabaser.recentUser()
  }

  public async updateUser(user: IUser) {
    const newUser = await AppDatabaser.updateUser(user)
    await store.storeUser(newUser)
    return newUser
  }

  public async createUser(user: IUser) {
    return AppDatabaser.createUser(user)
  }

  // UserCard
  public async queryUserCard() {
    const newCard = await UserDatabaser.queryUserCard()
    await store.storeCard(newCard)
    return newCard
  }

  public async updateUserCard(card: ICard) {
    const newCard = await UserDatabaser.updateUserCard(card)
    await store.storeCard(newCard)
    return newCard
  }

  // UserOrder
  public async queryUserOrders() {
    const newOrders = await UserDatabaser.queryUserOrders()
    await store.storeOrders(newOrders)
    return newOrders
  }

  public async createUserOrder(orders: Array<IOrder>) {
    const newOrders = await UserDatabaser.createUserOrder(orders)
    await store.storeOrders(newOrders)
    await this.queryUserCard()
    return newOrders
  }

  // UserMessage
  public async queryUserMessages() {
    const newMessages = await UserDatabaser.queryUserMessages()
    await store.storeMessages(newMessages)
    return newMessages
  }

  public async readUserMessage(message: IMessage) {
    const newMessages = await UserDatabaser.readUserMessage(message)
    await store.storeMessages(newMessages)
    return newMessages
  }

  public async createUserMessage(message: IMessage) {
    const newMessages = await UserDatabaser.createUserMessage(message)
    await store.storeMessages(newMessages)
    return newMessages
  }
}

export const event = new AppEvent()
