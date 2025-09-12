import 'package:flutter/material.dart';

// MTR Station positions on the SVG map
// These coordinates are approximate and based on the MTR_Map.svg file
class MTRStationPositions {
  static final Map<String, Offset> stationPositions = {
    // Island Line (ISL) - Blue Line
    // '堅尼地城': Offset(120, 380),
    // '香港大學': Offset(140, 380),
    // '西營盤': Offset(160, 380),
    // '上環': Offset(180, 380),
    // '中環': Offset(200, 380),
    // '金鐘': Offset(220, 380),
    // '灣仔': Offset(240, 380),
    // '銅鑼灣': Offset(260, 380),
    // '天后': Offset(280, 380),
    // '炮台山': Offset(300, 380),
    // '北角': Offset(320, 380),
    // '鰂魚涌': Offset(340, 380),
    // '太古': Offset(360, 380),
    // '西灣河': Offset(380, 380),
    // '筲箕灣': Offset(400, 380),
    // '杏花邨': Offset(420, 380),
    // '柴灣': Offset(440, 380),

    // Tsuen Wan Line (TWL) - Red Line
    // '荃灣': Offset(80, 200),
    // '大窩口': Offset(100, 220),
    // '葵興': Offset(120, 240),
    // '葵芳': Offset(140, 260),
    // '荔景': Offset(160, 280),
    // '美孚': Offset(180, 300),
    // '荔枝角': Offset(200, 320),
    // '長沙灣': Offset(220, 340),
    // '深水埗': Offset(240, 360),
    // '太子': Offset(260, 380),
    // '旺角': Offset(280, 400),
    // '油麻地': Offset(300, 420),
    // '佐敦': Offset(320, 440),
    // '尖沙咀': Offset(340, 460),

    // Kwun Tong Line (KTL) - Green Line
    // '黃埔': Offset(200, 500),
    // '何文田': Offset(220, 480),
    // '石硤尾': Offset(240, 460),
    // '九龍塘': Offset(260, 440),
    // '樂富': Offset(280, 420),
    // '黃大仙': Offset(300, 400),
    // '鑽石山': Offset(320, 380),
    // '彩虹': Offset(340, 360),
    // '九龍灣': Offset(360, 340),
    // '牛頭角': Offset(380, 320),
    // '觀塘': Offset(400, 300),
    // '藍田': Offset(420, 280),
    // '油塘': Offset(440, 260),

    // Tseung Kwan O Line (TKL) - Brown Line
    '調景嶺': Offset(460, 240),
    '將軍澳': Offset(480, 220),
    '坑口': Offset(500, 200),
    '寶琳': Offset(520, 180),
    '康城': Offset(540, 160),

    // East Rail Line (EAL) - Blue Line
    // '羅湖': Offset(300, 80),
    // '落馬洲': Offset(280, 80),
    // '上水': Offset(300, 100),
    // '粉嶺': Offset(300, 120),
    // '太和': Offset(300, 140),
    // '大埔墟': Offset(300, 160),
    // '大學': Offset(300, 180),
    // '馬場': Offset(300, 200),
    // '火炭': Offset(300, 220),
    // '沙田': Offset(300, 240),
    // '大圍': Offset(300, 260),
    // '旺角東': Offset(280, 400),
    // '紅磡': Offset(320, 480),
    // '會展': Offset(200, 360),

    // Tuen Ma Line (TML) - Purple Line
    // '屯門': Offset(40, 180),
    // '兆康': Offset(60, 180),
    // '天水圍': Offset(80, 180),
    // '朗屏': Offset(100, 180),
    // '元朗': Offset(120, 180),
    // '錦上路': Offset(140, 180),
    // '荃灣西': Offset(80, 220),
    // '南昌': Offset(160, 320),
    // '柯士甸': Offset(300, 440),
    // '尖東': Offset(340, 460),
    // '土瓜灣': Offset(240, 500),
    // '宋皇臺': Offset(260, 520),
    // '啟德': Offset(280, 540),
    // '顯徑': Offset(320, 260),
    // '車公廟': Offset(320, 280),
    // '沙田圍': Offset(320, 300),
    // '第一城': Offset(340, 320),
    // '石門': Offset(360, 340),
    // '大水坑': Offset(380, 360),
    // '恆安': Offset(400, 380),
    // '馬鞍山': Offset(420, 400),
    // '烏溪沙': Offset(440, 420),

    // South Island Line (SIL) - Purple Line
    '海怡半島': Offset(122, 373),
    '利東': Offset(200, 420),
    '黃竹坑': Offset(220, 420),
    '海洋公園': Offset(240, 420),

    // Airport Express (AEL) - Green Line
    '香港': Offset(200, 380),
    '九龍': Offset(300, 440),
    '青衣': Offset(120, 300),
    '機場': Offset(60, 320),
    '博覽館': Offset(40, 340),
  };

  // Get station position by name
  static Offset? getStationPosition(String stationName) {
    return stationPositions[stationName];
  }

  // Get all stations within a certain radius of a tap position
  static List<String> getStationsNearPosition(Offset tapPosition,
      {double radius = 30.0}) {
    List<String> nearbyStations = [];

    stationPositions.forEach((stationName, stationPosition) {
      double distance = (tapPosition - stationPosition).distance;
      if (distance <= radius) {
        nearbyStations.add(stationName);
      }
    });

    return nearbyStations;
  }

  // Get the closest station to a tap position
  static String? getClosestStation(Offset tapPosition,
      {double maxDistance = 50.0}) {
    String? closestStation;
    double minDistance = double.infinity;

    stationPositions.forEach((stationName, stationPosition) {
      double distance = (tapPosition - stationPosition).distance;
      if (distance < minDistance && distance <= maxDistance) {
        minDistance = distance;
        closestStation = stationName;
      }
    });

    return closestStation;
  }
}
