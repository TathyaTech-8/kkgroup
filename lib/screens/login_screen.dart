import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/InputFields.dart';
import 'package:kkgroup/models/models.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/AppController.dart';
import '../models/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  Login loginModel = new Login();
  bool isloading = false;

  var userController = new TextEditingController();
  var passwordController = new TextEditingController();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new Scaffold(

      body: new Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
            image: Mystyle().backgroundImage,
          ),),
          Container(
           child:
            new ListView(
              padding: const EdgeInsets.all(0.0),
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 80,),
                    Hero(
                        tag: Mystyle().logo,
                        child: Image.asset(
                          "assets/img/logo.png",
                          width: MediaQuery.of(context).size.width*0.55,
                          height: MediaQuery.of(context).size.width*0.55,)
                    ),
                    new SizedBox(height: 70,),
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            borderOnForeground: true,
                            child: Column(
                              children: [
                                SizedBox(height: 25,),
                                InputFieldArea(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",controller: userController,maxLen: 10,keyBoard: TextInputType.phone,),
                                SizedBox(height: 20,),
                                InputFieldArea(hint: "પાસવર્ડ",icon: Icons.vpn_key_rounded,obscure: true,errorTxt: "પાસવર્ડ દાખલ કરો",controller: passwordController,maxLen: 25,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  child: SizedBox(
                                    width: double.infinity, //Full width
                                    height: 50,
                                    child: RoundedLoadingButton(
                                      child: Text('લોગિન કરો ', style: TextStyle(color: Colors.black,fontSize: 25)),
                                      controller: _btnController,
                                      onPressed: _doSomething,
                                      width: 200,
                                      color: Mystyle().BtnColor,
                                      successColor: Colors.green,
                                      valueColor: Colors.black,
                                    ),
                                  ),)
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )
        ],),
    ));
  }

  void _doSomething() async {
      if (_formKey.currentState.validate()) {
        setState(() {
          isloading = true;
        }
        );
        _formKey.currentState.save();
        LoginAPI();
      }
      else{
        _btnController.reset();
       // AppController().ShowToast(text: "Please Enter Mobile/Password");
      }
  }

  Future<void> LoginAPI() async {

    //print("Entered In Function");
    Response response;
    Dio dio = new Dio();

    loginModel.username = userController.text;
    loginModel.password = passwordController.text;

    var json = jsonEncode(loginModel);

   try{
     response = await dio.post(Constants.API_LOGIN, data: json).timeout(Constants.API_TIMEOUT);

     if (response != null && response.data != null) {

       var data = response.data;
       String resCode = data['response_code'];
       //String msg = data['message'];

       if (resCode == Constants.CODE_SUCESS) {
         //AppController().ShowToast(text:msg,bgColor: Colors.green);
         Constants.USERID = data['user_id'];
         Constants.USERNAME = data['use_name'];
         Constants.USER_TYPE = data['user_type'];

         _btnController.success();
         Timer(Duration(milliseconds: 50), () {
           RouteController().GoTo(context, Constants.HOME_SCREEN);
         });
       } else {
         //AppController().ShowToast(text:msg,bgColor: Colors.red);
         _btnController.reset();
         passwordController.value = TextEditingValue.empty;
       }
     } else {
       //AppController().ShowToast(text: Constants.NO_REACHABILITY);
       _btnController.reset();

     }
   }
   catch(TimeoutException){
     AppController().showToast(text: Constants.NO_INTERNET);
     _btnController.reset();
    }

    print("Login Response:- " + response.toString());
  }
}




/*TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.black),
                                        focusedBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        border: OutlineInputBorder(),
                                      ),
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Enter password';
                                        else
                                          return null;
                                      },
                                    ),*/