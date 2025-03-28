abstract class Validations {

  static String? validateEmail(String? email) {
    final RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if(email == null || email.trim().isEmpty ){
      return " please Enter Your Email Address";
    }
    if(emailRegExp.hasMatch(email) == false){
      return "Please Enter A Valid Email Address";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    final RegExp passwordRegExp =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if(password == null || password.trim().isEmpty ){
      return " please Enter Your Password";
    }else if(password.length < 8 || !passwordRegExp.hasMatch(password) ){
      return "Please Enter Strong Password";
    }
    return null;
  }

  static String? validateConfirmPassword(String? rePassword , String? password ){
    if(rePassword == null || rePassword.isEmpty){
      return"Enter Your Password";
    }else if(rePassword != password){
      return "Password Must Match";
    }
    return null;
  }

  static String? ValidateUserName(String? userName){
    RegExp userNameRegExp = RegExp(r'^[a-zA-Z0-9,.-]+$');

    if(userName == null || userName.isEmpty){
      return"Please Enter Your User Name";
    }else if(!userNameRegExp.hasMatch(userName)){
      return "Please Enter Valid UserName";
    }
    return null;
  }

  static String? ValidateFullName(String? fullName){
    if(fullName == null || fullName.isEmpty){
      return "Required";
    }
    return null;
  }

  static String? ValidatePhoneNumber(String? number){
    if(number == null || number.isEmpty){
      return "Required";
    }else if(int.tryParse(number.trim()) == null){
      return "Enter Your Number";
    }else if(number.trim().length != 11){
      return "Value Must Equal 11 Digits";
    } return null;
  }
}