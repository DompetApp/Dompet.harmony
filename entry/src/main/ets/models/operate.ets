export class PayOperate implements IPayOperate {
  id: string = ''
  to: string = ''
  from: string = ''
  type: string = ''

  constructor(id: string, to: string, from: string, type: string) {
    this.type = type
    this.from = from
    this.to = to
    this.id = id
  }

  static from(json: IPayOperate) {
    return new PayOperate(json.id, json.to, json.from, json.type)
  }
}

export interface IPayOperate extends Recorder {
  type: string
  from: string
  to: string
  id: string
}