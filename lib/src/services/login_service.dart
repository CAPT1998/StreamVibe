

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model/users.dart';

class LoginService extends ChangeNotifier {
  Users? _userModel;

  Users? get loggedInUserModel => _userModel;

  Future<bool> signInWithGoogle(context) async {
    // Trigger the authentication flow
    // GoogleSignIn googleSignIn = GoogleSignIn();
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return false;
    }

    // Obtain the auth detail from request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    UserCredential userCreds =
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCreds != null) {
      _userModel = Users(

          firstname: "${userCreds.user!.displayName}",
          userName: "${userCreds.user!.displayName}",
          userProfilePic: userCreds.user?.photoURL??"",
          userId: userCreds.user!.uid,
          status: "1",
          userEmail: "${userCreds.user!.email}",

      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool("isfirst", false);

        // userid =prefs.getString('userid')!;

      prefs.setString("userid",_userModel!.userId);
      prefs.setString("profilepic", _userModel!.userProfilePic);

      prefs.setString("email", _userModel!.userEmail);
      prefs.setString("firstname", _userModel!.firstname);
      prefs.setBool('isLoggedIn', true);

      //*******************************************
      try{
      final response = await http.post(
        Uri.parse("https://admin.koinoniaconnect.org/API/" + 'signup'),
        body: {
          'user_id': _userModel!.userId,
          'user_email':  _userModel!.userEmail,
          'user_password': '12345',
          'firstname':  _userModel!.firstname,
          'lastname':  _userModel!.firstname,
          'status': '1',
          'user_profile_pic': "uploads/user/defaultprofile.png",
        },
      );

      if (response.statusCode == 200) {
        var respo = json.decode(response.body);
        if(respo['status']=='error'){
            var snackBar = SnackBar(
    content: Text(
      'Login Failed! You already signed in using custom email & password, So try logging in by writting email and password on the screen.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: Color(0xFFF15C00),
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: StadiumBorder(),
    // width: 200,
    backgroundColor: Colors.white,
  
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
  );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
     
  return false;
        }
        // final List result = jsonDecode(response.body);
        // if (result[0] == 'error') {
        //   // setState(() {
        //   //   _errorMessage = result[1];
        //   // });
        //   // throw RangeError(_errorMessage);
        // }
        // return music.map((json) => Result.fromJson(json)).toList();
      }
      

      }catch(e){
        Fluttertoast.showToast(msg: 'e');
        return false;
      }

      notifyListeners();
      return true;
    }
    return false;
  }

  signOut() async {
    await GoogleSignIn().signOut();
    _userModel = null;
    notifyListeners();
  }

  bool isUserLoggedIn() {
    return _userModel != null;
  }
}
