import { bundleManager } from "@kit.AbilityKit"
import { deviceInfo } from "@kit.BasicServicesKit"
import { display } from "@kit.ArkUI"
import { window } from "@kit.ArkUI"

@ObservedV2
export class AppDevice {
  @Trace id: number = -1
  @Trace top: number = 0
  @Trace width: number = 0
  @Trace bottom: number = 0
  @Trace height: number = 0
  @Trace startup: number = Date.now()
  @Trace isFoldable: boolean = false
  @Trace foldDisplayMode: display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN
  @Trace displayResolutions: display.DisplayPhysicalResolution[] = []
  @Trace orientation: display.Orientation = display.Orientation.PORTRAIT
  @Trace bundleFlags: bundleManager.BundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
  @Trace bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoForSelfSync(this.bundleFlags)
  @Trace foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN
  @Trace state: display.DisplayState = display.DisplayState.STATE_ON
  @Trace type: string = deviceInfo.deviceType

  @Computed
  get isTv() {
    return this.type === 'tv'
  }

  @Computed
  get isCar() {
    return this.type === 'car'
  }

  @Computed
  get isPhone() {
    return this.type === 'phone'
  }

  @Computed
  get isTablet() {
    return this.type === 'tablet'
  }

  @Computed
  get isDesktop() {
    return this.type === 'desktop'
  }

  @Computed
  get isWearable() {
    return this.type === 'wearable'
  }

  @Computed
  get isPortrait() {
    if (this.orientation === display.Orientation.PORTRAIT_INVERTED) {
      return true
    }

    if (this.orientation === display.Orientation.PORTRAIT) {
      return true
    }

    return false
  }

  @Computed
  get isLandscape() {
    if (this.orientation === display.Orientation.LANDSCAPE_INVERTED) {
      return true
    }

    if (this.orientation === display.Orientation.LANDSCAPE) {
      return true
    }

    return false
  }

  /**
   * @throws
   */
  updateAvoidArea(refer: window.AvoidAreaOptions) {
    if (this.orientation !== display.Orientation.PORTRAIT) {
      return
    }

    if (refer.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      this.bottom = refer.area.bottomRect.height
    }

    if (refer.type === window.AvoidAreaType.TYPE_SYSTEM) {
      this.top = refer.area.topRect.height
    }
  }

  /**
   * @throws
   */
  updateWindowSize(_: window.Size) {
    const displayClass = display.getDefaultDisplaySync()
    this.foldDisplayMode = display.getFoldDisplayMode()
    this.orientation = displayClass.orientation
    this.foldStatus = display.getFoldStatus()
    this.isFoldable = display.isFoldable()
    this.height = displayClass.height
    this.width = displayClass.width
    this.state = displayClass.state
    this.id = displayClass.id
  }

  /**
   * @throws
   */
  start() {
    display.getAllDisplayPhysicalResolution().then((resolutions) => {
      this.displayResolutions = resolutions
    })
  }
}

export const device = new AppDevice()