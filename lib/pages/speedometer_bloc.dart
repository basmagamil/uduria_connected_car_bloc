import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:uduria_connected_car/models/car_state.dart';

@immutable
abstract class CarEvent {}

class CarEventStarted extends CarEvent {}

class CarEventChanged extends CarEvent {
  final Position position;
  final int duration1;
  final int duration2;
  CarEventChanged({this.position, this.duration1, this.duration2});
}

class SpeedometerBloc extends Bloc<CarEvent, CarState> {
  StreamSubscription positionStream;
  final Geolocator geolocator;
  var timer;
  var stopwatch1 = new Stopwatch();
  var stopwatch2 = new Stopwatch();
  var _speed = 0.0;

  // int incrementSpeed(int value) {
  //   // return value;
  //   return (40 - value).abs();
  // }
  // void updateSpeed(Stream<int> stream) async {
  //   await for (var value in stream) {
  //     _speed = value;
  //     add(CarEventChanged(
  //         position: new Position(speed: _speed.toDouble()),
  //         duration1: state.duration1,
  //         duration2: state.duration2));
  //   }
  // }

  void startTimer() {
    timer = new Timer.periodic(new Duration(milliseconds: 1000), (Timer timer) {
      if (stopwatch1.isRunning) {
        add(CarEventChanged(
            duration1: (stopwatch1.elapsedMilliseconds * 0.001).round(),
            duration2: state.duration2,
            position: state.position));
      }
      if (stopwatch2.isRunning) {
        add(CarEventChanged(
            duration2: (stopwatch2.elapsedMilliseconds * 0.001).round(),
            duration1: state.duration1,
            position: state.position));
      }
    });
  }

  SpeedometerBloc({@required this.geolocator}) {
    // Stream<int> stream =
    //     Stream<int>.periodic(new Duration(milliseconds: 1000), incrementSpeed);
    // updateSpeed(stream);
  }

  @override
  CarState get initialState =>
      CarState(position: new Position(speed: 0), duration1: 0, duration2: 0);

  @override
  Stream<CarState> mapEventToState(CarEvent event) async* {
    if (event is CarEventStarted) {
      positionStream?.cancel();
      var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);
      positionStream = geolocator
          .getPositionStream(locationOptions)
          .listen((Position position) {
        // print('listen');
        startTimer();
        _speed = position.speed;
        add(CarEventChanged(position: position));
        if (_speed >= 10 && _speed <= 11 && !stopwatch1.isRunning) {
          stopwatch1.reset();
          stopwatch1.start();
        } else if ((_speed >= 30 || _speed <= 10) && stopwatch1.isRunning) {
          stopwatch1.stop();
        } else if (_speed <= 30 && _speed >= 29 && !stopwatch2.isRunning) {
          stopwatch2.reset();
          stopwatch2.start();
        } else if ((_speed <= 10 || _speed >= 30) && stopwatch2.isRunning) {
          stopwatch2.stop();
        }
      });
    } else if (event is CarEventChanged) {
      yield CarState(
          position: event.position ?? state.position,
          duration1: event.duration1 ?? state.duration1,
          duration2: event.duration2 ?? state.duration2);
    } else {
      yield state;
    }
  }

  @override
  Future<void> close() {
    positionStream?.cancel();
    return super.close();
  }
}
