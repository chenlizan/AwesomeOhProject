/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useState} from 'react';
import {SafeAreaView, Text, View, DeviceEventEmitter} from 'react-native';
import {NativeBaseProvider, AlertDialog, Button} from 'native-base';
import {NetModule} from './src/turboModule/NativeNet';
import {TimModule, LISTENER_TYPE} from './src/turboModule/NativeTim';

function App(): JSX.Element {
  const [info, setInfo] = useState('');
  const [isOpen, setIsOpen] = React.useState(false);

  const onClose = () => setIsOpen(false);

  const cancelRef = React.useRef(null);

  DeviceEventEmitter.addListener(LISTENER_TYPE.SUCCESS, e => {
    // 添加事件处理
    // setInfo('LISTENER_TYPE.SUCCESS');
  });

  const handleTest = async () => {
    TimModule.init(1400481918);
    const result = await NetModule.getCurrentNetStatus();
    setInfo(result.status);
    setIsOpen(!isOpen);
  };

  return (
    <NativeBaseProvider>
      <View style={{backgroundColor: 'white'}}>
        <SafeAreaView>
          <Button colorScheme="danger" onPress={handleTest}>
            Delete Customer
          </Button>
          <Text>输出结果：</Text>
          <Text>{info}</Text>
          <AlertDialog
            leastDestructiveRef={cancelRef}
            isOpen={isOpen}
            onClose={onClose}>
            <AlertDialog.Content>
              <AlertDialog.CloseButton />
              <AlertDialog.Header>Delete Customer</AlertDialog.Header>
              <AlertDialog.Body style={{backgroundColor: '#ff0500'}}>
                This will remove all data relating to Alex. This action cannot
                be reversed. Deleted data can not be recovered.
              </AlertDialog.Body>
              <AlertDialog.Footer>
                <Button.Group space={2}>
                  <Button
                    variant="unstyled"
                    colorScheme="coolGray"
                    onPress={onClose}
                    ref={cancelRef}>
                    Cancel
                  </Button>
                  <Button colorScheme="danger" onPress={onClose}>
                    Delete
                  </Button>
                </Button.Group>
              </AlertDialog.Footer>
            </AlertDialog.Content>
          </AlertDialog>
        </SafeAreaView>
      </View>
    </NativeBaseProvider>
  );
}

export default App;
