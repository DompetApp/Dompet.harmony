export class FocusMgr {
  private context: UIContext | null = null

  constructor(context: UIContext) {
    this.context = context
  }

  public focusSync(id: string) {
    if (this.context && id) {
      try {
        this.context.getFocusController().requestFocus(id)
      } catch (e) {
        /* e */
      }
    }
  }

  public blurSync(_?: never) {
    if (this.context) {
      this.context.getFocusController().clearFocus()
    }
  }

  public focus(id: string) {
    if (this.context && id) {
      focusControl.requestFocus(id)
    }
  }

  public blur(_?: never) {
    if (this.context) {
      this.context.getFocusController().clearFocus()
    }
  }

  public close() {
    if (this.context) {
      this.context.getFocusController().clearFocus()
      this.context = null
    }
  }
}
