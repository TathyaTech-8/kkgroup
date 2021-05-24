import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:kkgroup/screens/menu_8_1.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/InputFields.dart';

class TLOAN extends StatefulWidget {
  int PageIndex;
  TLOAN({this.PageIndex});

  @override
  _TLOANState createState() => _TLOANState(PageIndex: this.PageIndex);
}
class _TLOANState extends State<TLOAN> {

  final int PageIndex;
  bool isLoading = false;

  final _nameController = new TextEditingController();
  final _amtController = new TextEditingController();
  final _advController = new TextEditingController();
  final _irateController = new TextEditingController();
  final _monthsController = new TextEditingController();
  final _emiController = new TextEditingController();
  final _dateController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _searchController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();

  List <GetTLoan> _Fulllist = List <GetTLoan>();
  List <GetTLoan> _list = List <GetTLoan>();

  GetTLoan CustRegModel = new GetTLoan();
  bool isMember = Constants.USER_TYPE == "3" ? true : false;

  double irate = 0;
  double amt = 0;
  double emi = 0;

  void initState(){
    super.initState();
    GetCustAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);
    });
    _dateController.text = DateTime.now().toString();
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }

  _TLOANState({this.PageIndex});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: GFAppBar(
        actions: [
          GFIconButton(
              color: Colors.lightGreen,
              splashColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20),
              iconSize: 25,
              icon: Icon(Icons.print_rounded,size: 30,color: Colors.black,),
              onPressed: getPDF
          )
        ],
        title: Text(Constants.MENU_NAMES[PageIndex]),
        searchBar: true,
        searchController: _searchController,
        searchTextStyle: Mystyle().InputStyle,
        searchHintStyle: Mystyle().InputStyle,
        searchBarColorTheme: Colors.black,
        searchHintText: "નામ શોધો",
        onChanged: (value) {
          SearchFilter(value);
        },
      ),
      drawer: MyDrawer(PageIndex),
      floatingActionButton: !isMember ?FloatingActionButton(
        onPressed: () => AddLoan(),
        child: Icon(Icons.add,size: 30,),
      ) : Container() ,
      body: Container(
        //margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLoading ?
              Expanded(child: _list!=null && _list.length > 0 ?
              ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                itemCount: _list.length,
                itemBuilder: (context,index){
                  return
                    Card(
                      shape: Mystyle().RoundShape,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: index%2 == 0 ? Colors.grey[200]:Colors.white,
                      child: ListTile(
                        shape: Mystyle().RoundShape,
                        trailing: Icon(Icons.album,color: _list[index].tl_status == "0" ? Colors.green : Colors.red,size: 40,),
                        /*trailing: InkWell( //TODO : if Mobile Exist Add this
                            child: SizedBox(width: 50,height: 50,child: Icon(Icons.call_rounded,size: 35,color: Colors.green,),),
                            onTap: ()=>AppController().CallDialog(context,[_list[index],])),*/
                        //FlatButton(child: Icon(Icons.call_rounded,color: ,),onPressed: () => AppController().CallDialog(context, _list[_list.length - index - 1]),),
                        title: Text(_list[index].tl_name,style: Mystyle().InputStyle,),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text( "\t\tમોબાઈલ નં. : " + _list[index].tl_mobile,style: Mystyle().subText,),
                            Text( "\t\tરકમ : " + _list[index].tl_amount,style: Mystyle().subText,),
                            Text( "\t\tવ્યાજ દર : " + _list[index].tl_irate,style: Mystyle().subText,),
                          ],
                        ),
                        onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TEMILIST(loan: _list[index],))).then((value) => onBack())
                          //RouteController().GoTo2(context, Constants.TEMI_SCREEN,_list[index])
                        },//TODO:ADD Tloan Object
                      ),
                    );
                },
              ) :
              Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),)
              ) : Center(child: CircularProgressIndicator())
            ],
          )
      ),
    ), onWillPop: _onWillPop);
  }
  FutureOr onBack(){
    print("Yooooo I m BAck");
    setState(() {
      isLoading = false;
    });
    GetCustAPI().whenComplete(()  {
      _list = List.from(_Fulllist);
      print(_list.length);
      isLoading = true;
    });
  }
  CalculateValues(){
      irate = double.parse(_irateController.text == "" ? "0" : _irateController.text);
      amt = double.parse(_amtController.text == "" ? "0" : _amtController.text);

      emi = (irate*amt)/100;

      setState(() {
          _emiController.text = emi.toString();
      });
      print(emi);
  }
  AddLoan(){
    _nameController.text = "";
    _amtController.text = "";
    _advController.text = "";
    _irateController.text = "";
    _monthsController.text = "";
    _emiController.text = "";
    _phoneController.text = "";

    return showDialog(context: context,barrierDismissible: false,builder: (context)
    {
      return Dialog(
        shape: Mystyle().RoundShape,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20,),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: _dateController,
                      decoration: new InputDecoration(border: Mystyle().FullBorder(Colors.black54),icon:  Icon(Icons.date_range,color: Colors.black,size: 30,)),
                      //initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      style: Mystyle().InputStyle,
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date',
                      errorFormatText: "૧ - ૨૮ તારીખ પસંદ કરો",
                      onChanged: (val) {
                      },
                      validator: (val) {
                        DateTime tmp = DateTime.parse(val);
                        print(tmp.day);
                        if(tmp.day > 28){
                          return "૧ - ૨૮ તારીખ પસંદ કરો";
                        }
                        return null;
                      },
                    onSaved: (val) => print(val),
                  ),),
                  SizedBox(height:18),
                  InputFieldArea2(hint: "નામ",icon: Icons.person_rounded,errorTxt: "નામ દાખલ કરો",maxLen: 10,controller: _nameController,),
                  SizedBox(height:18),
                  InputFieldArea2(hint: "મોબાઈલ નં.",icon: Icons.phone_android,errorTxt: "મોબાઈલ નં. દાખલ કરો",maxLen: 10,controller: _phoneController,keyBoard:TextInputType.number,),
                  SizedBox(height:18),
                  InputFieldArea2(hint: "લોન ની રકમ",icon: Icons.monetization_on_rounded,obscure: false,errorTxt: "લોન ની રકમ દાખલ કરો",controller: _amtController,keyBoard: TextInputType.number,onChanged: (value) {
                    CalculateValues();
                  },),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "એડવાન્સ રકમ",icon: Icons.money,errorTxt: "એડવાન્સ રકમ દાખલ કરો",maxLen: 10,controller: _advController,keyBoard: TextInputType.number,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "વ્યાજદર",icon: Icons.account_balance_rounded,errorTxt: "વ્યાજદર દાખલ કરો",maxLen: 10,controller: _irateController ,keyBoard: TextInputType.number,onChanged: (value) {
                    CalculateValues();
                  },),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "કુલ હપ્તા",icon: Icons.lock_clock,errorTxt: "કુલ હપ્તા દાખલ કરો",maxLen: 10,controller: _monthsController,keyBoard: TextInputType.number,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "વ્યાજ ની રકમ",icon: Icons.attach_money,maxLen: 10,controller: _emiController,keyBoard: TextInputType.number,enable: false,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: SizedBox(
                      width: double.infinity, //Full width
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                            child: Text('લોન ઉમેરો', style: TextStyle(color: Colors.black,fontSize: 20)),
                            controller: _btnController,
                            onPressed: _doSomething,
                            width: MediaQuery.of(context).size.width*0.3,
                            color: Mystyle().BtnColor,
                            successColor: Colors.green,
                            valueColor: Colors.black,
                          ),
                          SizedBox(width: 20,),
                          RoundedLoadingButton(
                            animateOnTap: false,
                            child: Text('બંધ કરો', style: TextStyle(color: Colors.black,fontSize: 20)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            width: MediaQuery.of(context).size.width*0.3,
                            color: Colors.grey[200],
                          )
                        ],
                      ),
                    ),)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  getPDF(){
    GetPDF().getTLoanList(_list);
  }

  SearchFilter(String _searchTxt){
    print("enterd");
    setState(() {
      _list = _Fulllist.where((customer) => customer.tl_name.toLowerCase().contains(_searchTxt.toLowerCase())).toList();

    });
    //print(_list);
  }

  void _doSomething() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      CustRegAPI().whenComplete(() {
        Navigator.of(context).pop();
        GetCustAPI().whenComplete(() {
          _list = List.from(_Fulllist);
          isLoading = true;
          print(_Fulllist);
        });
      });
    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }

  Future CustRegAPI() async {
    Response response;
    Dio dio = new Dio();

    var queryParameters = {
        "tl_name": _nameController.text,
       "date":_dateController.text,
       "tl_amount": _amtController.text,
       "tl_advance": _advController.text,
       "tl_inrate": _irateController.text,
       "tl_months": _monthsController.text,
       "tl_emi" :_emiController.text,
       "tl_mobile" :_phoneController.text
    };

    print(queryParameters);
    //var json = jsonEncode(CustRegModel);

    try{
      response = await dio.post(Constants.API_ADDTLOAN, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if(resCode == Constants.CODE_SUCESS){
          _btnController.success();
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          _btnController.reset();
        }
        else if(resCode == Constants.CODE_CONFLICT){
          //AppController().ShowToast(text:Constants.MOBILE_EXIST,bgColor: Colors.red);
          _btnController.reset();
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          _btnController.reset();
        }
        else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
          _btnController.reset();
        }
      }
    }
    catch(e){
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
      _btnController.reset();
    }

    print("Response:- " + response.data.toString());
  }
  Future<void> GetCustAPI() async {
    isLoading = false;
    _Fulllist = [];
    _list = [];
    Response response;
    Dio dio = new Dio();

    try{



      response = await dio.post(Constants.API_GETTLOAN).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        if(nodata["response_code"] == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            for(var element in data){
              _Fulllist.insert(0,GetTLoan.fromJson(element));
            }
            isLoading =true;
          });
          //AppController().ShowToast(text: "${data.length} Customer Found");
        }
        else if(nodata["response_code"] == Constants.CODE_NULL){
          //AppController().ShowToast(text: "No Customer Found");
          setState(() {
            isLoading = true;
          });
        }
      }
      else {
        //AppController().ShowToast(text: Constants.NO_REACHABILITY);
        setState(() {
          isLoading = true;
        });
      }
      //print("GEtData Response : ${response.data}");
    }
    catch(e){
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
      setState(() {
        isLoading = true;
      });
    }
  }
}
