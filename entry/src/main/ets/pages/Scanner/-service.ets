import { logger } from "../../tracks/logger"
import { customScan, scanBarcode, scanCore } from "@kit.ScanKit"
import { AsyncCallback, BusinessError } from "@kit.BasicServicesKit"

export interface ScanCallback extends AsyncCallback<Array<ScanResult>> {}

export interface ScanOptions extends scanBarcode.ScanOptions {}

export interface ViewControl extends customScan.ViewControl {}

export interface ScanResult extends scanBarcode.ScanResult {}

export { MediaPlayer } from './-player'

export { ScannerCodes } from './Multi'

export { ScannerView } from './View'

export { ScannerLine } from './Line'

export { ScannerInfo } from './Info'

@ObservedV2
export class ScanResults {
  @Trace data: Array<ScanResult> = []
  @Trace code: number = 200
  @Trace size: number = 0
}

@ObservedV2
export class ScanService {
  @Trace timerId: number = -1
  @Trace retryScan: number = 0
  @Trace isGranted: boolean = false
  @Trace isScanned: boolean = false
  @Trace isScanLine: boolean = false
  @Trace isPageShow: boolean = true
  @Trace isOpenAlbum: boolean = false
  @Trace isStopCamera: boolean = false
  @Trace isFlashlight: boolean = false
  @Trace isSensorLight: boolean = false
  @Trace isScanNothing: boolean = false
  @Trace isReleaseCamera: boolean = false
  @Trace isDecodeGallery: boolean = false
  @Trace isSelectPicture: boolean = false
  @Trace storeScanResults: ScanResults = new ScanResults()
  private static instance: ScanService | null = null

  public retryOnError(error: BusinessError, options: ScanOptions, viewControl: ViewControl, callback: ScanCallback) {
    if (error) {
      logger.error(error)

      const isMaxRetryScan = this.retryScan >= 3
      const isGalleryDecodeResult = error.name === 'galleryDecodeResult'
      const isScanInternalErrorCode = error.code === scanCore.ScanErrorCode.INTERNAL_ERROR

      if (!isMaxRetryScan && !isGalleryDecodeResult && isScanInternalErrorCode) {
        this.retryScan++

        let timeId = setTimeout(async () => {
          this.isScanLine = false
          await this.releaseCamera()
          this.resetCamera(options, viewControl, callback)
          clearTimeout(timeId)
        }, 100)
        return true
      }
    }

    return false
  }

  public resetCamera(options: ScanOptions, viewControl: ViewControl, callback: ScanCallback) {
    this.resetScanData()
    this.initCamera(options, viewControl, callback)
  }

  public initCamera(options: ScanOptions, viewControl: ViewControl, callback: ScanCallback) {
    if (this.isPageShow && !this.isScanLine && !this.isScanned && !this.isDecodeGallery) {
      this.isReleaseCamera = false
      this.isScanNothing = false

      customScan.init(options)

      this.startCamera(
        viewControl,
        callback
      )
    }
  }

  public startCamera(viewControl: ViewControl, callback: ScanCallback) {
    customScan.start(viewControl, callback)
    this.isScanNothing = false
    this.isStopCamera = false
    this.isScanLine = true
    this.onLightingFlash()
    this.initLightFlash()
    this.startTimer()
  }

  public static getInstance(): ScanService {
    if (ScanService.instance === null) {
      ScanService.instance = new ScanService()
    }

    return ScanService.instance
  }

  public async releaseCamera() {
    if (!this.isReleaseCamera) {
      this.clearTimer()
      this.retryScan = 0
      this.isReleaseCamera = true
      await this.stopCamera().catch((e: Unknown) => logger.error(e))
      await customScan.release().catch((e: Unknown) => logger.error(e))
    }
  }

  public async stopCamera() {
    if (!this.isStopCamera) {
      this.isScanLine = false
      this.isStopCamera = true
      this.isScanNothing = false
      await customScan.stop().catch((e: Unknown) => logger.error(e))
      this.offLightingFlash()
      this.closeFlashLight()
    }
  }

  public offLightingFlash() {
    customScan.off('lightingFlash')
  }

  public changeFlashlight() {
    customScan.getFlashLightStatus() ? customScan.closeFlashLight() : customScan.openFlashLight()
    this.isFlashlight = customScan.getFlashLightStatus()
  }

  public onLightingFlash() {
    customScan.on('lightingFlash', (error, isLightingFlash) => {
      if (error) {
        logger.error(error)
        return
      }

      this.isSensorLight = isLightingFlash
    })
  }

  public closeFlashLight() {
    if (customScan.getFlashLightStatus()) {
      customScan.closeFlashLight()
      this.isFlashlight = false
    }
  }

  public initLightFlash() {
    this.isSensorLight = false
    this.isFlashlight = false
  }

  public resetScanData() {
    this.retryScan = 0
    this.isScanned = false
    this.isScanLine = false
    this.isScanNothing = false
    this.isSelectPicture = false

    if (!this.isOpenAlbum) {
      this.isDecodeGallery = false
    }

    this.storeScanResults.data = []
    this.storeScanResults.size = 0
    this.storeScanResults.code = 0
  }

  public resetTryCount() {
    this.retryScan = 0
  }

  public startTimer() {
    this.clearTimer()

    if (this.isGranted) {
      this.timerId = setTimeout(() => this.isScanNothing = this.storeScanResults.size === 0, 5000)
    }
  }

  public clearTimer() {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId)
      this.isScanNothing = false
      this.timerId = -1
    }
  }

  public destroy() {
    this.isSelectPicture = false
    this.isScanNothing = false
    this.isPageShow = false
    this.isScanLine = false
    this.isScanned = false
    this.isGranted = false
    this.releaseCamera()
    this.resetScanData()
  }
}