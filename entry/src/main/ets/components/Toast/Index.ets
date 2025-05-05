import { CtxManager } from "../../configure/context"
import { promptAction } from "@kit.ArkUI"

export class Toast {
  static show(options: promptAction.ShowToastOptions) {
    options.offset = options.offset ?? { dx: 0, dy: 64 }
    options.alignment = options.alignment ?? Alignment.Top
    CtxManager.uiContext?.getPromptAction().showToast(options)
  }
}
