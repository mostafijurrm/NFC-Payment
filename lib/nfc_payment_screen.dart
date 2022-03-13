import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_emulator/nfc_emulator.dart';

class NfcPaymentScreen extends StatefulWidget {
  const NfcPaymentScreen({Key? key}) : super(key: key);

  @override
  State<NfcPaymentScreen> createState() => _NfcPaymentScreenState();
}

class _NfcPaymentScreenState extends State<NfcPaymentScreen> {

  String _platformVersion = 'Unknown';
  NfcStatus _nfcStatus = NfcStatus.unknown;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    NfcStatus nfcStatus = NfcStatus.unknown;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await NfcEmulator.platformVersion;
      nfcStatus = await NfcEmulator.nfcStatus;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion ?? 'Unknown';
      _nfcStatus = nfcStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Emulator Example'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Version: $_platformVersion'),
              SizedBox(height: 20.0),
              Text('Status: $_nfcStatus'),
              SizedBox(height: 40.0),
              ElevatedButton(
                  child: Text(_started ? "Stop Emulator" : "Start Emulator"),
                  onPressed: startStopEmulator),
            ]),
      ),
    );
  }

  void startStopEmulator() async {
    if (_started) {
      await NfcEmulator.stopNfcEmulator();
    } else {
      await NfcEmulator.startNfcEmulator(
          "666B65630001", "cd22c716", "79e64d05ed6475d3acf405d6a9cd506b");
    }
    setState(() {
      _started = !_started;
    });
  }

}
