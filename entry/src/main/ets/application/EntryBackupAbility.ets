import { BackupExtensionAbility, BundleVersion } from "@kit.CoreFileKit"

export default class EntryBackupAbility extends BackupExtensionAbility {
  async onRestore(bundleVersion: BundleVersion) {
    console.log(`EntryBackupAbility: --- onRestore ---> ${JSON.stringify(bundleVersion)}`)
  }

  async onBackup() {
    console.log(`EntryBackupAbility: --- onBackup ---`)
  }
}