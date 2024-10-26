import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _phoneController1 = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;
  bool _isOtpSent = false;

  void _sendOtp() async {
    String phoneNumber = _phoneController1.text.trim();
    if (phoneNumber.isNotEmpty) {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          await _auth.signInWithCredential(credential);
          // Optionally, you can add the user to Firestore here if you want to handle auto-verification
          // await _firestore.collection('users').add({
          //   'phone': phoneNumber,
          // });
          Get.snackbar("Success", "Registration successful!");
          Get.back(); // Go back to the previous page
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error", e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
          });
          Get.snackbar("OTP Sent", "An OTP has been sent to your phone.");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } else {
      Get.snackbar("Error", "Please enter a phone number");
    }
  }

  void _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.isNotEmpty && _verificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      try {
        await _auth.signInWithCredential(credential);
        // Add user to Firestore after successful OTP verification
        await _firestore.collection('users').add({
          'phone': _phoneController1.text.trim(),
        });
        Get.snackbar("Success", "Registration successful!");
        Get.back(); // Go back to the previous page
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
      appBar: AppBar(title: Text("Register")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _phoneController1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your phone number",
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendOtp,
                  child: Text("Send OTP"),
                ),
                SizedBox(height: 20),
                if (_isOtpSent) ...[
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter OTP",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyOtp,
                    child: Text("Verify OTP"),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
