import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:med_plus/data/static_variable.dart';

import '../module_common.dart';
import '../validator.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => new RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {

  final controller_login = TextEditingController();
  final controller_full_login = TextEditingController();
  final controller_mail = TextEditingController();
  final controller_password = TextEditingController();
  final controller_repassword = TextEditingController();

  //step = 0 - ввод ФИО и пароля, step = 1 ввод кода подтверждения/пароля
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("РЕГИСТРАЦИЯ"),
        ),
        body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Form(
              child: new ListView(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.all(30.0),
                    child: new Image.asset(
                      "assets/images/med_logo.png",
                      height: 100.0,
                    ),
                  ),
                    new TextFormField(
                      controller: controller_full_login,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          labelText: 'ФИО'
                      ),
                    ),
                    new TextFormField(
                      controller: controller_login,
                      maxLength: 16,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: 'Номер полиса'
                      ),
                      inputFormatters: [ValidatorInputFormatter(
                        editingValidator: DecimalNumberEditingRegexValidator(),
                      )],
                    ),
                    new TextFormField(
                      controller: controller_mail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                          labelText: 'Почта'
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      controller: controller_password,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        labelText: 'Пароль'
                      ),
                    ),
                  new TextFormField(
                    obscureText: true,
                    controller: controller_repassword,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        labelText: 'Повторите пароль'
                    ),
                  ),
                    new Container(
                      decoration:
                      new BoxDecoration(border: Border.all(color: Colors.black)),
                      child: new ListTile(
                        title: new Text(
                          "Зарегистрироваться",
                          textAlign: TextAlign.center,
                        ),
                        onTap: this.registration,
                      ),
                      margin: new EdgeInsets.only(
                          top: 20.0
                      ),
                    ),
                ],
              ),
            )
        )
    );
  }

  void registration() async{
    if (controller_password.text != controller_repassword.text){
      CreateshowDialog(context,new Text(
        "Поля пароля и подтверждения пароля не совпадают",
        style: new TextStyle(fontSize: 16.0),
      ));
      return;
    }
    if (controller_login.text.length == 0) {
      CreateshowDialog(context, new Text(
          "Полис не может быть пустым",
          style: new TextStyle(fontSize: 16.0)
      ));
      return;
    }
    LoadingStart(context);
    try {
      var response = await http.post('${ServerUrl}/registration/',
          headers: {
            'content-type': 'application/json'
          },
          body: '{"username":"${controller_login.text}","full_name":"${controller_full_login.text}","password":"${controller_password.text}","email":"${controller_mail.text}"}'
      );
      if (response.statusCode == 200) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        LoadingStop(context);
        Navigator.pop(context);
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
}


