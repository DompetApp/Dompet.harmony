import { util } from "@kit.ArkTS"
import { unique } from "@hitro/ark"
import { common } from "@kit.AbilityKit"
import { fileIo } from "@kit.CoreFileKit"
import { ReadTextOptions } from "@kit.CoreFileKit"
import { CtxManager } from "../configure/context"
import { RWMutex } from "../utils/async"


export interface ICacher {
  fileMark?: string
  fileMode?: number
  encoding?: string
  fileKey?: string
}

export class Cacher {
  private mutex: RWMutex
  private fileKey: string = unique()
  private fileDir: string | null = null
  private filePath: string | null = null
  private fileMode: number = fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC
  private fileMark: string = 'com.package.dompet/cacher'
  private encoding: string = 'utf-8'

  constructor(options?: ICacher | string) {
    if (typeof options === 'string') {
      options = {
        fileKey: options
      }
    }

    this.encoding = options?.encoding || this.encoding
    this.fileMode = options?.fileMode || this.fileMode
    this.fileMark = options?.encoding || this.fileMark
    this.fileKey = options?.fileKey || this.fileKey
    
    this.mutex = RWMutex.create({
      key: this.fileKey,
      timeout: 3000,
    })

    try {
      const context = CtxManager.uiAbilityContext as common.UIAbilityContext
      const fileDir = context.filesDir + this.fileMark.replace(/^\/*/, '/')

      if (!fileIo.accessSync(fileDir)) {
        fileIo.mkdirSync(fileDir, true)
      }

      if (fileDir) {
        this.filePath = fileDir + '/' + this.fileKey
        this.fileDir = fileDir
      }
    } catch (e) {
      /* e */
    }
  }

  async read(options: ReadTextOptions = {}): Promise<string> {
    return this.mutex.read<string>(() => {
      options.encoding = options.encoding ?? this.encoding
      return fileIo.readText(this.filePath, options).catch(Promise.reject)
    })
  }

  async write(content: string, mode?: number): Promise<void> {
    return this.mutex.write<void>(() => {
      try {
        const opt = mode ?? this.fileMode
        const file = fileIo.openSync(this.filePath, opt)
        fileIo.writeSync(file.fd, content)
        fileIo.closeSync(file)
      } catch (e) {
        /* e */
      }
    })
  }

  public decode(data: Unknown, type?: string): Unknown {
    if (typeof data === 'string' && type === 'ArrayBuffer') {
      const len = data.length
      const buf = new ArrayBuffer(len)
      const uint8 = new Uint8Array(buf)
      const encoder = new util.TextEncoder('utf-8')
      encoder.encodeIntoUint8Array(data, uint8)
      return uint8.buffer
    }

    return data
  }

  public encode(data: Unknown): string {
    if (data instanceof ArrayBuffer) {
      const buffer = new Uint8Array(data)
      const decoder = util.TextDecoder.create('utf-8')
      return decoder.decodeToString(buffer)
    }

    return data
  }

  async clear(): Promise<void> {
    try {
      if (!this.fileDir || !this.filePath) {
        return
      }

      if (!fileIo.accessSync(this.fileDir)) {
        return
      }

      if (!fileIo.accessSync(this.filePath)) {
        return
      }

      fileIo.unlinkSync(this.filePath)
    } catch (e) {
      /* e */
    }
  }
}
