An app for monitoring Blood Glucose Levels.

Requirements:

  -> Intuitive input for entering value.
  
  -> Should automatically take time and date and should store it on the device.
  
  -> Should display a graph with option to change scale using a slider and buttons for day histories (3day/week/month)
  
  -> On app update data should be retained.
  
  -> Future: Store it on the cloud, OCR to read value, widget to enter value.
  

On windows

C:\Users\adity\AppData\Local\Android\Sdk\emulator>emulator.exe -avd Pixel_6_API_33 -no-snapshot-load

adb kill-server

adb.exe -a -P 5037 nodaemon server


On Linux

export ADB_SERVER_SOCKET=tcp:172.26.144.1:5037

adb shell



On Windows for metro bundler

iex "netsh interface portproxy delete v4tov4 listenport=8081 listenaddress=127.0.0.1" | out-null;

$WSL_CLIENT = bash.exe -c "ifconfig eth0 | grep 'inet '";

$WSL_CLIENT -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

$WSL_CLIENT = $matches[0];

iex "netsh interface portproxy add v4tov4 listenport=8081 listenaddress=127.0.0.1 connectport=8081 connectaddress=$WSL_CLIENT"


To run app, do following on WSL:

 npx react-native start -- host 127.0.0.1     < to run Metro
 
 
npx react-native run-android --variant=debug --deviceId emulator-5554     < to run app


CODE:

npm install --save react-native-async-storage

npm install --save moment
 
npm install --save react-native-chart-kit

npm install @react-native-async-storage/async-storage

npm install react-native-svg

npm install react-native-svg-transformer --save-dev

