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
import 'package:smart_select/smart_select.dart';


class OTHER_EXP extends StatefulWidget {
  int PageIndex;
  OTHER_EXP({this.PageIndex});

  @override
  _OTHER_EXPState createState() => _OTHER_EXPState(PageIndex: this.PageIndex);
}

class _OTHER_EXPState extends State<OTHER_EXP> {

  final int PageIndex;
  final _searchController = new TextEditingController();
  final _amtController = new TextEditingController();
  final _detController = new TextEditingController();
  final _dateController = new TextEditingController();

  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String month = Constants.SelMonth;
  String year = Constants.SelYear;
  final _btnController = new RoundedLoadingButtonController();

  bool isMember = Constants.USER_TYPE == "3" ? true : false;

  List<S2Choice<String>> team = [];

  int _radioValue = 0;
  String _dropValue = null;

  final _formKey = GlobalKey<FormState>();

  // simple usage
  List <OthList> _Fulllist = [];
  List <OthList> _list =[];

  _OTHER_EXPState({this.PageIndex});

  void initState(){
    super.initState();
    GetTxnAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);
      _dateController.text = DateTime.now().toString();
    });
    GetTeamList();
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }
  getPDF(){
    if(isLoading && _list.length > 0){

      String title;
      if(month == "0"){
        title = "$year";
      }
      else{
        title = "${Constants.Months[int.parse(month)] } $year";
      }
      GetPDF().getOthList(_list, title);
    }
    else{
      AppController().ShowToast(text: Constants.NO_DATA);
    }
  }
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
      floatingActionButton: !isMember ?FloatingActionButton(
        onPressed: () => AddExp(),
        child: Icon(Icons.add,size: 30,),
      ) : Container() ,
      drawer: MyDrawer(PageIndex),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MainCard(),
            isLoading ? OTHER_EXP != null && _list.length > 0 ? ListCard()
                : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),)
                : Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    ), onWillPop: _onWillPop);
  }

  Future<void> GetTeamList() async {

      var list = new List<GetTeam>();
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
                list.insert(0,GetTeam.fromJson(element));
              }
              for(int i = 0;i < list.length;i++){
                team.add(S2Choice(value: list[i].tm_id, title:list[i].tm_name));
              }
            });
            print(team);
          }
          else if(nodata["response_code"] == Constants.CODE_NULL){
            //AppController().ShowToast(text: "Database Error");
          }
        }
        else {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
        }
        //print("GetData Response : ${response.data}");
      }
      catch(e){
        print(e.toString());
        AppController().ShowToast(text: Constants.NO_INTERNET);
      }
  }
  AddExp() {
    //_selectedLocation =_locations[0];
    String _selectedLocation;
    return showDialog(context: context,barrierDismissible: false,builder: (context)
    {
      return StatefulBuilder(builder: (context, setState){
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            activeColor: Colors.cyan,
                            value: 0,
                            groupValue: _radioValue,
                            onChanged:  (value){
                              setState(() {
                                _radioValue = value;
                              });
                            }
                        ),
                        Text("આવક",style: Mystyle().InputStyle,),
                        SizedBox(width: 20,),
                        Radio(
                            activeColor: Colors.cyan,
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: (value){
                              setState(() {
                                _radioValue = value;
                              });
                            }
                        ),
                        Text("ખર્ચ",style: Mystyle().InputStyle,),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                      child: DropdownButton(
                        isDense: true,
                          style: Mystyle().InputStyle,
                          icon: Icon(Icons.person_rounded),
                          iconSize: 40,
                          isExpanded: true,
                          hint: Text('સભ્ય નું નામ',style: Mystyle().InputStyle,), // Not necessary for Option 1
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation = newValue;
                              _dropValue =  _selectedLocation;
                              print("$_selectedLocation");
                            });
                          },
                          value: _selectedLocation,
                          items: team.map((member) {
                            return DropdownMenuItem(
                              child: new Text(member.title,style: Mystyle().InputStyle,),
                              value: member.value,
                            );
                          }).toList(),
                    ),
                    ),
                    SizedBox(height: 13,),
                    AppController().DatePicker(_dateController),
                    SizedBox(height: 13,),
                    InputFieldArea2(hint: "રકમ",icon: Icons.money,errorTxt: "રકમ દાખલ કરો",maxLen: 10,controller: _amtController,keyBoard: TextInputType.number,onChanged: (value) {},),
                    SizedBox(height: 18,),
                    InputFieldArea2(hint: "વિગત",icon: Icons.list_alt,errorTxt: "વિગત દાખલ કરો",maxLen: 10,controller: _detController,onChanged: (value) {},),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: SizedBox(
                        width: double.infinity, //Full width
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedLoadingButton(
                              child: Text('ડાયરી ઉમેરો', style: TextStyle(color: Colors.black,fontSize: 20)),
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
                                print(_dateController.text);

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
    });
  }

  MainCard() {
    List<S2Choice<String>> years = new List();
    int cyear = DateTime.now().year;
    for(int i = cyear;i >2018;i--){
      years.add(new S2Choice(value: "$i", title: "$i"));
    }
    List<S2Choice<String>> months = new List();
    for(int i = 0; i < 13; i++){
      months.add(new S2Choice(value: "$i", title: Constants.Months[i]));
    }

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Card(
                  shape: Mystyle().RoundShape,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: SmartSelect<String>.single(
                        title: 'Year',
                        value: year,
                        choiceItems: years,
                        choiceType: S2ChoiceType.chips,
                        modalType: S2ModalType.bottomSheet,
                        onChange: (state) => setState(()
                        {
                          year = state.value;
                          RefreshData();
                        })
                    ),),
                ),
                Card(
                  shape: Mystyle().RoundShape,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SmartSelect<String>.single(
                        title: 'Month',
                        value: month,
                        choiceItems: months,
                        choiceType: S2ChoiceType.chips,
                        modalType: S2ModalType.bottomSheet,
                        onChange: (state) => setState(()
                        {
                          month = state.value;
                          RefreshData();
                        })
                    ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  ListCard() {
    return Expanded(child: ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      itemCount: _list.length,
      itemBuilder: (context,index){
        return Card(
          color: index%2 == 0 ? Colors.grey[200]:Colors.white,
          shape: Mystyle().RoundShape,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(
                _list[index].to_name??"બહાર થી લાવેલ",
                style: Mystyle().InputStyle
            ),
            trailing: Text('${int.parse(_list[index].amount)}',style: new TextStyle(fontSize: 25,color: _list[index].type == "0" ? Colors.green : Colors.red),),
            subtitle:  Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("તારીખ : ${_list[index].date}",style: Mystyle().subText,),
                Text("વિગત : ${_list[index].detiles}",style: Mystyle().subText,),
              ],
            ),
          ),
        );
      },
    ));
  }
  SearchFilter(String _searchTxt) {
    print("enterd");
    setState(() {
      _list = _Fulllist.where((txn) => txn.to_name.toLowerCase().contains(_searchTxt.toLowerCase())).toList();

    });
    //print(_list);
  }
  RefreshData() {

    isLoading = false;
    GetTxnAPI().whenComplete(()
    {
      isLoading = true;
      _list = List.from(_Fulllist);

      AppController().setSelMY(month,year);
    });
  }

  void _doSomething() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AddTxnAPI().whenComplete(() {
        Navigator.of(context).pop();
        GetTxnAPI().whenComplete(() {
          isLoading = true;
          _list = List.from(_Fulllist);
        });
      });
    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }

  Future<void> AddTxnAPI() async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();

    try {
      var queryParameters = {
        "oth_amount":_amtController.text,
        "oth_type" : _radioValue.toString(),
        "oth_details": _detController.text,
        "oth_by": Constants.USERID,
        "oth_ricived_by": _dropValue,
        'date' : _dateController.text
      };

      response = await dio.post(Constants.API_OTHADD, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if (resCode == Constants.CODE_SUCESS) {
          setState(() {
            _btnController.success();
          });
        } else if (resCode == Constants.CODE_WRONG_INPUT) {
          //AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_CONFLICT) {
          //AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
      }
    } catch (e) {
      print("excep " + e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }

  Future<void> GetTxnAPI() async {

    _Fulllist = new List();

    Response response;
    Dio dio = new Dio();

    try{
      var queryParameters;
      if(month != "0"){
        queryParameters = {'year': year, 'month' : month};
      }
      else{
        queryParameters = {'year': year};
      }
      print(queryParameters);

      response = await dio.post(Constants.API_GETOTH,data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        print(nodata);

        if(resCode == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            for(var element in data){
              _Fulllist.add(OthList.fromJson(element));
            }
            isLoading =true;
          });
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        }
        else if(resCode == Constants.CODE_CONFLICT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        }
        else if (resCode == Constants.CODE_NULL) {
          AppController().ShowToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
      }
    }
    catch(e){
      print("excep "+e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }
}



