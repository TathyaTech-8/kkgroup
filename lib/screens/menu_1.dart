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

import '../models/InputFields.dart';

class CUSTLIST extends StatefulWidget {
  int PageIndex;
  CUSTLIST({this.PageIndex});

  @override
  _CUSTLISTState createState() => _CUSTLISTState(PageIndex: this.PageIndex);
}
class _CUSTLISTState extends State<CUSTLIST> {

  final int PageIndex;
  bool isLoading = false;

  final _nameController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _phone2Controller = new TextEditingController();
  final _addressController = new TextEditingController();
  final _searchController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();

  List <GetCustomer> _Fulllist = [];
  List <GetCustomer> _list = [];

  GetCustomer CustRegModel = new GetCustomer();

  void initState(){
    super.initState();
    GetCustAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);
      _list.sort((a, b) => a.cust_name.compareTo(b.cust_name));
    });
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }

  _CUSTLISTState({this.PageIndex});
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
        title: Text(Constants.MENU_NAMES[PageIndex],style: Mystyle().InputStyle,),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddCustomer(),
        child: Icon(Icons.add,size: 30,),
      ),
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
                        trailing: InkWell(
                            child: SizedBox(width: 50,height: 50,child: Icon(Icons.call_rounded,size: 35,color: Colors.green,),),
                            onTap: ()=>AppController().CallDialog(context,[_list[index].cust_mobile,_list[index].cust_mobile2])),
                        //FlatButton(child: Icon(Icons.call_rounded,color: ,),onPressed: () => AppController().CallDialog(context, _list[_list.length - index - 1]),),
                        title: Text(_list[index].cust_name,style: Mystyle().InputStyle,),
                        subtitle: Text( "મોબાઇલ નં : " + _list[index].cust_mobile),
                        onTap: () => {RouteController().GoTo(context, Constants.LOAN_LIST_SCREEN,cust :_list[index])},
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

  getPDF(){
    if(isLoading && _list.length > 0){
      GetPDF().getCustList(_list);
    }
    else{
      AppController().showToast(text: Constants.NO_DATA);
    }

  }
  AddCustomer(){
    _nameController.text = "";
    _phoneController.text = "";
    _phone2Controller.text = "";
    _addressController.text = "";

    return showDialog(context: context,barrierDismissible: false,builder: (context)
    {

      List<String> namelist = [];
      List<String> addlist = [];

      for(var element in _Fulllist){
        addlist.add(element.cust_address.trim());
        namelist.add(element.cust_name.trim());
      }

      var addlist1 = addlist.toSet().toList();
      var namelist1 = namelist.toSet().toList();


      return StatefulBuilder(builder: (context, setState) => Dialog(
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
                  InputFieldArea3(hint: "ગ્રાહક નું નામ",icon: Icons.person,obscure: false,errorTxt: "ગ્રાહક નું નામ દાખલ કરો",controller: _nameController,suggestion: namelist1,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _phoneController,keyBoard: TextInputType.phone,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _phone2Controller,keyBoard: TextInputType.phone,required: false,),
                  SizedBox(height: 18,),
                  InputFieldArea3(hint: "સરનામું",icon: Icons.location_on,obscure: false,errorTxt: "સરનામું દાખલ કરો",controller: _addressController,suggestion: addlist1,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                            child: Text('ગ્રાહક ઉમેરો', style: TextStyle(color: Colors.black,fontSize: 20)),
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
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),);
    });
  }

  SearchFilter(String _searchTxt){
    print("enterd");
    setState(() {
      _list = _Fulllist.where((customer) => customer.cust_name.toLowerCase().contains(_searchTxt.toLowerCase())).toList();

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
     // AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }

  Future CustRegAPI() async {
    Response response;
    Dio dio = new Dio();

    var queryParameters = {
      'cust_name': _nameController.text.trim(),
      'cust_mobile': _phoneController.text.trim(),
      'cust_mobile2': _phone2Controller.text.trim(),
      'cust_address': _addressController.text.trim(),
    };

    //var json = jsonEncode(CustRegModel);

    try{
      response = await dio.post(Constants.API_ADDCUST, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if(resCode == Constants.CODE_SUCESS){
          _btnController.success();
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
         // AppController().ShowToast(text:msg,bgColor: Colors.red);
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
      //AppController().ShowToast(text: Constants.NO_INTERNET);
      _btnController.reset();
    }

    print("Response:- " + response.data.toString());
  }
  Future<void> GetCustAPI() async {
    isLoading = false;
    _Fulllist = new List<GetCustomer>();
    _list = new List<GetCustomer>();
    Response response;
    Dio dio = new Dio();

    try{



      response = await dio.get(Constants.API_GETCUST).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        if(nodata["response_code"] == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            for(var element in data){
              _Fulllist.insert(0,GetCustomer.fromJson(element));
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
