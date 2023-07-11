import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    final user = await provider.createUser(email: email, password: password);
    return user;
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    final user = await provider.logIn(email: email, password: password);
    return user;
  }

  @override
  Future<void> logOut() async {
    await provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    provider.sendEmailVerification();
  }
}
