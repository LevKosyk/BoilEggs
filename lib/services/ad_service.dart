import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:boil_eggs/lib/env/env.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  // Using Test IDs provided by Google
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Env.androidBannerAdUnitId; 
    } else if (Platform.isIOS) {
      return Env.iosBannerAdUnitId;
    }
    throw UnsupportedError("Unsupported platform");
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }
}
