import { promptAction } from "@kit.ArkUI"
import { CtxManager } from "../../configure/context"

export class Toast {
  static async show(options: promptAction.ShowToastOptions) {
    const prompter = (await CtxManager.uiContext).getPromptAction()
    options.alignment = options.alignment ?? Alignment.Top
    options.offset = options.offset ?? { dx: 0, dy: 64 }
    prompter.showToast(options)
  }
}
