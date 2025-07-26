import 'package:flutter/material.dart';
import 'package:blocked_verifier_app/verifier_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void>? _launched;
  final Uri toLaunch = Uri.parse("https://blocked-project.eu/");

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade500,
        centerTitle: true,
        title: const Text("block.Ed Verifier",),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: const Text(
              "Welcome to the block.Ed Verifier App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 37,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Tap on the graduation hat to scan a block.Ed eligible QR code",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
          scanButton(),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _launched = _launchInBrowserView(toLaunch);
                  });
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Image.asset(
                    "lib/assets/images/blocked-logo.png",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text("Funded by the European Union's Horizon 2020 research and innovation programme under grant agreement No 101017109",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget scanButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const VerifierScanner(),
              settings: const RouteSettings(name: "/scanner")
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(180),
          border: Border.all(
            color: Colors.teal,
            width: 3.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 25.0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.65,
        child: Image.asset(
          "lib/assets/images/student.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}
