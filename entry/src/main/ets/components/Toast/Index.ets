import { CtxManager } from "../../configure/context"
import { promptAction } from "@kit.ArkUI"

export type { promptAction }

export class Toast {
  static show(options: promptAction.ShowToastOptions) {
    try {
      const prompter = CtxManager.uiContext!.getPromptAction()
      options.alignment = options.alignment ?? Alignment.Top
      options.offset = options.offset ?? { dx: 0, dy: 64 }
      prompter.showToast(options)
    } catch (e) {
      /* e */
    }
  }
}