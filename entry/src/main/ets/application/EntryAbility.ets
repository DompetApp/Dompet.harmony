import { AbilityConstant, ConfigurationConstant } from "@kit.AbilityKit"
import { errorManager, UIAbility, Want } from "@kit.AbilityKit"
import { CtxManager } from "../configure/context"
import { Socketor } from "../configure/socket"
import { Sqliter } from "../configure/sqlite"
import { Network } from "../configure/network"
import { schemer } from "../configure/scheme"
import { device } from "../configure/device"
import { Scheme } from "../models/scheme"
import { logger } from "../tracks/logger"
import { store } from "../globals/store"
import { AxiosError } from "@ohos/axios"
import { Empty } from "../utils/empty"
import { webview } from "@kit.ArkWeb"
import { window } from "@kit.ArkUI"
import { font } from "@kit.ArkUI"


export default class EntryAbility extends UIAbility {
  observerId: number = -1
  windowClass: window.Window | null = null

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.log('EntryAbility: --- onCreate ---')
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    CtxManager.registerUIAbilityContext(this.context)
    webview.WebviewController.initializeWebEngine()
    Socketor.init()
    Sqliter.init()
    Network.init()
    schemer.init()
    logger.init()
    store.init()

    if (want.parameters?.url) {
      const parameters: Unknown = want.parameters
      const scheme = Scheme.from(parameters)
      schemer.forward(scheme)
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.log('EntryAbility: --- onNewWant ---')

    if (want.parameters?.url) {
      const parameters: Unknown = want.parameters
      const scheme = Scheme.from(parameters)
      schemer.forward(scheme)
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    console.log('EntryAbility: --- onWindowStageCreate ---')

    this.windowClass = windowStage.getMainWindowSync()
    this.windowClass.on("avoidAreaChange", this.onAvoidAreaChange)
    this.windowClass.on('windowSizeChange', this.onWindowSizeChange)

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        console.log('EntryAbility: --- onWindowStageCreate: failure ---> ' + JSON.stringify(err))
        return
      }

      console.log('EntryAbility: --- onWindowStageCreate: success ---')
      this.registerCustomizeFonts()
      this.onGlobalErrorCatcher()
    })
  }

  onAvoidAreaChange(refer: window.AvoidAreaOptions) {
    device.updateAvoidArea(refer)
  }

  onWindowSizeChange(size: window.Size) {
    device.updateWindowSize(size)
  }

  onWindowStageWillDestroy() {
    console.log('EntryAbility: --- onWindowStageWillDestroy ---')
    this.windowClass?.off('windowSizeChange', this.onWindowSizeChange)
    this.windowClass?.off("avoidAreaChange", this.onAvoidAreaChange)
  }

  registerCustomizeFonts() {
    font.registerFont({
      familyName: 'PingFang',
      familySrc: $rawfile('fonts/PingFang.ttf')
    })
  }

  onGlobalErrorCatcher() {
    errorManager.on("unhandledRejection", (error: Error) => {
      if (error instanceof AxiosError) {
        return
      }

      if (error instanceof Error) {
        logger.error(
          'App UnhandledRejection...',
          error.message,
          error.stack
        )
      }
    })

    this.observerId = errorManager.on('error', {
      onUnhandledException: Empty.fn,
      onException(error) {
        if (error instanceof AxiosError) {
          return
        }

        if (error instanceof Error) {
          logger.error(
            'App UnhandledException...',
            error.message,
            error.stack
          )
        }
      }
    })
  }

  onForeground() {
    console.log('EntryAbility: --- onForeground ---')
  }

  onBackground() {
    console.log('EntryAbility: --- onBackground ---')
  }

  onDestroy() {
    console.log('EntryAbility: --- onDestroy ---')
    errorManager.off('error', this.observerId)
    CtxManager.unregisterUIAbilityContext()
    Socketor.close()
    Sqliter.close()
    Network.close()
    schemer.close()
  }
}
