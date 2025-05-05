import { AttributeUpdater } from "@kit.ArkUI"


export class RouterDefaultModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute) {
    instance.mode(NavigationMode.Stack)
    instance.navBarWidth('100%')
    instance.hideTitleBar(true)
    instance.hideToolBar(true)
  }
}
