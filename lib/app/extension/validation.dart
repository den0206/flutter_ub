bool _isValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String validateEmail(String value) {
  if (value.isEmpty) {
    return "Please add in a email";
  } else if (!_isValidEmail(value)) {
    return "No email Regex";
  } else {
    return null;
  }
}
