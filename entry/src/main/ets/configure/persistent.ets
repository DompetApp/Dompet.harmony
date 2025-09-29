import { sendablePreferences } from "@kit.ArkData"
import { CtxManager } from "./context"
import { lang } from "@kit.ArkTS"

'use shared'

@Sendable
class AppPersistent {
  public instance: sendablePreferences.Preferences | null = null

  public write<T extends lang.ISendable = lang.ISendable>(key: string, value: T) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      try {
        this.instance.putSync(key, value)
        this.instance.flushSync()
      } catch (e) {
        /* e */
      }
    }
  }

  public read<T extends lang.ISendable = lang.ISendable>(key: string, value: T) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      try {
        this.instance.flushSync()
        return this.instance.getSync(key, value) as T
      } catch (e) {
        /* e */
      }
    }

    return value
  }

  public init(opt?: sendablePreferences.Options) {
    if (CtxManager.uiAbilityContext) {
      try {
        const context = CtxManager.uiAbilityContext
        const options = opt ?? { name: 'harmony.app.zgb' }
        this.instance = sendablePreferences.getPreferencesSync(context, options)
      } catch (e) {
        /* e */
      }
    }
  }

  public delete(key: string) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      try {
        this.instance.deleteSync(key)
        this.instance.flushSync()
      } catch (e) {
        /* e */
      }
    }
  }

  public clear() {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      try {
        this.instance.clearSync()
        this.instance.flushSync()
      } catch (e) {
        /* e */
      }
    }
  }
}

export const persistent = new AppPersistent()