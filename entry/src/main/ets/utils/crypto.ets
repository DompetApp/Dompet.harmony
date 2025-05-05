import { CryptoJS } from "@ohos/crypto-js"

export class crypto {
  static decode(msg: string, key: string) {
    const iv = CryptoJS.enc.Utf8.parse('\0'.repeat(16))
    const utfKey = CryptoJS.enc.Utf8.parse(key.padEnd(16, ' ').substring(0, 16))

    const decrypted = CryptoJS.AES.decrypt(msg, utfKey, {
      padding: CryptoJS.pad.Pkcs7,
      mode: CryptoJS.mode.ECB,
      iv: iv,
    })

    return decrypted.toString(CryptoJS.enc.Utf8)
  }

  static encode(msg: string, key: string) {
    const iv = CryptoJS.enc.Utf8.parse('\0'.repeat(16))
    const utfKey = CryptoJS.enc.Utf8.parse(key.padEnd(16, ' ').substring(0, 16))

    const encrypted = CryptoJS.AES.encrypt(msg, utfKey, {
      padding: CryptoJS.pad.Pkcs7,
      mode: CryptoJS.mode.ECB,
      iv: iv,
    })

    return encrypted.toString()
  }

  static md5(msg: string) {
    return CryptoJS.MD5(msg).toString()
  }
}
