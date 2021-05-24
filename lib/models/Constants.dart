
class Constants{


  //TODO API Calling Urls
  static String API_LOGIN = "https://tathyatech.com/api/login.php";
  static String API_GETCUST = "https://tathyatech.com/api/showcustomer.php";
  static String API_ADDCUST = "https://tathyatech.com/api/register.php";
  static String API_GETLOANS = "https://tathyatech.com/api/showloan.php";
  static String API_ADDLOAN = "https://tathyatech.com/api/loanadd.php";
  static String API_GETEMIS = "https://tathyatech.com/api/showemidata.php";
  static String API_GETEMIONDATE = "https://tathyatech.com/api/dateonemidata.php";
  static String API_DELETELOAN = "https://tathyatech.com/api/deleteloan.php";
  static String API_UPDATEEMI = "https://tathyatech.com/api/emiupdate.php";
  static String API_ADDTEAM = "https://tathyatech.com/api/teamadd.php";
  static String API_SHOWTEAM = "https://tathyatech.com/api/showteam.php";
  static String API_GETTXN = "https://tathyatech.com/api/showtxndata.php";
  static String API_GETOTH = "https://tathyatech.com/api/showotherdata.php";
  static String API_UPDATETXN = "https://tathyatech.com/api/transectiondataupadate.php";
  static String API_OTHADD = "https://tathyatech.com/api/othdataadd.php";
  static String API_GETTLOAN = "https://tathyatech.com/api/tloanshow.php";
  static String API_GETTEMI = "https://tathyatech.com/api/tlemishow.php";
  static String API_UPDATETLAON = "https://tathyatech.com/api/tloanadd.php";
  static String API_UPDATETEMI = "https://tathyatech.com/api/tlemiupdate.php";
  static String API_ADDTLOAN = "https://tathyatech.com/api/tloanadd.php";
  static String API_DELETETLOAN = "https://tathyatech.com/api/tloandelete.php";
  static String  API_BANKDATA = "https://tathyatech.com/api/showbanckdata.php";
  static String  API_GETDATA = "https://tathyatech.com/api/checkbalance.php";
  static String  API_LOGS = "https://tathyatech.com/api/login_logs.php";
  static String  API_ALLDATA = "https://tathyatech.com/api/alldata.php";
  static String  API_PASSWORDUPDATE = "https://tathyatech.com/api/UpdatePassword.php";

  /*static String API_LOGIN = "https://tathyatech.com/api2/login.php";
  static String API_GETCUST = "https://tathyatech.com/api2/showcustomer.php";
  static String API_ADDCUST = "https://tathyatech.com/api2/register.php";
  static String API_GETLOANS = "https://tathyatech.com/api2/showloan.php";
  static String API_ADDLOAN = "https://tathyatech.com/api2/loanadd.php";
  static String API_GETEMIS = "https://tathyatech.com/api2/showemidata.php";
  static String API_GETEMIONDATE = "https://tathyatech.com/api2/dateonemidata.php";
  static String API_DELETELOAN = "https://tathyatech.com/api2/deleteloan.php";
  static String API_UPDATEEMI = "https://tathyatech.com/api2/emiupdate.php";
  static String API_ADDTEAM = "https://tathyatech.com/api2/teamadd.php";
  static String API_SHOWTEAM = "https://tathyatech.com/api2/showteam.php";
  static String API_GETTXN = "https://tathyatech.com/api2/showtxndata.php";
  static String API_GETOTH = "https://tathyatech.com/api2/showotherdata.php";
  static String API_UPDATETXN = "https://tathyatech.com/api2/transectiondataupadate.php";
  static String API_OTHADD = "https://tathyatech.com/api2/othdataadd.php";
  static String API_GETTLOAN = "https://tathyatech.com/api2/tloanshow.php";
  static String API_GETTEMI = "https://tathyatech.com/api2/tlemishow.php";
  static String API_UPDATETLAON = "https://tathyatech.com/api2/tloanadd.php";
  static String API_UPDATETEMI = "https://tathyatech.com/api2/tlemiupdate.php";
  static String API_ADDTLOAN = "https://tathyatech.com/api2/tloanadd.php";
  static String API_DELETETLOAN = "https://tathyatech.com/api2/tloandelete.php";
  static String  API_BANKDATA = "https://tathyatech.com/api2/showbanckdata.php";
  static String  API_GETDATA = "https://tathyatech.com/api2/checkbalance.php";
  static String  API_LOGS = "https://tathyatech.com/api2/login_logs.php";
  static String  API_ALLDATA = "https://tathyatech.com/api2/alldata.php";
  static String  API_PASSWORDUPDATE = "https://tathyatech.com/api2/UpdatePassword.php";*/



  static const Duration API_TIMEOUT = Duration(seconds: 20);

  static const String CODE_SUCESS = '200';
  static const String CODE_CONFLICT = '501';
  static const String CODE_NULL = '404';
  static const String CODE_UNREACHBLE = '500';
  static const String CODE_WRONG_INPUT = '400';



  //TODO Screen Navigation Constants
  static const String HOME_SCREEN       = "0x00N001";
  static const String LOGIN_SCREEN      = "0x00N002";
  static const String SPLASH_SCREEN     = "0x00N003";
  static const String CUST_LIST_SCREEN  = "0x00N010";
  static const String LOAN_LIST_SCREEN  = "0x00N110";
  static const String EMI_LIST_SCREEN   = "0x00N210";
  static const String TODAY_COLL_SCREEN = "0x00N020";
  static const String PEND_COLL_SCREEN  = "0x00N030";
  static const String COLL_BANK_SCREEN  = "0x00N040";
  static const String BANK_TOTAL_SCREEN = "0x00N050";
  static const String OTHER_EXP_SCREEN  = "0x00N060";
  static const String TEAM_LIST_SCREEN  = "0x00N070";
  static const String TLOAN_SCREEN  = "0x00N080";
  static const String TEMI_SCREEN  = "0x00N180";
  static const String TCALL_SCREEN  = "0x00N090";
  static const String CHANGE_PASS_SCREEN  = "0x00N090";
  static const String DASHBOARD  = "0x00N004";
  static const String LOG_SCREEN  = "0x00N005";


  static String DIR_PATH;
  static String DIR_LOAN;
  static String DIR_HISAB;
  static String DIR_INVESTOR;


  static String SelMonth = "1";
  static String SelYear = "2020";

  //TODO User Data
  static String USERNAME;
  static String USER_TYPE;
  static String USERID;

  //TODO TOAST NOTIFICATION

  static const String NO_INTERNET = "તમારું ઇન્ટરનેટ સેટીંગ ચેક કરો";
  static const String NO_REACHABILITY = "ડેટાબેસ પ્રોબ્લેમ";
  static const String MOBILE_EXIST = "મોબાઇલ નંબર ડેટાબેસ માં ઉપલબ્ધ છે";
  static const String NO_DATA = "કોઈ ડેટા ઉપલબ્ધ નથી";

  //TODO Images Path
  static String H_FONT_PATH = "assets/fonts/Rasa-Bold.ttf";
  static String T_FONT_PATH = "assets/fonts/Rasa-Regular.ttf";
  static String IMG_LOGO = "assets/img/logo.png";
  static String IMG_BG = "assets/img/bg.png";
  static String IMG_DASH = "assets/img/dashboard.png";
  static String IMG_CALL = "assets/img/call.png";
  static String IMG_MENU_0 = "assets/img/Menu_0.png";
  static String IMG_MENU_1 = "assets/img/Menu_1.png";
  static String IMG_MENU_2 = "assets/img/Menu_2.png";
  static String IMG_MENU_3 = "assets/img/Menu_3.png";
  static String IMG_MENU_4 = "assets/img/Menu_4.png";
  static String IMG_MENU_5 = "assets/img/Menu_5.png";
  static String IMG_MENU_6 = "assets/img/Menu_6.png";
  static String IMG_MENU_7 = "assets/img/Menu_7.png";
  static String IMG_MENU_8 = "assets/img/Menu_8.png";
  static String IMG_MENU_9 = "assets/img/Menu_9.png";
  static String IMG_MENU_10 = "assets/img/Menu_10.png";
  static List <String> IMG_MENU = [IMG_MENU_0,
    IMG_MENU_1,IMG_MENU_2,IMG_MENU_3,
    IMG_MENU_4,IMG_MENU_5,IMG_MENU_6,
    IMG_MENU_7,IMG_MENU_8,IMG_MENU_9,
    IMG_MENU_10];

  static List <String> Months = ["0","જાન્યુઆરી","ફેબ્રુઆરી","માર્ચ","એપ્રિલ","મે","જૂન","જુલાઈ","ઓગસ્ટ","સપ્ટેમ્બર",'ઓક્ટોબર','નવેમ્બર',"ડિસેમ્બર"];
  //TODO Menu Names
  static List <String> MENU_NAMES = ["હોમ પેજ",
                                    "ગ્રાહક લિસ્ટ", "આજ નું કલેક્શન", "બાકી કલેક્શન",
                                    "પેઢી માં જમા", "પેઢી હિસાબ", "અન્ય ખર્ચ",
                                    "સભ્યો ની યાદી","લોન ની યાદી", "હપ્તા ચુકવણી",
                                    "લોગ આઉટ"];
}