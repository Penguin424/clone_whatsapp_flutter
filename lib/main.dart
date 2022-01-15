import 'package:chat_flutter/src/pages/HomePage.dart';
import 'package:chat_flutter/src/pages/LoginPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        // primaryColor: Colors.red,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0XFF4CAAB1),
          onPrimary: Colors.white,
          primaryVariant: Colors.orange,
          background: const Color(0XFFF5BB62),
          onBackground: Colors.black,
          secondary: const Color(0XFFBFE3ED), //Color(0xFF92f56f)
          onSecondary: Colors.white,
          secondaryVariant: Colors.deepOrange,
          error: Colors.black,
          onError: Colors.white,
          surface: const Color(0XFF36787D),
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
