import { Dialog as $Dialog } from "../components/Dialog/Index"
import { Toast as $Toast } from "../components/Toast/Index"
import { emitter } from "@kit.BasicServicesKit"


class Dialog {
  static custom() {
    emitter.on<Unknown>('Dialog.custom', (options: Unknown) => {
      $Dialog.custom(options.data)
    })
  }

  static show() {
    emitter.on<Unknown>('Dialog.show', (options: Unknown) => {
      $Dialog.show(options.data)
    })
  }

  static hide() {
    emitter.on<Unknown>('Dialog.hide', (options: Unknown) => {
      $Dialog.hide(options.data)
    })
  }
}

class Toast {
  static show() {
    emitter.on<Unknown>('Toast.show', (options: Unknown) => {
      $Toast.show(options.data)
    })
  }
}


/**
 * Emitter
 */
Dialog.custom()
Dialog.show()
Dialog.hide()
Toast.show()