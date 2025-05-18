import { Sqliter } from "../configure/sqlite"
import { AppRouterMgr } from "../router/manager"
import { AppRouter } from "../router/constants"
import { UserDatabaser } from "../database/user"
import { AppDatabaser } from "../database/app"
import { IMessage } from "../models/message"
import { logger } from "../tracks/logger"
import { IOrder } from "../models/order"
import { ICard } from "../models/card"
import { IUser } from "../models/user"
import { store } from "./store"

export class AppEvent {
  // Auth
  public async login() {
    logger.info('AppEvent.login is called')

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
    logger.info('AppEvent.logout is called')

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
    logger.info('AppEvent.recentUser is called')
    return AppDatabaser.recentUser()
  }

  public async updateUser(user: IUser) {
    logger.info('AppEvent.updateUser is called')
    const newUser = await AppDatabaser.updateUser(user)
    await store.storeUser(newUser)
    return newUser
  }

  public async createUser(user: IUser) {
    logger.info('AppEvent.createUser is called')
    return AppDatabaser.createUser(user)
  }

  // UserCard
  public async queryUserCard() {
    logger.info('AppEvent.queryUserCard is called')
    const newCard = await UserDatabaser.queryUserCard()
    await store.storeCard(newCard)
    return newCard
  }

  public async updateUserCard(card: ICard) {
    logger.info('AppEvent.updateUserCard is called')
    const newCard = await UserDatabaser.updateUserCard(card)
    await store.storeCard(newCard)
    return newCard
  }

  // UserOrder
  public async queryUserOrders() {
    logger.info('AppEvent.queryUserOrders is called')
    const newOrders = await UserDatabaser.queryUserOrders()
    await store.storeOrders(newOrders)
    return newOrders
  }

  public async createUserOrder(orders: Array<IOrder>) {
    logger.info('AppEvent.createUserOrder is called')
    const newOrders = await UserDatabaser.createUserOrder(orders)
    await store.storeOrders(newOrders)
    await this.queryUserCard()
    return newOrders
  }

  // UserMessage
  public async queryUserMessages() {
    logger.info('AppEvent.queryUserMessages is called')
    const newMessages = await UserDatabaser.queryUserMessages()
    await store.storeMessages(newMessages)
    return newMessages
  }

  public async readUserMessage(message: IMessage) {
    logger.info('AppEvent.readUserMessage is called')
    const newMessages = await UserDatabaser.readUserMessage(message)
    await store.storeMessages(newMessages)
    return newMessages
  }

  public async createUserMessage(message: IMessage) {
    logger.info('AppEvent.createUserMessage is called')
    const newMessages = await UserDatabaser.createUserMessage(message)
    await store.storeMessages(newMessages)
    return newMessages
  }
}

export const event = new AppEvent()
