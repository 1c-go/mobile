import 'dart:async';
import 'package:med_plus/data/static_variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordsData {
  final String id, specialization, status, hospital, doctor, recording_at, title, description;
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
    this.description
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
      description: jsonData['description'].toString()
    );
  }
}

class QuestionsData {
  final String id, question;
  int answer;
  QuestionsData({
    this.id,
    this.answer,
    this.question
  });
  factory QuestionsData.fromJson(Map<String, dynamic> jsonData) {
    return QuestionsData(
      id: jsonData['id'].toString(),
      answer: 0,
      question: jsonData['question'].toString(),
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


class RecordScreen extends StatefulWidget {
  final RecordsData value;
  RecordScreen({Key key, this.value}) : super(key: key);
  @override
  RecordScreenState createState() => RecordScreenState();
}

class RecordScreenState extends State<RecordScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('ДЕТАЛИ')),
      body:  new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            child: new ListView(
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 0,top: 10,right: 0,left: 0
                      ),
                      child: Text(
                          'Запись №${widget.value.id}',style: TextStyle(fontSize: 24),textAlign: TextAlign.left
                      ),
                    )
                  )
                ),
                Column(
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

                Column(
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
                Column(
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
                Column(
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
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(widget.value.description, maxLines: null, style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                ),
                new Container(
                  decoration:
                  new BoxDecoration(border: Border.all(color: Colors.black)),
                  child: new ListTile(
                    enabled: widget.value.status == 'Ожидает оценки',
                    title: new Text(
                      "Закрыть заявку и оценить прием",
                      textAlign: TextAlign.center,
                    ),
                    onTap: this.closeRecord,
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

  closeRecord() async {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
      new QuestionsScreen(value: widget.value),
    );

    Navigator.of(context).push(route);
  }
}

class QuestionsScreen extends StatefulWidget {
  final RecordsData value;
  QuestionsScreen({Key key, this.value}) : super(key: key);
  @override
  QuestionsScreenState createState() => QuestionsScreenState();
}

class QuestionsScreenState extends State<QuestionsScreen> {

  List<QuestionsData> questions_data;
  int answers_length = 0;

  //Future is n object representing a delayed computation.
  Future<List<QuestionsData>> downloadQuestionData() async {
    if (questions_data != null && questions_data.length > 0){
      return questions_data;
    }
    final jsonEndpoint = '${ServerUrl}/records/${widget.value.id}/questions/';
    try {
      final response = await http.get(jsonEndpoint,headers: {
        'Authorization': 'Bearer ${UserUID}'
      });
      print(jsonEndpoint);
      if (response.statusCode == 200) {
        List questions_data = json.decode(response.body);
        print(questions_data);
        if (questions_data.length != 0) {
          return questions_data
              .map((check_data) => new QuestionsData.fromJson(check_data))
              .toList();
        }
        else
          throw 'Список вопросов пуст';
      } else
        throw 'Не удалось загрузить вопросы';
    }catch(error){
      throw error.toString();
    }
  }

  submitAnswer() async{
    final jsonEndpoint = '${ServerUrl}/records/${widget.value.id}/answer/';
    List<String> body_list = new List();
    for (var questions in questions_data) {
      var answer = null;
      if (questions.answer == 1){
        answer = true;
      }else{
        answer = false;
      }
      String ell = '{"question":"${questions.id}","answer":${answer.toString()}}';
      body_list.add(ell);
    }
    print(body_list.toString());
    try {
      final response = await http.post(
        jsonEndpoint,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${UserUID}'
        },
        body: body_list.toString()
      );
      print(jsonEndpoint);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
      } else
        throw 'Не удалось загрузить вопросы';
    }catch(error){
      throw error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('ВОПРОСЫ')),
      body:  new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            child: new ListView(

              children: <Widget>[
                new Center(
                child: new FutureBuilder<List<QuestionsData>>(
                  future: this.downloadQuestionData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      questions_data = snapshot.data;
                      return Container(height: MediaQuery.of(context).size.height*0.69,
                        child: ListView.builder(
                        itemCount: questions_data.length,
                        itemBuilder: (context, int currentIndex)  => new Column(
                            children: <Widget>[
                              new Divider(
                                height: 10.0,
                              ),
                              this.CustomListViewTile(questions_data[currentIndex])
                            ]
                        ),
                      ),);
                    } else if (snapshot.hasError) {
                      return Padding(padding: EdgeInsets.fromLTRB(10, (MediaQuery.of(context).size.height*0.69)/2, 10, (MediaQuery.of(context).size.height-180)/2), child: Text('${snapshot.error}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.left,),);
                    }
                    return Container(alignment: FractionalOffset.center,
                        height: MediaQuery.of(context).size.height*0.690,
                        child:
                        new CircularProgressIndicator());
                  },
                ),
                ),

                new Container(
                  decoration:
                  new BoxDecoration(border: Border.all(color: Colors.black)),
                  child: new ListTile(
                    enabled: questions_data.length == answers_length,
                    title: new Text(
                      "Отправить",
                      textAlign: TextAlign.center,
                    ),
                    onTap: this.submitAnswer,
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

  //ЭЛЕМЕНТ СПИСКА
  //////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  //Элемент списка
  CustomListViewTile(QuestionsData question_data) {

    void _handleRadioValueChange(int value) {
      setState(() {
        if(question_data.answer != 0){
          answers_length = answers_length - 1;
        }
        question_data.answer = value;});
    }

    return new Card(
      child: new Column(children: <Widget>[
        new ListTile(
            title: new Text(
                  question_data.question,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
            subtitle: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text('Да'),
                  new Radio(
                    value: 1,
                    groupValue: question_data.answer,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text('Нет'),
                  new Radio(
                    value: 2,
                    groupValue: question_data.answer,
                    onChanged: _handleRadioValueChange,
                  ),
                ]
            ),
        )
      ]),
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

  List<RecordsData> records_data;

  Future<Null> refreshList() async {
    setState(() {
    });
    return null;
  }

  //Future is n object representing a delayed computation.
  Future<List<RecordsData>> downloadCheckData() async {
    final jsonEndpoint = '${ServerUrl}/records/';
    try {
      final response = await http.get(jsonEndpoint,headers: {
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
            records_data = snapshot.data;
            return ListView.builder(
              itemCount: records_data.length,
              itemBuilder: (context, int currentIndex)  => new Column(
                  children: <Widget>[
                    new Divider(
                      height: 10.0,
                    ),
                    this.CustomListViewTile(records_data[currentIndex])
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
  CustomListViewTile(RecordsData records_data) {
    return new Card(
      child: new Column(children: <Widget>[
        new ListTile(
          leading: new Container(
            child: records_data.icon,
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                records_data.specialization,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new Text(
                records_data.recording_at,
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
                    records_data.status,
                    style: new TextStyle(color: Colors.grey, fontSize: 13.0),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    records_data.hospital,
                    style: new TextStyle(color: Colors.grey, fontSize: 13.0),
                  ),
                )
              ]
          ),
          onTap: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new RecordScreen(value: records_data),
            );

            Navigator.of(context).push(route);
          }
        )
      ]),
    );
  }
}
