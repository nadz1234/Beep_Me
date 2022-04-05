import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: componentColor,
          title: Text('Forgot Password'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: Alignment(-1, -1),
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 51, 0, 0),
                                child: Image.asset(
                                  'Images/BM_icon_white.png',
                                  width: 80,
                                  height: 47.0,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                                child: Image.asset(
                                  'Images/BM_name_white.png',
                                  width: 250,
                                  height: 75.0,
                                ),
                              ),
                              //  VerticalText(),
                              //  TextLogin(),
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 50, right: 50),
                    child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: new InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: "Enter Username",
                            fillColor: Color.fromARGB(255, 37, 37, 37),
                            filled: true,

                            //fillColor: Colors.green
                          ),
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                          keyboardType: TextInputType.emailAddress,
                        )),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0),
                    child: Container(
                      width: 200,
                      child: RaisedButton(
                          color: Color.fromARGB(255, 31, 134, 112),
                          onPressed: () async {
                            BaseApi().forgotPassword(username);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Forgot Password",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
