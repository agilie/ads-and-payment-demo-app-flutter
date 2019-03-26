import 'package:firebase_admob/firebase_admob.dart';

const IMAGES_PATH = "assets/images/";

String getAssetImagePath(String fileName) {
  return "$IMAGES_PATH$fileName";
}

MobileAdTargetingInfo _defaultInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
  );

MobileAd _createDefaultBanner() {
  return BannerAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: _defaultInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
}

MobileAd _createInterstitialAd() {
  return InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: _defaultInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
    );
}

MobileAd getAds(AdType type) {
  switch (type) {
    case AdType.INTERSTITIAL:
      return _createInterstitialAd();
      break;
    case AdType.BANNER:
      return _createDefaultBanner();
      break;
  }

  return _createDefaultBanner();
}

enum AdType { BANNER, INTERSTITIAL }
