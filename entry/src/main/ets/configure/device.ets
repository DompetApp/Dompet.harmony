import { window, display } from "@kit.ArkUI"

@ObservedV2
export class AppDevice {
  @Trace id: number = -1
  @Trace top: number = 0
  @Trace width: number = 0
  @Trace bottom: number = 0
  @Trace height: number = 0
  @Trace startup: number = 0
  @Trace isFoldable: boolean = false;
  @Trace densityPixels: number = 0
  @Trace orientation: display.Orientation = display.Orientation.PORTRAIT
  @Trace foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN
  @Trace state: display.DisplayState = display.DisplayState.STATE_ON

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

  updateWindowSize(_: window.Size) {
    const displayClass = display.getDefaultDisplaySync()
    this.densityPixels = displayClass.densityPixels
    this.orientation = displayClass.orientation
    this.foldStatus = display.getFoldStatus()
    this.isFoldable = display.isFoldable();
    this.height = displayClass.height
    this.width = displayClass.width
    this.state = displayClass.state
    this.id = displayClass.id
  }

  start() {
    this.startup = Date.now()
  }
}

export const device = new AppDevice()