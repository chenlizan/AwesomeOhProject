import { TurboModule } from "@rnoh/react-native-openharmony"
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import {
  BarcodeFormat,
  MultiFormatReader,
  DecodeHintType,
  RGBLuminanceSource,
  BinaryBitmap,
  HybridBinarizer,
  Result,
  NotFoundException
} from '@ohos/zxing';
import image from '@ohos.multimedia.image';
import { util } from "@kit.ArkTS";

// 定义支持的条码类型映射
const VALID_BARCODE_TYPES: Map<string, string> = new Map([
  ['aztec', BarcodeFormat.AZTEC.toString()],
  ['ean13', BarcodeFormat.EAN_13.toString()],
  ['ean8', BarcodeFormat.EAN_8.toString()],
  ['qr', BarcodeFormat.QR_CODE.toString()],
  ['pdf417', BarcodeFormat.PDF_417.toString()],
  ['upc_e', BarcodeFormat.UPC_E.toString()],
  ['datamatrix', BarcodeFormat.DATA_MATRIX.toString()],
  ['code39', BarcodeFormat.CODE_39.toString()],
  ['code93', BarcodeFormat.CODE_93.toString()],
  ['interleaved2of5', BarcodeFormat.ITF.toString()],
  ['codabar', BarcodeFormat.CODABAR.toString()],
  ['code128', BarcodeFormat.CODE_128.toString()],
// 注意：鸿蒙ZXing库可能不支持以下格式
// ['maxicode', BarcodeFormat.MAXICODE.toString()],
// ['rss14', BarcodeFormat.RSS_14.toString()],
// ['rssexpanded', BarcodeFormat.RSS_EXPANDED.toString()],
// ['upc_a', BarcodeFormat.UPC_A.toString()],
// ['upc_ean', BarcodeFormat.UPC_EAN_EXTENSION.toString()]
]);

export class QrDecodeModule extends TurboModule implements TM.NativeQrDecode.Spec {
  private async getSmallerBitmap(
    pixelMap: image.PixelMap,
    originalWidth: number,
    originalHeight: number
  ): Promise<image.PixelMap> {
    const totalPixels = originalWidth * originalHeight;
    const maxPixels = 160000; // 最大允许像素数
    if (totalPixels <= maxPixels) {
      return pixelMap; // 无需缩小，返回原对象
    }

    // 计算缩放比例（确保缩小后像素数≤maxPixels）
    const scaleFactor = Math.sqrt(maxPixels / totalPixels);
    // 关键：await异步缩放，获取新的PixelMap实例
    await pixelMap.scale(scaleFactor, scaleFactor);

    return pixelMap
  }

  private async generateBitmapFromImageData(pixelMap: image.PixelMap): Promise<BinaryBitmap> {
    // 1. 获取原图像信息
    const originalImageInfo = await pixelMap.getImageInfo();
    const originalSize = originalImageInfo.size;
    const originalWidth = originalSize.width;
    const originalHeight = originalSize.height;

    // 2. 缩小图像（获取新的PixelMap）
    const smallerPixelMap = await this.getSmallerBitmap(pixelMap, originalWidth, originalHeight);
    // 3. 获取缩小后的图像尺寸（关键：用缩小后的尺寸）
    const smallerImageInfo = await smallerPixelMap.getImageInfo();
    const smallerWidth = smallerImageInfo.size.width
    const smallerHeight = smallerImageInfo.size.height

    try {
      // 4. 读取缩小后的像素数据（指定像素格式为RGB_888，避免Alpha通道干扰）
      const pixelFormat = image.PixelMapFormat.RGB_888; // 明确RGB格式
      const bufferSize = smallerPixelMap.getPixelBytesNumber();
      const arrayBuffer = new ArrayBuffer(bufferSize);
      await smallerPixelMap.readPixelsToBuffer(arrayBuffer);

      // 5. 转为Int32Array（ZXing需要）
      const intArray = new Int32Array(arrayBuffer);

      // 6. 创建RGBLuminanceSource（用缩小后的宽高，匹配像素数据）
      const luminanceSource = new RGBLuminanceSource(
        intArray,
        smallerWidth,
        smallerHeight
      );

      return new BinaryBitmap(new HybridBinarizer(luminanceSource));
    } finally {
      // 关键：释放缩小后的PixelMap，避免内存泄漏
      if (smallerPixelMap !== pixelMap) {
        smallerPixelMap.release();
      }
    }
  }

  async decode(base64Data: string, options: TM.NativeQrDecode.OptionsModel): Promise<string> {
    try {
      let base64Helper = new util.Base64Helper();

      // Base64解码
      const decodedData: Uint8Array = base64Helper.decodeSync(base64Data)

      // 创建ImageSource
      const imageSource: image.ImageSource = image.createImageSource(decodedData.buffer);

      // 创建PixelMap
      const pixelMap: image.PixelMap = await imageSource.createPixelMap();


      const reader: MultiFormatReader = new MultiFormatReader();
      let result: Result | null = null;
      // 设置解码提示
      if (options && options.codeTypes && options.codeTypes.length > 0) {
        const hints: Map<DecodeHintType, BarcodeFormat[]> = new Map();
        const decodeFormats: BarcodeFormat[] = [];

        for (const codeType of options.codeTypes) {
          const formatString: string | undefined = VALID_BARCODE_TYPES.get(codeType);
          if (formatString) {
            try {
              const format: BarcodeFormat = BarcodeFormat[formatString];
              decodeFormats.push(format);
            } catch (e) {
              console.error(`Unsupported barcode format: ${formatString}`);
            }
          }
        }

        if (decodeFormats.length > 0) {
          hints.set(DecodeHintType.POSSIBLE_FORMATS, decodeFormats);
          reader.setHints(hints);
        }
      }

      try {
        // 生成BinaryBitmap并解码
        const binaryBitmap: BinaryBitmap = await this.generateBitmapFromImageData(pixelMap);

        result = reader.decode(binaryBitmap) as Result;
      } catch (e) {
        if (e instanceof NotFoundException) {
          console.log('No barcode found in the image');
          // 可以尝试旋转图像后再次解码
          // const rotatedPixelMap = await this.rotateImage(pixelMap, 90);
          // const rotatedBinaryBitmap = await this.generateBitmapFromImageData(rotatedPixelMap);
          // result = reader.decode(rotatedBinaryBitmap);
        } else {
          console.error(`Decode error: ${JSON.stringify(e)}`);
        }
      } finally {
        // 释放资源
        pixelMap.release();
        imageSource.release();
      }

      return Promise.resolve(result ? result.getText() : "");
    } catch (error) {
      console.error(`QR decode error: ${JSON.stringify(error)}`);
      throw new Error(`QR decode failed: ${error.message}`);
    }
  }
}
