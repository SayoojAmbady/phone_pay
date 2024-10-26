import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonepay/controller/auth_controller.dart';
import 'package:phonepay/foundation/carousel_slider_widget.dart';
import 'package:phonepay/view/registration_page.dart';
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                CarouselSliderWidget(
                    imageAssetPaths: CarouselImages.loginImages),
                const SizedBox(height: 20),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "PhoneNumber"),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    String phoneNumber = _phoneController.text.trim();
                      if (!phoneNumber.startsWith('+')) {
                        phoneNumber = '+91$phoneNumber'; // Assuming India as the country code
                      }
                    print("Phone Number:$phoneNumber");
                    if (phoneNumber.isNotEmpty) {
                      _authController.verifyPhoneNumber(phoneNumber);
                    } else {
                      Get.snackbar("Error", "Please enter a phone number");
                    }
                  },
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Get.to(() => RegistrationPage());
                    },
                    child: Text("New user? Register here"),
                  ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class CarouselImages {
  static const List<String> loginImages = [
    'assets/images/Computer login-rafiki.svg',
    'assets/images/Office work.svg',
  ];
}





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:phonepay/controller/auth_controller.dart';
// import 'package:phonepay/foundation/carousel_slider_widget.dart';
// import 'package:phonepay/view/registration_page.dart';

// class Loginpage extends StatefulWidget {
//   const Loginpage({super.key});

//   @override
//   State<Loginpage> createState() => _LoginpageState();
// }

// class _LoginpageState extends State<Loginpage> {
//   final AuthController _authController = Get.put(AuthController());
//   final TextEditingController _phoneController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> _checkIfUserExists(String phoneNumber) async {
//     // Check if the phone number exists in Firestore
//     final querySnapshot = await _firestore
//         .collection('users')
//         .where('phone', isEqualTo: phoneNumber)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       // Phone number exists, proceed to send OTP
//       _authController.verifyPhoneNumber(phoneNumber);
//     } else {
//       // Phone number does not exist, show error message
//       Get.snackbar("Error", "This phone number is not registered.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               padding: EdgeInsets.all(10.0),
//               child: Column(
//                 children: <Widget>[
//                   CarouselSliderWidget(
//                       imageAssetPaths: CarouselImages.loginImages),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _phoneController,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(), hintText: "Phone Number"),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       String phoneNumber = _phoneController.text.trim();
//                       if (!phoneNumber.startsWith('+')) {
//                         phoneNumber = '+91$phoneNumber'; // Assuming India as the country code
//                       }
//                       print("Phone Number: $phoneNumber");
//                       if (phoneNumber.isNotEmpty) {
//                         _checkIfUserExists(phoneNumber);
//                       } else {
//                         Get.snackbar("Error", "Please enter a phone number");
//                       }
//                     },
//                     child: Text("Login"),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.greenAccent),
//                   ),
//                   SizedBox(height: 10),
//                   TextButton(
//                     onPressed: () {
//                       Get.to(() => RegistrationPage());
//                     },
//                     child: Text("New user? Register here"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CarouselImages {
//   static const List<String> loginImages = [
//     'assets/images/Computer login-rafiki.svg',
//     'assets/images/Office work.svg',
//   ];
// }

