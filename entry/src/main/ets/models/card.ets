export class Card implements ICard {
  id: number = 0
  cardNo: string = ''
  cardType: string = ''
  bankName: string = ''
  expiryDate: string = ''
  balance: number = 0.0
  status: string = ''

  static init() {
    return new Card()
  }

  static from(json: Partial<ICard>) {
    const instance = new Card()
    instance.status = json?.status ?? 'Y'
    instance.balance = json?.balance ?? 0.0
    instance.expiryDate = json?.expiryDate ?? ''
    instance.bankName = json?.bankName ?? ''
    instance.cardType = json?.cardType ?? ''
    instance.cardNo = json?.cardNo ?? ''
    instance.id = json?.id ?? -1
    return instance
  }

  public from(json: Partial<ICard>) {
    const instance = new Card()
    instance.status = json?.status ?? this.status
    instance.balance = json?.balance ?? this.balance
    instance.expiryDate = json?.expiryDate ?? this.expiryDate
    instance.bankName = json?.bankName ?? this.bankName
    instance.cardType = json?.cardType ?? this.cardType
    instance.cardNo = json?.cardNo ?? this.cardNo
    instance.id = json?.id ?? this.id
    return instance
  }

  public patch(json: Partial<ICard>) {
    this.status = json?.status ?? this.status
    this.balance = json?.balance ?? this.balance
    this.expiryDate = json?.expiryDate ?? this.expiryDate
    this.bankName = json?.bankName ?? this.bankName
    this.cardType = json?.cardType ?? this.cardType
    this.cardNo = json?.cardNo ?? this.cardNo
    this.id = json?.id ?? this.id
    return this
  }

  public change(json: ICard) {
    this.status = json?.status
    this.balance = json?.balance
    this.expiryDate = json?.expiryDate
    this.bankName = json?.bankName
    this.cardType = json?.cardType
    this.cardNo = json?.cardNo
    this.id = json?.id
    return this
  }

  public clear() {
    this.status = 'N'
    this.balance = 0.0
    this.expiryDate = ''
    this.bankName = ''
    this.cardType = ''
    this.cardNo = ''
    this.id = 0
    return this
  }
}

export interface ICard extends Recorder {
  id: number
  cardNo: string
  status: string
  balance: number
  cardType: string
  bankName: string
  expiryDate: string
  from: (_: Partial<ICard>) => ICard
  patch: (_: Partial<ICard>) => ICard
  change: (_: ICard) => ICard
  clear: () => ICard
}


