class generateChatId{
  static String generate(int id1, int id2) {
    List<int> sortedIds = [id1, id2]..sort();
    return '${sortedIds[0]}${sortedIds[1]}';
  }
}
