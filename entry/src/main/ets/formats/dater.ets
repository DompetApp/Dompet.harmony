import { intl } from "@kit.LocalizationKit"
import { store } from "../globals/store"

export class dater {
  static format(date: Date | number | string, options?: intl.DateTimeOptions) {
    const formatter = new intl.DateTimeFormat(store.locale, options)
    return formatter.format(new Date(date))
  }
}
