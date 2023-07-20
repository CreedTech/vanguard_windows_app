import 'package:vanguard/pages/explore_page.dart';
import 'package:vanguard/pages/notification_page.dart';
import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart'
    show PageTransitionSwitcher, FadeThroughTransition;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vanguard/utilities/config.dart';

import 'hiveDB/db_function.dart';
import 'l10n/l10n.dart';
import 'providers/connectivity_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/notification_provider.dart';
import 'utilities/constants.dart' show kSecondaryColor;
import 'package:path_provider/path_provider.dart';
// import 'providers/weather_provider.dart';
import 'providers/theme_provider.dart';
import 'customIcon/custom_icons.dart';
// import 'widgets/weather_widget.dart';
import 'utilities/get_category.dart';
import 'pages/settings_page.dart';
import 'utilities/globals.dart' as globals;
// import 'pages/explore_page.dart';
import 'pages/search_page.dart';
import 'hiveDB/local_db.dart';
import 'pages/home_page.dart';
import 'pages/save_page.dart';
// ignore: depend_on_referenced_packages
// import 'package:google_mobile_ads/google_mobile_ads.dart';

void main(List<String> args) async {
  globals.appNavigator = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDir.path);
  // await Hive.initFlutter();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(SaveArticleAdapter());
  Hive.registerAdapter(DarkThemeAdapter());
  Hive.registerAdapter(SaveNotificationAdapter());
  Hive.registerAdapter(SaveNotificationOnOffAdapter());

  await Hive.openBox('saveposts');
  await Hive.openBox('themedata');
  await Hive.openBox('savenotification');
  await Hive.openBox('saveNotificationOnOff');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ConnectivityProvider>(
        create: (context) => ConnectivityProvider()),
    // ChangeNotifierProvider<WeatherData>(create: (context) => WeatherData()),
    ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
    ChangeNotifierProvider<LocaleProvider>(
        create: (context) => LocaleProvider()),
    ChangeNotifierProvider<NotificationProvider>(
        create: (context) => NotificationProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeCode = Provider.of<LocaleProvider>(context).getLocale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Vanguard",
      // theme: Provider.of<ThemeProvider>(context).darkTheme
      //     ? darkThemeData(context)
      //     : lightThemeData(context),
      navigatorKey: globals.appNavigator,
      home: const MainHome(),
      locale: localeCode,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

class MainHome extends StatefulWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int navBarIndex = 0;
  String appBarTitle = "VANGUARD";

  final screens = const [
    HomePage(),
    ExplorePage(),
     SavePage(),
    SettingsPage(),
  ];

  // OneSignal Push Notification init Function
  Future<void> initPlatformState() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(Config.oneSignalAppId);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      saveNotification(
        notificationId: result.notification.notificationId,
        title: result.notification.title ?? "",
        body: result.notification.body,
      );
      globals.appNavigator.currentState!
          .push(MaterialPageRoute(builder: (context) {
        return const NotificationPage();
      }));
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      /// Display Notification, send null to not display
      if (Provider.of<NotificationProvider>(context).checkNotfication) {
        event.complete(event.notification);
      } else {
        event.complete(null);
      }
    });
  }

  @override
  void initState() {
    initPlatformState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    // Provider.of<WeatherData>(context, listen: false).setWeatherData();
    getHomeCategory();
    getCategory();
    super.initState();
  }

  @override
  void dispose() {
    Hive.box("saveposts").compact();
    Hive.box("saveposts").close();
    Hive.box("themedata").close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth > 300 ? 20 : 18;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        // title: Text(
        //   appBarTitle,
        //   style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        // ),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            "assets/images/splash.png",
            height: 200,
            width: 250,
            scale: 4,
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width < 300 ? 200 : 150,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            icon: const Icon(
              CustomIcon.search,
              color: kSecondaryColor,
            ),
            iconSize: iconSize,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const NotificationPage())));
            },
            icon: const Icon(
              CustomIcon.notification,
              color: kSecondaryColor,
            ),
            iconSize: iconSize,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: ((child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        }),
        child: screens[navBarIndex],
      ),
      bottomNavigationBar: Container(
        color: null,
        // isDarkTheme ? kSecondaryColor : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: GNav(
            selectedIndex: navBarIndex,
            gap: 8,
            activeColor: Colors.black,
            // isDarkTheme ? Colors.white : Colors.black,
            // tabBackgroundColor: Colors.black.withOpacity(0.03),
            // isDarkTheme
            //     ? const Color.fromARGB(255, 36, 36, 71)
            //     : Colors.black.withOpacity(0.03),
            padding: MediaQuery.of(context).size.width < 340
                ? const EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                : const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            duration: const Duration(milliseconds: 400),
            tabBorderRadius: 20.0,
            curve: Curves.easeIn,
            onTabChange: (value) {
              switch (value) {
                case 0:
                  {
                    if (mounted) {
                      setState(() {
                        navBarIndex = 0;
                        appBarTitle = "VANGUARD";
                      });
                    }
                    break;
                  }
                case 1:
                  {
                    if (mounted) {
                      setState(() {
                        navBarIndex = 1;
                        appBarTitle = AppLocalizations.of(context)
                            .categories
                            .toUpperCase();
                      });
                    }
                    break;
                  }
                case 2:
                  {
                    if (mounted) {
                      setState(() {
                        navBarIndex = 2;
                        appBarTitle = AppLocalizations.of(context)
                            .saved
                            .toUpperCase();
                      });
                    }
                    break;
                  }
                case 3:
                  {
                    if (mounted) {
                      setState(() {
                        navBarIndex = 3;
                        appBarTitle = AppLocalizations.of(context)
                            .settings
                            .toUpperCase();
                      });
                    }
                    break;
                  }
              }
            },
            tabs: [
              GButton(
                icon: CustomIcon.home,
                iconSize: iconSize,
                // text: AppLocalizations.of(context)!.home,
              ),
              GButton(
                icon: CustomIcon.menu,
                iconSize: iconSize,
                // text: AppLocalizations.of(context)!.explore,
              ),
              GButton(
                icon: CustomIcon.love,
                iconSize: iconSize,
                // text: AppLocalizations.of(context)!.saved,
              ),
              GButton(
                icon: Icons.settings_outlined,
                iconSize: iconSize,
                // text: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
