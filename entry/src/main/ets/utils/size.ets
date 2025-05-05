import { device } from "../configure/device"

export class size {
  static limit = 1.5
  static preset = 375.0

  static wmax(value: number) {
    const width = px2vp(device.width)
    return Math.min(width, value)
  }

  static wmin(value: number) {
    const width = px2vp(device.width)
    return Math.max(width, value)
  }

  static hmax(value: number) {
    const height = px2vp(device.height)
    return Math.min(height, value)
  }

  static hmin(value: number) {
    const height = px2vp(device.height)
    return Math.max(height, value)
  }

  static max(value: number) {
    const width = px2vp(device.width)
    const height = px2vp(device.height)
    return Math.min(width, height, value)
  }

  static min(value: number) {
    const width = px2vp(device.width)
    const height = px2vp(device.height)
    return Math.max(width, height, value)
  }

  static lpx(value: number) {
    const full = px2vp(device.width)
    const scale = full / size.preset
    return value * scale
  }

  static vp(value: number) {
    const full = px2vp(Math.min(device.width, device.height))
    const scale = Math.min(full / size.preset, size.limit)
    return value * scale
  }

  static fp(value: number) {
    return px2fp(vp2px(size.vp(value)))
  }

  static wp(value: number) {
    const width = device.width - (device.isLandscape ? device.top : 0)
    return vp2px(value) / width * 100 + '%'
  }

  static hp(value: number) {
    const top = device.isPortrait ? device.top : 0
    const height = device.height - device.bottom - top
    return vp2px(value) / height * 100 + '%'
  }

  static vw(value: number) {
    return px2vp(device.width) / 100 * value
  }

  static vh(value: number) {
    return px2vp(device.height) / 100 * value
  }

  static sr(value: number) {
    return value / size.preset
  }
}
