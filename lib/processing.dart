class processing{
  static String doubleDigit(int value){
    String ret = "";
    if(value < 10){
      ret = '0';
    }
    return ret += value.toString();
  }

}