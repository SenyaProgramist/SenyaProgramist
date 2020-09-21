import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';
import 'dart:io';

class Ads {
 static String getAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6406870136058423~1887555641';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6406870136058423~4469566501';
    }
    return null;
  }

  RewardedVideoAd videoAd = RewardedVideoAd.instance;

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'english',
      'learn english'
    ], // Android emulators are considered test devices
  );
  bool isLoaded = false;
  void showAdd() async {
    await videoAd.show();
  }

  void loadAdd() {
    videoAd
        .load(adUnitId: getVideoAddUnitId(), targetingInfo: targetingInfo)
        .then((e) {
      print('isLoadedInfunction');
    });
  }

  void attachListener() {
    videoAd.listener = (RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) async {
      print(event);
//      if (event == RewardedVideoAdEvent.loaded) {
//        showVideoAdd(context);
//      } else
      if (event == RewardedVideoAdEvent.rewarded) {
      } else if (event == RewardedVideoAdEvent.loaded) {
        print('isLoaded in listener');
        isLoaded = true;
      } else if (event == RewardedVideoAdEvent.closed) {
//      if (videoAdWasRewarded) {
//        videoAdWatched();
//      }
//      videoAdWasRewarded = false;
//      videoAdIsLoaded = false;
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
//      print('FAILED TO LOAAD');
//      if (pr.isShowing()) {
//        await pr.hide();
//      }
//
//      await provider.vibrate(4);
//      Future.delayed(Duration(milliseconds: 300), () {
//        videoAdWatched();
//      });
      }
    };
  }

  static String getVideoAddUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6406870136058423/5172194530';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6406870136058423/5435982056';
    }
    return null;
  }

  void initialize() {
    FirebaseAdMob.instance
        .initialize(appId: getAppId(), analyticsEnabled: true);
  }
}
