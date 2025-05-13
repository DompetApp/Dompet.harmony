import { ImageKnifeComponent } from "@ohos/imageknife"
import { ImageKnifeRequest } from "@ohos/imageknife"
import { ImageKnifeData } from "@ohos/imageknife"

@ObservedV2
export class CacheImageOptions {
  loadSrc: string | PixelMap | Resource = ''
  placeholderSrc?: string | PixelMap | Resource
  errorholderSrc?: string | PixelMap | Resource
  onLoadListener?: CacheImageLoader | undefined
  customGetImage?: (
    ctx: Context,
    src: string | PixelMap | Resource,
    headers?: Record<string, Object>
  ) => Promise<ArrayBuffer | undefined>
  errorholderObjectFit?: ImageFit
  placeholderObjectFit?: ImageFit
  border?: BorderOptions
  objectFit?: ImageFit

  static fromJson(json: CacheImageOptions | Recorder) {
    const instance = new CacheImageOptions()
    instance.errorholderObjectFit = json.errorholderObjectFit
    instance.placeholderObjectFit = json.placeholderObjectFit
    instance.errorholderSrc = json.errorholderSrc
    instance.placeholderSrc = json.placeholderSrc
    instance.onLoadListener = json.onLoadListener
    instance.customGetImage = json.customGetImage
    instance.objectFit = json.objectFit
    instance.loadSrc = json.loadSrc
    instance.border = json.border
    return instance
  }
}

@ObservedV2
export class CacheImageLoader {
  onLoadStart?: (request?: ImageKnifeRequest) => void
  onLoadFailed?: (err: string, request?: ImageKnifeRequest) => void
  onLoadCancel?: (reason: string, request?: ImageKnifeRequest) => void
  onLoadSuccess?: (
    data: string | PixelMap | undefined,
    imageKnifeData: ImageKnifeData,
    request?: ImageKnifeRequest,
  ) => void

  static fromJson(json: CacheImageLoader | Recorder) {
    const instance = new CacheImageLoader()
    instance.onLoadSuccess = json.onLoadSuccess
    instance.onLoadCancel = json.onLoadCancel
    instance.onLoadFailed = json.onLoadFailed
    instance.onLoadStart = json.onLoadStart
    return instance
  }
}

@ComponentV2
export struct CacheImager {
  @Param @Once error: boolean = false
  @Param @Once loading: boolean = true
  @Param @Once success: boolean = false
  @Require @Param imagerOptions: CacheImageOptions
  @BuilderParam errorHolder: () => void = this.defaultErrorHolder
  @BuilderParam loadingHolder: () => void = this.defaultLoadingHolder
  @Local localImagerOptions: CacheImageOptions = new CacheImageOptions()
  @Local onLoadListener: CacheImageLoader = this.createOnLoadListener()
  @Param loadingBgColor: ResourceColor = 'transparent'
  @Param loadingBorder: BorderOptions = { radius: 3 }
  @Param errorBgColor: ResourceColor = '#dddddd'
  @Param errorBorder: BorderOptions = { radius: 3 }
  @Param adaptiveHeight: Length = '100%'
  @Param adaptiveWidth: Length = '100%'
  @Param loadingHeight: Length = '100%'
  @Param loadingWidth: Length = '100%'
  @Param useSyncLoad: boolean = false
  @Param useRawSize: boolean = false
  @Local rawHeight: number = 0
  @Local rawWidth: number = 0

  @Computed
  get visible() {
    if (this.loading && !this.imagerOptions.placeholderSrc) {
      return 0
    }

    if (this.error && !this.imagerOptions.errorholderSrc) {
      return 0
    }

    return 1
  }

  @Computed
  get showWidth() {
    return this.useRawSize && this.rawWidth > 0 ? this.rawWidth : this.adaptiveWidth
  }

  @Computed
  get showHeight() {
    return this.useRawSize && this.rawHeight > 0 ? this.rawHeight : this.adaptiveHeight
  }

  @Builder
  defaultErrorHolder() {
    if (this.error && !this.imagerOptions.errorholderSrc) {
      Column()
        .backgroundColor(this.errorBgColor)
        .border(this.errorBorder)
        .height(this.showHeight)
        .width(this.showWidth)
        .clip(true)
    }
  }

  @Builder
  defaultLoadingHolder() {
    if (this.loading && !this.imagerOptions.placeholderSrc) {
      Column() {
        Image($rawfile('network/loading.gif'))
          .height(this.loadingHeight)
          .width(this.loadingWidth)
          .objectFit(ImageFit.Fill)
          .draggable(false)
      }
      .backgroundColor(this.loadingBgColor)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .border(this.loadingBorder)
      .height(this.showHeight)
      .width(this.showWidth)
      .clip(true)
    }
  }

  createOnLoadListener() {
    const instance = CacheImageLoader.fromJson({
      onLoadFailed: () => {
        this.success = false
        this.loading = false
        this.error = true
      },
      onLoadCancel: () => {
        this.success = false
        this.loading = false
        this.error = true
      },
      onLoadSuccess: (_, data) => {
        this.rawWidth = px2vp(data.imageWidth)
        this.rawHeight = px2vp(data.imageHeight)
        this.loading = false
        this.success = true
        this.error = false
      }
    })
    return instance
  }

  aboutToAppear() {
    this.localImagerOptions = CacheImageOptions.fromJson({
      onLoadListener: this.imagerOptions.onLoadListener ?? this.onLoadListener,
      placeholderObjectFit: this.imagerOptions.placeholderObjectFit,
      errorholderObjectFit: this.imagerOptions.errorholderObjectFit,
      errorholderSrc: this.imagerOptions.errorholderSrc,
      placeholderSrc: this.imagerOptions.placeholderSrc,
      customGetImage: this.imagerOptions.customGetImage,
      objectFit: this.imagerOptions.objectFit,
      loadSrc: this.imagerOptions.loadSrc,
      border: this.imagerOptions.border,
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      ImageKnifeComponent({
        imageKnifeOption: this.localImagerOptions,
        adaptiveHeight: this.adaptiveHeight,
        adaptiveWidth: this.adaptiveWidth,
        syncLoad: this.useSyncLoad,
      })
        .opacity(this.visible)
        .height('100%')
        .width('100%')

      this.defaultErrorHolder()
      this.defaultLoadingHolder()
    }
    .height(this.showHeight)
    .width(this.showWidth)
  }
}
