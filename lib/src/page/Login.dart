import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:transporter/src/page/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const String routeName = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  static String user = "";
  static String pass = "";
  // bool saleFlag = true;
  bool hidePassword = true;

  Future<void> showLogoutDialog(String title, String body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  setAuthentication(String id, bool saleFlag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", user);
    await prefs.setString("pass", pass);
    prefs.setString("id", id);
    prefs.setBool("saleFlag", saleFlag);
    print('Login setAuthentication $saleFlag');
//    await prefs.setBool("isAuthentication", true);
  }

  getAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userLogin = prefs.getString("user");
    String idLogin = prefs.getString("id");
    bool isAuth = prefs.getBool("isAuthentication");
    int idToInt;
    if (idLogin != "null") {
      idToInt = int.parse(idLogin);
    }
    if (isAuth != null && isAuth) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return Home(
          args: [idToInt, userLogin],
        );
      }), (Route<dynamic> route) => false);

//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
//        return Home(args: [idToInt, userLogin],);
//      }));
    }
  }

  getLogin() async {
    if (user != "" || pass != "") {
      String apiLogin =
          "https://transporter.group/songnguyen/myapi/login/?user=$user&pass=$pass";
      var result = await http.get(apiLogin);
      var jsonDecoded = json.decode(result.body);
      print('Login getLogin $jsonDecoded');
      var isMatchLogin = jsonDecoded["result"];
      var id;
      var saleFlag;
      
      if (jsonDecoded['sales'] == true) {
        id = jsonDecoded["sale_id"];
        saleFlag = true;
        print('login jsonDecoded $id');
        print('login jsonDecoded $saleFlag');
      }else{
        id = jsonDecoded["customer_id"];
        saleFlag = false;
        print(saleFlag);
      }
      
      var userTransport = jsonDecoded["user"];
      // setAuthentication(id.toString(), saleFlag);
      await setAuthentication(id.toString(), saleFlag);
      if (isMatchLogin) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return Home(
            args: [id, userTransport],
          );
        }), (Route<dynamic> route) => false);

//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
//          return Home(args: [id, userTransport],);
//        }));
      } else {
        showLogoutDialog(
            "Please check agian", "Username and password not correctly!");
      }
    } else {
      showLogoutDialog("Error", "Username and password can not be blank!");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    getAuthentication();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/a3.jpg'), fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Welcome to Transporter!',
                        style: GoogleFonts.quicksand(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        'Sign in to continue',
                        style: GoogleFonts.quicksand(color: Colors.black54),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: userController,
                        onChanged: (val) {
                          setState(() {
                            user = val;
                          });
                        },
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(
                              Icons.email,
                              size: 22,
                            ),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: passController,
                        onChanged: (val) {
                          setState(() {
                            pass = val;
                          });
                        },
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 22,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              child: Icon(
                                hidePassword == true
                                    ? FontAwesomeIcons.solidEye
                                    : FontAwesomeIcons.solidEyeSlash,
                                size: 18,
                              ),
                            ),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        obscureText: hidePassword,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Material(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(7),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(7),
                                onTap: () {
                                  getLogin();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
//                      CustomButton(
//                        text: 'Login',
//                        bgColor: Theme.of(context).primaryColor,
//                        textColor: Colors.white,
//                      ),
                      SizedBox(
                        height: 30,
                      ),
//                      Center(
//                        child: Text(
//                          'Forgot Password?',
//                          style: TextStyle(color: Colors.black54),
//                        ),
//                      ),
//                      SizedBox(
//                        height: 30,
//                      ),
//                      Container(
//                        decoration: BoxDecoration(
//                            border: Border.all(color: Colors.black87,width: 1),
//                            borderRadius: BorderRadius.circular(7)
//                        ),
//                        child: CustomButton(
//                          text: 'Sign Up',
//                          bgColor: Colors.white.withOpacity(0),
//                          textColor: Colors.black,
//                        ),
//                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({this.bgColor, this.text, this.textColor});

  final Color bgColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () {
//                getLogin();
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  '$text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: 15),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
