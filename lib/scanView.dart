import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:msapps/Movies.dart';
import 'package:msapps/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'DatabaseHelper.dart';

class ScanView extends StatefulWidget {
  ScanView({Key key}) : super(key: key);

  @override
  _ScanViewDemoState createState() => new _ScanViewDemoState();
}

class _ScanViewDemoState extends State<ScanView> {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setPermission();
    return new Scaffold(
      body: QrcodeReaderView(
        key: _key,
        onScan: onScan,
        headerWidget: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }

  void setPermission() async {

    setState(() {});
  }
  Future<String> onScan(String data) async {
    Movies movies;
    try {
      var rec = jsonDecode(data);
      String title = rec["title"];
      String image = rec["image"];
      double rating = rec["rating"].toDouble();
      int releaseYear = int.parse(rec['releaseYear'].toString());
      movies = new Movies(title, image, rating, releaseYear);
      SQLiteDbProvider.db.getProductByTitle(rec["title"]).then((value) {
        if (value == null){
          SQLiteDbProvider.db.insert(movies);
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Current movie already exist in the Database!'),
          ));

        }
      });

    } catch(e){
      print(e.toString());
    }

    _key.currentState.startScan();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyAppPre()));
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }
}