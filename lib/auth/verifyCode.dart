import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth/home.dart';
import 'package:new_project/widgets/myButton.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  
  // local thing
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  
// firebase thing
  final _auth = FirebaseAuth.instance;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.network(
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fnaruto.fandom.com%2Fwiki%2FSage&psig=AOvVaw2sC6NCDIyveRb_4CqHMcJk&ust=1668950650177000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOi7y_GruvsCFQAAAAAdAAAAABAE"),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter otp";
                      }
                    },
                    controller: otpController,
                    decoration: InputDecoration(hintText: "Enter otp"),
                  ),
                  myButton(() {
                    setState(() {
                      loading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      logInWithotp(otpController.text.toString());
                    }
                  }, "Get Started", loading)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

void logInWithotp(String otp) async {
    // after feeding the otp this will create credential to login
    final _authCredantial = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    // this will use Credential to login
    await _auth.signInWithCredential(_authCredantial).then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
    });
  }

}
