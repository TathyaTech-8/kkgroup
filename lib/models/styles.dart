import 'package:flutter/material.dart';


class Mystyle {

  DecorationImage backgroundImage = new DecorationImage(
    image: new ExactAssetImage('assets/img/bg.png'),
    fit: BoxFit.cover,
  );

  DecorationImage logo = new DecorationImage(
    image: new ExactAssetImage('assets/img/logo.png'),
    fit: BoxFit.cover,
  );

  Color BtnColor = Colors.green;

  Text AppText(String str, TextAlign align){
    return(Text(str,textAlign: align,style: Mystyle().InputStyle,));
  }

  RoundedRectangleBorder RoundShape = new RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));

  TextStyle InputStyle = new TextStyle(
      fontSize: 25,
      color: Colors.black
  );
  TextStyle subText = new TextStyle(
      fontSize: 17,
      color: Colors.black54,
  );


  OutlineInputBorder FullBorder(Color _borderColor) {
    return new OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: new BorderSide(color: _borderColor, width: 3)
    );
  }

  InputDecoration InputDec(IconData _icon,String _lblTxt) {
    return new InputDecoration(
      prefixIcon: new Icon(
        _icon,
        color: Colors.black,
        size: 30,
      ),
      hintText: _lblTxt,
      counterText: "",
      hintStyle: TextStyle(color: Colors.black54, fontSize: 25),
      border: InputBorder.none,// FullBorder(Colors.black54),
      focusedBorder: InputBorder.none,// FullBorder(Colors.black54),
      errorBorder: InputBorder.none,// FullBorder(Colors.red),
      focusedErrorBorder: InputBorder.none,// FullBorder(Colors.red),
    );
  }
  Decoration DoubleShadowBox (Color _topColor, Color _midColor, Color _btmColor){
    return new BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      color: _midColor,
      boxShadow: [
        BoxShadow(
            color: _btmColor,
            offset: Offset(1.0, 1.0),
            spreadRadius: 2,
            blurRadius: 1
        ),
        BoxShadow(
            color: _topColor,
            offset: Offset(-1.0, -1.0),
            spreadRadius: 2,
            blurRadius: 1
        )
      ],
    );
  }
}
