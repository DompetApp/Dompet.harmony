import { common } from "@kit.AbilityKit"
import { Permissions } from "@kit.AbilityKit"
import { bundleManager } from "@kit.AbilityKit"
import { abilityAccessCtrl } from "@kit.AbilityKit"

export class grant {
  public static CAMERA = abilityAccessCtrl.SwitchType.CAMERA
  public static LOCATION = abilityAccessCtrl.SwitchType.LOCATION
  public static MICROPHONE = abilityAccessCtrl.SwitchType.MICROPHONE

  public static context = getContext(this) as common.UIAbilityContext

  public static async requestGlobalSwitch(switchType: abilityAccessCtrl.SwitchType) {
    return abilityAccessCtrl.createAtManager().requestGlobalSwitch(grant.context, switchType)
  }

  public static async reqPermissionsFromUser(permissions: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager()
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED

    return atManager.requestPermissionsFromUser(grant.context, permissions)
      .then((result) => result.authResults.every((auth) => auth === GRANTED))
      .catch(() => false)
  }

  public static async requestPermissions(permissions: Permissions[]) {
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED

    if (await grant.checkAccessToken(permissions) === GRANTED) {
      return true
    }

    return await grant.reqPermissionsFromUser(permissions)
  }

  public static async checkAccessToken(permissions: Permissions[]) {
    const bundleFlags: bundleManager.BundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
    const appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    const DENIED = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    const atManager = abilityAccessCtrl.createAtManager()

    for (const permission of permissions) {
      try {
        if (atManager.checkAccessTokenSync(appInfo.accessTokenId, permission) === DENIED) {
          return DENIED
        }
      } catch {
        return DENIED
      }
    }

    return GRANTED
  }

  public static openSettings() {
    grant.context.startAbility({
      uri: 'application_info_entry',
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      parameters: { settingsParamBundleName: grant.context.abilityInfo.bundleName }
    })
  }
}
