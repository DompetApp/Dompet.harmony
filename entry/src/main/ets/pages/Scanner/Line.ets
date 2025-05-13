import { size } from "../../utils/size"
import { AnimatorResult } from "@kit.ArkUI"
import { Animator } from "@kit.ArkUI"
import { curves } from "@kit.ArkUI"


@ComponentV2
export struct ScannerLine {
  @Local lineSpeed: number = 0
  @Local lineAngle: number = 180
  @Local linePosition: number = 0
  private scanAnimator: AnimatorResult | undefined
  @Param isOpenAlbum: boolean = false
  @Local isScanning: boolean = true
  @Param isScanned: boolean = false

  @Computed
  get lineOpacity() {
    return !this.isScanned && !this.isOpenAlbum ? 1 : 0
  }

  @Builder
  renderParticleBuilder() {
    Particle({
      particles: [
        {
          opacity: {
            range: [0, 0.5],
            updater: {
              type: ParticleUpdater.CURVE,
              config: [
                {
                  to: 0.5,
                  from: 0,
                  endMillis: 200,
                  startMillis: 0,
                  curve: Curve.Smooth,
                },
                {
                  to: 0,
                  from: 0.5,
                  endMillis: 500,
                  startMillis: 300,
                  curve: Curve.Smooth,
                }
              ]
            }
          },
          emitter: {
            size: ['100%', '100%'],
            shape: ParticleEmitterShape.RECTANGLE,
            emitRate: 60,
            particle: {
              type: ParticleType.POINT,
              config: { radius: 2 },
              lifetime: 500,
              count: -1,
            },
          },
          scale: {
            range: [0.4, 1.1],
            updater: {
              type: ParticleUpdater.RANDOM,
              config: [0.4, 1.1]
            }
          },
          color: {
            range: ['#0A8BF5', '#FFFFFF']
          },
        }
      ]
    })
      .width('80%')
      .height('100%')
      .markAnchor({ y: this.lineAngle === 180 ? (60 * this.lineSpeed) : 0 })
      .maskShape(
        new Rect({ width: '100%', height: 60 * (this.lineSpeed) })
          .position({ y: this.linePosition + '%' })
          .fill(Color.White)
      )
  }

  scanAnimatorCreate() {
    if (!this.scanAnimator) {
      this.scanAnimator = Animator.create({
        duration: 2000,
        iterations: -1,
        direction: 'alternate',
        easing: 'smooth',
        fill: 'none',
        delay: 0,
        begin: 0,
        end: 100,
      })
    }

    if (this.scanAnimator) {
      this.scanAnimator.onRepeat = () => {
        this.lineAngle = this.lineAngle !== 180 ? 180 : 0
      }

      this.scanAnimator.onCancel = () => {
        this.isScanning = false
      }

      this.scanAnimator.onFrame = (value) => {
        if (!this.isScanning) {
          this.isScanning = true
        }

        this.linePosition = value

        this.lineSpeed = value >= 39
          ? 1.0 - curves.cubicBezierCurve(0.25, 0.0, 0.4, 1.0).interpolate((value - 39) / 61)
          : curves.cubicBezierCurve(0.4, 0.0, 0.7, 1.0).interpolate(value / 39)
      }
    }
  }

  aboutToDisappear() {
    this.scanAnimator?.cancel()
    this.scanAnimator = undefined
  }

  aboutToAppear() {
    this.scanAnimatorCreate()
    this.scanAnimator?.play()
  }

  build() {
    Stack() {
      Image($rawfile('scanner/line.png'))
        .position({ y: this.linePosition + '%' })
        .height(size.vp(2))
        .draggable(false)
        .width('100%')

      Image($rawfile('scanner/blur.png'))
        .scale({ y: Math.max(this.lineSpeed, 0.007) })
        .position({ y: this.linePosition + '%' })
        .height(size.vp(130))
        .draggable(false)
        .width('100%')
        .rotate({
          angle: this.lineAngle,
          centerX: 0,
          centerY: 0,
          x: 1,
        })

      this.renderParticleBuilder()
    }
    .opacity(this.lineOpacity)
    .height('100%')
    .width('100%')
  }
}