import 'package:flutter/material.dart';

import 'main.dart';

class Detail extends StatefulWidget {
  int pos;
  @override
  _DetailState createState() => _DetailState();

  Detail(this.pos);
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MSApps'),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(list[widget.pos].image,height: 300,),
          Text(list[widget.pos].title,textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 28),),
          Text('Rating: '+list[widget.pos].rating.toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 14),),
          Text('Release year: '+list[widget.pos].releaseYear.toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14),),

        ],
      ),
    );
  }
}
