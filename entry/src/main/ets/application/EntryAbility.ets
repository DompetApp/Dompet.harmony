import { AbilityConstant, UIAbility } from "@kit.AbilityKit"
import { errorManager, Want } from "@kit.AbilityKit"
import { StageManager } from "../configure/stage"
import { CtxManager } from "../configure/context"
import { Network } from "../configure/network"
import { Socketor } from "../configure/socket"
import { Sqliter } from "../configure/sqlite"
import { schemer } from "../configure/scheme"
import { device } from "../configure/device"
import { Scheme } from "../models/scheme"
import { logger } from "../tracks/logger"
import { store } from "../globals/store"
import { AxiosError } from "@ohos/axios"
import { Empty } from "../utils/empty"
import { webview } from "@kit.ArkWeb"
import { window } from "@kit.ArkUI"


export default class EntryAbility extends UIAbility {
  observerId: number = -1
  windowClass: window.Window | null = null

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.log('EntryAbility: --- onCreate ---')
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

    StageManager.registerStageWindowClass(this.windowClass)

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
    this.windowClass?.getUIContext().getFont().registerFont({
      familySrc: $rawfile('fonts/Roboto.ttf'),
      familyName: 'Google.Roboto',
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

  onWindowStageDestroy() {
    console.log('EntryAbility: --- onWindowStageDestroy ---')
    StageManager.unregisterStageWindowClass()
    this.windowClass = null
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
