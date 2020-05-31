import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:uduria_connected_car/models/car_state.dart';
import 'package:uduria_connected_car/pages/speedometer_bloc.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

class MyHomePage extends StatelessWidget {
  // double _speed = 0; //int
  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);
  var stopwatch1 = new Stopwatch();
  var stopwatch2 = new Stopwatch();

  MyHomePage() : super() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Speedometer"),
        ),
        body: BlocBuilder<SpeedometerBloc, CarState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Current Speed',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        Text(
                          (() {
                            if (state != null)
                              return '${(state.position.speed * 3.6).round()}'; // * 3.6 OR * 100 /////////////////
                            else {
                              return 'Fetching..';
                            }
                          }()),
                          style: Theme.of(context).textTheme.display1,
                        ),
                        Text(
                          'kmh',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From 10 to 30',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          '${state.duration1}',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        Text(
                          'Seconds',
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From 30 to 10',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          '${state.duration2}',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        Text(
                          'Seconds',
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
