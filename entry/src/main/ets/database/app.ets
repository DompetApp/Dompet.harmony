import { dateFormat } from "@hitro/ark"
import { relationalStore } from "@kit.ArkData"
import { CtxManager } from "../configure/context"
import { doctor } from "../formats/doctor"
import { logger } from "../tracks/logger"
import { Empty } from "../utils/empty"
import { IUser } from "../models/user"
import { User } from "../models/user"


export class AppDatabaser {
  static db: relationalStore.RdbStore | null = null
  static cfg: relationalStore.StoreConfig = {
    name: 'app.db',
    encrypt: false,
    isReadOnly: false,
    securityLevel: relationalStore.SecurityLevel.S3,
    customDir: 'sqlite/dompet',
  }

  static get created(): boolean {
    return AppDatabaser.db != null
  }

  static async close(): Promise<void> {
    await AppDatabaser.db?.close().catch(() => logger.error('AppDatabaser close error'))
    AppDatabaser.db = null
  }

  static async delete(): Promise<void> {
    await AppDatabaser.close()

    await relationalStore.deleteRdbStore(CtxManager.uiAbilityContext, AppDatabaser.cfg).catch(() => {
      logger.error('AppDatabaser delete error')
    })
  }

  static async create(dir?: string | null): Promise<void> {
    await AppDatabaser.close()

    AppDatabaser.cfg.customDir = dir ?? AppDatabaser.cfg.customDir

    const promise = relationalStore.getRdbStore(CtxManager.uiAbilityContext, AppDatabaser.cfg)

    promise.catch((): Promise<void> => logger.error('AppDatabaser create error'))

    return promise.then(async store => {
      AppDatabaser.db = store

      if (store.version === 0) {
        await store.executeSql(
          `CREATE TABLE IF NOT EXISTS AppUser (
            uid TEXT PRIMARY KEY NOT NULL,
            name TEXT,
            phone TEXT,
            email TEXT,
            avatar BLOB,
            activate TEXT NOT NULL DEFAULT 'Y',
            create_date TEXT NOT NULL
          )`
        )
      }

      store.version = 1
    })
  }

  static async connect(dir?: string | null): Promise<void> {
    if (dir && dir !== AppDatabaser.cfg.customDir) {
      await AppDatabaser.close()
    }

    if (!AppDatabaser.db) {
      return AppDatabaser.create(dir)
    }
  }

  static async closeUser(uid?: string | null): Promise<void> {
    if (!AppDatabaser.db) {
      return
    }

    if (!uid) {
      return
    }

    AppDatabaser.db.createTransaction().then(async transaction => {
      await transaction.execute('update AppUser set activate = ? where uid = ?', ['N', uid]).catch(Empty.fn)
      await transaction.commit()
    })
  }

  static async deleteUser(uid?: string | null): Promise<void> {
    if (!AppDatabaser.db) {
      await AppDatabaser.connect()
    }

    if (!AppDatabaser.db) {
      return
    }

    if (!uid) {
      return
    }

    AppDatabaser.db.createTransaction().then(async transaction => {
      const predicates = new relationalStore.RdbPredicates("AppUser").equalTo("uid", uid)
      await transaction.delete(predicates).catch(Empty.fn)
      await transaction.commit()
    })
  }

  static async createUser(user?: IUser | null): Promise<IUser | null> {
    if (!AppDatabaser.db) {
      await AppDatabaser.connect()
    }

    if (!AppDatabaser.db) {
      return null
    }

    if (!user?.uid || !user.phone) {
      return null
    }

    const transaction = await AppDatabaser.db.createTransaction()

    try {
      await transaction.execute('update AppUser set activate = "N" where activate = "Y"')
      const predicates = new relationalStore.RdbPredicates("AppUser").equalTo("phone", user.phone)
      const resultSet = await transaction.query(predicates, ['uid', 'name', 'avatar'])
      const rowValue = resultSet.goToFirstRow() && resultSet.getRow()

      if (rowValue) {
        const uid = (rowValue.uid ?? '') as string
        const name = (rowValue.name ?? '') as string
        const email = (rowValue.email ?? '') as string
        const avatar = (rowValue.avatar ?? null) as Uint8Array | null
        const isChangeAvatar = !avatar && !!user.avatar as boolean
        const isChangeEmail = !email && !!user.email as boolean
        const isChangeName = !name && !!user.name as boolean

        await transaction.execute(
          'update AppUser set name = ?, email = ?, avatar = ?, create_date = ?, activate = ? where uid = ?',
          [
            isChangeName ? user.name : name,
            isChangeEmail ? user.email : email,
            (isChangeAvatar ? user.avatar : avatar) as Unknown as Uint8Array,
            dateFormat(new Date(), 'yyyy-MM-dd HH:mm:ss'),
            'Y',
            uid,
          ]
        )
      }

      if (!rowValue) {
        await transaction.execute(
          'insert into AppUser(uid, name, phone, email, avatar, create_date, activate) VALUES(?, ?, ?, ?, ?, ?, ?)',
          [
            user.uid,
            user.name,
            user.phone,
            user.email,
            user.avatar as Unknown as Uint8Array,
            dateFormat(new Date(), 'yyyy-MM-dd HH:mm:ss'),
            'Y',
          ]
        )
      }

      await transaction.commit()
      return user
    } catch {
      await transaction.rollback()
      return null
    }
  }

  static async updateUser(user?: IUser | null): Promise<IUser | null> {
    if (!AppDatabaser.db) {
      await AppDatabaser.connect()
    }

    if (!AppDatabaser.db) {
      return null
    }

    if (!user?.uid || !user.phone) {
      return null
    }

    const transaction = await AppDatabaser.db.createTransaction()

    try {
      const predicates = new relationalStore.RdbPredicates("AppUser").equalTo("phone", user.phone)
      const resultSet = await transaction.query(predicates, ['uid', 'name', 'avatar'])
      const found = resultSet.goToFirstRow()

      if (found) {
        await transaction.execute(
          'update AppUser set name = ?, phone = ?, email = ?, avatar = ?, create_date = ?, activate = ? where uid = ?',
          [
            user.name,
            user.phone,
            user.email,
            user.avatar as Unknown as Uint8Array,
            dateFormat(new Date(), 'yyyy-MM-dd HH:mm:ss'),
            user.activate,
            user.uid,
          ]
        )
      }

      await transaction.commit()
      return found ? user : null
    } catch {
      await transaction.rollback()
      return null
    }
  }

  static async recentUser(user?: IUser | null): Promise<IUser | null> {
    if (!AppDatabaser.db) {
      await AppDatabaser.connect()
    }

    if (!AppDatabaser.db) {
      return null
    }

    const transaction = await AppDatabaser.db.createTransaction()

    try {
      const resultSet = await transaction.querySql(`
        select
          uid,
          name,
          phone,
          email,
          avatar,
          activate,
          create_date
        from AppUser
        where activate = "Y"
        order by datetime(create_date) desc
      `)

      const value = resultSet.goToFirstRow() && resultSet.getRow()
      const result = value ? User.from(doctor.camelCase(value)) : null

      await transaction.commit()
      return result
    } catch {
      await transaction.rollback()
      return null
    }
  }
}
