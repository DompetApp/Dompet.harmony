import { CtxManager } from "../configure/context"
import { device } from "../configure/device"

export class unit {
  static limit = 1.5
  static preset = 375.0

  // Unit Adapter
  static lpx2px(value: number): number {
    return CtxManager.uiContext!.lpx2px(value)
  }

  static px2lpx(value: number): number {
    return CtxManager.uiContext!.px2lpx(value)
  }

  static fp2px(value: number): number {
    return CtxManager.uiContext!.fp2px(value)
  }

  static px2fp(value: number): number {
    return CtxManager.uiContext!.px2fp(value)
  }

  static vp2px(value: number): number {
    return CtxManager.uiContext!.vp2px(value)
  }

  static px2vp(value: number): number {
    return CtxManager.uiContext!.px2vp(value)
  }

  static vp2fp(value: number): number {
    return CtxManager.uiContext!.px2fp(CtxManager.uiContext!.vp2px(value))
  }

  static fp2vp(value: number): number {
    return CtxManager.uiContext!.px2vp(CtxManager.uiContext!.fp2px(value))
  }

  static lpx2fp(value: number): number {
    return CtxManager.uiContext!.px2fp(CtxManager.uiContext!.lpx2px(value))
  }

  static fp2lpx(value: number): number {
    return CtxManager.uiContext!.px2lpx(CtxManager.uiContext!.fp2px(value))
  }

  static lpx2vp(value: number): number {
    return CtxManager.uiContext!.px2vp(CtxManager.uiContext!.lpx2px(value))
  }

  static vp2lpx(value: number): number {
    return CtxManager.uiContext!.px2lpx(CtxManager.uiContext!.vp2px(value))
  }

  static any2vp(value: Unknown): number {
    const regex = /^[+-]?\d+\.?\d*$/

    if (typeof value === 'number') {
      return !Number.isNaN(value) ? value : 0.0
    }

    if (typeof value !== 'string') {
      return 0.0
    }

    if (value.endsWith('lpx')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.px2vp(CtxManager.uiContext!.lpx2px(num)) : 0.0
    }

    if (value.endsWith('fp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.px2vp(CtxManager.uiContext!.fp2px(num)) : 0.0
    }

    if (value.endsWith('vp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? num : 0.0
    }

    if (value.endsWith('px')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.px2vp(num) : 0.0
    }

    if (value.endsWith('%')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.px2vp(device.width * num / 100) : 0.0
    }

    if (regex.test(value)) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? num : 0.0
    }

    return 0.0
  }

  static any2px(value: Unknown): number {
    const regex = /^[+-]?\d+\.?\d*$/

    if (typeof value === 'number') {
      return !Number.isNaN(value) ? CtxManager.uiContext!.vp2px(value) : 0.0
    }

    if (typeof value !== 'string') {
      return 0.0
    }

    if (value.endsWith('lpx')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.lpx2px(num) : 0.0
    }

    if (value.endsWith('fp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.fp2px(num) : 0.0
    }

    if (value.endsWith('vp')) {
      const num = Number.parseFloat(value)
      return !Number.isNaN(num) ? CtxManager.uiContext!.vp2px(num) : 0.0
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
      return !Number.isNaN(num) ? CtxManager.uiContext!.vp2px(num) : 0.0
    }

    return 0.0
  }

  // Media Adapter
  static wmax(value: number): number {
    const width = unit.px2vp(device.width)
    return Math.min(width, value)
  }

  static wmin(value: number): number {
    const width = unit.px2vp(device.width)
    return Math.max(width, value)
  }

  static hmax(value: number): number {
    const height = unit.px2vp(device.height)
    return Math.min(height, value)
  }

  static hmin(value: number): number {
    const height = unit.px2vp(device.height)
    return Math.max(height, value)
  }

  static max(value: number): number {
    const width = unit.px2vp(device.width)
    const height = unit.px2vp(device.height)
    return Math.min(width, height, value)
  }

  static min(value: number): number {
    const width = unit.px2vp(device.width)
    const height = unit.px2vp(device.height)
    return Math.max(width, height, value)
  }

  static lpx(value: number): number {
    const full = unit.px2vp(device.width)
    const scale = full / unit.preset
    return value * scale
  }

  static vp(value: number): number {
    const full = unit.px2vp(Math.min(device.width, device.height))
    const scale = Math.min(full / unit.preset, unit.limit)
    return value * scale
  }

  static fp(value: number): number {
    return unit.px2fp(unit.vp2px(unit.vp(value)))
  }

  static wp(value: number): string {
    const width = device.width - (device.isLandscape ? device.top : 0)
    return unit.vp2px(value) / width * 100 + '%'
  }

  static hp(value: number): string {
    const top = device.isPortrait ? device.top : 0
    const height = device.height - device.bottom - top
    return unit.vp2px(value) / height * 100 + '%'
  }

  static vw(value: number): number {
    return unit.px2vp(device.width) / 100 * value
  }

  static vh(value: number): number {
    return unit.px2vp(device.height) / 100 * value
  }

  static sr(value: number): number {
    return value / unit.preset
  }
}
