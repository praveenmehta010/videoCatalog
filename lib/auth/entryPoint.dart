import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth/home.dart';
import 'package:new_project/auth/logInScreen.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    isLogIn(context);
    // TODO: implement initState
    super.initState();
  }
  void isLogIn (BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),),);
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen(),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}