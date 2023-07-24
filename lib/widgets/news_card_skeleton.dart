import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import '../customIcon/custom_icons.dart';
import '../pages/news_details_page.dart';
import '../utilities/constants.dart';
import '../utilities/responsive_height.dart';
// import 'package:flare_flutter/flare_actor.dart';
// import '../utilities/ad_helpers.dart';
// ignore: depend_on_referenced_packages
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class NewsCardSkeleton extends StatefulWidget {
  final String imageUrl, title, shortDescription, content, date, authorName;
  final String? avatarUrl, link;
  final int postId;
  final int? index;

  final List<int> categoryIdNumbers;
  const NewsCardSkeleton({
    Key? key,
    this.index,
    required this.postId,
    this.link,
    required this.imageUrl,
    required this.title,
    required this.shortDescription,
    required this.content,
    required this.date,
    required this.avatarUrl,
    required this.authorName,
    required this.categoryIdNumbers,
  }) : super(key: key);

  @override
  State<NewsCardSkeleton> createState() => _NewsCardSkeletonState();
}

class _NewsCardSkeletonState extends State<NewsCardSkeleton> {
  // BannerAd? _bannerAd;
  bool isSave = false;

  @override
  void initState() {
    super.initState();

    // BannerAd(
    //   adUnitId: AdHelper.bannerAdUnitId,
    //   request: const AdRequest(),
    //   size: AdSize.banner,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       if (kDebugMode) {
    //         print('Failed to load a banner ad: ${err.message}');
    //       }
    //       ad.dispose();
    //     },
    //   ),
    // ).load();
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = newscardDynamicScreen(screenHeight);
    // final postCategoryName = categoryMap!["${widget.categoryIdNumbers}"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // if (_bannerAd != null)
          //   Container(
          //     margin: const EdgeInsets.only(top: 8),
          //     width: double.infinity,
          //     height: 100,
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       // border: Border.all(color: Colors.redAccent),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(5.0),
          //       ),
          //     ),
          //     child: AdWidget(ad: _bannerAd!),
          //   ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsDetailsPage(
                            postId: widget.postId,
                            link: widget.link,
                            title: widget.title,
                            imageUrl: widget.imageUrl,
                            content: widget.content,
                            date: widget.date,
                            avatarUrl: widget.avatarUrl,
                            authorName: widget.authorName,
                            categoryIdNumbers: widget.categoryIdNumbers,
                            shortDescription: widget.shortDescription,
                          )));
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE1E1E1),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 115,
                      height: 100,
                      child: Hero(
                        tag: '${widget.imageUrl} ${widget.index}',
                        child: CachedNetworkImage(
                          // width: MediaQuery.of(context).size.width / 2.5,
                          // height: cardHeight,
                          imageUrl: widget.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const SpinKitCircle(
                              color: kSecondaryColor,
                              size: 50.0,
                            );
                          },
                          errorWidget: (context, url, error) => Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: cardHeight,
                            decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(5.0),

                                ),
                            child: Image.asset('assets/images/logo_full.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.8,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.clip,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.8,
                          height: 55,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: Text(
                            widget.shortDescription,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                color: kSecondaryColor,
                                size: screenWidth > 400 ? 15 : 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  fontSize: screenWidth > 400 ? 11 : 9,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                                child: VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                widget.authorName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth > 400 ? 10 : 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
