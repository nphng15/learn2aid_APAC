import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../config/routes/app_routes.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Text controllers for email & password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var authToken = ''.obs;
  
  // Google user information
  var googleUserEmail = ''.obs;
  var googleUserName = ''.obs;
  var googleUserPhotoUrl = ''.obs;
  var googleAccessToken = ''.obs;

  // Login with email & password 
  Future<void> loginUser() async {
    isLoading.value = true;
    errorMessage.value = '';

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      authToken.value = (await userCredential.user!.getIdToken())!;
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // User cancelled sign-in
      }

      // Get user information from Google
      googleUserEmail.value = googleUser.email;
      googleUserName.value = googleUser.displayName ?? '';
      googleUserPhotoUrl.value = googleUser.photoUrl ?? '';
      
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      
      // Save access token
      googleAccessToken.value = googleAuth.accessToken ?? '';

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      authToken.value = (await userCredential.user!.getIdToken())!;
      
   
      // print('Google User Email: ${googleUserEmail.value}');
      // print('Google User Name: ${googleUserName.value}');
      // print('Google User Photo URL: ${googleUserPhotoUrl.value}');
      // print('Google Access Token: ${googleAccessToken.value}');
      
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = 'Google login failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Log out
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    authToken.value = '';
    // Clear Google information
    googleUserEmail.value = '';
    googleUserName.value = '';
    googleUserPhotoUrl.value = '';
    googleAccessToken.value = '';
    Get.offAllNamed(AppRoutes.login);
  }
}

