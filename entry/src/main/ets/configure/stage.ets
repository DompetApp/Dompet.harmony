import { window } from "@kit.ArkUI"

export class StageManager {
  static mainWindow: window.Window | null = null

  static registerStageWindowClass(windowClass: window.Window) {
    StageManager.mainWindow = windowClass
  }

  static unregisterStageWindowClass() {
    StageManager.mainWindow = null
  }
}