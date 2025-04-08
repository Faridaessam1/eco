//
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// import '../utils/snack_bar_services.dart';
//
// class FirebaseFunctions {
//
//
//
//   static Future<bool> createAccount(String email, String password) async{
//     EasyLoading.show();
//
//     try{
//       UserCredential credential=
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       String userID = credential.user?.uid ?? "";
//       SnackBarServices.showSuccessMessage("Account Created Successfully");
//
//       return Future.value(true);
//     }
//     on FirebaseAuthException catch(e){
//       if (e.code == 'weak-password') {
//         SnackBarServices.showErrorMessage(e.message ?? "The password provided is too weak.");
//         return Future.value(false);
//
//       } else if (e.code == 'email-already-in-use') {
//         SnackBarServices.showErrorMessage(e.message ?? "The account already exists for that email.");
//         return Future.value(false);
//
//       }
//       return Future.value(false);
//
//     } catch (e){
//       return Future.value(false);
//     }
//
//   }
//
//
//   static Future<bool> login(String email, String password) async{
//     EasyLoading.show();
//
//     try{
//       final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email,
//           password: password
//       );
//       String userID = credential.user?.uid ?? "";
//
//       SnackBarServices.showSuccessMessage("Logged In Successfully");
//       return Future.value(true);
//     }
//     on FirebaseAuthException catch(e){
//       if (e.code == 'invalid-credential') {
//         SnackBarServices.showErrorMessage(e.message ?? "User Is Not Found");
//         return Future.value(false);
//
//       } else if (e.code == ' invalid-credential') {
//         SnackBarServices.showErrorMessage("Wrong password");
//         return Future.value(false);
//
//       }else if (e.code == 'network-request-failed') {
//         SnackBarServices.showErrorMessage("Network error");
//         return Future.value(false);
//         }
//       return Future.value(false);
//
//     }
//      catch (e){
//       print(e.toString());
//       return Future.value(false);
//     }
//
//   }
//
//
//   static Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // await GoogleSignIn().signIn(); de btft7le window google 3shan ykhtar el account bta3o
//       // lw ekhtar htrg3 value ttkhzn fl variable lw mkhtrsh btrg3 null
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return null; // User canceled sign-in
//
//       // lw luser ekhtar account bstkhdm googleUser.authentication;
//       // 3shan at2ked en byanat el user sah
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       // ay user 3ndo hagten awl ma by3ml sign in b google
//       //accesstoken wda b2dar a access be hagat f account l shakhs w bykon haga mo2kata
//       //idtoken w da bykon fe byanat asasya 3shan a3rf hawyt lshakhs el dkhal
//       // 3shan at2ked mn hawyt lshakhs el dkhal byhtag letnen w letnnakhdthom wna b3ml sign in
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       SnackBarServices.showSuccessMessage("Logged In Successfully");
//       // 4️⃣ Sign in to Firebase and Return User
//       return await FirebaseAuth.instance.signInWithCredential(credential);
//
//     } catch (e) {
//       SnackBarServices.showErrorMessage(e.toString());
//       print(e);
//     }
//   }
//
// }