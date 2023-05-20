import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/login_auth_result.dart';
import 'package:volume_vault/models/enums/signin_auth_result.dart';
import 'package:volume_vault/models/user_session.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';

class UserSessionState extends Notifier<UserSession?> {
  @override
  UserSession? build() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    return UserSession(
        uid: currentUser.uid,
        name: currentUser.displayName!,
        email: currentUser.email!);
  }

  Future<LoginAuthResult> loginUser(UserLoginRequest loginRequest) async {
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginRequest.email, password: loginRequest.password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return LoginAuthResult.invalidEmail;
        case "user-disabled":
          return LoginAuthResult.userDisabled;
        case "user-not-found":
          return LoginAuthResult.userNotFound;
        case "wrong-password":
          return LoginAuthResult.wrongPassword;
        default:
          return LoginAuthResult.unknown;
      }
    }
    User currentUser = credential.user!;

    state = UserSession(
        uid: currentUser.uid,
        name: currentUser.displayName!,
        email: currentUser.email!);

    return LoginAuthResult.success;
  }

  Future<SigninAuthResult> signinUser(UserSigninRequest signinRequest) async {
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signinRequest.email, password: signinRequest.password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return SigninAuthResult.emailAlreadyInUse;
        case "invalid-email":
          return SigninAuthResult.invalidEmail;
        case "operation-not-allowed":
          return SigninAuthResult.operationNotAllowed;
        case "weak-password":
          return SigninAuthResult.weakPassword;
        default:
          return SigninAuthResult.unknown;
      }
    }

    User currentUser = credential.user!;
    await currentUser.updateDisplayName(signinRequest.username);
    state = UserSession(
        uid: currentUser.uid,
        name: signinRequest.username,
        email: currentUser.email!);

    return SigninAuthResult.success;
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
