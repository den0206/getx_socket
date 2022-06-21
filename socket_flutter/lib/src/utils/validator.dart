String? valideName(String? value) {
  if (value == null || value.isEmpty) {
    return "Your Name";
  } else if (value.length < 3) {
    return "more 3";
  } else {
    return null;
  }
}

bool _isValidEmail(String email) {
  return RegExp(
          r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$")
      .hasMatch(email);
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Please add in a email";
  } else if (!_isValidEmail(value)) {
    return "No email Regex";
  } else {
    return null;
  }
}

String? validPassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Please add in a Passwrod";
  } else if (value.length < 5) {
    return "More Long Password(5)";
  } else {
    return null;
  }
}
