import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_dart;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'functions.dart';
import 'main.dart';


extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
}

class ThemeColor{
  late Color themeColorMain;
  late Color themeColorBG;
  late Color textColorAppBar;
  late Color textColorMain;

  ThemeColor({required this.themeColorMain, this.themeColorBG = Colors.white, this.textColorMain = Colors.black, this.textColorAppBar = Colors.white}){
    loadFromPreferences();
  }
  
  factory ThemeColor.fromMap(Map<String, dynamic> json) => ThemeColor(
    themeColorMain: json['themeColorMain'],
  );

  Future<void> loadFromPreferences()async{
    final prefs = await SharedPreferences.getInstance();
    themeColorMain = changeAppBarColor(prefs.getInt('themeColorMain') ?? 2);
  }

  Map<String, dynamic> toMap(){
    return{ 
      'themeColorMain': themeColorMain,
    };
  }
}

class Plant{
  late String family;
  late String slovakFirstName;
  late String slovakLastName;
  late String path;
  String wikipediaLink;
  bool enabled = false;
  Plant(this.family, this.slovakFirstName, this.slovakLastName, this.path, {this.wikipediaLink = 'https://www.google.com'});

  Future<void> setToPreferences()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$slovakFirstName $slovakLastName', enabled);
  }

  Future<void> loadFromPreferences()async{
    final prefs = await SharedPreferences.getInstance();
    enabled = (prefs.getBool('$slovakFirstName $slovakLastName') ?? true);
    if(enabled == true){
      print('a');
    }
  }

}

class StopWatch extends Stopwatch{
  int _starterMilliseconds = 0;

  StopWatch();

  get elapsedDuration{
    return Duration(
      microseconds: 
      elapsedMicroseconds + (_starterMilliseconds * 1000)
    );
  }

  get elapsedMillis{
    return elapsedMilliseconds + _starterMilliseconds;
  }

  get elapsedSecond{
    return ((elapsedMilliseconds + _starterMilliseconds)/1000).floor();
  }

  get elapsedMinutes{
    return ((elapsedMilliseconds + _starterMilliseconds)/60000).floor();
  }

  get elapsedHours{
    return ((elapsedMilliseconds + _starterMilliseconds)/3600000).floor();
  }

  set milliseconds(int timeInMilliseconds){
    _starterMilliseconds = timeInMilliseconds;
  }

}

class GameScore{
  int correct;
  int wrong;
  int hints;
  String time;
  String date;
  String stopWatch;
  String wrongAnswersList;
  GameScore({required this.correct, required this.wrong, required this.hints, required this.time, required this.date, required this.stopWatch, required this.wrongAnswersList});

  factory GameScore.fromMap(Map<String, dynamic> json) => GameScore(
    correct: json['correct'],
    wrong: json['wrong'],
    hints: json['hints'],
    time: json['time'],
    date: json['date'],
    stopWatch: json['stopWatch'],
    wrongAnswersList: json['wrongAnswersList'],
  );

  Map<String, dynamic> toMap(){
    return{
      'correct': correct, 
      'wrong': wrong,
      'hints': hints,
      'time': time,
      'date': date,
      'stopWatch': stopWatch,
      'wrongAnswersList': wrongAnswersList,
    };
  }
}

