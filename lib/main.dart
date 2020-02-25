import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:http/http.dart' as http;
import 'package:msapps/Movies.dart';
import 'package:msapps/scanView.dart';
import 'DatabaseHelper.dart';
import 'detail.dart';

void main() => runApp(MyAppPre());

class MyAppPre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MSApps",
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
List<Movies> list;
class _MyAppState extends State<MyApp> {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();

  @override
  Future<void> initState() {
    super.initState();
    loadMovies();
  }

  loadMovies()  {
    SQLiteDbProvider.db.getAllProducts().then((value) async {
      if(value.length == 0){
        String link = "https://api.androidhive.info/json/movies.json";
        var res = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        if (res.statusCode == 200) {
          Movies movies;
          try {
            var data = jsonDecode(res.body);
            list = new List<Movies>();
            setState(() {
              for (int i=0;i<data.length;i++){
                movies = new Movies(data[i]["title"], data[i]["image"], data[i]["rating"].toDouble(), data[i]["releaseYear"]);
                list.add(movies);
              }
            });

            for(int i=0;i<list.length;i++){
              print(list[i]);
              SQLiteDbProvider.db.insert(list[i]);
            }

          } catch (e) {
            print(e.toString());
          }
        }
      } else {
        setState(() {
          list = value;
          for(int i=0;i<list.length;i++){
            print(list[i].id);
          }
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    String scannedText = "";
    return Scaffold(
          appBar: AppBar(
            title: const Text('MSApps'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.library_add,color: Colors.yellowAccent,),
                onPressed: () {
                  scannedText = "";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ScanView()));
                },
              ),
            ],
          ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text('MSApps',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                    accountEmail: Text('info@msapps.mobi',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/originals/e6/96/13/e69613dd64ed3f31196bbf9be32eae57.png'),
                      radius: 50.0,
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://msapps.mobi/wp-content/uploads/2018/01/Depositphotos_70654223_l-2015.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  ListTile(
                    title: Text("Settings"),
                    trailing: Icon(Icons.settings, color: Colors.grey),
                  ),
                  ListTile(
                    title: Text("About Us"),
                    trailing: Icon(
                      Icons.info,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            body: list == null? CircularProgressIndicator() : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(list[index].image),
                  title: Text(list[index].title),
                  subtitle: Text('ReleaseYear: '+list[index].releaseYear.toString()),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Detail(index)));
                    print('index: '+ index.toString()+list[index].id.toString());
                  },
                );
              },
            ));
  }
}
