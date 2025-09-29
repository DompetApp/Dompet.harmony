import { util } from "@kit.ArkTS"
import { unique } from "@hitro/ark"
import { common } from "@kit.AbilityKit"
import { fileIo } from "@kit.CoreFileKit"
import { CtxManager } from "../configure/context"
import { ReadTextOptions } from "@kit.CoreFileKit"


export interface CacherOptions {
  fileMark?: string
  fileMode?: number
  encoding?: string
  fileKey?: string
}

export class AsyncMutex {
  private locked: boolean = false
  private queues: Array<() => void> = []

  public async synchronized<T = void>(fn: () => T | Promise<T>): Promise<T> {
    await this.acquire()

    try {
      return await fn()
    } finally {
      this.release()
    }
  }

  public async acquire(): Promise<void> {
    return new Promise<void>((resolve) => {
      if (!this.locked) {
        this.locked = true
        resolve()
        return
      }

      this.queues.push(resolve)
    })
  }

  public release(): void {
    this.queues.length > 0 ? this.queues.shift()?.() : this.locked = false
  }
}

export class Cacher {
  private lock = new AsyncMutex()
  private fileKey: string = unique()
  private fileDir: string | null = null
  private filePath: string | null = null
  private fileMode: number = fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC
  private fileMark: string = 'com.package.dompet/cacher/files'
  private encoding: string = 'utf-8'

  constructor(options?: CacherOptions | string) {
    if (typeof options === 'string') {
      options = {
        fileKey: options
      }
    }

    this.fileKey = options?.fileKey || this.fileKey
    this.fileMode = options?.fileMode || this.fileMode
    this.fileMark = options?.encoding || this.fileMark
    this.encoding = options?.encoding || this.encoding

    try {
      const context = CtxManager.uiAbilityContext as common.UIAbilityContext
      const fileDir = context.filesDir + this.fileMark

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

  async read(options: ReadTextOptions = {}): Promise<string | null> {
    return this.lock.synchronized<string>(() => {
      options.encoding = options.encoding || this.encoding || 'utf-8'
      return fileIo.readText(this.filePath, options).catch((err: Unknown) => Promise.reject(err))
    })
  }

  async write(content: string, mode?: number): Promise<void> {
    return this.lock.synchronized<void>(() => {
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
