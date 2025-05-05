import { StartupConfig, StartupConfigEntry, StartupListener } from "@kit.AbilityKit"
import { BusinessError } from "@kit.BasicServicesKit"

export default class AppStartupConfigEntry extends StartupConfigEntry {
  onConfig() {
    let onCompletedCallback = (error: BusinessError<void>) => {
      if (error) {
        console.log(`AppStartupConfigEntry/onCompletedCallback ---> ${error.code}, message: ${error.message}`)
      } else {
        console.log('AppStartupConfigEntry/onCompletedCallback: --- success ---')
      }
    }

    let startupListener: StartupListener = {
      'onCompleted': onCompletedCallback
    }

    let config: StartupConfig = {
      'startupListener': startupListener,
      'timeoutMs': 10000
    }

    return config
  }
}