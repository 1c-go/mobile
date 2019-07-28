import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:med_plus/data/static_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:med_plus/validator.dart';
import 'package:med_plus/module_common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

//Класс данных больницы
class Hospital {
  String id, name;
  Hospital({
    this.id,
    this.name,
  });
  factory Hospital.fromJson(Map<String, dynamic> jsonData) {
    return Hospital(
        id: jsonData['id'].toString(),
        name: jsonData['name'].toString()
    );
  }
}

//Класс данных специализации
class Specialization {
  String id, name;
  Specialization({
    this.id,
    this.name,
  });
  factory Specialization.fromJson(Map<String, dynamic> jsonData) {
    return Specialization(
        id: jsonData['id'].toString(),
        name: jsonData['name'].toString()
    );
  }
}
//Класс данных доктора
class Doctor {
  String id, name;
  Doctor({
    this.id,
    this.name,
  });
  factory Doctor.fromJson(Map<String, dynamic> jsonData) {
    return Doctor(
        id: jsonData['id'].toString(),
        name: jsonData['full_name'].toString()
    );
  }
}

//Форма ручного ввода
class ManualInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManualInputPageState();
}

class _ManualInputPageState extends State<ManualInputPage> {
  //Переменные сканера
  String result_scan = "";
  //переменные imagePicker
  String image_path = "";
  //Переменные даты аремени формы
  DateTime _date = DateTime.now();
  DateFormat formatter = new DateFormat('dd-MM-yyyy');
  DateFormat formatter_send = new DateFormat('yyyy-MM-ddTHH:mm');
  TimeOfDay _time = TimeOfDay.now();
  //Переменные формы
  final controller_date = TextEditingController();
  final controller_time = TextEditingController();
  final controller_hospital = TextEditingController();
  String hospital = "";
  final controller_specialization = TextEditingController();
  String specialization = "";
  final controller_doctor = TextEditingController();
  String doctor = "";
  final controller_title = TextEditingController();
  final controller_description = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller_hospital.text = 'Заполните значение';
    controller_specialization.text = 'Заполните значение';
    controller_doctor.text = 'Заполните значение';

  }

  //При выборе даты
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: _date, firstDate: new DateTime(2018), lastDate: new DateTime(2050));

    if(picked != null){
      setState(() {
        _date = picked;
        controller_date.text = formatter.format(_date);
      });
    }
  }

  //При выборе времени
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);

    if(picked != null){
      setState(() {
        _time = picked;
        controller_time.text = _time.format(context);
      });
    }
  }

  _validateRequiredField(String value, String Field) {
    if (value.isEmpty) {
      CreateshowDialog(context,new Text(
        'Поле "${Field}" не заполнено',
        style: new TextStyle(fontSize: 16.0),
      ));
      return true;
    }
    return false;
  }

  //Локальные функции
  NumberToString(int number){
    String numberstring =  number.toString();
    if (numberstring.length == 1){
      numberstring = '0' + numberstring;
    }
    return numberstring;
  }

  //отправка данных
  submit() async{
    //Обработки проверки заполнения форм
    if (_validateRequiredField(controller_date.text,'Дата')){
      return;
    };
    if (_validateRequiredField(controller_time.text,'Время')){
      return;
    };
    if (_validateRequiredField(controller_hospital.text,'Больница')){
      return;
    };
    if (_validateRequiredField(controller_specialization.text,'Специализация')){
      return;
    };
    if (_validateRequiredField(controller_doctor.text,'Доктор')){
      return;
    };
    if (_validateRequiredField(controller_title.text,'Тема')){
      return;
    };
    if (_validateRequiredField(controller_description.text,'Описание')){
      return;
    };
    //Методы отправки
    LoadingStart(context);
    try {
      DateTime formatter_datetime = new DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute);
      print(formatter_send.format(formatter_datetime));
      var response = await http.post('${ServerUrl}/records/',
          body: '{"hospital":"${hospital}","specialization":"${specialization}","doctor":"${doctor}","title":"${controller_title.text}","description":"${controller_description.text}","recording_at":"${formatter_send.format(formatter_datetime)}"}',
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${UserUID}'
          }
      );
      if (response.statusCode == 201) {
        LoadingStop(context);
        CreateshowDialog(context,new Text(
          "Данные успешно отправлены",
          style: new TextStyle(fontSize: 16.0),
        ));
        print('ok!');
      } else {
        LoadingStop(context);
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        CreateshowDialog(context,new Text(
          response.body,
          style: new TextStyle(fontSize: 16.0),
        ));
      }
    } catch (error) {
      LoadingStop(context);
      print(error.toString());
      CreateshowDialog(context,new Text(
        'Ошибка соединения с сервером',
        style: new TextStyle(fontSize: 16.0),
      ));
    };
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('РЕГИСТРАЦИЯ ЗАЯВКИ'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            child: new ListView(
              children: <Widget>[
                new InkWell(
                  onTap: this.hospitalOnClick,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Больница',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(controller_hospital.text,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                      )
                    ]
                  )
                ),
                new InkWell(
                    onTap: this.specializationOnClick,
                    child: Column(
                        children: <Widget>[
                          new Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Специализация',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                          ),
                          new Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(controller_specialization.text,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                          )
                        ]
                    )
                ),
                new InkWell(
                    onTap: this.doctorOnClick,
                    child: Column(
                        children: <Widget>[
                          new Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 0,left: 0), child: Text('Доктор',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                          ),
                          new Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 0,left: 0), child: Text(controller_doctor.text,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                          )
                        ]
                    )
                ),
                Row(
                    children: <Widget>[
                      Expanded(
                          child:new GestureDetector(
                              onTap: (){_selectDate(context);},
                              behavior: HitTestBehavior.opaque,
                              child: new TextFormField(
                                enabled: false,
                                controller: controller_date,
                                keyboardType: TextInputType.datetime,
                                decoration: new InputDecoration(
                                  labelText: 'Дата',
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child:new GestureDetector(
                              onTap: (){_selectTime(context);},
                              behavior: HitTestBehavior.opaque,
                              child: new TextFormField(
                                enabled: false,
                                controller: controller_time,
                                keyboardType: TextInputType.datetime,
                                decoration: new InputDecoration(
                                  labelText: 'Время',
                                ),
                              )
                          )
                      ),
                    ]
                ),
                new TextFormField(
                    controller: controller_title,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        labelText: 'Тема'
                    ),
                ),
                new TextFormField(
                  controller: controller_description,
                  maxLines: null,
                  maxLength: 1000,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      labelText: 'Описание'
                  ),
                ),
                new Container(
                  decoration:
                  new BoxDecoration(border: Border.all(color: Colors.black)),
                  child: new ListTile(
                    title: new Text(
                      "Отправить",
                      textAlign: TextAlign.center,
                    ),
                    onTap: this.submit,
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

  //при изменении больницы
  hospitalOnClick() async{
    LoadingStart(context);
    try {
      var response = await http.get('${ServerUrl}/hospitals/',
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${UserUID}'
          }
      );
      if (response.statusCode == 200) {
        LoadingStop(context);
        Hospital _selectedOption;

        List hospital_data_list = json.decode(response.body)['results'];
        List<Hospital> hospital_data = hospital_data_list
            .map((hospital_data_list) => new Hospital.fromJson(hospital_data_list))
            .toList();
        List<DropdownMenuItem<Hospital>> _options = [];
        for (var hospital in hospital_data) {
          _options.add(new DropdownMenuItem<Hospital>(
            value: hospital,
            child: new Text(hospital.name),
          ));
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new SimpleDialog(
              title: new Text('Выбор больницы'),
              children: <Widget>[
                new SimpleDialogOption(
                  child: new Center(
                    child: new DropdownButton<Hospital>(
                        hint: new Text("Выберите значение"),
                        value: _selectedOption,
                        items: _options,
                        onChanged: (newVal) {
                          saveHospital(newVal);
                          ;
                        }
                    ),
                  ),
                ),
              ],
            );
          }
        );
      } else {
        LoadingStop(context);
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        CreateshowDialog(context,new Text(
          response.body,
          style: new TextStyle(fontSize: 16.0),
        ));
      }
    } catch (error) {
      LoadingStop(context);
      print(error.toString());
      CreateshowDialog(context,new Text(
        'Ошибка соединения с сервером',
        style: new TextStyle(fontSize: 16.0),
      ));
    };
  }

  saveHospital(Hospital newVal) async{
    Navigator.of(context).pop();
    setState(() {
      hospital = newVal.id;
      controller_hospital.text = newVal.name;
    });
  }
  //при изменении специализация
  specializationOnClick() async{
    LoadingStart(context);
    String full_url = '${ServerUrl}/specializations/';
    if(hospital!=""){
      full_url = full_url + '?hospital=${hospital}';
    }
    try {
      var response = await http.get(full_url,
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${UserUID}'
          }
      );
      if (response.statusCode == 200) {
        LoadingStop(context);
        Specialization _selectedOption;

        List hospital_data_list = json.decode(response.body)['results'];
        List<Specialization> hospital_data = hospital_data_list
            .map((hospital_data_list) => new Specialization.fromJson(hospital_data_list))
            .toList();
        List<DropdownMenuItem<Specialization>> _options = [];
        for (var hospital in hospital_data) {
          _options.add(new DropdownMenuItem<Specialization>(
            value: hospital,
            child: new Text(hospital.name),
          ));
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new SimpleDialog(
                title: new Text('Выбор специализации'),
                children: <Widget>[
                  new SimpleDialogOption(
                    child: new Center(
                      child: new DropdownButton<Specialization>(
                          hint: new Text("Выберите значение"),
                          value: _selectedOption,
                          items: _options,
                          onChanged: (newVal) {
                            saveSpecialization(newVal);
                            ;
                          }
                      ),
                    ),
                  ),
                ],
              );
            }
        );
      } else {
        LoadingStop(context);
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        CreateshowDialog(context,new Text(
          response.body,
          style: new TextStyle(fontSize: 16.0),
        ));
      }
    } catch (error) {
      LoadingStop(context);
      print(error.toString());
      CreateshowDialog(context,new Text(
        'Ошибка соединения с сервером',
        style: new TextStyle(fontSize: 16.0),
      ));
    };
  }

  saveSpecialization(Specialization newVal) async{
    Navigator.of(context).pop();
    setState(() {
      specialization = newVal.id;
      controller_specialization.text = newVal.name;
    });
  }

  //при изменении доктора
  doctorOnClick() async{
    LoadingStart(context);
    String full_url = '${ServerUrl}/doctors/';
    if(hospital!=""){
      full_url = full_url + '?specialization=${specialization}';
    }
    try {
      var response = await http.get(full_url,
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${UserUID}'
          }
      );
      if (response.statusCode == 200) {
        LoadingStop(context);
        Doctor _selectedOption;

        List hospital_data_list = json.decode(response.body)['results'];
        List<Doctor> hospital_data = hospital_data_list
            .map((hospital_data_list) => new Doctor.fromJson(hospital_data_list))
            .toList();
        List<DropdownMenuItem<Doctor>> _options = [];
        for (var hospital in hospital_data) {
          _options.add(new DropdownMenuItem<Doctor>(
            value: hospital,
            child: new Text(hospital.name),
          ));
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new SimpleDialog(
                title: new Text('Выбор доктора'),
                children: <Widget>[
                  new SimpleDialogOption(
                    child: new Center(
                      child: new DropdownButton<Doctor>(
                          hint: new Text("Выберите значение"),
                          value: _selectedOption,
                          items: _options,
                          onChanged: (newVal) {
                            saveDoctor(newVal);
                            ;
                          }
                      ),
                    ),
                  ),
                ],
              );
            }
        );
      } else {
        LoadingStop(context);
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        CreateshowDialog(context,new Text(
          response.body,
          style: new TextStyle(fontSize: 16.0),
        ));
      }
    } catch (error) {
      LoadingStop(context);
      print(error.toString());
      CreateshowDialog(context,new Text(
        'Ошибка соединения с сервером',
        style: new TextStyle(fontSize: 16.0),
      ));
    };
  }

  saveDoctor(Doctor newVal) async{
    Navigator.of(context).pop();
    setState(() {
      doctor = newVal.id;
      controller_doctor.text = newVal.name;
    });
  }
}