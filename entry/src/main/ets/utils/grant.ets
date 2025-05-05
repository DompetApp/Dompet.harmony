import { common } from "@kit.AbilityKit"
import { Permissions } from "@kit.AbilityKit"
import { bundleManager } from "@kit.AbilityKit"
import { abilityAccessCtrl } from "@kit.AbilityKit"

export class grant {
  public static context = getContext(this) as common.UIAbilityContext

  public static async reqPermissionsFromUser(permissions: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager()
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED

    return atManager.requestPermissionsFromUser(grant.context, permissions)
      .then((result) => result.authResults.some((auth) => auth === GRANTED))
      .catch(() => false)
  }

  public static async requestPermissions(permission: Permissions) {
    const GRANTED = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED

    if (await grant.checkAccessToken(permission) === GRANTED) {
      return true
    }

    return await grant.reqPermissionsFromUser([permission])
  }

  public static async checkAccessToken(permission: Permissions) {
    const bundleFlags: bundleManager.BundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
    const appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo

    return abilityAccessCtrl.createAtManager().checkAccessToken(appInfo.accessTokenId, permission).catch(() => {
      return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    })
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
