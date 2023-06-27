import 'dart:convert';

import 'package:amazon/constants/error_handling.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/features/home/screens/home_screen.dart';
import 'package:amazon/models/user.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name
  }) async {
    try{
      User user = User(id: '', name: name, password: password, address: '', type: '', token: '', email: email);
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String> {
          'Content-Type':'application/json; charset=UTF-8'
        }
      );
      httpErrorHandle(response: response, context: context, onSuccess: (){
        showSnackbar(context, "Account created! Login with the same credentials");
      });
    } catch(e){
      showSnackbar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password
  }) async {
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            "email":email,
            "password":password
          }),
          headers: <String, String> {
            'Content-Type':'application/json; charset=UTF-8'
          }
      );
      httpErrorHandle(response: response, context: context, onSuccess: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false).setUser(response.body);
        await prefs.setString('x-auth-token', jsonDecode(response.body)['token']);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
      });
    } catch(e){
      showSnackbar(context, e.toString());
    }
  }

  void getUserData(
    BuildContext context
  ) async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("x-auth-token");

      if (token == null){
        preferences.setString("x-auth-token", "");
      }
      var tokenRes = await http.post(
        Uri.parse("$uri/token"),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        },
      );
      
      var response = jsonDecode(tokenRes.body);
      if (response){
        http.Response userResponse = await http.get(
          Uri.parse("$uri/"),
          headers: <String, String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
      }
    } catch(e){
      showSnackbar(context, e.toString());
    }
  }
}