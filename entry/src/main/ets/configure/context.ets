import { sendableContextManager } from "@kit.AbilityKit"
import { common } from "@kit.AbilityKit"
import { window } from "@kit.ArkUI"

'use shared'

@Sendable
export class CtxManager {
  static sendableAbilityStageContext: sendableContextManager.SendableContext | null = null
  static sendableUIAbilityContext: sendableContextManager.SendableContext | null = null

  static registerAbilityStageContext(context: common.AbilityStageContext) {
    CtxManager.sendableAbilityStageContext = sendableContextManager.convertFromContext(context)
  }

  static registerUIAbilityContext(context: common.UIAbilityContext) {
    CtxManager.sendableUIAbilityContext = sendableContextManager.convertFromContext(context)
  }

  static unregisterAbilityStageContext() {
    CtxManager.sendableAbilityStageContext = null
  }

  static unregisterUIAbilityContext() {
    CtxManager.sendableUIAbilityContext = null
  }

  static get abilityStageContext() {
    const context = CtxManager.sendableUIAbilityContext
    return context ? sendableContextManager.convertToAbilityStageContext(context) : null
  }

  static get uiAbilityContext() {
    const context = CtxManager.sendableUIAbilityContext
    return context ? sendableContextManager.convertToUIAbilityContext(context) : null
  }

  static get uiContext() {
    return window.getLastWindow(CtxManager.uiAbilityContext).then(windowClass => windowClass.getUIContext())
  }
}