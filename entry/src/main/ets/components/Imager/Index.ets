import { ImageKnifeComponent } from "@ohos/imageknife"
import { ImageKnifeRequest } from "@ohos/imageknife"
import { ImageKnifeData } from "@ohos/imageknife"
import { unit } from "../../utils/unity"

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
  @Param errorBorder: BorderOptions = { radius: 3 }
  @Param errorBgColor: ResourceColor = '#dddddd'
  @Param loadingBorder: BorderOptions = { radius: 3 }
  @Param loadingBgColor: ResourceColor = 'transparent'
  @BuilderParam errorHolder: () => void = this.defaultErrorHolder
  @BuilderParam loadingHolder: () => void = this.defaultLoadingHolder
  @Local renderKnifeOptions: CacheImageOptions = this.imgKnifeOptions
  @Param renderKnifeSyncLoad: boolean = false
  @Param adaptiveHeight: Length = '100%'
  @Param adaptiveWidth: Length = '100%'
  @Param loadingHeight: Length = '100%'
  @Param loadingWidth: Length = '100%'
  @Param useRawSize: boolean = false
  @Local rawHeight: number = 0
  @Local rawWidth: number = 0

  @Computed
  get onLoadListener() {
    return CacheImageLoader.fromJson({
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
        this.rawWidth = unit.px2vp(data.imageWidth)
        this.rawHeight = unit.px2vp(data.imageHeight)
        this.loading = false
        this.success = true
        this.error = false
      }
    })
  }

  @Computed
  get imgKnifeOptions() {
    return CacheImageOptions.fromJson({
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

  @Computed
  get renderKnifeWidth() {
    return this.useRawSize && this.rawWidth > 0 ? this.rawWidth : this.adaptiveWidth
  }

  @Computed
  get renderKnifeHeight() {
    return this.useRawSize && this.rawHeight > 0 ? this.rawHeight : this.adaptiveHeight
  }

  @Computed
  get renderKnifeVisibility() {
    if (this.loading && !this.imagerOptions.placeholderSrc) {
      return Visibility.Hidden
    }

    if (this.error && !this.imagerOptions.errorholderSrc) {
      return Visibility.Hidden
    }

    return Visibility.Visible
  }

  @Monitor('imgKnifeOptions')
  onRenderKnifeOptionsWatcher() {
    this.renderKnifeOptions = this.imgKnifeOptions
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
      .height(this.renderKnifeHeight)
      .width(this.renderKnifeWidth)
      .border(this.loadingBorder)
      .clip(true)
    }
  }

  @Builder
  defaultErrorHolder() {
    if (!this.loading && this.error && !this.imagerOptions.errorholderSrc) {
      Column()
        .backgroundColor(this.errorBgColor)
        .height(this.renderKnifeHeight)
        .width(this.renderKnifeWidth)
        .border(this.errorBorder)
        .clip(true)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      ImageKnifeComponent({
        syncLoad: this.renderKnifeSyncLoad,
        imageKnifeOption: this.renderKnifeOptions,
        adaptiveHeight: '100%',
        adaptiveWidth: '100%',
      })
        .visibility(this.renderKnifeVisibility)
        .height(this.renderKnifeHeight)
        .width(this.renderKnifeWidth)

      this.defaultErrorHolder()
      this.defaultLoadingHolder()
    }
    .height(this.renderKnifeHeight)
    .width(this.renderKnifeWidth)
  }
}
