import { AbilityStage, Want } from "@kit.AbilityKit"
import { device } from "../configure/device"

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    console.log('MyAbilityStage: --- onCreate ---')
    device.start()
  }

  onAcceptWant(want: Want): string {
    console.log('MyAbilityStage: --- onAcceptWant ---')
    return 'MyAbilityStage'
  }
}
