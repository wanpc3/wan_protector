String PswdStrength(String pswd) {
  if (pswd.length == 0) {
    return 'None';
  }
  else if (pswd.length < 6) {
    return 'Weak';
  }
  else if (pswd.length < 10) {
    return 'Moderate';
  }
  else if (pswd.length >= 10 &&
      pswd.contains(RegExp(r'[A-Z]')) &&
      pswd.contains(RegExp(r'[a-z]')) &&
      pswd.contains(RegExp(r'[0-9]')) &&
      pswd.contains(RegExp(r'[@$!%*?&]'))) {
    return 'Strong';
  } else {
    return 'Moderate';
  }
}