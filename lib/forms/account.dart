import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:med_plus/data/static_variable.dart';

//Класс данных акаунта
class AccountData {
  String ref, full_name, pol, snils, car_uid, car;
  AccountData({
    this.ref,
    this.full_name,
    this.pol,
    this.snils,
    this.car_uid,
    this.car,
  });
  factory AccountData.fromJson(Map<String, dynamic> jsonData) {
    return AccountData(
      ref: jsonData['Ref'],
      full_name: jsonData['Description'],
      pol: jsonData['Пол'],
      snils: jsonData['СНИЛС'],
      car_uid: jsonData['ОсновнойАвтомобиль'],
      car: jsonData['ОсновнойАвтомобильПредставление']
    );
  }
}

//Класс данных автомобилей
class CarData {
  String car_uid, car;
  CarData({
    this.car_uid,
    this.car,
  });
  factory CarData.fromJson(Map<String, dynamic> jsonData) {
    return CarData(
        car_uid: jsonData['Ref_Key'],
        car: jsonData['Description']
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => new AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  AccountData account_data;
  List<CarData> car_data;
  bool updated = true;  //флаг обновления

  @override
  void dispose() {
    saveParam();
    super.dispose();
  }

  //Процедура сохранения параметров
  saveParam() async{
    try {
      var response = await http.post('${ServerUrl}/hs/mobilecheckcheck/account',
          body: '{"individual":"${account_data.ref}","car":"${account_data.car_uid}"}',
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Basic YXBpOmFwaQ=='
          }
      );
      if (response.statusCode == 200) {
        print('ok');

      } else {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print(error.toString());
    };
  }

  //Получение данных аккаунта и списка доступных автомобилей
  Future<AccountData> getAccount() async {
    if (!updated){
      return account_data;
    };
    final jsonEndpoint_account = '${ServerUrl}/hs/mobilecheckcheck/account?user=${UserUID}';
    try {
      final response = await http.get(jsonEndpoint_account,headers: {
        'Authorization': 'Basic YXBpOmFwaQ=='
      });
      if (response.statusCode == 200) {
        var account_data = new AccountData.fromJson(json.decode(response.body)['#value']);
        final jsonEndpoint_car = '${ServerUrl}/odata/standard.odata/Catalog_%D0%90%D0%B2%D1%82%D0%BE%D0%BC%D0%BE%D0%B1%D0%B8%D0%BB%D0%B8?%24format=json&%24filter= cast(Owner_Key, %27Catalog__ДемоФизическиеЛица%27) eq guid%27${account_data.ref}%27';
        try {
          final response = await http.get(jsonEndpoint_car,headers: {
            'Authorization': 'Basic YXBpOmFwaQ=='
          });
          if (response.statusCode == 200) {
            List car_data_list = json.decode(response.body)['value'];
            car_data = car_data_list
                .map((car_data_list) => new CarData.fromJson(car_data_list))
                .toList();
            updated = false;
            return account_data;
          } else
            throw 'Не удалось загрузить список автомобилей';
        }catch(error){
          throw error.toString();
        }
      } else{
        print(response.body);
        throw 'Не удалось загрузить данные аккаунта';
      };
    }catch(error){
      throw error.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("УЧЕТНАЯ ЗАПИСЬ"),
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height-80,
        child: new FutureBuilder<AccountData>(
          future: getAccount(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              account_data = snapshot.data;
              if(account_data.car.isEmpty){
                account_data.car = 'Отсутствует';
              };
              return new ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  new Card(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.all(15), child: Text("ИНФОРМАЦИЯ",style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),textAlign: TextAlign.left), )
                        ),

                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 15,left: 15), child: Text('ФИО',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 15,left: 15), child: Text(account_data.full_name,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                        ),

                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 15,left: 15), child: Text('Пол',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 15,left: 15), child: Text(account_data.pol,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                        ),

                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 15,left: 15), child: Text('СНИЛС',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 15,left: 15), child: Text(account_data.snils,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                        ),
                      ],
                    ),
                  ),
                  new Card(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding: EdgeInsets.all(15), child: Text("ОСНОВНЫЕ ЗНАЧЕНИЯ",style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),textAlign: TextAlign.left), )
                        ),
                        new InkWell(
                          onTap: this.carOnClick,
                          child: Column(
                            children: <Widget>[
                              new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(padding: EdgeInsets.only(bottom: 0,top: 10,right: 15,left: 15), child: Text('Автомобиль',style: TextStyle(fontSize: 16),textAlign: TextAlign.left), )
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(padding: EdgeInsets.only(bottom: 10,top: 0,right: 15,left: 15), child: Text(account_data.car,style: TextStyle(fontSize: 14, color: Colors.grey,),textAlign: TextAlign.left), )
                              )
                            ]
                          )
                        )
                      ]
                    )
                  ),
                ]
              );
            } else if (snapshot.hasError) {
              return Container(alignment: FractionalOffset.center,
                  child:
                  Text('${snapshot.error}'));
            }
            return Container(alignment: FractionalOffset.center,
                child:
                new CircularProgressIndicator());
          },
        ),
      )
    );
  }

  //при изменении автомобиля
  carOnClick() async{
    CarData _selectedOption;

    List<DropdownMenuItem<CarData>> _options = [];
    for (var car in car_data) {
      _options.add(new DropdownMenuItem<CarData>(
        value: car,
        child: new Text(car.car),
      ));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('Выбор автомобиля'),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Center(
                child: new DropdownButton<CarData>(
                  hint: new Text("Выберите значение"),
                  value: _selectedOption,
                  items: _options,
                  onChanged: (newVal) {
                    saveCar(newVal);
                    ;
                  }
                ),
              ),
            ),
          ],
        );
      });
  }

  saveCar(CarData newVal) async{
    Navigator.of(context).pop();
    setState(() {
      account_data.car_uid = newVal.car_uid;
      account_data.car = newVal.car;
    });
  }
}


