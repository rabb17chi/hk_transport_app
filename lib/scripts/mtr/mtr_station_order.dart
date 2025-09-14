/// MTR 車站排序規則
///
/// 定義各線路車站的顯示順序，按照實際的上下行方向排列

class MTRStationOrder {
  /// 獲取車站排序順序
  static int getStationOrder(String lineCode, Map<String, dynamic> station) {
    final stationNameTc = station['nameTc'] as String;

    // 荃灣線 TWL 車站順序
    if (lineCode == 'TWL') {
      const twlOrder = [
        '荃灣',
        '大窩口',
        '葵興',
        '葵芳',
        '荔景',
        '美孚',
        '茘枝角', // 修正：使用正確的字符
        '長沙灣',
        '深水埗',
        '太子',
        '旺角',
        '油麻地',
        '佐敦',
        '尖沙咀',
        '金鐘',
        '中環'
      ];
      final index = twlOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 東涌線 TCL 車站順序
    if (lineCode == 'TCL') {
      const tclOrder = ['東涌', '欣澳', '青衣', '荔景', '南昌', '奧運', '九龍', '香港'];
      final index = tclOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 東鐵線 EAL 車站順序
    if (lineCode == 'EAL') {
      const ealOrder = [
        '羅湖',
        '落馬洲',
        '上水',
        '粉嶺',
        '太和',
        '大埔墟',
        '大學',
        '馬場',
        '火炭',
        '沙田',
        '大圍',
        '九龍塘',
        '旺角東',
        '紅磡',
        '會展',
        '金鐘'
      ];
      final index = ealOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 觀塘線 KTL 車站順序
    if (lineCode == 'KTL') {
      const ktlOrder = [
        '調景嶺',
        '油塘',
        '藍田',
        '觀塘',
        '牛頭角',
        '九龍灣',
        '彩虹',
        '鑽石山',
        '黃大仙',
        '樂富',
        '九龍塘',
        '石硤尾',
        '太子',
        '旺角',
        '油麻地',
        '何文田',
        '黃埔'
      ];
      final index = ktlOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 港島線 ISL 車站順序
    if (lineCode == 'ISL') {
      const islOrder = [
        '堅尼地城',
        '香港大學',
        '西營盤',
        '上環',
        '中環',
        '金鐘',
        '灣仔',
        '銅鑼灣',
        '天后',
        '炮台山',
        '北角',
        '鰂魚涌',
        '太古',
        '西灣河',
        '筲箕灣',
        '杏花邨',
        '柴灣'
      ];
      final index = islOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 機場快線 AEL 車站順序
    if (lineCode == 'AEL') {
      const aelOrder = ['博覽館', '機場', '青衣', '九龍', '香港'];
      final index = aelOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 南港島線 SIL 車站順序
    if (lineCode == 'SIL') {
      const silOrder = ['金鐘', '海洋公園', '黃竹坑', '利東', '海怡半島'];
      final index = silOrder.indexOf(stationNameTc);
      return index == -1 ? 999 : index; // 未找到的車站排在最後
    }

    // 其他線路暫時按中文名稱排序
    return 0;
  }

  /// 對車站列表進行排序
  static List<Map<String, dynamic>> sortStationsByLine(
      String lineCode, List<Map<String, dynamic>> stations) {
    final sortedStations = List<Map<String, dynamic>>.from(stations);
    sortedStations.sort((a, b) =>
        getStationOrder(lineCode, a).compareTo(getStationOrder(lineCode, b)));
    return sortedStations;
  }
}
