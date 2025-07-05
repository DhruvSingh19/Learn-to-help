class generateCallId{
  static String generate(int id1, int id2, int id3, int id4) {
    List<int> sortedIds = [id1, id2, id3, id4]..sort();
    return '${sortedIds[0]}${sortedIds[1]}${sortedIds[2]}${sortedIds[3]}';
  }
}