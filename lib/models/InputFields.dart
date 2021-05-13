import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final int maxLen;
  final String errorTxt;
  final TextEditingController controller;
  final TextInputType keyBoard;
  InputFieldArea({this.controller,this.hint, this.obscure, this.icon,this.errorTxt = '',this.maxLen = 15,this.keyBoard = TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: Mystyle().DoubleShadowBox(Colors.white, Colors.grey[200], Colors.grey),
          height: 55,
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
          //padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
        ),
       Container(
         margin: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
         child:  TextFormField(
           decoration: Mystyle().InputDec(icon,hint),
           autovalidateMode: AutovalidateMode.onUserInteraction,
           style: Mystyle().InputStyle,
           controller: controller,
           maxLength: maxLen,
           maxLengthEnforced: true,
           keyboardType: keyBoard,
           inputFormatters: [
             LengthLimitingTextInputFormatter(maxLen),
           ],
           obscureText: obscure,
           validator: (value) {
             if (value.isEmpty)
               return errorTxt;
             else
               return null;
           },
         ),
       ),
      ],);
  }

  // Widget build(BuildContext context) {
  //   return (new Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     decoration: Mystyle().DoubleShadowBox(Colors.white, Colors.grey[100], Colors.grey) ,
  //     // BoxDecoration(
  //     //   shape: BoxShape.rectangle,
  //     //   borderRadius: BorderRadius.all(Radius.circular(25)),
  //     //   color: Colors.grey[100],
  //     //   boxShadow: [
  //     //     BoxShadow(
  //     //         color: Colors.grey,
  //     //         offset: Offset(1.0, 1.0),
  //     //         spreadRadius: 2,
  //     //         blurRadius: 1
  //     //     ),
  //     //     BoxShadow(
  //     //         color: Colors.white,
  //     //         offset: Offset(-1.0, -1.0),
  //     //         spreadRadius: 2,
  //     //         blurRadius: 1
  //     //     )
  //     //   ],
  //     // ),
  //      child: new TextFormField(
  //       keyboardType: TextInputType.phone,
  //       obscureText: obscure,
  //       style: const TextStyle(
  //         color: Colors.black,
  //         fontSize: 25.0,
  //       ),
  //       decoration: Mystyle().InputDec(icon, hint),
  //     ),
  //   ));
  // }
}

class InputFieldArea3 extends StatelessWidget {
  final List<String> suggestion;
  final String hint;
  final bool obscure;
  final IconData icon;
  final int maxLen;
  final String errorTxt;
  final TextEditingController controller;
  final TextInputType keyBoard;
  InputFieldArea3({this.controller,this.hint, this.obscure, this.icon,this.errorTxt = '',this.maxLen = 15,this.keyBoard = TextInputType.text,this.suggestion});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
          child:  AutoCompleteTextField(
            controller: controller,
            clearOnSubmit: false,
            style: Mystyle().InputStyle,
            decoration:new InputDecoration(
              prefixIcon: new Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              labelText: hint,
              labelStyle: TextStyle(color: Colors.black),
              //hintText: hint,
              counterText: "",
              hintStyle: TextStyle(color: Colors.black54, fontSize: 25),
              border: Mystyle().FullBorder(Colors.black54),
              focusedBorder: Mystyle().FullBorder(Colors.black54),
              errorBorder: Mystyle().FullBorder(Colors.red),
              focusedErrorBorder: Mystyle().FullBorder(Colors.red),
            ),
            itemFilter: (String suggestion, String query) {
              return suggestion.toLowerCase().contains(query.toLowerCase());
            },
            suggestions: suggestion,
            itemSorter: (a, b) { return a.compareTo(b); },
            itemSubmitted: (data) {
              controller.text = data;
            },
            itemBuilder: (BuildContext context, suggestion) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(suggestion,style: Mystyle().subText,)
                  ],
                ),
              );
            },
            key: null,

          ),
        ),
      ],);
  }

// Widget build(BuildContext context) {
//   return (new Container(
//     margin: EdgeInsets.symmetric(horizontal: 20),
//     decoration: Mystyle().DoubleShadowBox(Colors.white, Colors.grey[100], Colors.grey) ,
//     // BoxDecoration(
//     //   shape: BoxShape.rectangle,
//     //   borderRadius: BorderRadius.all(Radius.circular(25)),
//     //   color: Colors.grey[100],
//     //   boxShadow: [
//     //     BoxShadow(
//     //         color: Colors.grey,
//     //         offset: Offset(1.0, 1.0),
//     //         spreadRadius: 2,
//     //         blurRadius: 1
//     //     ),
//     //     BoxShadow(
//     //         color: Colors.white,
//     //         offset: Offset(-1.0, -1.0),
//     //         spreadRadius: 2,
//     //         blurRadius: 1
//     //     )
//     //   ],
//     // ),
//      child: new TextFormField(
//       keyboardType: TextInputType.phone,
//       obscureText: obscure,
//       style: const TextStyle(
//         color: Colors.black,
//         fontSize: 25.0,
//       ),
//       decoration: Mystyle().InputDec(icon, hint),
//     ),
//   ));
// }
}

class InputFieldArea2 extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final int maxLen;
  final String errorTxt;
  final TextEditingController controller;
  final TextInputType keyBoard;
  final bool required;
  final bool enable;
  ValueChanged<String> onChanged;
  
  InputFieldArea2({this.controller,this.onChanged,this.enable = true,this.hint, this.obscure = false, this.icon,this.errorTxt = '',this.maxLen = 255,this.keyBoard = TextInputType.text,this.required = true});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
          child:  TextFormField(
            enableSuggestions: true,
            onChanged:onChanged,
            enabled: enable,
            decoration:  new InputDecoration(
              prefixIcon: new Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              labelText: hint,
              labelStyle: TextStyle(color: Colors.black),
              //hintText: hint,
              counterText: "",
              hintStyle: TextStyle(color: Colors.black54, fontSize: 25),
              border: Mystyle().FullBorder(Colors.black54),
              focusedBorder: Mystyle().FullBorder(Colors.black54),
              errorBorder: Mystyle().FullBorder(Colors.red),
              focusedErrorBorder: Mystyle().FullBorder(Colors.red),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: Mystyle().InputStyle,
            controller: controller,
            maxLength: maxLen,
            maxLengthEnforced: true,
            keyboardType: keyBoard,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLen),
            ],
            obscureText: obscure,
            validator: (value) {
              if (value.isEmpty && required)
                return errorTxt;
              else
                return null;
            },
          ),
        ),
      ],);
  }

// Widget build(BuildContext co0ntext) {
//   return (new Container(
//     margin: EdgeInsets.symmetric(horizontal: 20),
//     decoration: Mystyle().DoubleShadowBox(Colors.white, Colors.grey[100], Colors.grey) ,
//     // BoxDecoration(
//     //   shape: BoxShape.rectangle,
//     //   borderRadius: BorderRadius.all(Radius.circular(25)),
//     //   color: Colors.grey[100],
//     //   boxShadow: [
//     //     BoxShadow(
//     //         color: Colors.grey,
//     //         offset: Offset(1.0, 1.0),
//     //         spreadRadius: 2,
//     //         blurRadius: 1
//     //     ),
//     //     BoxShadow(
//     //         color: Colors.white,
//     //         offset: Offset(-1.0, -1.0),
//     //         spreadRadius: 2,
//     //         blurRadius: 1
//     //     )
//     //   ],
//     // ),
//      child: new TextFormField(
//       keyboardType: TextInputType.phone,
//       obscureText: obscure,
//       style: const TextStyle(
//         color: Colors.black,
//         fontSize: 25.0,
//       ),
//       decoration: Mystyle().InputDec(icon, hint),
//     ),
//   ));
// }
}