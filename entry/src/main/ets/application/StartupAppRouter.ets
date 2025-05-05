import { StartupTask, common } from "@kit.AbilityKit"
import { HMRouterMgr } from "@hadss/hmrouter"

@Sendable
export default class AppRouterTask extends StartupTask {
  async init(context: common.AbilityStageContext) {
    console.log('AppRouterTask init: --- success ---')
    HMRouterMgr.init({ context: context })
    HMRouterMgr.openLog('DEBUG')
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    console.log(`AppRouterTask dependence: ${dependence}, result: ${JSON.stringify(result)}`)
  }
}