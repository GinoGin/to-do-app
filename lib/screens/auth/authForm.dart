import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({ Key? key }) : super(key: key);
  

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email= '';
  var _password= '';
  var _username='';
  bool isLogin = false;

  startAuthentication(){
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(validity){
        _formkey.currentState!.save();
        submitForm(_email, _password, _username);
    }
  }

  Future submitForm(String email, String password, String username) async{
    final auth = FirebaseAuth.instance;
    UserCredential authresult;
    try{
        if(isLogin){
          authresult =await auth.signInWithEmailAndPassword(email: email, password: password);
        }
        else{
          authresult = await auth.createUserWithEmailAndPassword(email: email, password: password);
          String uid= authresult.user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'username': username,
            'email' : email,
            'psd' : password,
          });
        }

    }catch(e){
        print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20,left: 10,right: 10),
            child: Container(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      keyboardType: TextInputType.name,
                      validator: (val){
                          if(val!.isEmpty)
                            return "Incorrect username";
                          else return null;
                      },
                      onSaved: (val){
                        _username=val!;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          //borderSide: new BorderSide(),
                        )
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val){
                          if(val!.isEmpty || !val.contains('@'))
                            return "Incorrect email";
                          else return null;
                      },
                      onSaved: (val){
                        _email=val!;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          //borderSide: new BorderSide(),
                        )
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      key: ValueKey('password'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (val){
                          if(val!.isEmpty)
                            return "Incorrect password";
                          else return null;
                      },
                      onSaved: (val){
                        _password=val!;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          //borderSide: new BorderSide(),
                        )
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 45,
                      width: double.infinity,
                      
                      child: RaisedButton(
                        
                        onPressed: (){
                          startAuthentication();
                        },
                         child: isLogin? Text("Login"): Text("Register"),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                         color: Theme.of(context).primaryColor,
                         
                         ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: TextButton(
                        onPressed: (){
                          setState(() {
                            isLogin=!isLogin;
                          });
                        },
                         child: isLogin? Text("Not a member?"): Text("Already a member?"),
                         ),
                    )
                  ],
                )
                )
              
            ),
          )
        ],
      ),
    );
  }
}