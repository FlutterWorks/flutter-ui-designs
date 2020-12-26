import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uis/AppRoutes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'NavigatorObserver.dart';
import 'configs/Theme.dart' as theme;
import 'AppLocalizations.dart';
import 'Providers/AppProvider.dart';

import 'screens/Home/Home.dart';
import 'screens/Download/Download.dart';
import 'screens/AboutApp/AboutApp.dart';
import 'screens/AboutDeveloper/AboutDeveloper.dart';
import 'screens/UIList/UIList.dart';
import 'screens/UIDetail/UIDetail.dart';
import 'screens/DesignerProfile/DesignerProfile.dart';

import 'MiniApps/HealtyFoodDelivery/Screens/HomeScreen/HFDHomeScreen.dart';
import 'MiniApps/HealtyFoodDelivery/Screens/DetailScreen/HFDDetailScreen.dart';

import 'MiniApps/HotAirBalloons/Screens/HomeScreen/HABHomeScreen.dart';
// import './MiniApps/HotAirBalloons/Screens/DetailScreen/HABDetailScreen.dart';

import 'MiniApps/SkyView/Screens/HomeScreen/SKVHomeScreen.dart';
import 'MiniApps/SkyView/Screens/DetailScreen/SKVDetailScreen.dart';

import 'MiniApps/AsicsShoesConcept/Screens/HomeScreen/ASCHomeScreen.dart';

import 'MiniApps/EggTimerConcept/Screens/HomeScreen/ETCHomeScreen.dart';

//
import 'MiniApps/ChefCraft/Screens/HomeScreen/CCNHomeScreen.dart';

class AppNavigator extends StatelessWidget {
  AppNavigator(this.observers);
  final List<NavigatorObserver> observers;
  final GlobalKey<NavigatorState> navigator = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent &&
            event.isAltPressed &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            this.navigator.currentState.canPop()) {
          this.navigator.currentState.pop();
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: Consumer<AppProvider>(
          builder: (context, value, _) {
            return MaterialChild(
              state: value,
              observers: this.observers,
              navigatorKey: this.navigator,
            );
          },
        ),
      ),
    );
  }
}

class MaterialChild extends StatelessWidget {
  MaterialChild({
    @required this.navigatorKey,
    @required this.observers,
    @required this.state,
  });
  final List<NavigatorObserver> observers;
  final GlobalKey<NavigatorState> navigatorKey;
  final AppProvider state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: state.activeLocale,
      supportedLocales: AppProvider.locales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (locale != null &&
              supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: theme.base,
      darkTheme: theme.baseDark,
      themeMode: state.themeMode,
      navigatorKey: this.navigatorKey,
      navigatorObservers: [AppNavigatorObserver()],
      initialRoute: "home",
      onGenerateRoute: (settings) {
        final index = ["skvDetail", "hfdDetail"].indexOf(settings.name);
        if (index > -1) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) {
              if (index == 1) {
                return HFDDetailScreen();
              }
              return SKVDetailScreen(settings.arguments);
            },
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          );
        }
        return MaterialPageRoute(builder: (context) => HomeScreen());
      },
      routes: <String, WidgetBuilder>{
        AppRoutes.home: (_) => new HomeScreen(),
        AppRoutes.about: (_) => new AboutAppScreen(),
        AppRoutes.aboutDeveloper: (_) => new AboutDeveloperScreen(),
        AppRoutes.download: (_) => new DownloadScreen(),
        AppRoutes.uiList: (_) => new UIListScreen(),
        AppRoutes.uiDetail: (_) => new UIDetailScreen(),
        AppRoutes.designerProfile: (_) => new DesignerProfileScreen(),

        // Healthy Food Delivery
        AppRoutes.hfdHome: (_) => new HFDHomeScreen(),
        // "hfdDetail": (_) => new HFDDetailScreen(),

        // Hot Air Balloon
        AppRoutes.habHome: (_) => new HABHomeScreen(),

        // Sky View
        AppRoutes.skvHome: (_) => new SKVHomeScreen(),
        AppRoutes.skvDetail: (context) {
          final int index = ModalRoute.of(context).settings.arguments;
          return SKVDetailScreen(index);
        },

        AppRoutes.ascHome: (_) => new ASCHomeScreen(),

        AppRoutes.etcHome: (_) => new ETCHomeScreen(),
        AppRoutes.ccnHome: (_) => new CCNHomeScreen(),
      },
    );
  }
}
