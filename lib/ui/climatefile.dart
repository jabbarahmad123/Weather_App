import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/apifile.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class climate extends StatefulWidget {
  @override
  _climateState createState() => _climateState();
}

class _climateState extends State<climate> {
  void showstuff() async {
    Map data = await getweather(util.apiId, util.defaultcity);
    print(data.toString());
  }

  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      //change to Map instead of dynamic for this to work
      return new ChangeCityName();
    }));

    if (results != null && results.containsKey('enter')) {
      setState(() {
        _cityEntered = results['enter'];
      });
      // debugPrint("From First screen" + results['enter'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WEATHER APP'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage('images/umbrella.png'),
              height: 1200,
              width: 600,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              '${_cityEntered == null ? util.defaultcity : _cityEntered}',
              style: citystyle(),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('images/light_rain.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20.0, 390.0, 0.0, 0.0),
            child: updatetemp(
                '${_cityEntered == null ? util.defaultcity : _cityEntered}'),
          ),
        ],
      ),
    );
  }

  Future<Map> getweather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.apiId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updatetemp(String city) {
    return FutureBuilder(
        future: getweather(util.apiId, city == null ? util.defaultcity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() + " F",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Max: ${content['main']['temp_max'].toString()} F\n"
                        "Min: ${content['main']['temp_min'].toString()} F\n"
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                        "Wind Speed: ${content['wind']['speed'].toString()} \n"
                        "Pressure: ${content['main']['pressure'].toString()}\n"
                        "Clouds: ${content['clouds']['all'].toString()} \n"
                        "Country: ${content['sys']['country'].toString()} ",
                        style: extraData(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class ChangeCityName extends StatelessWidget {
  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Enter City'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          //TODO Image
          Center(
            child: new Image.asset(
              'images/city_background.jpg',
              height: 700,
              width: 400,
              fit: BoxFit.fill,
            ),
          ),
          //TODO Text Field and Button
          ListView(
            children: [
              ListTile(
                title: TextField(
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                    // 'enter' is a key
                  },
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  child: Text('Get Weather'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle citystyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempstyle() {
  return TextStyle(
      color: Colors.red, fontSize: 50.0, fontStyle: FontStyle.normal);
}

TextStyle extraData() {
  return TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontSize: 17.0,
  );
}
