import { UserDatabaser } from "../database/user"
import { AppDatabaser } from "../database/app"
import { event } from "../globals/event"
import { store } from "../globals/store"
import { IUser } from "../models/user"


export class Sqliter {
  static appUser: IUser | null = null
  static useAccount: string | null = null
  static closeAccount: string | null = null

  static async init(): Promise<void> {
    await Sqliter.initAppDatabase()
  }

  static async close(): Promise<void> {
    await UserDatabaser.close()
    await AppDatabaser.close()
  }

  // 创建/关闭/销毁 App Database
  static async initAppDatabase(): Promise<void> {
    if (!AppDatabaser.created) {
      await Sqliter.openAppDatabase()
    }

    if (AppDatabaser.created) {
      Sqliter.appUser = await AppDatabaser.recentUser()
    }

    if (store.logined) {
      !Sqliter.appUser ? event.logout() : event.login()
    }
  }

  static async openAppDatabase(): Promise<void> {
    if (AppDatabaser.created) {
      return
    }

    return AppDatabaser.create()
  }

  static async closeAppDatabase(): Promise<void> {
    return AppDatabaser.close()
  }

  static async deleteAppDatabase(): Promise<void> {
    return AppDatabaser.delete()
  }

  // 创建/关闭/销毁 User Database
  static async initUserDatabase(): Promise<void> {
    Sqliter.appUser ??= await AppDatabaser.recentUser()
    return Sqliter.openUserDatabase()
  }

  static async openUserDatabase(): Promise<void> {
    if (UserDatabaser.created) {
      return
    }

    if (!Sqliter.appUser?.uid) {
      return
    }

    return UserDatabaser.create()
  }

  static async closeUserDatabase(): Promise<void> {
    await AppDatabaser.closeUser(Sqliter.appUser?.uid)
    await UserDatabaser.close()
    Sqliter.appUser = null
  }

  static async deleteUserDatabase(): Promise<void> {
    if (!Sqliter.appUser?.uid) {
      return
    }

    const uid = Sqliter.appUser.uid
    await Sqliter.closeUserDatabase()
    await AppDatabaser.deleteUser(uid)
    await UserDatabaser.delete()
  }

  // 关闭/删除/清理 所有 Database
  static async closeAllDatabases(): Promise<void> {
    await Sqliter.closeUserDatabase()
    await Sqliter.closeAppDatabase()
  }

  static async deleteAllDatabases(): Promise<void> {
    await Sqliter.deleteUserDatabase()
    await Sqliter.deleteAppDatabase()
  }
}