import { AttributeUpdater } from "@kit.ArkUI"
import { size } from "../../utils/size"

export class LoadingModifier extends AttributeUpdater<ColumnAttribute> {
  applyNormalAttribute(instance: ColumnAttribute) {
    super.applyNormalAttribute?.(instance)
    this.change(this.state)
  }

  initializeModifier(instance: ColumnAttribute) {
    super.initializeModifier(instance)
    this.change(this.state)
  }

  change(state: boolean) {
    this.state = state

    if (!this.attribute) {
      return
    }

    if (this.state === true) {
      this.attribute.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      this.attribute.height('100%')
      this.attribute.width('100%')
      this.attribute.opacity(1)
      return
    }

    this.attribute.expandSafeArea()
    this.attribute.opacity(0)
    this.attribute.height(0)
    this.attribute.width(0)
  }

  state: boolean = false
}

@ComponentV2
export struct Loading {
  @BuilderParam customBuilder: () => void = this.defaultBuilder
  @Param loadingModifier: LoadingModifier = new LoadingModifier()
  @Param fontColor: ResourceColor = 'rgba(67, 108, 255, 1)'
  @Param bgColor: ResourceColor = 'rgba(255, 255, 255, 0.65)'
  @Param desc: Resource | string = $r('app.string.System_Loading')
  @Param bgBlurScale: number = 0.07
  @Param state: boolean = false

  @Monitor('state')
  onStateChange() {
    this.loadingModifier.change(this.state)
  }

  aboutToAppear() {
    this.loadingModifier.change(this.state)
  }

  @Builder
  defaultBuilder() {
    Column() {
      LoadingProgress()
        .enableLoading(true)
        .color(this.fontColor)
        .height(size.vp(60))
        .width(size.vp(60))

      Text(this.desc)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.fontColor)
        .fontSize(size.vp(14))
        .margin(size.vp(5))
    }
    .attributeModifier(this.loadingModifier)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.bgColor)
    .backgroundBlurStyle(BlurStyle.Thin, {
      adaptiveColor: AdaptiveColor.DEFAULT,
      colorMode: ThemeColorMode.LIGHT,
      scale: this.bgBlurScale,
    })
  }

  build() {
    if (this.state === true) {
      this.customBuilder()
    }
  }
}