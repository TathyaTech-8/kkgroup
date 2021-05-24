import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:smart_select/smart_select.dart';

import '../models/InputFields.dart';

class TEAM_LIST extends StatefulWidget {
  int PageIndex;
  TEAM_LIST({this.PageIndex});

  @override
  _TEAM_LISTState createState() => _TEAM_LISTState(PageIndex: this.PageIndex);
}
class _TEAM_LISTState extends State<TEAM_LIST> {

  final int PageIndex;
  bool isLoading = false;

  final _nameController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _searchController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  List <GetTeam> _Fulllist =[];// List <GetTeam>();
  List <GetTeam> _list = [];//List <GetTeam>();

  bool isAdmin = Constants.USER_TYPE == "1" ? true : false;

  String type = "3";
  bool status = true;

  bool is1Pressed = false;
  bool is2Pressed = false;


  GetTeam CustRegModel = new GetTeam();

  void initState(){
    super.initState();
    GetCustAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);
    });
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }

  getPDF(){
    if(isLoading && _list.length > 0){
      GetPDF().getTeamList(_list);
    }
    else{
      AppController().showToast(text: Constants.NO_DATA);
    }
  }

  _TEAM_LISTState({this.PageIndex});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: GFAppBar(
        actions: [
          isAdmin ? GFIconButton(
              color: Colors.lightGreen,
              splashColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20),
              iconSize: 25,
              icon: Icon(Icons.print_rounded,size: 30,color: Colors.black,),
              onPressed: getPDF
          ) : Container(),
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
      floatingActionButton: isAdmin ?FloatingActionButton(
        onPressed: () => AddCustomer(),
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
                      color: _list[index].tm_status == "1" ? index%2 == 0 ? Colors.grey[200]:Colors.white : Colors.red[50],
                      child: ListTile(
                        shape: Mystyle().RoundShape,
                        trailing: InkWell(
                            child: SizedBox(width: 50,height: 50,child: Icon(Icons.call_rounded,size: 35,color: Colors.green,),),
                            onTap: ()=>AppController().CallDialog(context,[_list[index].tm_mobile])),
                        //FlatButton(child: Icon(Icons.call_rounded,color: ,),onPressed: () => AppController().CallDialog(context, _list[_list.length - index - 1]),),
                        title: Text(_list[index].tm_name,style: Mystyle().InputStyle,),
                        subtitle: Text( "મોબાઇલ નં : " + _list[index].tm_mobile),
                        onTap: (){if(isAdmin) EditCustomer(index);},
                        onLongPress: (){
                          if(isAdmin){
                            ShowPassword(index);
                          }
                        },
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

  ShowPassword(int index){
    Widget okBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: RoundedLoadingButton(
      child: Text('ઓકે', style: TextStyle(color: Colors.lightBlue, fontSize: 20)),
      onPressed: () {
        Navigator.pop(context);
      },
      width: 80,
      animateOnTap: false,
      color: Colors.grey[200],
      successColor: Colors.green,
      valueColor: Colors.black,
    ),
    );
    AlertDialog alert = new AlertDialog(
      shape: Mystyle().RoundShape,
      title: Text(
        "${_list[index].tm_name} નો પાસવર્ડ",
        style: Mystyle().InputStyle,
      ),
      content: Text(
        "${_list[index].tm_pass}",
        style: Mystyle().subText,
      ),
      actions: [
        okBtn,
      ],
    );
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  AddCustomer(){

    is1Pressed = false;
    _nameController.text = "";
    _phoneController.text = "";
    _passwordController.text = "";

    List<S2Choice<String>> userType = [
      S2Choice(value: "1", title: "Admin"),
      S2Choice(value: "2", title: "Banker"),
      S2Choice(value: "3", title: "Member"),
    ];

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
                  //Text("નવો ગ્રાહક ઉમેરો",style: new TextStyle(fontSize: 35,),),
                  InputFieldArea2(hint: "સભ્ય નું નામ",icon: Icons.person,obscure: false,errorTxt: "સભ્ય નું નામ દાખલ કરો",controller: _nameController,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _phoneController,keyBoard: TextInputType.phone,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "પાસવર્ડ",icon: Icons.vpn_key_rounded,obscure: true,errorTxt: "પાસવર્ડ દાખલ કરો",maxLen: 10,controller: _passwordController,),
                  SizedBox(height: 18,),
                  Card(
                    shape: Mystyle().RoundShape,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: SmartSelect<String>.single(
                          title: 'સભ્ય નો પ્રકાર',
                          value: userType[2].value,
                          choiceItems: userType,
                          choiceType: S2ChoiceType.chips,
                          modalType: S2ModalType.bottomSheet,
                          onChange: (state) => setState(() {
                            type = state.value;
                          })
                      ),),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: SizedBox(
                        width: double.infinity, //Full width
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedLoadingButton(
                              child: Text('સભ્ય ઉમેરો', style: TextStyle(color: Colors.black,fontSize: 20)),
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
                                if(!is1Pressed){Navigator.of(context).pop();}
                              },
                              width: MediaQuery.of(context).size.width*0.3,
                              color: Colors.grey[200],
                            )
                          ],
                        )
                    ),)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  EditCustomer(int index){

    is2Pressed = false;
    print(index);
    _nameController.text = _list[index].tm_name;
    _phoneController.text = _list[index].tm_mobile;
    _passwordController.text = _list[index].tm_pass;
    type = _list[index].tm_type;

    status = _list[index].tm_status == "0" ? false : true;

    List<S2Choice<String>> userType = [
      S2Choice(value: "1", title: "Admin"),
      S2Choice(value: "2", title: "Banker"),
      S2Choice(value: "3", title: "Member"),
    ];
  print("ok 1");

    return showDialog(context: context,barrierDismissible: false,builder: (context)
    {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: Mystyle().RoundShape,
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Text("નવો ગ્રાહક ઉમેરો",style: new TextStyle(fontSize: 35,),),
                      InputFieldArea2(hint: "સભ્ય નું નામ",icon: Icons.person,obscure: false,errorTxt: "સભ્ય નું નામ દાખલ કરો",controller: _nameController,enable: false,),
                      SizedBox(height: 18,),
                      InputFieldArea2(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _phoneController,keyBoard: TextInputType.phone, enable: status,),
                      SizedBox(height: 18,),
                      InputFieldArea2(hint: "પાસવર્ડ",icon: Icons.vpn_key_rounded,obscure: true,errorTxt: "પાસવર્ડ દાખલ કરો",maxLen: 10,controller: _passwordController,enable: status,),
                      SizedBox(height: 18,),
                     AbsorbPointer(
                       absorbing: !status,
                       child:  Card(
                         shape: Mystyle().RoundShape,
                         child: Container(
                           width: MediaQuery.of(context).size.width * 0.7,
                           child: SmartSelect<String>.single(
                               title: 'સભ્ય નો પ્રકાર',
                               value: type,
                               choiceItems: userType,
                               choiceType: S2ChoiceType.chips,
                               modalType: S2ModalType.bottomSheet,
                               onChange: (state) => setState(() {
                                 type = state.value;
                               })
                           ),),
                       ),
                     ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: SizedBox(
                            width: double.infinity, //Full width
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AbsorbPointer(
                                  absorbing: !status,
                                  child: RoundedLoadingButton(
                                    child: Text('સુધારો', style: TextStyle(color: Colors.black,fontSize: 20)),
                                    controller: _btnController,
                                    onPressed: (){_doSomething2(index);},
                                    width: MediaQuery.of(context).size.width*0.3,
                                    color: Mystyle().BtnColor,
                                    successColor: Colors.green,
                                    valueColor: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 20,),
                                RoundedLoadingButton(
                                  animateOnTap: false,
                                  child: Text('બંધ કરો', style: TextStyle(color: Colors.black,fontSize: 20)),
                                  onPressed: () {
                                    if(!is2Pressed){Navigator.of(context).pop();}
                                  },
                                  width: MediaQuery.of(context).size.width*0.3,
                                  color: Colors.grey[200],
                                )
                              ],
                            )
                        ),),
                      TextButton(
                          onPressed: () {
                            if(!is2Pressed){
                              setState(() {
                                status = !status;
                              });
                              if(!status){
                                _btnController.start();
                                _doSomething2(index);
                              }

                            }
                          },
                          child: Text('સભ્ય ${!status?"સક્રિય":"નિષ્ક્રિય"} કરો', style: TextStyle(color: status?Colors.red:Colors.green,fontSize: 30)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  SearchFilter(String _searchTxt){
    print("enterd");
    setState(() {
      _list = _Fulllist.where((member) => member.tm_name.toLowerCase().contains(_searchTxt.toLowerCase())).toList();
    });
    //print(_list);
  }

  void _doSomething2(index) async {
    if(is2Pressed){return;}
    if (_formKey2.currentState.validate()) {
      is2Pressed = true;
      _formKey2.currentState.save();
      CustRegAPI(index).whenComplete(() {
        GetCustAPI().whenComplete(() {
          _list = List.from(_Fulllist);
          isLoading = true;
          print(_Fulllist);
          Navigator.of(context).pop();
        });
      });
    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }
  void _doSomething() async {
    if(is1Pressed){return;}

    if (_formKey.currentState.validate()) {
      is1Pressed = true;
      _formKey.currentState.save();
      CustRegAPI().whenComplete(() {
        GetCustAPI().whenComplete(() {
          _list = List.from(_Fulllist);
          isLoading = true;
          print(_Fulllist);
          Navigator.of(context).pop();
        });
      });
    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }

  Future CustRegAPI([int index = -1]) async {
    Response response;
    Dio dio = new Dio();
    var queryParameters;

    if(index < 0){
      queryParameters = {
        'tm_name': _nameController.text,
        'tm_mobile': _phoneController.text,
        "tm_type": type,
        "tm_password": _passwordController.text
      };
    }
    else{
      queryParameters = {
        "tm_id": _list[index].tm_id,
        "tm_name":  _list[index].tm_name,
        "tm_mobile": _phoneController.text,
        "tm_type": type,
        "tm_password": _passwordController.text,
        "tm_status": status? "1" : "0"
      };
    }

print (queryParameters);

    //var json = jsonEncode(CustRegModel);

    try{
      response = await dio.post(Constants.API_ADDTEAM, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];

        if(resCode == Constants.CODE_SUCESS){
          _btnController.success();
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          _btnController.reset();
        }
        else if(resCode == Constants.CODE_CONFLICT){
          AppController().showToast(text:Constants.MOBILE_EXIST,bgColor: Colors.red);
          _phoneController.text = "";
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

      response = await dio.get(Constants.API_SHOWTEAM).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        if(nodata["response_code"] == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            for(var element in data){
              _Fulllist.insert(0,GetTeam.fromJson(element));
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
      //print("GetData Response : ${response.data}");
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
