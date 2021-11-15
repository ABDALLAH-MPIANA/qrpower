import 'dart:developer';
import 'dart:io';
import 'package:qrpower/SendData.dart';
import 'package:qrpower/barcodeValue.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

// flutter 2.2.3
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Qr Power'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Barcode? result;
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    //controller!.resumeCamera();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child: Text('Info App'),
                  value: "Info",
                ),
              ];
            },
            onSelected: handleClick,
          ),
        ],
      ),
      body:
          buildResult(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        controller.pauseCamera();
        result = scanData;
        BarcodeValue.setString('${result!.code.toString()}');
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => SendData()))
            .then((value) => controller.resumeCamera());
        // ajout
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget buildResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderLength: 15,
                  borderRadius: 7,
                  borderWidth: 7),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
          ),
          /**
           * Expanded(
            flex: 1,
            child: Center(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                children: <Widget>[
                  if (result != null)
                    //Text('Barcode Type ${describeEnum(result!.format)} Data :${result!.code}')
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            // controller!.pauseCamera();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendData()));
                          },
                          child: Center(
                            child: Text('Go to sent\nData :${result!.code}'),
                          )),
                    )
                  else
                    Text('Scan code')
                ],
              ),
            )),
          )
           */
        ],
      ),
    );
  }

  handleClick(String value) {
    switch (value) {
      case 'Info':
        {
          _aproposApp(context);
        }
        break;
    }
  }

  // about app
  _aproposApp(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationVersion: "Beta 1.0.0",
      applicationName: "QrPower",
      children: [
        Text("Tout droit reservé",
            style: new TextStyle(color: Colors.grey, fontSize: 15.0)),
        Text('WORIAPP & ALL',
            style: new TextStyle(color: Colors.grey, fontSize: 15.0)),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: new Text(
            "woriapp.all@gmail.com",
            style: new TextStyle(
                color: Colors.grey, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
