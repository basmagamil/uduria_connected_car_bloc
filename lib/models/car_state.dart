import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class CarState {
  final Position position;
  final int duration1;
  final int duration2;

  CarState({this.position, this.duration1, this.duration2});
}
