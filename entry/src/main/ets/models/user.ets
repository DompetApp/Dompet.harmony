export class User implements IUser {
  uid: string = ''
  name: string = ''
  phone: string = ''
  email: string = ''
  activate: string = ''
  createDate: string = ''
  avatar: Uint8Array | null = null

  static init() {
    return new User()
  }

  static from(json: Partial<IUser>) {
    const instance = new User()
    instance.createDate = json?.createDate ?? ''
    instance.activate = json?.activate ?? ''
    instance.avatar = json?.avatar ?? null
    instance.email = json?.email ?? ''
    instance.phone = json?.phone ?? ''
    instance.name = json?.name ?? ''
    instance.uid = json?.uid ?? ''
    return instance
  }

  public from(json: Partial<IUser>) {
    const instance = new User()
    instance.createDate = json?.createDate ?? this.createDate
    instance.activate = json?.activate ?? this.activate
    instance.avatar = json?.avatar ?? this.avatar
    instance.email = json?.email ?? this.email
    instance.phone = json?.phone ?? this.phone
    instance.name = json?.name ?? this.name
    instance.uid = json?.uid ?? this.uid
    return instance
  }

  public patch(json: Partial<IUser>) {
    this.createDate = json.createDate ?? this.createDate
    this.activate = json.activate ?? this.activate
    this.avatar = json.avatar ?? this.avatar
    this.email = json.email ?? this.email
    this.phone = json.phone ?? this.phone
    this.name = json.name ?? this.name
    this.uid = json.uid ?? this.uid
    return this
  }

  public change(json: IUser) {
    this.createDate = json.createDate
    this.activate = json.activate
    this.avatar = json.avatar
    this.email = json.email
    this.phone = json.phone
    this.name = json.name
    this.uid = json.uid
    return this
  }

  public clear() {
    this.createDate = ''
    this.activate = 'N'
    this.avatar = null
    this.email = ''
    this.phone = ''
    this.name = ''
    this.uid = ''
    return this
  }
}

export interface IUser extends Recorder {
  uid: string
  name: string
  phone: string
  email: string
  activate: string
  createDate: string
  avatar: Uint8Array | null
  from: (_: Partial<IUser>) => IUser
  patch: (_: Partial<IUser>) => IUser
  change: (_: IUser) => IUser
  clear: () => IUser
}
