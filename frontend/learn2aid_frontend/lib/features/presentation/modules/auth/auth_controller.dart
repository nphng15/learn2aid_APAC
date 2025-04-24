import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxString authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Hàm đăng nhập bằng Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Người dùng huỷ đăng nhập

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập với Firebase Auth
      await _auth.signInWithCredential(credential);

      // Lấy token Firebase để sử dụng cho API
      authToken.value = (await _auth.currentUser!.getIdToken())!;
      // authToken.value = await _auth.currentUser!.getIdToken();
      print("User token: ${authToken.value}");
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      Get.snackbar("Lỗi", "Không thể đăng nhập");
    }
  }

  // Hàm đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    authToken.value = '';
  }
}
