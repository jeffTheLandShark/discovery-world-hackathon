import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ExhibitScanView extends StatelessWidget {
  static const routeName = '/nfc-scan';
  const ExhibitScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scan NFC Tag'),
        ),
        body: ListView(children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.4),
          Center(
              child: FutureBuilder<bool>(
                  future: NfcManager.instance.isAvailable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.data!) {
                      return const Text('NFC is not available');
                    } else {
                      _startNfcSession(context);
                      return const Text('Listening for NFC tags...');
                    }
                  })),
          // spacing
          SizedBox(height: MediaQuery.of(context).size.height * 0.5),
          Image.asset("assets/images/beep_search.png",
              height: MediaQuery.of(context).size.height * 0.2),
        ]));
  }

  void _startNfcSession(BuildContext context) {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        NfcManager.instance.stopSession();
        final ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          // Handle the case where the tag is not NDEF formatted
          _startNfcSession(context);
          return;
        }
        final ndefMessage = ndef.cachedMessage;
        if (ndefMessage == null) {
          // Handle the case where there is no NDEF message
          _startNfcSession(context);
          return;
        }
        for (var record in ndefMessage.records) {
          if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
              record.payload.isNotEmpty) {
            final payload = record.payload;
            // drop first character and extract URL from params
            final payloadString = String.fromCharCodes(payload.sublist(1));
            final uri = Uri.parse(payloadString);
            final routingInfo = uri.queryParameters['id'] ?? '';
            Navigator.restorablePushNamed(
              context,
              uri.path,
              arguments: routingInfo,
            );

            break;
          }
        }
        // Restart the NFC session after processing the tag
        _startNfcSession(context);
      },
    );
  }
}
