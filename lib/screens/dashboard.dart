import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/InputFields.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  bool isLoading=false;
  bool isAdmin = Constants.USER_TYPE == "1" ? true : false;

  int value0 = 0;
  int value1 = 0;
  int value2 = 0;
  int value3 = 0;
  int value4 = 0;
  int value5 = 0;
  int value6 = 0;


  List<TotalList> _FullList = [];
  bool is2Pressed = false;

  final _nameController = new TextEditingController();
  final _oldpass = new TextEditingController();
  final _newpass = new TextEditingController();
  final _new2pass = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  final _formKey2 = GlobalKey<FormState>();

  void initState(){
    super.initState();
    getDataAPI().whenComplete(() {
     getLoanDataAPI().whenComplete(() {
       isLoading = true;
     }) ;
    });
  }

  Future<bool> _onWillPop() async {
    return isLoading;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: GFAppBar(
            title: Text("Dashboard"),
            searchBar: false,
          ),
          body: Center(child: Container(
            margin: EdgeInsets.all(20),
            child: isLoading ? SingleChildScrollView(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                itemCard("હાલ નું બેલેન્સ : $value0", 0),
                itemCard("કુલ ગ્રાહક : $value1", 1),
                itemCard("કુલ સભ્યો : $value2", 2),
                itemCard("કુલ ડાયરી : $value3", 3),
                itemCard("ચાલુ ડાયરી : $value4", 4),
                itemCard("બહાર ની કુલ લોન : $value5", 5),
                itemCard("બહાર ની ચાલુ લોન : $value6", 6),
                SizedBox(height: 20,),
                RoundedLoadingButton(
                  animateOnTap: false,
                  child: Text('પાસવર્ડ બદલો', style: TextStyle(color: Colors.black,fontSize: 22)),
                  onPressed: EditCustomer,
                  width: MediaQuery.of(context).size.width*0.6,
                  color: Colors.lightBlueAccent,
                ),
                SizedBox(height: 20,),
                isAdmin ? RoundedLoadingButton(
                  animateOnTap: false,
                  child: Text('લોગિન લૉગ જુઓ', style: TextStyle(color: Colors.black,fontSize: 22)),
                  onPressed: () {
                    RouteController().GoTo(context, Constants.LOG_SCREEN);
                  },
                  width: MediaQuery.of(context).size.width*0.6,
                  color: Colors.lightGreen,
                ) : Container(),
              ],
            ),) : CircularProgressIndicator(),
          ),),
    ), onWillPop: _onWillPop);
  }

  itemCard(String text,int index){
    return Card(
      shape: Mystyle().RoundShape,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: index%2 == 0 ? Colors.grey[200]:Colors.white,
      child: ListTile(
        trailing: (index == 3 || index == 4)?GFIconButton(
            color: index%2 == 0 ? Colors.grey[200]:Colors.white,
            //splashColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 20),
            iconSize: 25,
            icon: Icon(Icons.print_rounded,size: 30,color: Colors.black,),
            onPressed: () {
              print("btn pressed");
              GetPDF().getLoanList(index,_FullList);
            },
        ):SizedBox(),
        shape: Mystyle().RoundShape,
        //FlatButton(child: Icon(Icons.call_rounded,color: ,),onPressed: () => AppController().CallDialog(context, _list[_list.length - index - 1]),),
        title: Text(text,style: Mystyle().InputStyle,),
      ),
    );
  }

  EditCustomer(){

    //AppController().ShowToast(text:"Feature In Development");
    //return;

    is2Pressed = false;
    _nameController.text = Constants.USERNAME;
    _oldpass.text = "";
    _newpass.text = "";
    _new2pass.text = "";


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
                      InputFieldArea2(hint: "જૂનો પાસવર્ડ",icon: Icons.vpn_key_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _oldpass,),
                      SizedBox(height: 18,),
                      InputFieldArea2(hint: "નવો પાસવર્ડ",icon: Icons.vpn_key_rounded,obscure: false,errorTxt: "નવો પાસવર્ડ દાખલ કરો",maxLen: 10,controller: _newpass,),
                      SizedBox(height: 18,),
                      InputFieldArea2(hint: "ફરી નવો પાસવર્ડ",icon: Icons.vpn_key_rounded,obscure: true,errorTxt: "નવો પાસવર્ડ મેચ નથી થતો, ફરી પ્રયત્ન કરો",maxLen: 10,controller: _new2pass,),
                      SizedBox(height: 18,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: SizedBox(
                            width: double.infinity, //Full width
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoundedLoadingButton(
                                    child: Text('સુધારો', style: TextStyle(color: Colors.black,fontSize: 20)),
                                    controller: _btnController,
                                    onPressed: (){_doSomething2();},
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
                                    if(!is2Pressed){Navigator.of(context).pop();}
                                  },
                                  width: MediaQuery.of(context).size.width*0.3,
                                  color: Colors.grey[200],
                                )
                              ],
                            )
                        ),),
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

  void _doSomething2() async {
    if(is2Pressed){return;}
    if (_formKey2.currentState.validate()) {
      is2Pressed = true;
      _formKey2.currentState.save();
       CustRegAPI().whenComplete(() {
           isLoading = true;
           Navigator.of(context).pop();
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


    queryParameters = {"tm_id":Constants.USERID,"tm_old_password":_oldpass.text,"tm_New_password":_newpass.text};

    print (queryParameters);
    try{
      response = await dio.post(Constants.API_PASSWORDUPDATE, data: queryParameters).timeout(Constants.API_TIMEOUT);

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
          AppController().ShowToast(text:Constants.MOBILE_EXIST,bgColor: Colors.red);
          //_phoneController.text = "";
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
      AppController().ShowToast(text: Constants.NO_INTERNET);
      _btnController.reset();
    }

    print("Response:- " + response.data.toString());
  }

  Future<void> getDataAPI() async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();

    try{


      response = await dio.post(Constants.API_GETDATA).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        if(nodata["response_code"] == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            setValues(data[0]);
          });

          //AppController().ShowToast(text: "${data.length} Customer Found");
        }
        else if(nodata["response_code"] == Constants.CODE_NULL){
          //AppController().ShowToast(text: "No Customer Found");
        }
      }
      else {
        AppController().ShowToast(text: Constants.NO_REACHABILITY);
      }
      print("GEtData Response : ${response.data}");
    }
    catch(e){
      print(e.toString());
      isLoading = true;
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }

  Future<void> getLoanDataAPI() async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();

    _FullList = [];

    try{


      response = await dio.post(Constants.API_GETLOANS).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        if(nodata["response_code"] == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            for(var element in data){
              _FullList.insert(0,TotalList.fromJson(element));
            }
          });

          //AppController().ShowToast(text: "${data.length} Customer Found");
        }
        else if(nodata["response_code"] == Constants.CODE_NULL){
          //AppController().ShowToast(text: "No Customer Found");
        }
      }
      else {
        AppController().ShowToast(text: Constants.NO_REACHABILITY);
      }
      print("GEtData Response : ${response.data}");
    }
    catch(e){
      print(e.toString());
      isLoading = true;
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }

  setValues(data){
    value0 = int.parse(data["cloase_balanc"]);
    value1 = int.parse(data["custmer"]);
    value2 = int.parse(data["team"]);
    value4 = int.parse(data["loan_open"]);
    var cloan = int.parse(data["loan_cloas"]);
    value3 = value4+cloan;
    value6 = int.parse(data["tloan_open"]);
    var tcloan = int.parse(data["tloan_cloas"]);
    value5 = value6+tcloan;
  }
}
