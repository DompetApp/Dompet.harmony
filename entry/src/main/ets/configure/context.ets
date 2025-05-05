import { common } from "@kit.AbilityKit"

export class CtxManager {
  static uiContext: UIContext | undefined | null = null
  static abilityContext: common.UIAbilityContext | undefined | null = null

  static registerAbilityContext(context?: common.UIAbilityContext) {
    CtxManager.abilityContext = context
  }

  static registerUIContext(context?: UIContext) {
    CtxManager.uiContext = context
  }

  static unregisterAbilityContext() {
    CtxManager.abilityContext = null
  }

  static unregisterUIContext() {
    CtxManager.uiContext = null
  }
}