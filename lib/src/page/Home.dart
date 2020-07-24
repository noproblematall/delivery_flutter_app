import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transporter/src/model/OrdersModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:transporter/src/page/Login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final args;

  Home({this.args});

  static const String routeName = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _HomeState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          if(this.orderFlag){
            filteredListOrders = listOrders;
          }else{
            filteredListOrders = listCompletedOrders;
          }
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          checkList(this.orderFlag);
          print("triger(home constructor)");
        });
      }
    });
  }
//  String urlApi = "https://transporter.group/wp-json/wc/v1/order/1";
  final TextEditingController _filter = new TextEditingController();
  // final TextEditingController _initNote = new TextEditingController();
  String tempNote = "";
  String _searchText = "";
  String user = "";
  int idUser = 0;
  bool saleFlag;
  int currentIndex = 0;
  bool orderFlag = true;

  List<OrdersModel> listOrders = [];
  List<OrdersModel> listCompletedOrders = [];
  List<OrdersModel> filteredListOrders = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('ترتيب الحالة', textDirection: TextDirection.rtl,);

  _launchURL(BuildContext context, String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("الرقم خاطئ.", textDirection: TextDirection.rtl,),
      ));
      // throw 'Could not launch $url';
    }
  }

  void onSomeMethod(String id, String desc) async {
    switch (desc) {
      case 'complete':
        {
          var hello = await http.get(
              "https://transporter.group/wp-json/wc/v1/orderstatus/$id/Completed");
          print(
              "https://transporter.group/wp-json/wc/v1/orderstatus/$id/complete");
        }
        break;
      case 'cancel':
        {
          var hello = await http.get(
              "https://transporter.group/wp-json/wc/v1/orderstatus/$id/Cancelled");
          print(
              "https://transporter.group/wp-json/wc/v1/orderstatus/$id/cancel");
        }
        break;

      case 'process':
        {
          var hello = await http.get(
              "https://transporter.group/wp-json/wc/v1/orderstatus/$id/Processing");
          print(
              "https://transporter.group/wp-json/wc/v1/orderstatus/$id/process");
        }
        break;
    }
  }

  void onTabTapped(int index) async {
    setState(() {
      currentIndex = index;
    });

    switch (currentIndex) {
      case 0:
        {
          print("======");
          setState(() {
            this.orderFlag = true;
            _filter.clear();
            this._searchText = '';
            filteredListOrders = listOrders;
          });
        }
        break;

      case 1:
        {}
        break;
      case 2:
        {
          print("+++++++");
          setState(() {
            this.orderFlag = false;
            _filter.clear();
            this._searchText = '';
            filteredListOrders = listCompletedOrders;
          });
        }
        break;
    }
  }

  void savNote(BuildContext context, String note, String id) async {
    String url = 'https://transporter.group/wp-json/wc/v1/note';
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'orderId': id, 'save_note': note}));
    if (response.body == "1") {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("يتم حفظ الملاحظة.", textDirection: TextDirection.rtl,),
      ));
    }
  }

  void fetchApi() async {
    print("FetchApi start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idInLocal = prefs.getString("id");
    saleFlag = prefs.getBool("saleFlag");
    String urlApi =
        "https://transporter.group/wp-json/wc/v1/order/$idInLocal/$saleFlag";
    print(urlApi);
    var datajson = await http.get(urlApi);
    var jsonDecoded = json.decode(datajson.body);
    
    List<OrdersModel> tempListOrders = [];
    List<OrdersModel> tempListCompletedOrders = [];
    if (jsonDecoded is List) {
      for (var index = 0; index < jsonDecoded.length; index++) {
        if (jsonDecoded[index]['Order_Status'] == 'Completed' || jsonDecoded[index]['Order_Status'] == 'Cancelled') {
          if (jsonDecoded[index]['Order_Status'] == 'Completed') {
            jsonDecoded[index]['Order_Status'] = 'منجز';
          } else if (jsonDecoded[index]['Order_Status'] == 'Cancelled') {
            jsonDecoded[index]['Order_Status'] = 'ألغيت';
          }
          tempListCompletedOrders.add(OrdersModel(
            Customer_Created: jsonDecoded[index]['Customer_Created'] ?? "",
            Customer_Email: jsonDecoded[index]['Customer_Email'] ?? "",
            Customer_FEUP_ID: jsonDecoded[index]['Customer_FEUP_ID'] ?? "",
            Customer_ID: jsonDecoded[index]['Customer_ID'] ?? "",
            Customer_Name: jsonDecoded[index]['Customer_Name'] ?? "",
            Customer_WP_ID: jsonDecoded[index]['Customer_WP_ID'] ?? "",
            Order_Customer_Notes:
                jsonDecoded[index]['Order_Customer_Notes'] ?? "",
            Order_Display: jsonDecoded[index]['Order_Display'] ?? "",
            Order_Email: jsonDecoded[index]['Order_Email'] ?? "",
            Order_External_Status:
                jsonDecoded[index]['Order_External_Status'] ?? "",
            Order_ID: jsonDecoded[index]['Order_ID'] ?? "",
            Order_Location: jsonDecoded[index]['Order_Location'] ?? "",
            Order_Name: jsonDecoded[index]['Order_Name'] ?? "",
            Order_Notes_Private:
                jsonDecoded[index]['Order_Notes_Private'] ?? "",
            Order_Notes_Public: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Order_Number: jsonDecoded[index]['Order_Number'] ?? "",
            Order_Payment_Completed:
                jsonDecoded[index]['Order_Payment_Completed'] ?? "",
            Order_Payment_Price:
                jsonDecoded[index]['Order_Payment_Price'] ?? "",
            Order_PayPal_Receipt_Number:
                jsonDecoded[index]['Order_PayPal_Receipt_Number'] ?? "",
            Order_Status: jsonDecoded[index]['Order_Status'] ?? "",
            Order_Status_Updated:
                jsonDecoded[index]['Order_Status_Updated'] ?? "",
            Order_Tracking_Link_Clicked:
                jsonDecoded[index]['Order_Tracking_Link_Clicked'] ?? "",
            Order_Tracking_Link_Code:
                jsonDecoded[index]['Order_Tracking_Link_Code'] ?? "",
            Order_View_Count: jsonDecoded[index]['Order_View_Count'] ?? "",
            Sales_Rep_Created: jsonDecoded[index]['Sales_Rep_Created'] ?? "",
            Sales_Rep_Email: jsonDecoded[index]['Sales_Rep_Email'] ?? "",
            Sales_Rep_First_Name:
                jsonDecoded[index]['Sales_Rep_First_Name'] ?? "",
            Sales_Rep_ID: jsonDecoded[index]['Sales_Rep_ID'] ?? "",
            Sales_Rep_Last_Name:
                jsonDecoded[index]['Sales_Rep_Last_Name'] ?? "",
            Sales_Rep_WP_ID: jsonDecoded[index]['Sales_Rep_WP_ID'] ?? "",
            WooCommerce_ID: jsonDecoded[index]['WooCommerce_ID'] ?? "",
            Zendesk_ID: jsonDecoded[index]['Zendesk_ID'] ?? "",
            Note: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Phone: jsonDecoded[index]['Phone'] ?? "",
            Final_Price: jsonDecoded[index]['Final_Price'] ?? "",
            Driver_Price: jsonDecoded[index]['Driver_Price'] ?? "",
            Customer_Price: jsonDecoded[index]['Customer_Price'] ?? "",
          ));
        } else {
          if(jsonDecoded[index]['Order_Status'] == 'Processing'){
            jsonDecoded[index]['Order_Status'] = 'معالجة';

          }
          tempListOrders.add(OrdersModel(
            Customer_Created: jsonDecoded[index]['Customer_Created'] ?? "",
            Customer_Email: jsonDecoded[index]['Customer_Email'] ?? "",
            Customer_FEUP_ID: jsonDecoded[index]['Customer_FEUP_ID'] ?? "",
            Customer_ID: jsonDecoded[index]['Customer_ID'] ?? "",
            Customer_Name: jsonDecoded[index]['Customer_Name'] ?? "",
            Customer_WP_ID: jsonDecoded[index]['Customer_WP_ID'] ?? "",
            Order_Customer_Notes:
                jsonDecoded[index]['Order_Customer_Notes'] ?? "",
            Order_Display: jsonDecoded[index]['Order_Display'] ?? "",
            Order_Email: jsonDecoded[index]['Order_Email'] ?? "",
            Order_External_Status:
                jsonDecoded[index]['Order_External_Status'] ?? "",
            Order_ID: jsonDecoded[index]['Order_ID'] ?? "",
            Order_Location: jsonDecoded[index]['Order_Location'] ?? "",
            Order_Name: jsonDecoded[index]['Order_Name'] ?? "",
            Order_Notes_Private:
                jsonDecoded[index]['Order_Notes_Private'] ?? "",
            Order_Notes_Public: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Order_Number: jsonDecoded[index]['Order_Number'] ?? "",
            Order_Payment_Completed:
                jsonDecoded[index]['Order_Payment_Completed'] ?? "",
            Order_Payment_Price:
                jsonDecoded[index]['Order_Payment_Price'] ?? "",
            Order_PayPal_Receipt_Number:
                jsonDecoded[index]['Order_PayPal_Receipt_Number'] ?? "",
            Order_Status: jsonDecoded[index]['Order_Status'] ?? "",
            Order_Status_Updated:
                jsonDecoded[index]['Order_Status_Updated'] ?? "",
            Order_Tracking_Link_Clicked:
                jsonDecoded[index]['Order_Tracking_Link_Clicked'] ?? "",
            Order_Tracking_Link_Code:
                jsonDecoded[index]['Order_Tracking_Link_Code'] ?? "",
            Order_View_Count: jsonDecoded[index]['Order_View_Count'] ?? "",
            Sales_Rep_Created: jsonDecoded[index]['Sales_Rep_Created'] ?? "",
            Sales_Rep_Email: jsonDecoded[index]['Sales_Rep_Email'] ?? "",
            Sales_Rep_First_Name:
                jsonDecoded[index]['Sales_Rep_First_Name'] ?? "",
            Sales_Rep_ID: jsonDecoded[index]['Sales_Rep_ID'] ?? "",
            Sales_Rep_Last_Name:
                jsonDecoded[index]['Sales_Rep_Last_Name'] ?? "",
            Sales_Rep_WP_ID: jsonDecoded[index]['Sales_Rep_WP_ID'] ?? "",
            WooCommerce_ID: jsonDecoded[index]['WooCommerce_ID'] ?? "",
            Zendesk_ID: jsonDecoded[index]['Zendesk_ID'] ?? "",
            Note: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Phone: jsonDecoded[index]['Phone'] ?? "",
            Final_Price: jsonDecoded[index]['Final_Price'] ?? "",
            Driver_Price: jsonDecoded[index]['Driver_Price'] ?? "",
            Customer_Price: jsonDecoded[index]['Customer_Price'] ?? "",
          ));
          
        }
      }
    }
    setState(() {
      listOrders = tempListOrders;
      listCompletedOrders = tempListCompletedOrders;
      print('I am orderFlag ${this.orderFlag}');
      if (this.orderFlag) {
        filteredListOrders = listOrders;
      }else{
        filteredListOrders = listCompletedOrders;
      }
      
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          textDirection: TextDirection.rtl,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'بحث...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('ترتيب الحالة', textDirection: TextDirection.rtl,);
        filteredListOrders = listOrders;
        _filter.clear();
      }
    });
  }

  setAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString("user", user);
//    await prefs.setString("pass", idUser.toString());
    await prefs.setBool("isAuthentication", true);
    print("Home setAuthentication done");
  }

  @override
  void initState() {
    setState(() {
      idUser = widget.args[0];
      user = widget.args[1];
      // saleFlag = widget.args[2];
      // print('Home initState $saleFlag');
    });
    setAuthentication();

    fetchApi();
    super.initState();
  }

  Future<void> showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'المستخدم الحالي: $user',
            style: GoogleFonts.quicksand(),textDirection: TextDirection.rtl,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'هل ترغب بالخروج؟',
                  style: GoogleFonts.quicksand(),textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('لا', style: GoogleFonts.quicksand(), textDirection: TextDirection.rtl,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'نعم',
                style: GoogleFonts.quicksand(),textDirection: TextDirection.rtl,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool("isAuthentication", false);
                // await prefs.setBool("saleFlag", true);
                Navigator.pushReplacementNamed(context, Login.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirmDialog(String id, String desc, int index) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تؤكد', style: GoogleFonts.quicksand(), textDirection: TextDirection.rtl,),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                Text('هل تريد ان $desc ?', style: GoogleFonts.quicksand(), textDirection: TextDirection.rtl,)
              ],
            )),
            actions: <Widget>[
              FlatButton(
                child: Text('لا', style: GoogleFonts.quicksand(), textDirection: TextDirection.rtl,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(
                    'نعم',
                    style: GoogleFonts.quicksand(),textDirection: TextDirection.rtl,
                  ),
                  onPressed: () {
                    if (desc == 'complete' || desc == 'cancel') {
                      List<OrdersModel> _temp = [];
                      setState(() {
                        if (desc == 'complete') {
                          filteredListOrders[index].Order_Status = 'منجز';
                          
                        }else if(desc == 'cancel'){
                        filteredListOrders[index].Order_Status = 'ألغيت';

                        }
                        listCompletedOrders.add(filteredListOrders[index]);
                      });
                      for (int i = 0; i < filteredListOrders.length; i++) {
                        if (i != index) {
                          _temp.add(filteredListOrders[i]);
                        }
                      }
                      setState(() {
                        filteredListOrders = _temp;
                      });
                    }
                    onSomeMethod(id, desc);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            showLogoutDialog();
          },
          child: CircleAvatar(
            child: Icon(
              Icons.account_circle,
              size: 38,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  void checkList(bool orderFlag) {
    if (_searchText.isNotEmpty) {
      if(orderFlag){
        List<OrdersModel> tempList = [];
        print("triger111(home)");
        for (int i = 0; i < listOrders.length; i++) {
          if (listOrders[i]
              .Order_Number
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
            tempList.add(listOrders[i]);
          }
        }
        filteredListOrders = tempList;
      }else{
        List<OrdersModel> tempList = [];
        print("triger111(home)");
        for (int i = 0; i < listCompletedOrders.length; i++) {
          if (listCompletedOrders[i]
              .Order_Number
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
            tempList.add(listCompletedOrders[i]);
          }
        }
        filteredListOrders = tempList;
      }
    }
  }

  Widget _buildList() {
    checkList(this.orderFlag);
    print("triger222(home)");
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: saleFlag == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[                            
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  size: 25,
                                ),
                                color: Colors.white,
                                tooltip:
                                    '${filteredListOrders[index].Phone.toString()}',
                                onPressed: () {
                                  _launchURL(
                                      context,
                                      filteredListOrders[index]
                                          .Phone
                                          .toString());
                                },
                              ),
                            )
                          ],
                        )
                      : Container(),
                ),
                Text(
                    "اسم الزبون: ${filteredListOrders[index].Customer_Name.toString().toUpperCase()}",
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,
                  ),
                Text(
                  "الحالة: ${filteredListOrders[index].Order_Status.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey), textDirection: TextDirection.rtl,
                ),
                Text(
                  "هوية شخصية: ${filteredListOrders[index].Order_Number.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey), textDirection: TextDirection.rtl,
                ),
                Text(
                  "ملحوظة: ${filteredListOrders[index].Note.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey), textDirection: TextDirection.rtl,
                ),
                Text(
                  "السعر النهائي: ${filteredListOrders[index].Final_Price.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey), textDirection: TextDirection.rtl,
                ),
                Container(
                    margin: EdgeInsets.all(5.0),
                    child: saleFlag == true
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: this.orderFlag == true ? <Widget>[
                                  FlatButton(
                                    padding: EdgeInsets.all(8.0),
                                    color: Colors.blue,
                                    onPressed: () {
                                      showConfirmDialog(
                                          filteredListOrders[index].Order_ID,
                                          'process',
                                          index);
                                      // onProcessed(
                                      //     listOrders[index].Order_ID);
                                    },
                                    child: Text(
                                      'عاد ثانية',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.all(8.0),
                                    color: Colors.green,
                                    onPressed: () {
                                      showConfirmDialog(
                                          filteredListOrders[index].Order_ID,
                                          'complete',
                                          index);
                                      // onCanceled(
                                      //     listOrders[index].Order_ID);
                                    },
                                    child: Text(
                                      'منجز',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.all(8.0),
                                    color: Colors.red,
                                    onPressed: () {
                                      showConfirmDialog(
                                          filteredListOrders[index].Order_ID,
                                          'cancel',
                                          index);
                                      // onCanceled(
                                      //     listOrders[index].Order_ID);
                                    },
                                    child: Text(
                                      'ألغيت',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ] : <Widget>[],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Directionality(textDirection: TextDirection.rtl,
                                   child: Expanded(
                                      flex: 7,
                                      child: TextField(
                                        // controller: _initNote,
                                        onChanged: (text) {
                                          tempNote = text;
                                        },
                                        decoration: InputDecoration(
                                          // icon: Icon(Icons.note_add, color: Colors.green,),
                                          // border: OutlineInputBorder(),
                                          hintText: 'ملاحظة عامة...',
                                        ),
                                      ),
                                    )
                                   ),
                                  Expanded(
                                    flex: 2,
                                    child: FlatButton(
                                        padding: EdgeInsets.all(8.0),
                                        color: Colors.pink,
                                        onPressed: () {
                                          if (tempNote.isNotEmpty) {
                                            String orderId =
                                                filteredListOrders[index]
                                                    .Order_ID
                                                    .toString();
                                            savNote(context, tempNote, orderId);
                                            print(tempNote);
                                            setState(() {
                                              tempNote = '';
                                              // _initNote.clear();
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.save,
                                          size: 25,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(8.0),
                                        color: Colors.pink[500],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              _createRoute(
                                                  filteredListOrders[index]));
                                        },
                                        child: Text(
                                          'عرض التفاصيل',
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: FlatButton(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.pink[500],
                                  onPressed: () {
                                    Navigator.of(context).push(_createRoute(
                                        filteredListOrders[index]));
                                  },
                                  child: Text(
                                    'تفاصيل الطلب',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,
                                  ),
                                ),
                              )
                            ],
                          ))
              ],
            ),
          ),
        );
      },
      itemCount: filteredListOrders.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("triger333(home)");
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: _buildBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchApi();
        },
        child: filteredListOrders.length != 0
            ? Container(padding: EdgeInsets.all(10), child: _buildList())
            : Center(
                child: Text(
                  "فارغة",
                  style: GoogleFonts.quicksand(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // this will be set when a new tab is tapped
        onTap: onTabTapped,

        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.new_releases),
            title: new Text('أمر جديد',  textDirection: TextDirection.rtl,),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.stop, color: Colors.grey[100],),
            title: new Text(''),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.restore_from_trash), title: Text('أمر قديم',  textDirection: TextDirection.rtl,))
        ],
      ),
    );
  }
}

Route _createRoute(OrdersModel filteredListOrders) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Page2(args: [filteredListOrders]),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  final args;
  Page2({Key key, this.args}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: new Text('تفاصيل الطلب',  textDirection: TextDirection.rtl,),
      ),
      body: Card(
        margin: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("اسم الطلب: ${args[0].Order_Name.toString()}", style: Theme.of(context).textTheme.headline6, textDirection: TextDirection.rtl,),
                  Text("هوية شخصية: ${args[0].Order_Number.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("حالة الطلب: ${args[0].Order_Status.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("السعر النهائي: ${args[0].Final_Price.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("سعر العميل: ${args[0].Customer_Price.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("سعر السائق: ${args[0].Driver_Price.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("ملحوظة: ${args[0].Note.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("اسم الزبون: ${args[0].Customer_Name.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                  Text("هاتف العميل: ${args[0].Phone.toString()}", style: Theme.of(context).textTheme.headline6,  textDirection: TextDirection.rtl,),
                ],
              ),
            )),
      ),
      
    );
  }
}
