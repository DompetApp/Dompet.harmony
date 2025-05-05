export class AppNav {
  static sub = 'sub'
  static root = 'Root'
}

export class AppRouter {
  static home = '/PageHome'
  static card = '/PageCard'
  static login = '/PageLogin'
  static stats = '/PageStats'
  static langs = '/PageLangs'
  static logger = '/PageLogger'
  static profile = '/PageProfile'
  static webview = '/PageWebview'
  static scanner = '/PageScanner'
  static register = '/PageRegister'
  static operater = '/PageOperater'
  static settings = '/PageSettings'
  static notification = '/PageNotification'

  static get authorize() {
    return [
      AppRouter.home,
      AppRouter.card,
      AppRouter.stats,
      AppRouter.langs,
      AppRouter.logger,
      AppRouter.profile,
      AppRouter.scanner,
      AppRouter.operater,
      AppRouter.settings,
      AppRouter.notification,
    ]
  }

  static get anonymous() {
    return [AppRouter.login, AppRouter.register]
  }

  static get flippings() {
    return [AppRouter.login, AppRouter.register, AppRouter.webview, AppRouter.logger, AppRouter.stats]
  }
}
