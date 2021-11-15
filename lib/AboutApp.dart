import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: _aproposApp(context));
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
        new Text(
          "+243 82 36 55 282",
          style: new TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
