import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/auth/services/auth_service.dart';
import 'package:amazon/features/home/screens/home_screen.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:amazon/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider())
      ],
      child: const MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon_Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black
          )
        ),
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor
        )
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty ? const HomeScreen() : const AuthScreen()
    );
  }
}
