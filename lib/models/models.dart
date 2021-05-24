class OthList{
  String id;
  String amount;
  String type;
  String detiles;
  String from;
  String date;
  String to;
  String from_name;
  String to_name;

  OthList({
    this.id,
    this.type,
    this.detiles,
    this.amount,
    this.from,
    this.date,
    this.to,
    this.from_name,
    this.to_name
  });

  OthList.fromJson(Map<String, dynamic> json) {
    id = json["oth_id"];
    amount = json["oth_amount"];
    type = json["oth_type"];
    detiles = json["oth_detiles"];
    from = json["oth_from"];
    date = json["oth_date"];
    to = json["oth_to"];
    from_name = json["oth_from_name"];
    to_name = json["oth_to_name"];
  }

}
class TxnList{
  String id;
  String date;
  String panalti_amount;
  String emi_amount;
  String from;
  String receive_date;
  String to;
  String status;
  String from_name;
  String to_name;

  TxnList({
    this.id,
    this.date,
    this.panalti_amount,
    this.emi_amount,
    this.from,
    this.receive_date,
    this.to,
    this.status,
    this.from_name,
    this.to_name
  });

  TxnList.fromJson(Map<String, dynamic> json) {
    id = json["txn_id"];
    date = json["txn_date"];
    panalti_amount = json["txn_panalti_amount"];
    emi_amount = json["txn_emi_amount"];
    from = json["txn_from"];
    receive_date = json["txn_receive_date"];
    to = json["txn_to"];
    status = json["txn_status"];
    from_name = json["txn_from_name"];
    to_name = json["txn_to_name"];
  }

}
class GivenList{


  String temi_id;
  String tl_loan_id;
  String temi_date;
  String temi_amount;
  String temi_given_date;
  String temi_status;
  String temi_given_by;
  String name;




  GivenList(
      {
        this.temi_id,
        this.tl_loan_id,
        this.temi_date,
        this.temi_amount,
        this.temi_given_date,
        this.temi_status,
        this.temi_given_by,
        this.name
      });

  GivenList.fromJson(Map<String, dynamic> json) {
    temi_id = json["temi_id"];
    tl_loan_id = json["tl_loan_id"];
    temi_date = json["temi_date"];
    temi_amount = json["temi_amount"];
    temi_given_date = json["temi_given_date"];
    temi_status = json["temi_status"];
    temi_given_by = json["temi_given_by"];
    name = json["tl_name"];
  }
}
class TotalList{


 String loan_id;
 String loan_amount;
 String loan_status;
 String loan_date;
 String loan_given_amount;
 String loan_emi_amount;
 String loan_total_emi;
 String loan_no;
 String cust_id;
 String cust_name;
 String cust_mobile;
 String loan_emi_day;
 String loan_coumtemi;


  TotalList(
      {
        this.loan_id,
        this.loan_amount,
        this.loan_status,
        this.loan_date,
        this.loan_given_amount,
        this.loan_emi_amount,
        this.loan_total_emi,
        this.loan_no,
        this.cust_id,
        this.cust_name,
        this.cust_mobile,
        this.loan_emi_day,
        this.loan_coumtemi
      });

  TotalList.fromJson(Map<String, dynamic> json) {
    loan_id = json["loan_id"];
    loan_amount = json["loan_amount"];
    loan_status = json["loan_status"];
    loan_date = json["loan_date"];
    loan_given_amount = json["loan_given_amount"];
    loan_emi_amount = json["loan_emi_amount"];
    loan_total_emi = json["loan_total_emi"];
    loan_no = json["loan_no"];
    cust_id = json["cust_id"];
    cust_name = json["cust_name"];
    cust_mobile = json["cust_mobile"];
    loan_emi_day = json["loan_emi_day"];
    loan_coumtemi = json["loan_coumtemi"]??"0";
  }
}
class CollectionList{


  String emi_id;
  String emi_amount;
  String emi_rcvd_by;
  String emi_status;
  String cust_id;
  String loan_id;
  String emi_rcvd_id;
  String cust_name;
  String cust_mobile;
  String cust_mobile2;
  String loan_no;
  String emi_date;



  CollectionList(
      {
        this.emi_id,
        this.emi_date,
        this.emi_amount,
        this.emi_rcvd_by,
        this.emi_status,
        this.cust_id,
        this.loan_id,
        this.emi_rcvd_id,
        this.cust_name,
        this.cust_mobile,
        this.cust_mobile2,
        this.loan_no
      });

  CollectionList.fromJson(Map<String, dynamic> json) {
    emi_id = json["emi_id"];
    emi_amount = json["emi_amount"];
    emi_rcvd_by = json["emi_rcvd_by"];
    emi_status = json["emi_status"];
    cust_id = json["cust_id"];
    loan_id = json["loan_id"];
    emi_rcvd_id = json["emi_rcvd_id"];
    cust_name = json["cust_name"];
    cust_mobile = json["cust_mobile"];
    cust_mobile2 = json["cust_mobile2"];
    loan_no = json["loan_no"];
    emi_date = json["emi_date"];
  }
}
class GetTeam{

  String tm_id;
  String tm_name;
  String tm_mobile;
  String tm_type;
  String tm_pass;
  String tm_status;


  GetTeam({this.tm_id,this.tm_name,this.tm_mobile,this.tm_type,this.tm_pass,this.tm_status});

  GetTeam.fromJson(Map<String, dynamic> json) {
    tm_id = json['tm_id'];
    tm_name = json['tm_name'];
    tm_mobile = json['tm_mobile'];
    tm_type = json['tm_type'];
    tm_pass = json['tm_pass'];
    tm_status = json['tm_status'];
  }
}
class GetLoans{
  String id;
  String amount;
  String status;
  String date;
  String given_amount;
  String emi_amount;
  String total_emi;
  String loan_no;
  String emi_day;

  GetLoans({this.id,this.amount,this.status,this.date,this.given_amount,this.emi_amount,this.total_emi,this.loan_no,this.emi_day});

  GetLoans.fromJson(Map<String, dynamic> json) {
    id = json['loan_id'];
    amount = json['loan_amount'];
    status = json['loan_status'];
    date = json['loan_date'];
    given_amount = json['loan_given_amount'];
    emi_amount = json['loan_emi_amount'];
    total_emi = json['loan_total_emi'];
    loan_no = json['loan_no'];
    emi_day = json['loan_emi_day'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   // data['custname'] = this.cust_name;
//   // data['custnumber'] = this.cust_mobile;
//   // data['custnumber2'] = this.cust_mobile2;
//   // data['custaddress'] = this.cust_address;
//
//   return data;
// }


}
class LoanReg{

  String custid;
  String loanamount;
  String givanamount;
  String emiamount;
  String totalemi;
  String emaiday;
  String issuebay;

  LoanReg({this.custid,this.emaiday,this.emiamount,this.givanamount,this.issuebay,this.loanamount,this.totalemi});
}
class GetEmi{
  String  id;
  String  date;
  String  rcvd_date;
  String  pnlti;
  String  rcvd;
  String  rcvd_by;
  String  status;

  GetEmi({this.id,this.rcvd_date,this.status,this.date,this.pnlti,this.rcvd,this.rcvd_by});

  GetEmi.fromJson(Map<String, dynamic> json) {
    id = json[ "emi_id"];
    date = json["emi_date"];
    rcvd_date = json["emi_rcvd_date"];
    pnlti = json["emi_pnlti"];
    rcvd = json["emi_rcvd"];
    rcvd_by = json["emi_rcvd_by"];
    status = json["emi_status"];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   // data['custname'] = this.cust_name;
//   // data['custnumber'] = this.cust_mobile;
//   // data['custnumber2'] = this.cust_mobile2;
//   // data['custaddress'] = this.cust_address;
//
//   return data;
// }


}
class GetTLoan{
  String tl_id;
  String tl_name;
  String tl_mobile;
  String tl_date;
  String tl_amount;
  String tl_advace;
  String tl_irate;
  String tl_month;
  String tl_emi;
  String tl_status;

  GetTLoan({
    this.tl_id,
    this.tl_name,
    this.tl_mobile,
    this.tl_date,
    this.tl_amount,
    this.tl_advace,
    this.tl_irate,
    this.tl_month,
    this.tl_emi,
    this.tl_status});

  GetTLoan.fromJson(Map<String, dynamic> json) {
    tl_id = json["tl_id"];
    tl_name = json["tl_name"];
    tl_mobile = json["tl_mobile"];
    tl_date = json["tl_date"];
    tl_amount = json["tl_amount"];
    tl_advace = json["tl_advace"];
    tl_irate = json["tl_irate"];
    tl_month = json["tl_month"];
    tl_emi = json["tl_emi"];
    tl_status = json["tl_status"];
  }
}
class GetTEmi{

  String temi_id;
  String tl_loan_id;
  String temi_date;
  String temi_amount;
  String temi_given_date;
  String temi_status;
  String temi_given_by;
  String tm_name;


  GetTEmi({
    this.temi_id,
    this.tl_loan_id,
    this.temi_date,
    this.temi_amount,
    this.temi_given_date,
    this.temi_status,
    this.temi_given_by,
    this.tm_name
  });

  GetTEmi.fromJson(Map<String, dynamic> json) {
    temi_id = json["temi_id"];
    tl_loan_id = json["tl_loan_id"];
    temi_date = json["temi_date"];
    temi_amount = json["temi_amount"];
    temi_given_date = json["temi_given_date"];
    temi_status = json["temi_status"];
    temi_given_by = json["temi_given_by"];
    tm_name = json["tm_name"];
  }
}
class GetCustomer{

  String cust_id;
  String cust_name;
  String cust_mobile;
  String cust_mobile2;
  String cust_address;


  GetCustomer({this.cust_id,this.cust_name,this.cust_mobile,this.cust_mobile2,this.cust_address});

  GetCustomer.fromJson(Map<String, dynamic> json) {
    cust_id = json['cust_id'];
    cust_name = json['cust_name'];
    cust_mobile = json['cust_mobile'];
    cust_mobile2 = json['cust_mobile2'];
    cust_address = json['cust_address'];
  }
}
class GetLog{

  String log_id;
  String log_tmid;
  String log_time;
  String log_tm_name;


  GetLog({this.log_id,this.log_tmid,this.log_time,this.log_tm_name});

  GetLog.fromJson(Map<String, dynamic> json) {
    log_id = json['log_id'];
    log_tmid = json['log_tmid'];
    log_time = json['log_time'];
    log_tm_name = json['log_tm_name'];
  }
}
class BankData{


  String Id;
  String bl_date;
  String bl_open;
  String bl_saving;
  String bl_loan_amt;
  String bl_emi_amount;
  String bl_penlti_amount;
  String bl_loan_expance;
  String bl_loan_given;
  String bl_other_expance;
  String bl_other_income;
  String bl_cloas;

  BankData({
    this.Id,
    this.bl_date,
    this.bl_open,
    this.bl_saving,
    this.bl_loan_amt,
    this.bl_emi_amount,
    this.bl_penlti_amount,
    this.bl_loan_expance,
    this.bl_loan_given,
    this.bl_other_expance,
    this.bl_other_income,
    this.bl_cloas
  });

  BankData.fromJson(Map<String, dynamic> json) {
    Id = json["Id"];
    bl_date = json["bl_date"];
    bl_open = json["bl_open"];
    bl_saving = json["bl_saving"];
    bl_loan_amt = json["bl_loan_amt"];
    bl_emi_amount = json["bl_emi_amount"];
    bl_penlti_amount = json["bl_penlti_amount"];
    bl_loan_expance = json["bl_loan_expance"];
    bl_loan_given = json["bl_loan_given"];
    bl_other_expance = json["bl_other_expance"];
    bl_other_income = json["bl_other_income"];
    bl_cloas = json["bl_cloas"];
  }
}
class Login{
  String username;
  String password;

  Login({this.username,this.password});


  Login.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }

}
class AllData{
  String name;
  String details;
  String amount;
  String date;

  AllData({this.name,this.details,this.amount,this.date});
}