import { ScanService } from "./-service"

@ObservedV2
export class ScanViewSize {
  @Trace offsetX?: number | string = 0
  @Trace offsetY?: number | string = 0
  @Trace height: number | string = '100%'
  @Trace width: number | string = '100%'
}

@ComponentV2
export struct ScannerView {
  @Event initialize: (id: string) => void
  @Local scanService: ScanService = ScanService.getInstance()
  @Local controller: XComponentController = new XComponentController()
  @Param viewSize: ScanViewSize = new ScanViewSize()

  build() {
    Column() {
      XComponent({ type: XComponentType.SURFACE, controller: this.controller })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .onLoad(() => this.initialize(this.controller.getXComponentSurfaceId()))
        .position({ x: this.viewSize.offsetX, y: this.viewSize.offsetY })
        .height(this.viewSize.height)
        .width(this.viewSize.width)
        .clip(true)
    }
  }
}
