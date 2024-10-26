import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:phonepay/view/otp_page.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //verification code function
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
        
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
           print("Verification failed: ${e.message}"); // Log the error
           Get.snackbar("Error", e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store the verification ID for later use
          Get.to(() => OtpPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
