import { preferences } from "@kit.ArkData"
import { ValueType } from "@kit.ArkData"
import { CtxManager } from "./context"

class AppPersistent {
  private instance: preferences.Preferences | null = null
  private options: preferences.Options = { name: 'harmony.app.zgb' }

  public write<T extends ValueType = ValueType>(key: string, value?: T) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      this.instance.putSync(key, value)
      this.instance.flushSync()
    }
  }

  public read<T extends ValueType = ValueType>(key: string, value?: T) {
    if (!this.instance) {
      this.init()
    }

    if (this.instance) {
      this.instance.flushSync()
      return this.instance.getSync(key, value) as T
    }

    return value
  }

  public init(opt?: preferences.Options) {
    if (CtxManager.abilityContext) {
      this.instance = preferences.getPreferencesSync(CtxManager.abilityContext, opt ?? this.options)
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