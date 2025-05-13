import { AbilityStage, ConfigurationConstant, Want } from "@kit.AbilityKit"
import { CtxManager } from "../configure/context"
import { device } from "../configure/device"

export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    CtxManager.registerAbilityStageContext(this.context)
    console.log('MyAbilityStage: --- onCreate ---')
    device.start()
  }

  onAcceptWant(want: Want) {
    console.log('MyAbilityStage: --- onAcceptWant ---')
    return 'MyAbilityStage'
  }

  onDestroy() {
    console.log('MyAbilityStage: --- onDestroy ---')
    CtxManager.unregisterAbilityStageContext()
  }
}
