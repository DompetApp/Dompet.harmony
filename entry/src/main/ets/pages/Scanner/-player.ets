import { audio } from "@kit.AudioKit"
import { media } from "@kit.MediaKit"
import { common } from "@kit.AbilityKit"
import { logger } from "../../tracks/logger"


export class MediaPlayer {
  private player: media.AVPlayer | null = null
  private streamUsage: audio.StreamUsage = audio.StreamUsage.STREAM_USAGE_NOTIFICATION
  private audioRendererInfo: audio.AudioRendererInfo = { usage: this.streamUsage, rendererFlags: 0 }
  private static instance: MediaPlayer | null = null

  public static getInstance(context: common.UIAbilityContext) {
    if (MediaPlayer.instance === null) {
      MediaPlayer.instance = new MediaPlayer(context)
      MediaPlayer.instance.initPlayer(context)
    }
    return MediaPlayer.instance
  }

  public async initPlayer(context: common.UIAbilityContext) {
    if (!this.player) {
      this.player = await media.createAVPlayer().catch(() => null)
    }

    if (this.player) {
      this.setListener()
      this.player.fdSrc = await context.resourceManager.getRawFd('scanner/audio.ogg')
    }
  }

  constructor(context: common.UIAbilityContext) {
    this.initPlayer(context)
  }

  public setListener() {
    try {
      this.player?.on('stateChange', async (state) => {
        switch (state) {
          case 'idle':
            this.prepare()
            break

          case 'stopped':
            this.prepare()
            break

          case 'initialized':
            if (this.player) {
              this.player.audioRendererInfo = this.audioRendererInfo
              this.player.prepare().then(() => this.player!.setVolume(0.5)).catch((e: Unknown) => logger.error(e))
            }
            break
        }
      })
    } catch (error) {
      logger.error(error)
    }
  }

  public prepare() {
    this.player?.prepare().catch((e: Unknown) => logger.error(e))
  }

  public play() {
    this.player?.play().catch((e: Unknown) => logger.error(e))
  }
}