import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:blocked_verifier_app/is_Verified_Screen.dart';

class VerifierScanner extends StatefulWidget {
  const VerifierScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerifierScannerState();
}

class _VerifierScannerState extends State<VerifierScanner> with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;

  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 1000,
    // returnImage: false,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent[50],
      appBar: AppBar(
          title: const Text('Verify'),
        backgroundColor: Colors.indigo.shade500,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Builder(
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: MobileScanner(
                          controller: controller,
                          errorBuilder: (context, error, child) {
                            return AlertDialog(
                              icon: const Icon(
                                Icons.crisis_alert,
                                color: Colors.redAccent,
                              ),
                              content: Text(
                                error.errorDetails?.message ?? "",
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                          fit: BoxFit.cover,
                          onDetect: (barcode) {
                            setState(() {
                              this.barcode = barcode;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            bool isQRValid = false;
                            if(barcode != null &&
                                barcode!.barcodes.isNotEmpty &&
                                barcode!.barcodes.last.rawValue != null &&
                                barcode!.barcodes.last.rawValue!.isNotEmpty &&
                                barcode!.barcodes.last.rawValue!.length == 64
                            ) isQRValid = true;

                            if (barcode == null) {
                              _showDialog("Please try to scan again the QR Code.");
                            } else if (barcode!.barcodes.last.rawValue!.length != 64) {
                              _showDialog("This QR code does not contain correct information.");
                            } else if (isQRValid) {
                              controller.stop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => IsVerified(
                                    certificateHash: barcode!.barcodes.last.rawValue.toString(),
                                    cameraController: controller,
                                  ),
                                  settings: const RouteSettings(name: "/isVerified")
                                ),
                              );
                            }
                          },
                          child: const Text('Scan Certificate',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            barcode = null;
                          });
                        },
                        child: const Text('Clear QR',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.crisis_alert,
            color: Colors.redAccent,
          ),
          content: Text(
            text,
            style: const TextStyle(
              color: Colors.redAccent,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                setState(() {
                  barcode = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}