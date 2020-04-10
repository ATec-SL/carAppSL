import 'package:carappsl/Screens/signup_screen.dart';
import 'package:carappsl/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class LoginScreen extends StatefulWidget {

  static final String id = 'login_screen';
  String errorMsg = 'Enter a valid email address';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  submit(){

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      AuthService.login(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(  //Create a column child in cscaffold
              mainAxisAlignment: MainAxisAlignment.center,  //To center the title
              crossAxisAlignment: CrossAxisAlignment.center,  //To center the title'
              children: <Widget>[    //Inside this widget we do all the login screen design

                GFAvatar(   //Add app logo
                  radius: 50.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                    shape: GFAvatarShape.square
                ),

                Text('Auto City',
                  style: TextStyle(
                    fontSize: 50.0,   //Add style to text******
                    fontFamily: 'schyler'  //Need to add this font type to pubspec.yaml --fonts
                ),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Padding(   //Email
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(    // Input label email
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (input) => !input.contains('@') ? 'Please enter a valid email': null,
                          onSaved: (input) => _email = input,
                        ),
                      ),

                      Padding( //Password
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (input) => input.length < 6 ? 'Must be atleast 6 characters' : null,
                          onSaved: (input) => _password = input,
                          obscureText: true,  //character hidden
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Container(   //Login button container
                        width: 250.0,
                        child: FlatButton(    // Login button
                          onPressed:submit,
                          color: Colors.lightGreen,
                          padding: EdgeInsets.all(10.0),
                          child: Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      Container(   //Sign up button container
                        width: 250.0,
                        child: FlatButton(    // Login button
                          onPressed: () => Navigator.pushNamed(context, SignupScreen.id),
                          color: Colors.lightGreen,
                          padding: EdgeInsets.all(10.0),
                          child: Text('Go to Signup',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      )


                    ],
                  ),
                )

              ],
            ),
          ),
        ),

    );
  }
}
