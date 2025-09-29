import { common } from "@kit.AbilityKit"
import { Permissions } from "@kit.AbilityKit"
import { bundleManager } from "@kit.AbilityKit"
import { abilityAccessCtrl } from "@kit.AbilityKit"
import { BusinessError } from "@kit.BasicServicesKit"

export class grant {
  public static CAMERA = abilityAccessCtrl.SwitchType.CAMERA
  public static LOCATION = abilityAccessCtrl.SwitchType.LOCATION
  public static MICROPHONE = abilityAccessCtrl.SwitchType.MICROPHONE
  public static context = getContext(this) as common.UIAbilityContext

  public static async requestGlobalSwitch(switchType: abilityAccessCtrl.SwitchType) {
    return abilityAccessCtrl.createAtManager()
      .requestGlobalSwitch(grant.context, switchType)
      .catch((err: BusinessError) => {
        if (err.code !== 12100013) {
          return Promise.reject(err)
        }
        return true
      })
  }

  /**
   * @throws
   */
  public static async requestPermissionsFromUser(permissions: Permissions[]) {
    if (permissions.length === 0) {
      return false
    }

    const atManager = abilityAccessCtrl.createAtManager()
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED

    return atManager.requestPermissionsFromUser(grant.context, permissions).then((result) => {
      return result.authResults.every((auth) => auth === GRANTED)
    })
  }

  public static async requestPermissions(permissions: Permissions[]) {
    if (permissions.length === 0) {
      return false
    }

    if (await grant.checkPermissions(permissions)) {
      return true
    }

    return grant.openSettings(permissions).catch(async () => {
      return await grant.requestPermissionsFromUser(permissions).catch(() => false)
    })
  }

  public static async checkPermissions(permissions: Permissions[]) {
    const bundleFlags: bundleManager.BundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
    const appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    const atManager = abilityAccessCtrl.createAtManager()

    for (const permission of permissions) {
      try {
        if (atManager.checkAccessTokenSync(appInfo.accessTokenId, permission) !== GRANTED) {
          return false
        }
      } catch {
        return false
      }
    }

    if (permissions.length === 0) {
      return false
    }

    return true
  }

  /**
   * @throws
   */
  public static async openSettings(permissions?: Permissions[]) {
    if (permissions && permissions.length > 0) {
      const atManager = abilityAccessCtrl.createAtManager()
      const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
      return atManager.requestPermissionOnSetting(grant.context, permissions)
        .then((results) => results.every(result => result === GRANTED))
        .catch((err: BusinessError) => {
          if (err.code !== 12100011) {
            return Promise.reject(err)
          }
          return true
        })
    }

    grant.context.startAbility({
      uri: 'application_info_entry',
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      parameters: { settingsParamBundleName: grant.context.abilityInfo.bundleName }
    })

    return false
  }
}
