import { intl } from "@kit.LocalizationKit"
import { store } from "../globals/store"

export class money {
  static USD(money: number) {
    const formatter = new intl.NumberFormat(store.locale, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })

    return `USD ${formatter.format(money)}`
  }

  static usd(money: number) {
    const formatter = new intl.NumberFormat(store.locale, {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })

    if (money >= 0) {
      return `$${formatter.format(money)}`
    }

    return `-$${formatter.format(-money)}`
  }

  static usd2(money: number) {
    const formatter = new intl.NumberFormat(store.locale, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })

    if (money >= 0) {
      return `$${formatter.format(money)}`
    }

    return `-$${formatter.format(-money)}`
  }
}
