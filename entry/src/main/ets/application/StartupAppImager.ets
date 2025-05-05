import { StartupTask, common } from "@kit.AbilityKit"
import { ImageKnife } from "@ohos/imageknife"

@Sendable
export default class AppImagerTask extends StartupTask {
  async init(context: common.AbilityStageContext) {
    await ImageKnife.getInstance().initFileCache(context, 256, 256 * 1024 * 1024)
    console.log('AppImagerTask init: --- success ---')
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    console.log(`AppImagerTask dependence: ${dependence}, result: ${JSON.stringify(result)}`)
  }
}