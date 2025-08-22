import { RNOHContext, RNViewBase } from "@rnoh/react-native-openharmony";
// import { RNC } from "@rnoh/react-native-openharmony/generated";

@Component
export struct NativeVideo {
  // public static readonly NAME = RNC.NativeVideo.NAME
  ctx!: RNOHContext;
  tag: number = -1;

  build() {
    Column() {
      Text('NativeVideo chenlizan')
    }
    .height('100%')
  }
}