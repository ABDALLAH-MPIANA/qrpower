import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrpower/barcodeValue.dart';

class SendData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePSDate();
  }
}

class HomePSDate extends StatefulWidget {
  HomePSDState createState() => HomePSDState();
}

class HomePSDState extends State<HomePSDate> {
  //static String url = '';
  TextEditingController preferencesController = new TextEditingController();
  final snackBar = SnackBar(content: Text("Please enter a value !"));
  final snackBarSuccessfully = SnackBar(content: Text("Successfully"));
  final snackBarFailure = SnackBar(content: Text("Failure"));
  final snackBarPref = SnackBar(content: Text("Please enter an Url"));
  TextEditingController settingsScreenController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: Text('Url preference'),
                    value: "preference",
                  ),
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
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: settingsScreenController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Cote',
                      hintMaxLines: 1,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 4.0))),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final ip = prefs.getString('ip') ?? '';

                    if (settingsScreenController.text.isNotEmpty) {
                      if (ip == '')
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarPref);
                      else {
                        print(ip + ' Est l adresse IP');
                        senddata(settingsScreenController.text.toString(),
                            BarcodeValue.getString(), ip.trim().toString());
                      }

                      // NETOYER TEXTFIELD
                      settingsScreenController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Center(
                    child: Text(
                      'Valeur Qr: ${BarcodeValue.getString()} \n\n Envoyer cote',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('cote\nchaine\nSont les variables'),
                )
              ],
            ),
          ),
        ));
  }

  Future senddata(var cote, var chaine, var ip) async {
    if (chaine != null && cote != null && ip != null) {
      final response = await http.post(Uri.parse(ip), body: {
        "cote": cote,
        "chaine": chaine,
      });
      String res;
      res = json.decode(response.body);
      if (res == "successfully") {
        ScaffoldMessenger.of(context).showSnackBar(snackBarSuccessfully);
        //RETOUR A LA RACINE
        Navigator.of(context, rootNavigator: true).pop(context);
        print('Le json :' + json.decode(response.body).toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarFailure);
        print('Le json :' + json.decode(response.body).toString());
      }
    }
  }

  handleClick(String value) {
    switch (value) {
      case 'preference':
        {
          _preferencesUrl(context);
        }
        break;
      case 'Info':
        {
          _aproposApp(context);
        }
        break;
    }
  }

  _preferencesUrl(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: preferencesController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                            labelText: 'IP Adress',
                            hintMaxLines: 1,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green, width: 4.0))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  'ip', preferencesController.text.toString());

                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              'Update IP',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ));
  }

  // about app
  _aproposApp(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationVersion: "Beta 1.0",
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
