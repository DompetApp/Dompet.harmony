import { sendablePreferences } from "@kit.ArkData"
import { CtxManager } from "./context"
import { lang } from "@kit.ArkTS"

'use shared'

@Sendable
class AppPersistent {
  private instance: sendablePreferences.Preferences | null = null

  public write<T extends lang.ISendable = lang.ISendable>(key: string, value: T) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      this.instance.putSync(key, value)
      this.instance.flushSync()
    }
  }

  public read<T extends lang.ISendable = lang.ISendable>(key: string, value: T) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      this.instance.flushSync()
      return this.instance.getSync(key, value) as T
    }

    return value
  }

  public init(opt?: sendablePreferences.Options) {
    if (CtxManager.uiAbilityContext) {
      const context = CtxManager.uiAbilityContext
      const options = opt ?? { name: 'harmony.app.zgb' }
      this.instance = sendablePreferences.getPreferencesSync(context, options)
    }
  }

  public delete(key: string) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      this.instance.deleteSync(key)
      this.instance.flushSync()
    }
  }
}

export const persistent = new AppPersistent()