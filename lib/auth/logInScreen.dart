import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth/verifyCode.dart';
import 'package:new_project/widgets/customMessage.dart';
import 'package:new_project/widgets/myButton.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
// local thing
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final phoneNoController = TextEditingController();

  // firebase thing
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 380,
                child: Image.network(
                    "https://culturedvultures.com/wp-content/uploads/2022/10/Naruto-803x452.jpg"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter A Number to procede";
                          }
                        },
                        keyboardType: TextInputType.number,
                        controller: phoneNoController,
                        decoration: InputDecoration(hintText: "Enter a phone no"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      myButton(
                        () {
                          setState(() {
                            loading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            logInWithPhoneNumber(
                                phoneNoController.text.toString());
                          }
                        },
                        "Next",
                        loading,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void logInWithPhoneNumber(String phoneNumber) {
    // print(phoneNumber);
    // this is to verify phone no. and the send the code
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {
          CustomMsg().customMsg("Authantication Complete");
        },
        verificationFailed: (e) {
          CustomMsg().customMsg(e.toString());
        },
        codeSent: (String verificationId, int? verificationCode) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId),),);
        },
        codeAutoRetrievalTimeout: (e) {
          CustomMsg().customMsg(e.toString());
        },
      );
  }
}
