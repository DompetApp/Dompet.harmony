import { ArkTSUtils } from "@kit.ArkTS"

'use shared'

@Sendable
export class RWMutex {
  private timeout: number = 0
  private check: boolean = false
  private lock: ArkTSUtils.locks.AsyncLock

  constructor(opt: IRWMutex) {
    this.lock = opt.key ? ArkTSUtils.locks.AsyncLock.request(opt.key) : new ArkTSUtils.locks.AsyncLock()
    this.timeout = opt.timeout ?? this.timeout
    this.check = opt.check ?? this.check
  }

  public static create(opt: IRWMutex | string) {
    return new RWMutex(typeof opt === 'string' ? { key: opt } : opt)
  }

  public async write<T, U = never>(fn: () => T | Promise<T>, opt?: ArkTSUtils.locks.AsyncLockOptions<U>) {
    const options = new ArkTSUtils.locks.AsyncLockOptions<U>()
    const mode = ArkTSUtils.locks.AsyncLockMode.EXCLUSIVE

    options.isAvailable = opt?.isAvailable ?? this.check
    options.timeout = opt?.timeout ?? this.timeout

    return this.lock.lockAsync<T, U>(
      fn,
      mode,
      options
    ).catch(Promise.reject)
  }

  public async read<T, U = never>(fn: () => T | Promise<T>, opt?: ArkTSUtils.locks.AsyncLockOptions<U>) {
    const options = new ArkTSUtils.locks.AsyncLockOptions<U>()
    const mode = ArkTSUtils.locks.AsyncLockMode.SHARED

    options.isAvailable = opt?.isAvailable ?? this.check
    options.timeout = opt?.timeout ?? this.timeout

    return this.lock.lockAsync<T, U>(
      fn,
      mode,
      options
    ).catch(Promise.reject)
  }
}

interface IRWMutex {
  timeout?: number;
  check?: boolean;
  key?: string;
}
