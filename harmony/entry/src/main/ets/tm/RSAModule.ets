import { TurboModule } from "@rnoh/react-native-openharmony"
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { cryptoFramework } from "@kit.CryptoArchitectureKit"
import { buffer, util } from "@kit.ArkTS"

export class RSAModule extends TurboModule implements TM.NativeRSA.Spec {
  encryptWithOAEPSHA256(publicKey: string, plan: string): Promise<string> {
    try {
      const asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024')
      const keyPairData = asyKeyGenerator.convertPemKeySync(publicKey, null)
      if (keyPairData === null) {
        throw new Error('convert pem key pair result fail!')
      }
      const cipher = cryptoFramework.createCipher("RSA|PKCS1_OAEP|SHA256|MGF1_SHA256");
      cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPairData.pubKey, null)
      const input: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(plan, 'utf-8').buffer) }
      const cipherDataBlob = cipher.doFinalSync(input)
      return new Promise((resolve) => resolve(new util.Base64Helper().encodeToStringSync(cipherDataBlob.data)))
    } catch (e) {
      console.error(`Sync error, ${e.code}, ${e.message}`)
      return new Promise((resolve) => resolve(''))
    }
  }
}