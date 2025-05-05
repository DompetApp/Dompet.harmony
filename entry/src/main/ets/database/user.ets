import { dateFormat } from "@hitro/ark"
import { relationalStore } from "@kit.ArkData"
import { CtxManager } from "../configure/context"
import { Message, IMessage } from "../models/message"
import { Order, IOrder } from "../models/order"
import { Card, ICard } from "../models/card"
import { doctor } from "../formats/doctor"
import { logger } from "../tracks/logger"


export class UserDatabaser {
  static db: relationalStore.RdbStore | null = null
  static cfg: relationalStore.StoreConfig = {
    name: 'user.db',
    encrypt: false,
    isReadOnly: false,
    securityLevel: relationalStore.SecurityLevel.S3,
    customDir: 'sqlite/dompet',
  }

  static get created(): boolean {
    return UserDatabaser.db != null
  }

  static async close(): Promise<void> {
    await UserDatabaser.db?.close().catch(() => {
      logger.error('UserDatabaser close error')
      UserDatabaser.db = null
    })
  }

  static async delete(): Promise<void> {
    await UserDatabaser.close()

    await relationalStore.deleteRdbStore(CtxManager.abilityContext, UserDatabaser.cfg).catch(() => {
      logger.error('UserDatabaser delete error')
      UserDatabaser.db = null
    })
  }

  static async create(): Promise<void> {
    await UserDatabaser.close()

    const promise = relationalStore.getRdbStore(CtxManager.abilityContext, UserDatabaser.cfg)

    promise.catch((): Promise<void> => logger.error('UserDatabaser create error'))

    return promise.then(async store => {
      UserDatabaser.db = store

      if (store.version === 0) {
        await store.executeSql(
          `CREATE TABLE UserCard (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            card_no TEXT NOT NULL,
            balance REAL NOT NULL DEFAULT '0.0',
            card_type TEXT NOT NULL,
            bank_name TEXT NOT NULL,
            expiry_date TEXT NOT NULL,
            status TEXT NOT NULL
          )`
        )

        await store.executeSql(
          `CREATE TABLE UserOrder (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            icon TEXT NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            money REAL NOT NULL
          )`
        )

        await store.executeSql(
          `CREATE TABLE UserMessage (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "to" TEXT NOT NULL DEFAULT '',
            "from" TEXT NOT NULL DEFAULT '',
            "type" TEXT NOT NULL,
            "desc" TEXT NOT NULL,
            "date" TEXT NOT NULL,
            "money" REAL NOT NULL,
            "is_read" TEXT NOT NULL DEFAULT 'N'
          )`
        ).catch((e: Error) => {
          console.log(e + '')
        })
      }

      if (store.version === 0) {
        const format = 'yyyy-MM-dd HH:mm:ss'
        const year = new Date().getFullYear()

        const card = Card.from({
          cardNo: '621062xxxxxx8888',
          cardType: 'Debit Card',
          bankName: 'Citibank',
          expiryDate: '2058-12-01',
          balance: 0.0,
          status: 'Y',
        })

        await UserDatabaser.createUserCard(card)

        await UserDatabaser.createUserOrder([
        // year-1
          Order.from({
            icon: 'emma',
            name: 'Emma',
            type: 'Transfer',
            date: dateFormat(new Date(year - 1, 6, 17, 11, 11), format),
            money: 10000.0,
          }),
          Order.from({
            icon: 'me',
            name: 'Me',
            type: 'Top_up',
            date: dateFormat(new Date(year - 1, 9, 2, 17, 3), format),
            money: 50000.0,
          }),
          Order.from({
            icon: 'netflix',
            name: 'Netflix',
            type: 'Payment',
            date: dateFormat(new Date(year - 1, 9, 11, 13, 7), format),
            money: -2000.0,
          }),
          Order.from({
            icon: 'paypal',
            name: 'PayPal',
            type: 'Transfer',
            date: dateFormat(new Date(year - 1, 9, 21, 8, 8), format),
            money: -1500.0,
          }),

          // year-2
          Order.from({
            icon: 'emma',
            name: 'Emma',
            type: 'Payment',
            date: dateFormat(new Date(year - 2, 3, 8, 8, 11), format),
            money: -20000.0,
          }),
          Order.from({
            icon: 'paypal',
            name: 'PayPal',
            type: 'Payment',
            date: dateFormat(new Date(year - 2, 4, 7, 15, 14), format),
            money: -15000.0,
          }),
          Order.from({
            icon: 'me',
            name: 'Me',
            type: 'Top_up',
            date: dateFormat(new Date(year - 2, 6, 6, 17, 19), format),
            money: 20000.0,
          }),
          Order.from({
            icon: 'david',
            name: 'David',
            type: 'Transfer',
            date: dateFormat(new Date(year - 2, 8, 8, 20, 21), format),
            money: -40000.0,
          }),

          // year-3
          Order.from({
            icon: 'netflix',
            name: 'Netflix',
            type: 'Payment',
            date: dateFormat(new Date(year - 3, 5, 30, 14, 25), format),
            money: -3000.0,
          }),
          Order.from({
            icon: 'emma',
            name: 'Emma',
            type: 'Top_up',
            date: dateFormat(new Date(year - 3, 7, 11, 9, 1), format),
            money: 55000.0,
          }),
          Order.from({
            icon: 'paypal',
            name: 'PayPal',
            type: 'Payment',
            date: dateFormat(new Date(year - 3, 7, 19, 13, 7), format),
            money: -700.0,
          }),
          Order.from({
            icon: 'david',
            name: 'David',
            type: 'Transfer',
            date: dateFormat(new Date(year - 3, 9, 3, 9, 57), format),
            money: 27000.0,
          }),

          // year-4
          Order.from({
            icon: 'emma',
            name: 'Emma',
            type: 'Transfer',
            date: dateFormat(new Date(year - 4, 6, 1, 9, 37), format),
            money: -40000.0,
          }),
          Order.from({
            icon: 'paypal',
            name: 'PayPal',
            type: 'Payment',
            date: dateFormat(new Date(year - 4, 6, 20, 11, 11), format),
            money: -5000.0,
          }),
          Order.from({
            icon: 'me',
            name: 'Me',
            type: 'Top_up',
            date: dateFormat(new Date(year - 4, 9, 9, 19, 17), format),
            money: 3000.0,
          }),
          Order.from({
            icon: 'david',
            name: 'David',
            type: 'Transfer',
            date: dateFormat(new Date(year - 4, 10, 17, 15, 11), format),
            money: 2500.0,
          }),

          // year-5
          Order.from({
            icon: 'me',
            name: 'Me',
            type: 'Top_up',
            date: dateFormat(new Date(year - 5, 9, 21, 5, 10), format),
            money: 200000.0,
          }),
          Order.from({
            icon: 'netflix',
            name: 'Netflix',
            type: 'Payment',
            date: dateFormat(new Date(year - 5, 10, 9, 17, 12), format),
            money: -1800.0,
          }),
          Order.from({
            icon: 'paypal',
            name: 'PayPal',
            type: 'Transfer',
            date: dateFormat(new Date(year - 5, 11, 1, 8, 36), format),
            money: -12000.0,
          }),
          Order.from({
            icon: 'david',
            name: 'David',
            type: 'Transfer',
            date: dateFormat(new Date(year - 5, 12, 22, 15, 22), format),
            money: -20000.0,
          }),
        ])

        await UserDatabaser.createUserMessage([
        // year-1
          Message.from({
            to: '',
            from: 'Emma',
            type: 'Transfer',
            desc: 'You_received_a_transfer_from',
            date: dateFormat(new Date(year - 1, 6, 17, 11, 11), format),
            money: 10000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: '',
            from: 'Me',
            type: 'Top_up',
            desc: 'You_top_up_some_money',
            date: dateFormat(new Date(year - 1, 9, 2, 17, 3), format),
            money: 50000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'Netflix',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 1, 9, 11, 13, 7), format),
            money: -2000.0,
          }),
          Message.from({
            to: 'PayPal',
            from: '',
            type: 'Transfer',
            desc: 'You_transferred_money_to',
            date: dateFormat(new Date(year - 1, 9, 21, 8, 8), format),
            money: -1500.0,
          }),

          // year-2
          Message.from({
            to: 'Emma',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 2, 3, 8, 8, 11), format),
            money: -20000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'PayPal',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 2, 4, 7, 15, 14), format),
            money: -15000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: '',
            from: 'Me',
            type: 'Top_up',
            desc: 'You_top_up_some_money',
            date: dateFormat(new Date(year - 2, 6, 6, 17, 19), format),
            money: 20000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'David',
            from: '',
            type: 'Transfer',
            desc: 'You_transferred_money_to',
            date: dateFormat(new Date(year - 2, 8, 8, 20, 21), format),
            money: -40000.0,
            isRead: 'Y',
          }),

          // year-3
          Message.from({
            to: 'Netflix',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 3, 5, 30, 14, 25), format),
            money: -3000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: '',
            from: 'Emma',
            type: 'Top_up',
            desc: 'You_received_a_top_up_from',
            date: dateFormat(new Date(year - 3, 7, 11, 9, 1), format),
            money: 55000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'PayPal',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 3, 7, 19, 13, 7), format),
            money: -700.0,
            isRead: 'Y',
          }),
          Message.from({
            to: '',
            from: 'David',
            type: 'Transfer',
            desc: 'You_received_a_transfer_from',
            date: dateFormat(new Date(year - 3, 9, 3, 9, 57), format),
            money: 27000.0,
            isRead: 'Y',
          }),

          // year-4
          Message.from({
            to: 'Emma',
            from: '',
            type: 'Transfer',
            desc: 'You_transferred_money_to',
            date: dateFormat(new Date(year - 4, 6, 1, 9, 37), format),
            money: -40000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'PayPal',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 4, 6, 20, 11, 11), format),
            money: -5000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: '',
            from: 'Me',
            type: 'Top_up',
            desc: 'You_top_up_some_money',
            date: dateFormat(new Date(year - 4, 9, 9, 19, 17), format),
            money: 3000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: '',
            from: 'David',
            type: 'Transfer',
            desc: 'You_received_a_transfer_from',
            date: dateFormat(new Date(year - 4, 10, 17, 15, 11), format),
            money: 2500.0,
            isRead: 'Y',
          }),

          // year-5
          Message.from({
            to: '',
            from: 'Me',
            type: 'Top_up',
            desc: 'You_top_up_some_money',
            date: dateFormat(new Date(year - 5, 9, 21, 5, 10), format),
            money: 200000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'Netflix',
            from: '',
            type: 'Payment',
            desc: 'You_paid_money_to',
            date: dateFormat(new Date(year - 5, 10, 9, 17, 12), format),
            money: -1800.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'PayPal',
            from: '',
            type: 'Transfer',
            desc: 'You_transferred_money_to',
            date: dateFormat(new Date(year - 5, 11, 1, 8, 36), format),
            money: -12000.0,
            isRead: 'Y',
          }),
          Message.from({
            to: 'David',
            from: '',
            type: 'Transfer',
            desc: 'You_transferred_money_to',
            date: dateFormat(new Date(year - 5, 12, 22, 15, 22), format),
            money: -166200.0,
            isRead: 'Y',
          }),
        ])
      }

      store.version = 1
    })
  }

  // UserCard
  static async createUserCard(card: ICard): Promise<ICard | null> {
    if (!UserDatabaser.db) {
      return null
    }

    const transaction = await UserDatabaser.db.createTransaction()

    try {
      await transaction.execute(
        'insert into UserCard(card_no, balance, card_type, bank_name, expiry_date, status) VALUES(?, ?, ?, ?, ?, ?)',
        [
          card.cardNo,
          card.balance,
          card.cardType,
          card.bankName,
          card.expiryDate,
          card.status,
        ]
      )

      await transaction.commit()
      return card
    } catch {
      await transaction.rollback()
      return null
    }
  }

  static async updateUserCard(card: ICard): Promise<ICard | null> {
    if (!UserDatabaser.db) {
      return null
    }

    const transaction = await UserDatabaser.db.createTransaction()

    try {
      const predicates = new relationalStore.RdbPredicates("UserCard").equalTo("id", card.id)
      const resultSet = await transaction.query(predicates, ['id'])
      const found = resultSet.goToFirstRow()

      if (found) {
        card.expiryDate = dateFormat(new Date(), 'yyyy-MM-dd HH:mm:ss')

        await transaction.execute(
          'update UserCard set card_no = ?, balance = ?, card_type = ?, bank_name = ?, expiry_date = ?, status = ? where id == ?',
          [
            card.cardNo,
            card.balance,
            card.cardType,
            card.bankName,
            card.expiryDate,
            card.status,
            card.id,
          ]
        )
      }

      await transaction.commit()
      return found ? card : null
    } catch {
      await transaction.rollback()
      return null
    }
  }

  static async queryUserCard(card?: ICard): Promise<ICard | null> {
    if (!UserDatabaser.db) {
      return null
    }

    const transaction = await UserDatabaser.db.createTransaction()

    try {
      const resultSet = await transaction.querySql(`
        select
          id,
          card_no,
          balance,
          card_type,
          bank_name,
          expiry_date,
          status
        from UserCard
        order by datetime(expiry_date) desc
      `)

      const value = resultSet.goToFirstRow() && resultSet.getRow()
      const result = value ? Card.from(doctor.camelCase(value)) : null

      await transaction.commit()
      return result
    } catch {
      await transaction.rollback()
      return null
    }
  }

  // UserOrder
  static async createUserOrder(orders: IOrder | IOrder[]): Promise<IOrder[]> {
    if (!UserDatabaser.db) {
      return []
    }

    if (!Array.isArray(orders)) {
      orders = [orders]
    }

    if (Array.isArray(orders)) {
      const transaction = await UserDatabaser.db.createTransaction()

      try {
        const resultSet = await transaction.querySql(`
          select
            id,
            card_no,
            balance,
            card_type,
            bank_name,
            expiry_date,
            status
          from UserCard
          order by datetime(expiry_date) desc
        `)

        const values: IOrder[] = Array.from(orders)
        const card = Card.from(doctor.camelCase(resultSet.goToFirstRow() && resultSet.getRow() || {}))

        card.balance += values.reduce((total, item) => total + item.money, 0)
        card.expiryDate = dateFormat(new Date(), 'yyyy-MM-dd HH:mm:ss')

        await transaction.batchInsert('UserOrder', values.map((item): Recorder => {
          return Object({
            icon: item.icon,
            name: item.name,
            type: item.type,
            date: item.date,
            money: item.money,
          })
        }))

        await transaction.execute(
          'update UserCard set card_no = ?, balance = ?, card_type = ?, bank_name = ?, expiry_date = ?, status = ? where id == ?',
          [
            card.cardNo,
            card.balance,
            card.cardType,
            card.bankName,
            card.expiryDate,
            card.status,
            card.id,
          ],
        )

        const result: IOrder[] = []
        const resultSet2 = await transaction.querySql(`
          select
            id,
            icon,
            name,
            type,
            date,
            money
          from UserOrder
          order by datetime(date) desc
        `)

        while (resultSet2.goToNextRow()) {
          result.push(Order.from(doctor.camelCase(resultSet2.getRow())))
        }

        await transaction.commit()
        return result
      } catch {
        await transaction.rollback()
        return []
      }
    }

    return []
  }

  static async queryUserOrders(order?: IOrder): Promise<IOrder[]> {
    if (!UserDatabaser.db) {
      return []
    }

    const transaction = await UserDatabaser.db.createTransaction()

    try {
      const result: IOrder[] = []
      const resultSet = await transaction.querySql(`
        select
          id,
          icon,
          name,
          type,
          date,
          money
        from UserOrder
        order by datetime(date) desc
      `)

      while (resultSet.goToNextRow()) {
        result.push(Order.from(doctor.camelCase(resultSet.getRow())))
      }

      await transaction.commit()
      return result
    } catch {
      await transaction.rollback()
      return []
    }
  }

  // UserMessage
  static async createUserMessage(message: IMessage | IMessage[]): Promise<IMessage[]> {
    if (!UserDatabaser.db) {
      return []
    }

    if (!Array.isArray(message)) {
      message = [message]
    }

    if (Array.isArray(message)) {
      const transaction = await UserDatabaser.db.createTransaction()

      try {
        const result: IMessage[] = []
        const values: IMessage[] = Array.from(message)

        for (const item of values) {
          transaction.executeSync(
            'insert into UserMessage("to", "from", "type", "desc", "date", "money", "is_read") VALUES(?, ?, ?, ?, ?, ?, ?)',
            [
              item.to,
              item.from,
              item.type,
              item.desc,
              item.date,
              item.money,
              item.isRead,
            ]
          )
        }

        const resultSet = await transaction.querySql(`
          select
            "id",
            "to",
            "from",
            "type",
            "desc",
            "date",
            "money",
            "is_read"
          from UserMessage
          order by datetime(date) desc
        `)

        while (resultSet.goToNextRow()) {
          result.push(Message.from(doctor.camelCase(resultSet.getRow())))
        }

        await transaction.commit()
        return result
      } catch {
        await transaction.rollback()
        return []
      }
    }

    return []
  }

  static async queryUserMessages(message?: IMessage): Promise<IMessage[]> {
    if (!UserDatabaser.db) {
      return []
    }

    const transaction = await UserDatabaser.db.createTransaction()

    try {
      const result: IMessage[] = []
      const resultSet = await transaction.querySql(`
        select
          "id",
          "to",
          "from",
          "type",
          "desc",
          "date",
          "money",
          "is_read"
        from UserMessage
        order by datetime(date) desc
      `)

      while (resultSet.goToNextRow()) {
        result.push(Message.from(doctor.camelCase(resultSet.getRow())))
      }

      await transaction.commit()
      return result
    } catch {
      await transaction.rollback()
      return []
    }
  }

  static async readUserMessage(message: IMessage): Promise<IMessage[]> {
    if (!UserDatabaser.db) {
      return []
    }

    const transaction = await UserDatabaser.db.createTransaction()

    try {
      const result: IMessage[] = []

      await transaction.execute('update UserMessage set is_read = ? where id == ?', [
        'Y',
        message.id,
      ])

      const resultSet = await transaction.querySql(`
        select
          "id",
          "to",
          "from",
          "type",
          "desc",
          "date",
          "money",
          "is_read"
        from UserMessage
        order by datetime(date) desc
      `)

      while (resultSet.goToNextRow()) {
        result.push(Message.from(doctor.camelCase(resultSet.getRow())))
      }

      await transaction.commit()
      return result
    } catch {
      await transaction.rollback()
      return []
    }
  }
}
