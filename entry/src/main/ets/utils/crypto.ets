import { cryptoFramework } from "@kit.CryptoArchitectureKit"
import { buffer } from "@kit.ArkTS"

export class crypto {
  /**
   * @throws
   */
  static encode(msg: string, key: string) {
    const ivByte = cryptoFramework.createRandom().generateRandomSync(16)
    const ivSpec: cryptoFramework.IvParamsSpec = { algName: "IvParamsSpec", iv: ivByte }
    const symKeyBlob: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(key, 'utf-8').buffer) }
    const aesGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128')

    const symKey = aesGenerator.convertKeySync(symKeyBlob)
    const cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|CBC|PKCS7')
    const msgBlob: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(msg, 'utf-8').buffer) }

    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, ivSpec)

    const ivLen = ivByte.data.length
    const encoded = cipher.doFinalSync(msgBlob)
    const combined = new Uint8Array(ivLen + encoded.data.length)

    combined.set(ivByte.data, 0)
    combined.set(encoded.data, ivLen)

    return buffer.from(combined).toString('base64')
  }

  /**
   * @throws
   */
  static decode(msg: string, key: string) {
    const combined = new Uint8Array(buffer.from(msg, 'base64').buffer)
    const symKeyBlob: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(key, 'utf-8').buffer) }
    const aesGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128')
    const symKey = aesGenerator.convertKeySync(symKeyBlob)

    const msgBlob: cryptoFramework.DataBlob = { data: combined.slice(16) }
    const ivSpec: cryptoFramework.IvParamsSpec = { algName: "IvParamsSpec", iv: { data: combined.slice(0, 16) } }
    const cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|CBC|PKCS7')

    cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, ivSpec)

    return buffer.from(cipher.doFinalSync(msgBlob).data).toString('utf-8')
  }

  /**
   * @throws
   */
  static md5(msg: string) {
    const buf = buffer.from(msg, 'utf-8')
    const md5 = cryptoFramework.createMd('MD5')
    md5.updateSync({ data: new Uint8Array(buf.buffer) })
    return buffer.from(md5.digestSync().data).toString('hex')
  }
}
