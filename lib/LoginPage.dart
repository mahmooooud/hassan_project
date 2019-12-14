import 'package:courses_project/HomePage.dart';
import 'package:courses_project/RegisterationPage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  String _userEmail = "";
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('Login'),
         centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Login Page",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                     fontSize: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                alignment: Alignment.topLeft,
                child: Text("Email Address",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w300,color: Colors.grey.withOpacity(.5)),),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Colors.grey)
                ),
                padding: EdgeInsets.only(left: 7.0,right: 7.0),
                margin: EdgeInsets.only(top: 7.0,left: 10.0,right: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 10.0),
                alignment: Alignment.topLeft,
                child: Text("Password",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w300,color: Colors.grey.withOpacity(.5)),),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Colors.grey)
                ),
                padding: EdgeInsets.only(left: 7.0,right: 7.0),
                margin: EdgeInsets.only(top: 7.0,left: 10.0,right: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText,
                  controller: _passwordController,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: (){
                    _signInWithEmailAndPassword().then((_){
                      if(_success) {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()));
                      }else{
                        print("Error");
                      }
                    });
                  },
                  child: Container(
                    height: 30.0,
                    width: MediaQuery.of(context).size.width/1.4,
                    decoration: BoxDecoration(
                      color: Color(0xff2B4E72),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    alignment: Alignment.center,
                    child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: (){

                  Navigator.push(context,new MaterialPageRoute(
                      builder: (BuildContext context) => RegisterationPage()));
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have account?",style: TextStyle(color: Colors.grey.withOpacity(.8),fontSize: 15.0,fontWeight: FontWeight.w400),),
                      Text("Sign Up",style: TextStyle(color: Color(0xff2B4E72),fontSize: 15.0,fontWeight: FontWeight.w400),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );

  }

  Future<String> _signInWithEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ));
    if (user != null) {
      setState(() {
        _success = true;
        print("userId  ${user.uid}");
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }


}
