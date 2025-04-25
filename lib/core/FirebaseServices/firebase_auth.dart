import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../ui/auth/otp_screen.dart';
import '../utils/snack_bar_services.dart';

class FirebaseFunctions {
  static Future<bool> createAccount(String email, String password) async {
    EasyLoading.show();
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userID = credential.user?.uid ?? "";
      SnackBarServices.showSuccessMessage("Account Created Successfully");
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        SnackBarServices.showErrorMessage(e.message ?? "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        SnackBarServices.showErrorMessage(e.message ?? "The account already exists for that email.");
      } else {
        SnackBarServices.showErrorMessage(e.message ?? "An error occurred.");
      }
      return Future.value(false);
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<bool> login(String email, String password) async {
    EasyLoading.show();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userID = credential.user?.uid ?? "";
      SnackBarServices.showSuccessMessage("Logged In Successfully");
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        SnackBarServices.showErrorMessage(e.message ?? "Invalid credentials");
      } else if (e.code == 'network-request-failed') {
        SnackBarServices.showErrorMessage("Network error");
      } else {
        SnackBarServices.showErrorMessage(e.message ?? "An error occurred.");
      }
      return Future.value(false);
    } catch (e) {
      print(e.toString());
      return Future.value(false);
    }
  }
  static Future<String?> getUserType(String? uid) async {
    if (uid == null) return null;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['userType'] as String?;
      } else {
        SnackBarServices.showErrorMessage("User data not found.");
        return null;
      }
    } catch (e) {
      print("Error fetching userType: $e");
      SnackBarServices.showErrorMessage("Failed to fetch user type.");
      return null;
    }
  }
  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  static Future<void> signInWithPhone(String phoneNumber, BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  static Future<void> verifyOtp(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }
  static Future<void> logout() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }



}

