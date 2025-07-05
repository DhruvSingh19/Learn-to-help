import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:springsecurity/APiServices/DataProvider.dart';
import 'package:springsecurity/Constants/VideoCallInfo.dart';
import 'package:springsecurity/Screens/loginscreen.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'APiServices/AuthProvider.dart';
import 'Screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ZIMKit().init(
    appID: AppInfo.appId,
    appSign: AppInfo.appSign,
  );


  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
            ChangeNotifierProvider(create: (_) => DataProvider()),
          ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Spring Security',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: authProvider.isAuthenticated ? const Homescreen() : const Loginscreen(),
        );
      },
    );
  }
}