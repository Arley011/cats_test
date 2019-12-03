import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

  UserRepository({FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignin,
    FacebookLogin facebookLogin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser =
    await _googleSignIn.signIn().catchError((onError) => print(onError));
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final facebookResult = await _facebookLogin.logIn(
        ['email']).catchError((e) => print(e));
    switch (facebookResult.status) {
      case FacebookLoginStatus.loggedIn:
        final token = facebookResult.accessToken;
        await firebaseAuthWithFacebook(token: token);
        return _firebaseAuth.currentUser();
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

    Future<AuthResult> firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {

      AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);
      AuthResult firebaseUser = await _firebaseAuth.signInWithCredential(credential);
      return firebaseUser;
    }




  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(
      {String email, String password, String name, String photoUrl}) async {
    UserUpdateInfo update = UserUpdateInfo();
    update.displayName = name;
    update.photoUrl = photoUrl;
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = await _firebaseAuth.currentUser();
    return await user.updateProfile(update);
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    print(currentUser.displayName.toString());
    return currentUser != null;
  }

  Future<Map<String, String>> getUser() async {
    final user = await _firebaseAuth.currentUser();
    final name = user.displayName;
    final email = user.email;
    final photo = user.photoUrl;
    if (name != null) {
      return {'name': name, 'email': email, 'photo': photo};
    }
  }
}
