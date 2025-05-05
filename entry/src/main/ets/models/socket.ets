export type SocketCallback = (type: string, data?: Unknown) => void

export class SocketSubscribe implements ISocketSubscribe {
  public type: string
  public callback: SocketCallback

  constructor(type: string, callback: SocketCallback) {
    this.callback = callback
    this.type = type
  }
}

export interface ISocketSubscribe {
  callback: SocketCallback
  type: string
}
