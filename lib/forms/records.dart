import 'dart:async';
import 'package:med_plus/data/static_variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';

class RecordsData {
  final String id, specialization, status, hospital, doctor, recording_at, title, description, json_check_data;
  final Icon icon;
  RecordsData({
    this.icon,
    this.id,
    this.specialization,
    this.status,
    this.hospital,
    this.doctor,
    this.recording_at,
    this.title,
    this.description,
    this.json_check_data
  });
  factory RecordsData.fromJson(Map<String, dynamic> jsonData) {
    return RecordsData(
      id: jsonData['id'].toString(),
      specialization: jsonData['specialization']['name'].toString(),
      hospital: jsonData['hospital']['name'].toString(),
      recording_at: jsonData['recording_at'].toString().replaceAll('T', ' ').replaceAll('Z', ''),
      icon: getIcon(jsonData['status'].toString()),
      status: jsonData['status'].toString(),
      doctor:  jsonData['doctor']['full_name'].toString(),
      title: jsonData['title'].toString(),
      description: jsonData['description'].toString(),
      json_check_data:  jsonData.toString(),
    );
  }
}

getIcon(String status){

  Icon return_icon;
  if(status == 'Открыта'){
    return_icon = new Icon(Icons.access_time,color: Colors.amber);
  }
  else if(status == 'Ждет оценку'){
    return_icon = new Icon(Icons.access_time,color: Colors.amber);
  }
  else if(status == 'Закрыта'){
    return_icon = new Icon(Icons.check,color: Colors.green);
  }
  else if(status == 'Отменена'){
    return_icon = new Icon(Icons.error,color: Colors.red);
  }
  else {
    return_icon = new Icon(Icons.error,color: Colors.red);
  }
  return return_icon;
}


class SecondScreen extends StatefulWidget {
  final RecordsData value;
  SecondScreen({Key key, this.value}) : super(key: key);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Детали')),
      body:  new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            child: new ListView(
              children: <Widget>[
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Запись №',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                ),
                Row(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Больница',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.hospital,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),

                Row(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Специализация',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.specialization,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),
                Row(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Доктор',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.doctor,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),
                Row(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Дата/время приема',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.recording_at,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),
                Column(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Тема',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.title,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),
                Column(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Описание',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.description,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),
                new Container(
                  decoration:
                  new BoxDecoration(border: Border.all(color: Colors.black)),
                  child: new ListTile(
                    title: new Text(
                      "Закрыть заявку и оценить прием",
                      textAlign: TextAlign.center,
                    ),
                    onTap: (){},
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

class CheckPage extends StatefulWidget {
  @override
  CheckPageState createState() {
    return new CheckPageState();
  }
}

class CheckPageState extends State<CheckPage> {

  List<RecordsData> check_data;

  Future<Null> refreshList() async {
    setState(() {
    });
    return null;
  }

  //Future is n object representing a delayed computation.
  Future<List<RecordsData>> downloadCheckData() async {
    final jsonEndpoint = '${ServerUrl}/records/';
    try {
      final response = await get(jsonEndpoint,headers: {
        'Authorization': 'Bearer ${UserUID}'
      });
      if (response.statusCode == 200) {
        List check_data = json.decode(response.body)['results'];
        print(check_data);
        if (check_data.length != 0) {
          return check_data
              .map((check_data) => new RecordsData.fromJson(check_data))
              .toList();
        }
        else
          throw 'Список пуст';
      } else
        throw 'Не удалось загрузить список';
    }catch(error){
      throw error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new RefreshIndicator(
        onRefresh: this.refreshList,
        child: new FutureBuilder<List<RecordsData>>(
        future: this.downloadCheckData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            check_data = snapshot.data;
            return ListView.builder(
              itemCount: check_data.length,
              itemBuilder: (context, int currentIndex)  => new Column(
                  children: <Widget>[
                    new Divider(
                      height: 10.0,
                    ),
                    this.CustomListViewTile(check_data[currentIndex])
                  ]
              ),
            );
          } else if (snapshot.hasError) {
            return new ListView(
              children: <Widget>[
                new Container(
                  child: Text('${snapshot.error}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.5,
                  alignment:  FractionalOffset.center,
                )
              ],
            );
          }
          return new CircularProgressIndicator();
        },
      ),),
    );
  }

  //ЭЛЕМЕНТ СПИСКА
  //////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  //Элемент списка
  CustomListViewTile(RecordsData check_data) {
    return new Card(
      child: new Column(children: <Widget>[
        new ListTile(
          leading: new Container(
            child: check_data.icon,
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                check_data.specialization,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new Text(
                check_data.recording_at,
                style: new TextStyle(color: Colors.grey, fontSize: 13.0),
              ),
            ],
          ),
          subtitle: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    check_data.status,
                    style: new TextStyle(color: Colors.grey, fontSize: 13.0),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    check_data.hospital,
                    style: new TextStyle(color: Colors.grey, fontSize: 13.0),
                  ),
                )
              ]
          ),
          onTap: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new SecondScreen(value: check_data),
            );

            Navigator.of(context).push(route);
          }
        )
      ]),
    );
  }
}
