export class Message implements IMessage {
  id: number = 0
  to: string = ''
  from: string = ''
  type: string = ''
  desc: string = ''
  date: string = ''
  money: number = 0.0
  isRead: string = 'N'

  static init() {
    return new Message()
  }

  static from(json: Partial<IMessage>) {
    const instance = new Message()
    instance.isRead = json?.isRead ?? 'N'
    instance.money = json?.money ?? 0.0
    instance.date = json?.date ?? ''
    instance.desc = json?.desc ?? ''
    instance.type = json?.type ?? ''
    instance.from = json?.from ?? ''
    instance.to = json?.to ?? ''
    instance.id = json?.id ?? 0
    return instance
  }
}

export class Messages implements IMessages {
  list: Array<IMessage> = []

  static init() {
    return new Messages()
  }

  static from(json: Array<IMessage>) {
    const iterable = json.map((item): IMessage => Message.from(item))
    const instance = new Messages()
    instance.list = iterable
    return instance
  }

  public change(list: Array<IMessage>) {
    this.list = list
    return this
  }

  public clear() {
    this.list = []
    return this
  }
}

export class GroupMessage implements IGroupMessage {
  messages: Array<IMessage> = []
  year: number = 0

  constructor(year: number, messages: Array<IMessage>) {
    this.messages = messages
    this.year = year
  }

  static from(json: IGroupMessage) {
    return new GroupMessage(json.year, json.messages)
  }
}

export interface IGroupMessage extends Recorder {
  messages: Array<IMessage>
  year: number
}

export interface IMessages extends Recorder {
  list: Array<IMessage>
  clear: () => IMessages
  change: (_: Array<IMessage>) => IMessages
}

export interface IMessage extends Recorder {
  id: number
  to: string
  from: string
  type: string
  desc: string
  date: string
  money: number
  isRead: string
}
