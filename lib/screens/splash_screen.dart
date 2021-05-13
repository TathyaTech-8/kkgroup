
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import '../models/styles.dart';
import 'package:shimmer/shimmer.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void fcmSubscribe() {
    firebaseMessaging.subscribeToTopic('GLOBLE').whenComplete(() => print("done"));
  }

  void fcmUnSubscribe() {
    firebaseMessaging.unsubscribeFromTopic('GLOBLE');
  }

  @override
  void initState(){
    super.initState();

    checkAndRunOnce();


    _mockCheckForSession().then(
        (status) {
           RouteController().GoTo(context, Constants.LOGIN_SCREEN);
        }
    );
  }
  checkAndRunOnce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(!prefs.containsKey("OnceInLife")){
      print("generate key first time");
      prefs.setBool("OnceInLife", false);
    }

    if(!prefs.getBool("OnceInLife")){
      print("code runs first time");
      prefs.setBool("OnceInLife", true);

      //TODO Put Fuction that run Once
      fcmSubscribe();
    }

    if(!prefs.containsKey("SelMonth")){
      prefs.setString("SelMonth", Constants.SelMonth);
      prefs.setString("SelYear", Constants.SelYear);
    }
    else{
      Constants.SelMonth = prefs.getString("SelMonth");
      Constants.SelYear = prefs.getString("SelYear");
    }
  }

  Future<bool> _mockCheckForSession() async {

    if(!await AppController().CanWrite()){
      SystemNavigator.pop();
    }

    await Future.delayed(Duration(milliseconds: 3000), () {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
        image: Mystyle().backgroundImage,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Hero(
                tag: Mystyle().logo,
                child: Image.asset(
                  "assets/img/logo.png",
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.width*0.8,),
              ),
            ),

            Shimmer.fromColors(
              period: Duration(milliseconds: 3000),
              baseColor: Colors.black12,
              highlightColor: Colors.white54,
              child:
                Image.asset("assets/img/logo.png",
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.width*0.8,),
              ),
          ],
        ),
      ),
    );
  }


}