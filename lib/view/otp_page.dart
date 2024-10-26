import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:phonepay/view/dashboard.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;

  const OtpPage({super.key, required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.isNotEmpty) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otp,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigate to the next page or show success message
        Get.to(Dashboard());
        // You can navigate to another page here
      } catch (e) {
        Get.snackbar("Error", "Invalid OTP");
      }
    } else {
      Get.snackbar("Error", "Please enter the OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter OTP",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _verifyOtp,
                    child: Text("Verify OTP"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
