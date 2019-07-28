import 'package:flutter/material.dart';
import 'package:med_plus/forms/login.dart';
import 'package:med_plus/forms/manual_input.dart';
import 'package:med_plus/forms/records.dart';
import 'package:med_plus/forms/account.dart';

class ActivityPage extends StatefulWidget {
  @override
  ActivityPageState createState() {
    return new ActivityPageState();
  }
}

class ActivityPageState extends State<ActivityPage>  with SingleTickerProviderStateMixin {
  //Переменные
  TabController _tabController;
  String appbar_text = "ЗАЯВКИ";

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 1);
  }

  //Открытие формы по кнопке добавления
  OpenForm(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ManualInputPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbar_text),
      ),
      drawer: new Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  new DrawerHeader(
                    child: new Image.asset(
                      "assets/images/med_logo.png",
                      height: 100.0,
                    ),
                  ),
                  new ListTile(
                    selected: _tabController.index == 0,
                    leading: new Icon(Icons.check_box),
                    title: new Text('ЗАЯВКИ'),
                    onTap: () {
                      if(_tabController.index != 1) {
                        Navigator.of(context).pop();
                        setState(() {
                          _tabController.index = 1;
                          appbar_text = 'ЗАЯВКИ';
                        });
                      }
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.account_circle),
                    title: new Text('УЧЕТНАЯ ЗАПИСЬ'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountPage()));
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.info),
                    title: new Text('ПОМОШЬ'),
                    onTap: () {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.info),
                    title: new Text('О ПРОГРАММЕ'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      new ListTile(
                        leading: new Icon(Icons.exit_to_app),
                        title: new Text('ВЫХОД'),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new LoginPage()
                            ),
                              (Route<dynamic> route) => false
                          );
                        },
                      )
                    ],
                  )
                )
              )
            )
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new CheckPage(),
        ],
      ),
      floatingActionButton:
      FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: this.OpenForm,
      ),
    );
  }
}
