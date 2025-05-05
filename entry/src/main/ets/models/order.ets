export class Order implements IOrder {
  id: number = 0
  icon: string = ''
  name: string = ''
  type: string = ''
  date: string = ''
  money: number = 0.0

  static from(json: Partial<IOrder>) {
    const instance = new Order()
    instance.money = json?.money ?? 0.0
    instance.date = json?.date ?? ''
    instance.type = json?.type ?? ''
    instance.name = json?.name ?? ''
    instance.icon = json?.icon ?? ''
    instance.id = json?.id ?? 0
    return instance
  }
}

export class Orders implements IOrders {
  list: Array<IOrder> = []

  static init() {
    return new Orders()
  }

  static from(json: Array<IOrder>) {
    const iterable = json.map((item): IOrder => Order.from(item))
    const instance = new Orders()
    instance.list = iterable
    return instance
  }

  public change(list: Array<IOrder>) {
    this.list = list
    return this
  }

  public clear() {
    this.list = []
    return this
  }
}

export class YearOrder implements IYearOrder {
  year: number = 0
  money: number = 0.0

  constructor(year: number, money: number) {
    this.year = year
    this.money = money
  }

  static from(json: IYearOrder) {
    return new YearOrder(json.year, json.money)
  }
}

export interface IYearOrder extends Recorder {
  year: number
  money: number
}

export interface IOrders extends Recorder {
  list: Array<IOrder>
  clear: () => IOrders
  change: (_: Array<IOrder>) => IOrders
}

export interface IOrder extends Recorder {
  id: number
  icon: string
  name: string
  type: string
  date: string
  money: number
}