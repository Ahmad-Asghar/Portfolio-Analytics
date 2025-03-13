import 'package:firebase_core/firebase_core.dart';
import 'package:my_portfolio_analytics/utils/app_exports.dart';
import 'package:my_portfolio_analytics/views/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: '1:754307824519:android:92e84e11022d7146fbf122',
        messagingSenderId: '754307824519	',
        projectId: 'my-portfolio-analytics-689df', apiKey: 'AIzaSyABhlvLdEiJhq3SfDqlm4uQEUYyDJj966A',
      )
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    return  ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return  MaterialApp(
            title: AppStrings.APP_NAME,
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.landingPage,
            routes: AppRoutes.routes,
            theme: light
        );
      },
    );
  }
}

