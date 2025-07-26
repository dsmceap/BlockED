import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'API/API.dart';

class IsVerified extends StatefulWidget {
  const IsVerified({Key? key, required this.certificateHash, required this.cameraController}) : super(key: key);

  final String? certificateHash;
  final MobileScannerController cameraController;

  @override
  State<StatefulWidget> createState() => _IsVerifiedState();
}

class _IsVerifiedState extends State<IsVerified> {

  bool isLoading = false;
  String? _certificateHash = "";
  Future<Map<String,dynamic>>? _verificationFuture;
  late MobileScannerController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraController = widget.cameraController;
    _certificateHash = widget.certificateHash;
    _verificationFuture = _checkVerification(_certificateHash!);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: Colors.grey, onPressed: () {
          _cameraController.start(cameraFacingOverride: CameraFacing.back);
          Navigator.of(context).pop();
        },
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Certificate Hash:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height:5),
                Text(
                  _certificateHash ?? "no did found",style:
                const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
                ),
                const SizedBox(height: 25,),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: ModalProgressHUD(
                    opacity: 0,
                    inAsyncCall: isLoading,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.5,
                      child: FutureBuilder(
                        future: _verificationFuture,
                        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if(snapshot.hasError){
                            return const Text("Could not validate");
                          } else if(snapshot.hasData) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  snapshot.data?['result'] ?? false
                                      ?Icons.verified_user_outlined
                                      :Icons.remove_circle_outline,
                                  size: 300,
                                  color: snapshot.data?['result'] ?? false
                                      ?Colors.green
                                      :Colors.red,
                                ),
                                const SizedBox(height:25),
                                Text(
                                  snapshot.data?['message'] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Center(child: Text("Validating..."));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25,),
                IconButton(
                  icon: const Icon(Icons.home, size: 50, color: Colors.teal,),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.settings.name == "/");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String,dynamic>> _checkVerification(String hash) async{
    try{
      setState(() {
        isLoading = true;
      });
      var response = await API.verifyCertificate(hash);
      setState(() {
        isLoading = false;
      });
      return response;
    }catch(e){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
      return {'message':'Could not complete verification', 'result': false};
    }
  }
}