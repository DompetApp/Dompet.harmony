import type { CustomDialogOptions } from "../components/Dialog/Index"
import type { ShowDialogOptions } from "../components/Dialog/Index"
import type { promptAction } from "../components/Toast/Index"
import { emitter } from "@kit.BasicServicesKit"


export class Dialog {
  static custom(options: CustomDialogOptions) {
    emitter.emit('Dialog.custom', { data: options })
  }

  static show(options: ShowDialogOptions) {
    emitter.emit('Dialog.show', { data: options })
  }

  static hide(keys?: number | number[]) {
    emitter.emit('Dialog.hide', { data: keys })
  }
}

export class Toast {
  static show(options: promptAction.ShowToastOptions) {
    emitter.emit('Toast.show', { data: options })
  }
}