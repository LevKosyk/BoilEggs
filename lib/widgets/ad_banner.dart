import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:boil_eggs/services/ad_service.dart';
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}
class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _loadAd();
  }
  void _loadAd() {
    _bannerAd = AdService().createBannerAd()
      ..load().then((_) {
        if (mounted) {
          setState(() {
             _isLoaded = true;
          });
        }
      }).catchError((e) {
         debugPrint("Ad failed to load: $e");
      });
  }
  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
             margin: const EdgeInsets.only(top: 8, bottom: 4),
             width: 40,
             height: 4,
             decoration: BoxDecoration(
               color: Colors.grey.withValues(alpha: 0.1),
               borderRadius: BorderRadius.circular(2),
             )
          ),
          Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
