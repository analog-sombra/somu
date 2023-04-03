String modidyString(String text, {int num = 8, String char = "..."}) {
  if (text.length <= num) {
    return text;
  }
  return "${text.substring(0, num)}$char";
}
