import 'dart:io';
import 'dart:ui';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Global {
  static var settings = {};

  static loadInitData() async {
    var box = await Hive.openBox('settings');
    // await box.clear();
    settings = box.toMap();
    if (settings.isEmpty) {
      settings['language'] = language[0];
      Global.settings['translateLanguage'] = language[2];
      Global.settings['gTransLangCode'] = 'hi';
      settings['theme'] = 'light';
      settings['textFontSize'] = 18.0;
      settings['loadingVedaFromAssets'] = 'notDone';
      saveSettings();
    }
  }

  static loadingGitaFromAssets() async {
    if (settings['loadingGitaFromAssets'] == 'notDone' || settings['loadingGitaFromAssets'] == null) {
      for (String lang in language) {
        String data = await rootBundle.loadString('assets/gita/$lang.txt');
        List dataList = data.split('\n');
        List finalData = [];
        for (int i = 0; i < dataList.length; i++) {
          if (dataList[i].toString().contains('<title>')) {
            Map map = {'type': 'title', 'data': dataList[i].toString().replaceAll('<title>', '').trim()};
            finalData.add(map);
          } else {
            Map map = {'type': 'verse', 'data': dataList[i].toString().trim()};
            finalData.add(map);
          }
        }
        var box = await Hive.openBox('gita$lang');
        await box.clear();
        await box.addAll(finalData);
      }
      settings['loadingGitaFromAssets'] = 'done';
      saveSettings();
    }

    var boxG = await Hive.openBox('gita${settings['language']}');
    List dataList = boxG.values.toList();
    Map indexMap = {};
    //indexList.removeWhere((element) => element['type'] != 'title');

    for (int j = 0; j < dataList.length; j++) {
      if (dataList[j]['type'] == 'title') {
        indexMap[dataList[j]] = j;
      }
    }

    //print(indexMap);

    return indexMap;
  }

  static getDataDirectoryPath() async {
    if (Platform.isAndroid) {
      var directory = await getApplicationSupportDirectory();
      return directory.path;
    } else if (Platform.isWindows) {
      var directory = await getApplicationSupportDirectory();
      return directory.path;
    }
  }

  static saveSettings() async {
    var box = await Hive.openBox('settings');
    box.clear();
    box.putAll(settings);
   // print(settings);
  }

  static bookmarkColor() {
    if (settings['theme'] == 'dark') {
      return Colors.deepOrangeAccent;
    } else {
      return Colors.deepOrangeAccent;
    }
  }

  static canvasColor() {
    if (settings['theme'] == 'dark') {
      return Color.fromRGBO(45, 45, 45, 1.0);
    } else {
      return Color.fromRGBO(253, 253, 253, 1.0);
    }
  }

  static normalTextColor() {
    if (settings['theme'] == 'dark') {
      return Color.fromRGBO(245, 245, 245, 1.0);
    } else {
      return Colors.black87;
    }
  }

  static subTextColor(){
    if (settings['theme'] == 'dark') {
      return Color.fromRGBO(208, 208, 208, 1.0);
    } else {
      return Colors.black45;
    }
  }

  static List veda() {
    return languageTitleMap[settings['language']];
  }

  static List language = ['english', 'hindi', 'sanskrit'];

  static Map languageTitleMap = {
    'english': 'Bhagvad Gita',
    'hindi': 'श्रीमद्भगवद्‌गीता',
    'sanskrit': 'श्रीमद्भगवद्‌गीता'
  };

  static List listOfChakraImage = [
    'assets/images/AgyaChakra.png',
    'assets/images/VishudhhiChakra.png',
    'assets/images/HeartChakra.png',
    'assets/images/ManipurChakra.png',
    'assets/images/SacralChakra.png',
    'assets/images/RootChakra.png'
  ];

  static gTransWarningText() {
    Map text = {
      'hindi':
          'यह अनुवाद गूगल ट्रांसलेशन का उपयोग करता है, यह अनुवाद गलतियों और संदिग्धता से भरा हो सकता है, कृपया इसे गंभीरता से ना लें',
      'english':
          'This translation will be machine generated from google translation service.It may be confusing and erroneous. Please do not take it seriously... '
    };
    return text[settings['language']];
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}' : '';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}
