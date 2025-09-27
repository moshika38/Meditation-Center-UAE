import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/data/services/user.services.dart';

class AuthServices {
  // password authentication
  static Future<String> signInWithEmail(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      if (credential.user != null) {
         credential.user!.displayName;
        return "Successfully";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'errCode1';
      } else if (e.code == 'wrong-password') {
        return 'errCode2';
      }
    }
    return 'Something went wrong';
  }

  // create password account
  static Future<String> createAccountWithEmailAndPassword(
    String emailAddress,
    String password,
    String name,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      if (credential.user != null) {
        sendEmailVerification(emailAddress);
        checkUserStatus(name,false);
        return 'Successfully';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'errCode1';
      } else if (e.code == 'email-already-in-use') {
        return 'errCode2';
      }
    } catch (e) {
      return e.toString();
    }
    return 'Unknown error occurred.';
  }

  static void checkUserStatus(String name,bool isVerify) async {
    final isUserIdExists = await UserServices()
        .isUserIdExists(FirebaseAuth.instance.currentUser!.uid);

    if (!isUserIdExists) {
      // user not exists, then add to collection
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        UserServices().addNewUser(
          UserModel(
            name: name,
            email: currentUser.email.toString(),
            uid: currentUser.uid.toString(),
            profileImage: currentUser.photoURL == null
                ? AppData.baseUserUrl
                : currentUser.photoURL.toString(),
            isAdmin: false,
            isVerify: isVerify,
            allowNotification: true,
          ),
        );
      } else {
        print('User not found');
      }
    }
  }

  // send email verification
  static Future<String> sendEmailVerification(String emailAddress) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return 'Successfully';
    } catch (e) {
      return e.toString();
    }
  }

  // password reset
  static Future<String> resetPassword(String emailAddress) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
      return 'Successfully';
    } catch (e) {
      return e.toString();
    }
  }

  // check if email is verified
  static Future<bool> isEmailVerified() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        return refreshedUser?.emailVerified ?? false;
      }
      return false;
    } catch (e) {
      print('Verification check error: $e');
      return false;
    }
  }
  // google authentication

  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return false;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final data = await FirebaseAuth.instance.signInWithCredential(credential);
    if (data.user != null) {
      final name =FirebaseAuth.instance.currentUser!.displayName;
      checkUserStatus(name??"User123",true);
      return true;
    } else {
      return false;
    }
  }

  // sing out
  static Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  // check if  email is valid
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegex.hasMatch(email);
  }
}
