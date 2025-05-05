export class Scheme implements IScheme {
  url: string = ''
  param?: Unknown = undefined

  constructor(url: string, param?: Unknown) {
    this.param = param
    this.url = url
  }

  static from(json: IScheme) {
    return new Scheme(json.url, json.param)
  }
}

export interface IScheme {
  param?: Unknown
  url: string
}