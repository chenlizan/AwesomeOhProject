import { display, window } from "@kit.ArkUI";
import { Descriptor, RNOHContext, RNViewBase, ViewBaseProps } from "@rnoh/react-native-openharmony";
import { RNC } from "@rnoh/react-native-openharmony/generated";
import { media } from "@kit.MediaKit";
import { BusinessError } from "@kit.BasicServicesKit";

export const NATIVE_AUDIO_TYPE: string = RNC.NativeAudio.NAME

enum AvplayerStatus {
  IDLE = 'idle',
  INITIALIZED = 'initialized',
  PREPARED = 'prepared',
  PLAYING = 'playing',
  PAUSED = 'paused',
  COMPLETED = 'completed',
  STOPPED = 'stopped',
  RELEASED = 'released',
  ERROR = 'error'
}

enum Events {
  STATE_CHANGE = 'stateChange',
  TIME_UPDATE = 'timeUpdate',
  ERROR = 'error'
}

function fill(value: number): string {
  return value.toString().padStart(2, '0')
}

function msToCountdownTime(ms: number): string {
  if (!ms) {
    return '00:00'
  }

  const days = Math.floor(ms / (1000 * 60 * 60 * 24))
  const hours = Math.floor((ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
  const minutes = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60))
  const seconds = Math.floor((ms % (1000 * 60)) / 1000)
  return `${(days ? fill(days) + ':' : '')}${(hours ? fill(hours) + ':' : '')}
      ${fill(minutes)}:${fill(seconds)} `.trim()
}

interface DataModal {
  uri: string;
}

export interface NativeAudioProps extends ViewBaseProps {
  source: DataModal,
  paused?: boolean
}

export interface AutoLayoutViewState {}

export type AudioViewDescriptor = Descriptor<"RNCVideo", ViewBaseProps, AutoLayoutViewState, NativeAudioProps>

@Component
export struct NativeAudio {
  ctx!: RNOHContext;
  tag: number = -1;
  @State descriptor: AudioViewDescriptor = Object() as AudioViewDescriptor;
  @State @Watch('onPlaying') playing: boolean = false
  private avPlayer: media.AVPlayer | null = null;
  private callbackList: Array<() => void> = []
  private eventEmitter: RNC.NativeAudio.EventEmitter | undefined = undefined

  async createAVPlayer() {
    this.avPlayer = await media.createAVPlayer()
    await this.bindState()
  }

  async bindState() {
    if (this.avPlayer === null) {
      return
    }
    this.avPlayer.on(Events.STATE_CHANGE, async (state: media.AVPlayerState) => {
      let avplayerStatus: string = state
      if (this.avPlayer === null) {
        return
      }
      switch (avplayerStatus) {
        case AvplayerStatus.IDLE:
          this.avPlayer.release()
          break
        case AvplayerStatus.INITIALIZED:
          this.avPlayer.prepare()
          break
        case AvplayerStatus.PREPARED:
          this.eventEmitter?.emit('load', {
            currentTime: 0,
            duration: this.avPlayer.duration
          })
          break
        case AvplayerStatus.PLAYING:
          break
        case AvplayerStatus.PAUSED:
          break
        case AvplayerStatus.COMPLETED:
          this.avPlayer.seek(0)
          this.eventEmitter?.emit('end', null)
          break
        case AvplayerStatus.RELEASED:
          this.avPlayer.release()
          break
        default:
          break
      }
    })
    this.avPlayer.on(Events.TIME_UPDATE, (time: number) => {
      this.eventEmitter?.emit('progress', {
        currentTime: time,
      })
    })
    this.avPlayer.on(Events.ERROR, () => {
      this.eventEmitter?.emit('error', null)
    })
  }

  onPlaying() {
    if (this.playing) {
      this.avPlayer?.play()
    } else {
      this.avPlayer?.pause()
    }
  }

  async aboutToAppear(): Promise<void> {
    this.eventEmitter = new RNC.NativeAudio.EventEmitter(this.ctx.rnInstance, this.tag);
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<AudioViewDescriptor>(this.tag);
    this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as AudioViewDescriptor);
        this.playing = !this.descriptor.rawProps.paused || false
      })
    this.registerCommandCallback()
    await this.createAVPlayer()
    if (this.descriptor.rawProps.source) {
      if (this.avPlayer) {
        this.avPlayer.url = this.descriptor.rawProps.source.uri
      }
    }
  }

  registerCommandCallback(): void {
    if (this.ctx) {
      this.callbackList.push(this.ctx.componentCommandReceiver.registerCommandCallback(
        this.tag,
        (command, args: (string | number)[]) => {
          if (command === 'seek') {
            this.avPlayer?.seek(args[0] as number)
          }
        }))
    }
  }

  cancellationCallback() {
    this.callbackList.forEach(
      callback => {
        callback?.()
      }
    )
  }

  build() {
    Column() {
      RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      }
    }
  }

  aboutToDisappear(): void {
    this.cancellationCallback()
    if (this.avPlayer) {
      this.avPlayer.stop()
      this.avPlayer.release()
    }
  }
}