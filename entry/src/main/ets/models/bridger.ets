export interface IBridgeResult {
  status: 'success' | 'failure'
  result?: Unknown | null
  message?: string | null
}

export class BridgeResult {
  static success(options?: Partial<IBridgeResult>) {
    return {
      status: 'success',
      result: options?.result ?? null,
      message: options?.message ?? null
    } as IBridgeResult
  }

  static failure(options?: Partial<IBridgeResult>) {
    return {
      status: 'failure',
      result: options?.result ?? null,
      message: options?.message ?? null
    } as IBridgeResult
  }
}
