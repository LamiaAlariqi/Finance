import 'package:bloc/bloc.dart';
import 'package:finance/helper/HiveUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid ?? "";
       final box = await Hive.openBox<HiveUser>('userBox');
      final user = HiveUser(
        email: email.trim(),
        password: password.trim(),
      );
      await box.put('currentUser', user);

      emit(LoginSuccess(uid));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? "خطأ غير معروف"));
    } catch (e) {
      emit(LoginFailure("ليس لديك صلاحية دخول "));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
   final box = Hive.box<HiveUser>('userBox');
    await box.clear();
    emit(LoginInitial());
  }

 bool isLoggedIn() {
  final box = Hive.box<HiveUser>('userBox');
  final user = box.get("currentUser"); 
  return user != null; 
}

}
