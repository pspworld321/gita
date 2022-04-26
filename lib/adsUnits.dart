import 'package:flutter/material.dart';
import 'package:gita/textReading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'global.dart';
import 'main.dart';

final bannerAdId = 'ca-app-pub-5704045408668888/9630020072';
final interAdId = 'ca-app-pub-5704045408668888/5499203371';
final bannerAdId2 =  "ca-app-pub-5704045408668888/8807583878";
class AdsUnits {

  static bool admobInit = false;
  static bool interAdLoaded = false;
  static bool gAdClicked = false;

  var myBanner1;
  var adWidget1;
  var myBanner2;
  var adWidget2;
  var interstitialAd;

  loadInterAd() {
    InterstitialAd.load(
        adUnitId: interAdId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this.interstitialAd = ad;
          interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) => print('%ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
            onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
          );

          AdsUnits.interAdLoaded = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        }));
  }

  showInterAd() {
    if (AdsUnits.admobInit && !AdsUnits.gAdClicked && AdsUnits.interAdLoaded) {
      interstitialAd.show();
      loadInterAd();
    }
  }

  loadBanner2() async {
    myBanner2 = myBannerAd2;
    adWidget2 = AdWidget(ad: myBanner2);
    await myBanner2.load();
    TextReadingState.adNotifier.value++;
  }

  loadBanner1() async {
    myBanner1 = myBannerAd1;
    adWidget1 = AdWidget(ad: myBanner1);
    await myBanner1.load();
    MyHomePageState.adNotifier.value++;
  }

  loadAds() async {
    try {
      MobileAds.instance.initialize().then((d) async {
        await loadBanner1();
        await loadInterAd();
        AdsUnits.admobInit = true;
      });
    } catch (e) {
      AdsUnits.admobInit = false;
    }
  }

  googleBannerAd() {
    return ValueListenableBuilder(
      valueListenable: MyHomePageState.adNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return AdsUnits.admobInit
            ? Container(
          alignment: Alignment.center,
          child: adWidget1,

          width: myBannerAd1.size.width.toDouble(),
          height: myBannerAd1.size.height.toDouble(),
        )
            : Container(
          width: 0,
          height: 0,
          // width: 300,
        );
      },
    );
  }

  googleBannerAd2() {
    return ValueListenableBuilder(
      valueListenable: TextReadingState.adNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return AdsUnits.admobInit
            ? Container(
          alignment: Alignment.center,
          child: adWidget2,

          width: myBannerAd2.size.width.toDouble(),
          height: myBannerAd2.size.height.toDouble(),
        )
            : Container(
          width: 0,
          height: 0,
          // width: 300,
        );
      },
    );
  }

  BannerAd myBannerAd1 = BannerAd(
    adUnitId: bannerAdId,
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(onAdFailedToLoad: (Ad, err) {
      print('Ad error.' + err.toString());
    },
      // onAdOpened: (Ad ad) {
      //   print('Ad opened.');
      //   AdsUnits.gAdClicked = true;
      //   Global.settings['gAdClickedTime'] = DateTime.now();
      //   Global.saveSettings();
      //   print(AdsUnits.gAdClicked);
      //   MyHomePageState.adNotifier.value++;
      // },
    ),
  );

  BannerAd myBannerAd2 = BannerAd(
    adUnitId: bannerAdId2,
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(onAdFailedToLoad: (Ad, err) {
      print('Ad error.' + err.toString());
    },
      // onAdOpened: (Ad ad) {
      //   print('Ad opened.');
      //   AdsUnits.gAdClicked = true;
      //   Global.settings['gAdClickedTime'] = DateTime.now();
      //   Global.saveSettings();
      //   print(AdsUnits.gAdClicked);
      //   MyHomePageState.adNotifier.value++;
      // },
    ),
  );

}