import { logger } from "../../tracks/logger"
import { detectBarcode } from "@kit.ScanKit"
import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { ScanCallback, ScanOptions, ScanService, ScanResult } from "./-service"

export class AError {
  code: number
  name: string
  message: string

  constructor(code?: number, message?: string) {
    this.name = 'galleryDecodeResult'
    this.message = message ?? ''
    this.code = code ?? 200
  }
}

export class Album {
  public static return(callback: ScanCallback) {
    callback((new AError(400)), [])
  }

  public static failed(msg: string, callback: ScanCallback) {
    ScanService.getInstance().isDecodeGallery = false
    Album.return(callback)
    logger.error(msg)
  }

  public static decode(uri: string, option: ScanOptions, callback: ScanCallback) {
    ScanService.getInstance().isSelectPicture = true

    const inputImage: detectBarcode.InputImage = { uri: uri }

    const options: ScanOptions = {
      scanTypes: option.scanTypes,
      enableMultiMode: false,
      enableAlbum: true
    }

    try {
      const promise = detectBarcode.decode(inputImage, options).then((result) => {
        if (!result || result.length === 0) {
          Album.return(callback)
          return
        }

        const scanResult: ScanResult = {
          originalValue: result[0].originalValue,
          scanCodeRect: result[0].scanCodeRect,
          scanType: result[0].scanType,
        }

        callback(new AError(200), [scanResult])
      })

      promise.catch((): void => Album.return(callback))
    } catch (error) {
      logger.error(error)
    }
  }

  public static async open(option: ScanOptions, callback: ScanCallback, callBackFn: CallableFunction) {
    try {
      const photoPicker = new photoAccessHelper.PhotoViewPicker()
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()

      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
      photoSelectOptions.isPhotoTakingSupported = false
      photoSelectOptions.isEditSupported = false
      photoSelectOptions.maxSelectNumber = 1

      await photoPicker.select(photoSelectOptions).then((result) => {
        callBackFn()

        if (!result || (result.photoUris && result.photoUris.length === 0)) {
          Album.failed(`Failed to get photoPicker result.`, callback)
          return
        }

        Album.decode(result.photoUris[0], option, callback)
      })

    } catch (error) {
      Album.failed(error, callback)
    }
  }
}
