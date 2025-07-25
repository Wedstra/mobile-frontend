class Vendor {
  late final String _vendorName;
  late final String _email;
  late final String _password;
  late final String _businessName;
  late final String _businessCategory;
  final String _gstin;
  final String _phone;
  final String _city;
  late final String _termsAndConditions;
  late final String _aadharCard;
  late final String _vendorPan;
  late final String _businessPan;
  final String _electricityBill;
  final String _license;
  final List<String> _businessPhotos;
  final String _role;
  final int _noOfServices;
  final bool _isVerified;

  Vendor(
    this._vendorName,
    this._email,
    this._password,
    this._businessName,
    this._businessCategory,
    this._gstin,
    this._phone,
    this._city,
    this._termsAndConditions,
    this._aadharCard,
    this._vendorPan,
    this._businessPan,
    this._electricityBill,
    this._license,
    this._businessPhotos,
    this._role,
    this._noOfServices,
    this._isVerified,
  );

  // Getters
  String get vendorName => _vendorName;
  String get email => _email;
  String get password => _password;
  String get businessName => _businessName;
  String get businessCategory => _businessCategory;
  String get gstin => _gstin;
  String get phone => _phone;
  String get city => _city;
  String get termsAndConditions => _termsAndConditions;
  String get aadharCard => _aadharCard;
  String get vendorPan => _vendorPan;
  String get businessPan => _businessPan;
  String get electricityBill => _electricityBill;
  String get license => _license;
  List<String> get businessPhotos => _businessPhotos;
  String get role => _role;
  int get noOfServices => _noOfServices;
  bool get isVerified => _isVerified;

  set businessPan(String value) {
    _businessPan = value;
  }

  set vendorPan(String value) {
    _vendorPan = value;
  }

  set aadharCard(String value) {
    _aadharCard = value;
  }

  set termsAndConditions(String value) {
    _termsAndConditions = value;
  }

  set businessCategory(String value) {
    _businessCategory = value;
  }

  set businessName(String value) {
    _businessName = value;
  }

  set password(String value) {
    _password = value;
  }

  set email(String value) {
    _email = value;
  }

  set vendorName(String value) {
    _vendorName = value;
  }
}
