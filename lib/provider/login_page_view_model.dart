part of provider;

class LoginPageViewModel with ChangeNotifier {
  bool _isOtpScreen = false;
  String _verificationId = '';
  String _phoneNumber = '';
  String _selectedCode = '+91';

  bool get isOtpScreen => _isOtpScreen;
  String get verificationId => _verificationId;
  String get phoneNumber => _phoneNumber;
  String get selectedCode => _selectedCode;

  setOptScreen(bool value) {
    _isOtpScreen = value;
    notifyListeners();
  }

  setVerificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }

  setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  setSelectedCode(String value) {
    _selectedCode = value;
    notifyListeners();
  }

  setBoth(bool value, String value1) {
    _isOtpScreen = value;
    _verificationId = value1;
    notifyListeners();
  }
}
