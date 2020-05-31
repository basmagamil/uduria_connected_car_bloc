import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uduria_connected_car/pages/speedometer_bloc.dart';
import 'package:uduria_connected_car/pages/speedometer_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedometer',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 36),
            display1: TextStyle(
                color: Colors.green, fontSize: 80, fontFamily: "Digital"),
            body2: TextStyle(fontSize: 28),
            display2: TextStyle(
                color: Colors.green, fontSize: 60, fontFamily: "Digital"),
          )),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        child: MyHomePage(),
        create: (BuildContext context) =>
            SpeedometerBloc(geolocator: new Geolocator())
              ..add(CarEventStarted()),
      ),
    );
  }
}
