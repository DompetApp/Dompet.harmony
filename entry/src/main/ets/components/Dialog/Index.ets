import { promptAction } from "@kit.ArkUI"
import { CtxManager } from "../../configure/context"

interface CustomDialogOptions extends promptAction.CustomDialogOptions {
  close?: (() => Promise<void> | void) | null
}

interface ShowDialogOptions extends promptAction.ShowDialogOptions {
  confirm?: ((data: promptAction.ShowDialogSuccessResponse) => Promise<void> | void) | null
  cancel?: ((data: promptAction.ShowDialogSuccessResponse) => Promise<void> | void) | null
  close?: ((data: promptAction.ShowDialogSuccessResponse) => Promise<void> | void) | null
  confirmText?: string | Resource | null | false
  cancelText?: string | Resource | null | false
  confirmColor?: string | Resource | null
  cancelColor?: string | Resource | null
  confirmPrimary?: boolean | null
  cancelPrimary?: boolean | null
}

export class Dialog {
  static async custom(options: CustomDialogOptions) {
    options.onWillDisappear = options.onWillDisappear || options.close || undefined

    const promptAction = CtxManager.uiContext!.getPromptAction()

    return promptAction.openCustomDialog(options).then(id => {
      Dialog.ids.add(id)
      return id
    })
  }

  static async show(options: ShowDialogOptions) {
    const isCustomButton = !!options.buttons

    if (options.message === undefined || options.message === '') {
      return
    }

    if (!options.buttons && options.confirmText !== false && options.cancelText !== false) {
      options.buttons = [
        {
          text: options.cancelText ?? $r('app.string.System_Cancel'),
          color: options.cancelColor ?? '#606266',
          primary: options.cancelPrimary ?? false,
        },
        {
          text: options.confirmText ?? $r('app.string.System_Confirm'),
          color: options.confirmColor ?? '#000000',
          primary: options.confirmPrimary ?? false,
        }
      ]
    }

    if (!options.buttons && options.confirmText !== false && options.cancelText === false) {
      options.buttons = [
        {
          text: options.confirmText ?? $r('app.string.System_Confirm'),
          color: options.confirmColor ?? '#000000',
          primary: options.confirmPrimary ?? false,
        }
      ]
    }

    if (!options.buttons && options.confirmText === false && options.cancelText !== false) {
      options.buttons = [
        {
          text: options.cancelText ?? $r('app.string.System_Cancel'),
          color: options.cancelColor ?? '#606266',
          primary: options.cancelPrimary ?? false,
        }
      ]
    }

    const promptAction = CtxManager.uiContext!.getPromptAction()

    promptAction.showDialog(options, (err, data) => {
      if (err) {
        if (!isCustomButton) {
          options.cancel?.(data)
        }
        options.close?.(data)
        return
      }

      if (!isCustomButton && options.buttons?.length == 1 && options.confirmText !== false) {
        options.confirm?.(data)
      }

      if (!isCustomButton && options.buttons?.length == 1 && options.cancelText !== false) {
        options.cancel?.(data)
      }

      if (!isCustomButton && options.buttons?.length == 2 && data.index === 0) {
        options.cancel?.(data)
      }

      if (!isCustomButton && options.buttons?.length == 2 && data.index === 1) {
        options.confirm?.(data)
      }

      options.close?.(data)
    })
  }

  static async hide(keys?: number | number[]) {
    const promptAction = CtxManager.uiContext!.getPromptAction()
    const reverseIds = Array.from(Dialog.ids).reverse()
    const isInteger = Number.isInteger(keys)
    const isArray = Array.isArray(keys)

    if (!isInteger && !isArray) {
      for (const id of reverseIds) {
        promptAction.closeCustomDialog(id)
        Dialog.ids.delete(id)
        break
      }
      return
    }

    if (isInteger) {
      const id = keys as number

      if (Dialog.ids.has(id)) {
        promptAction.closeCustomDialog(id)
        Dialog.ids.delete(id)
      }

      return
    }

    if (isArray) {
      for (const id of keys) {
        promptAction.closeCustomDialog(id)
        Dialog.ids.delete(id)
      }
      return
    }
  }

  static ids = new Set<number>()
}
