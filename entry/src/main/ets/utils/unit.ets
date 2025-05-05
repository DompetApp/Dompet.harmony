import { device } from "../configure/device"

export class unit {
  // lpx <--> px
  static lpx2px(value: number) {
    return lpx2px(value)
  }

  static px2lpx(value: number) {
    return px2lpx(value)
  }

  // fp <--> px
  static fp2px(value: number) {
    return fp2px(value)
  }

  static px2fp(value: number) {
    return px2fp(value)
  }

  // vp <--> px
  static vp2px(value: number) {
    return vp2px(value)
  }

  static px2vp(value: number) {
    return px2vp(value)
  }

  // vp <--> fp
  static vp2fp(value: number) {
    return px2fp(vp2px(value))
  }

  static fp2vp(value: number) {
    return px2vp(fp2px(value))
  }

  // lpx <--> fp
  static lpx2fp(value: number) {
    return px2fp(lpx2px(value))
  }

  static fp2lpx(value: number) {
    return px2lpx(fp2px(value))
  }

  // lpx <--> vp
  static lpx2vp(value: number) {
    return px2vp(lpx2px(value))
  }

  static vp2lpx(value: number) {
    return px2lpx(vp2px(value))
  }

  // any --> vp
  static any2vp(value: Unknown) {
    const regex = /^[+-]?\d+\.?\d*$/

    if (typeof value === 'number') {
      return !Number.isNaN(value) ? value : 0.0
    }

    if (typeof value !== 'string') {
      return 0.0
    }

    if (value.endsWith('lpx')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? px2vp(lpx2px(num)) : 0.0
    }

    if (value.endsWith('fp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? px2vp(fp2px(num)) : 0.0
    }

    if (value.endsWith('vp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? num : 0.0
    }

    if (value.endsWith('px')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? px2vp(num) : 0.0
    }

    if (value.endsWith('%')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? px2vp(device.width * num / 100) : 0.0
    }

    if (regex.test(value)) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? num : 0.0
    }

    return 0.0
  }

  // any --> px
  static any2px(value: Unknown) {
    const regex = /^[+-]?\d+\.?\d*$/

    if (typeof value === 'number') {
      return !Number.isNaN(value) ? vp2px(value) : 0.0
    }

    if (typeof value !== 'string') {
      return 0.0
    }

    if (value.endsWith('lpx')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? lpx2px(num) : 0.0
    }

    if (value.endsWith('fp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? fp2px(num) : 0.0
    }

    if (value.endsWith('vp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? vp2px(num) : 0.0
    }

    if (value.endsWith('px')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? num : 0.0
    }

    if (value.endsWith('%')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? device.width * num / 100 : 0.0
    }

    if (regex.test(value)) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? vp2px(num) : 0.0
    }

    return 0.0
  }
}
