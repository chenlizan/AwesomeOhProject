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
  NotFoundException,
  PlanarYUVLuminanceSource  // 新增导入
} from '@ohos/zxing';
import image from '@ohos.multimedia.image';
import util from '@ohos.util';


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
]);

// 解码选项接口
interface DecodeOptions {
  codeTypes?: string[];
}


export class QrDecodeModule extends TurboModule implements TM.NativeQrDecode.Spec {
  async decode(base64Data: string, options?: DecodeOptions): Promise<string> {
    try {
      let base64Helper = new util.Base64Helper();
      if (base64Data.startsWith('data:')) {
        base64Data = base64Data.split(',')[1];
      }
      const decodedData: Uint8Array =  base64Helper.decodeSync(base64Data)
      const imageSource: image.ImageSource = image.createImageSource(decodedData.buffer);
      const pixelMap: image.PixelMap = await imageSource.createPixelMap();
      let result: Result | null = null;
      const reader: MultiFormatReader = new MultiFormatReader();

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
        const binaryBitmap: BinaryBitmap = await this.generateBitmapFromImageData(pixelMap);
        console.log("today + binaryBitmap" + JSON.stringify(binaryBitmap))

        result = reader.decode(binaryBitmap);
        console.log("today + result" + JSON.stringify(result))
      } catch (e) {
        if (e instanceof NotFoundException) {
          console.log('No barcode found in the image');
        } else {
          console.error(`Decode error: ${e instanceof Error ? e.message : JSON.stringify(e)}`);
        }
      } finally {
        // 释放资源
        pixelMap.release();
        imageSource.release();
      }
      console.log("today" + result?.getText());
      return result ? result.getText() : "";
    } catch (error) {
      console.error(`QR decode error: ${error instanceof Error ? error.message : JSON.stringify(error)}`);
      throw new Error(`QR decode failed: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  private async getSmallerBitmap(
    pixelMap: image.PixelMap,
    originalWidth: number,
    originalHeight: number
  ): Promise<image.PixelMap> {
    const totalPixels = originalWidth * originalHeight;
    const maxPixels = 300000;
    if (totalPixels <= maxPixels) {
      return pixelMap;
    }
    const scaleFactor = Math.sqrt(maxPixels / totalPixels);
    // 修复：使用scale方法返回的新实例
    await pixelMap.scale(scaleFactor, scaleFactor);
    return  pixelMap
  }

  private async generateBitmapFromImageData(pixelMap: image.PixelMap): Promise<BinaryBitmap> {
    // 1. 获取图像信息以获取原始宽高
    const imageInfo = await pixelMap.getImageInfo();
    console.log("today" + JSON.stringify(imageInfo))

    const originalWidth = imageInfo.size.width;
    const originalHeight = imageInfo.size.height;

    // 2. 图片缩放（修复参数不匹配问题）
    const smallerPixelMap = await this.getSmallerBitmap(pixelMap, originalWidth, originalHeight);
    const smallerImageInfo = await smallerPixelMap.getImageInfo();
    const width = smallerImageInfo.size.width;
    const height = smallerImageInfo.size.height;

    try {
      // 3. 读取RGB像素数据（指定RGB_888格式）
      const pixelFormat = image.PixelMapFormat.RGB_888;
      const bufferSize = smallerPixelMap.getPixelBytesNumber();
      const arrayBuffer = new ArrayBuffer(bufferSize);
      await smallerPixelMap.readPixelsToBuffer(arrayBuffer);
      const rgbPixels = new Int32Array(arrayBuffer);

      // 4. 转换为YUV420SP格式
      const yuv420sp = this.encodeYUV420SP(rgbPixels, width, height);

      // 5. 创建PlanarYUVLuminanceSource
      const luminanceSource = new PlanarYUVLuminanceSource(
        new Uint8ClampedArray(yuv420sp),        // YUV数据
        width,           // 图像宽度
        height,          // 图像高度
        0,               // 左偏移
        0,               // 上偏移
        width,           // 裁剪宽度
        height,          // 裁剪高度
        false            // 不反转水平方向
      );
      console.log("today" + JSON.stringify(luminanceSource))
      return new BinaryBitmap(new HybridBinarizer(luminanceSource));
    } finally {
      // 释放缩放后的PixelMap
      if (smallerPixelMap !== pixelMap) {
        smallerPixelMap.release();
      }
    }
  }

  /**
   * 转换RGB为YUV420SP格式
   */
  private encodeYUV420SP(rgbPixels: Int32Array, width: number, height: number): Uint8Array {
    const frameSize = width * height;
    const yuv420sp = new Uint8Array(frameSize + Math.ceil(frameSize / 2));

    let yIndex = 0;
    let uvIndex = frameSize;
    let argbIndex = 0;

    for (let j = 0; j < height; j++) {
      for (let i = 0; i < width; i++) {
        // 提取RGB值（忽略Alpha通道）
        const rgb = rgbPixels[argbIndex++];
        const R = (rgb >> 16) & 0xff;
        const G = (rgb >> 8) & 0xff;
        const B = rgb & 0xff;

        // RGB转YUV公式
        const Y = ((66 * R + 129 * G + 25 * B + 128) >> 8) + 16;
        const U = ((-38 * R - 74 * G + 112 * B + 128) >> 8) + 128;
        const V = ((112 * R - 94 * G - 18 * B + 128) >> 8) + 128;

        // 确保像素值在0-255范围内
        yuv420sp[yIndex++] = Math.max(0, Math.min(Y, 255));

        // UV通道按2x2采样（仅偶数行和偶数列）
        if ((j % 2 === 0) && (i % 2 === 0)) {
          yuv420sp[uvIndex++] = Math.max(0, Math.min(V, 255));
          yuv420sp[uvIndex++] = Math.max(0, Math.min(U, 255));
        }
      }
    }

    return yuv420sp;
  }

}
