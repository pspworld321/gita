import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gita/textReading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'adsUnits.dart';
import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path + '/hive/');
  //await ConvertData.convert();
  await Global.loadInitData();
  await MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhagvad Gita',
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  MyHomePageState();

  var ctx;

  static ValueNotifier adNotifier = ValueNotifier(0);
  AdsUnits adsUnits = AdsUnits();

  int allDataLength = 0;

  static var email = '';

  @override
  void initState() {
    super.initState();
    adsUnits.loadAds();
  }

  languageDialog() {
    showDialog(
        builder: (BuildContext cntxt) {
          return Dialog(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (String item in Global.language)
                  ListTile(
                    onTap: () {
                      Global.settings['language'] = item;
                      // print(Globle.settings);
                      Global.saveSettings();
                      Navigator.pop(cntxt);
                      setState(() {});
                    },
                    title: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        item.toString().capitalizeFirstofEach,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
              ],
            ),
          );
        },
        context: ctx);
  }

  menuDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return Dialog(
            insetPadding: EdgeInsets.fromLTRB(30, 50, 30, 30),
            child: ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Container(
                      color: Colors.deepOrangeAccent,
                      padding: EdgeInsets.fromLTRB(30, 25, 30, 20),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                      onPressed: null,
                                      child: Text(
                                        'Bhagvad Gita',
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ))))
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/randomBack/${Random().nextInt(12).toString()}.png',
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/smallIconGreen.png',
                        width: 25,
                        height: 25,
                      )),
                  title: Text(
                    'Veda',
                    style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    if (await DeviceApps.isAppInstalled('com.BlueStoneStudio.veda')) {
                      DeviceApps.openApp('com.BlueStoneStudio.veda');
                    } else {
                      launch('https://play.google.com/store/apps/details?id=com.BlueStoneStudio.veda');
                    }
                    Navigator.pop(cntxt);
                  },
                ),
                ListTile(
                  leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/smallIconBlue.png',
                        width: 25,
                        height: 25,
                      )),
                  title: Text(
                    'Upanishad',
                    style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    if (await DeviceApps.isAppInstalled('com.bhartiyadarshan.upanishad')) {
                      DeviceApps.openApp('com.bhartiyadarshan.upanishad');
                    } else {
                      launch('https://play.google.com/store/apps/details?id=com.bhartiyadarshan.upanishad');
                    }
                    Navigator.pop(cntxt);
                  },
                ),
                ListTile(
                  leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/smallIcon.png',
                        width: 25,
                        height: 25,
                      )),
                  title: Text(
                    'Ashtavakra Gita',
                    style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    if (await DeviceApps.isAppInstalled('com.bss.ashtavakra_gita')) {
                      DeviceApps.openApp('com.bss.ashtavakra_gita');
                    } else {
                      launch('https://play.google.com/store/apps/details?id=com.bss.ashtavakra_gita');
                    }
                    Navigator.pop(cntxt);
                  },
                ),
                // ListTile(
                //   leading: Padding(
                //       padding: EdgeInsets.fromLTRB(4, 5, 0, 0),
                //       child: Icon(
                //         Icons.add_to_drive,
                //         color: Colors.blue,
                //         size: 30,
                //       )),
                //   title: Text(
                //     'Wallpapers',
                //     style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                //   ),
                //   onTap: () async {
                //   },
                // ),
                ListTile(
                  leading: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(
                        Icons.star,
                        color: Colors.deepOrangeAccent,
                        size: 32,
                      )),
                  title: Text(
                    'Rate this App',
                    style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text('Help us Make it Better'),
                  onTap: () async {
                    Navigator.pop(cntxt);
                    launch("https://play.google.com/store/apps/details?id=com.bss.gita");
                  },
                ),
                ListTile(
                  leading: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(
                        Icons.share,
                        color: Colors.deepOrangeAccent,
                        size: 32,
                      )),
                  title: Text(
                    'Share this App',
                    style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    Navigator.pop(cntxt);
                    Share.share(
                        'Hey! Checkout this App.\nBhagvad Gita in three languages.\n\n'
                        'https://play.google.com/store/apps/details?id=com.bss.gita',
                        subject: 'Bhagvad Gita');
                  },
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ListTile(
                      leading: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Icon(
                            Icons.apps,
                            color: Colors.deepOrangeAccent,
                            size: 30,
                          )),
                      title: Text(
                        'More Apps',
                        style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      onTap: () async {
                        Navigator.pop(cntxt);
                        launch("https://play.google.com/store/apps/developer?id=Blue+Stone+Studio");
                      },
                    )),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.deepOrangeAccent, // navigation bar color
      statusBarColor: Colors.deepOrangeAccent, // status bar color
    ));
    return Scaffold(
        backgroundColor: Global.canvasColor(),
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.deepOrangeAccent,
          leading: TextButton(
              onPressed: () {
                menuDialog(context);
              },
              child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 0, 0),
                  child: Icon(
                    Icons.menu,
                    size: 25,
                    color: Colors.white,
                  ))),
          iconTheme: IconThemeData(color: Colors.white),
          //  elevation: 0,
          title: Text(
            'Bhagvad Gita',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  languageDialog();
                },
                icon: Icon(Icons.translate, color: Colors.white)),
            IconButton(
                onPressed: () {
                  if (Global.settings['theme'] == 'dark') {
                    Global.settings['theme'] = 'light';
                  } else {
                    Global.settings['theme'] = 'dark';
                  }
                  Global.saveSettings();
                  setState(() {});
                },
                icon:
                    Icon(Global.settings['theme'] == 'dark' ? Icons.wb_sunny : Icons.nights_stay, color: Colors.white))
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/treebranch_background.png',
                height: 100,
                width: 150,
                fit: BoxFit.fill,
              ),
            ),
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  Global.settings['theme'] == 'dark'
                      ? 'assets/images/yogi_background.png'
                      : 'assets/images/yogi_background2.png',
                  // height: 270,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    flex: 0,
                    child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: adsUnits.googleBannerAd())),
                Expanded(
                  flex: 1,
                  child: FutureBuilder(
                      future: Global.loadingGitaFromAssets(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map? indexMap = snapshot.data as Map?;
                          return Container(
                            child: ListView(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                              shrinkWrap: true,
                              children: [
                                for (int index = 0; index < indexMap!.length; index++)
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TextReading(indexMap.values.toList()[index]),
                                          )).then((value) {
                                        adsUnits.showInterAd();
                                      });
                                    },
                                    title: Text(indexMap.keys.toList()[index]['data'].toString().split('-')[0].trim(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Global.normalTextColor())),
                                    subtitle:
                                        Text(indexMap.keys.toList()[index]['data'].toString().split('-')[1].trim(),
                                            style: TextStyle(
                                                //fontSize: 20,
                                                // fontWeight: FontWeight.w600,
                                                color: Global.subTextColor())),
                                  )
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Column(
                              children: [Spacer(), CircularProgressIndicator(), Spacer()],
                            ),
                          );
                        }
                      }),
                ),
              ],
            )
          ],
        ));
  }
}
