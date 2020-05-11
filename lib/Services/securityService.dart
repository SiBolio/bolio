import 'package:local_auth/local_auth.dart';

class SecurityService {
  LocalAuthentication _auth = LocalAuthentication();

  SecurityService() {
    _auth = new LocalAuthentication();
  }

  Future<bool> checkAuthentication() async {
    bool authenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Bitte legen Sie Ihren Finger auf den Touch Sensor',
        useErrorDialogs: true,
        stickyAuth: true);
    return authenticated;
  }

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    return canCheckBiometrics;
  }
}
