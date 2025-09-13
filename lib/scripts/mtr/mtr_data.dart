/// MTR Data Storage
///
/// 儲存港鐵線路和車站的中英文資料
/// 使用類似JavaScript object的Map結構

class MTRData {
  // 港鐵線路資料
  static const Map<String, Map<String, String>> mtrLines = {
    'ISL': {
      'fullNameTc': '港島線',
      'fullNameEn': 'Island Line',
      'shortName': 'ISL',
      'color': '#0066CC',
      'defaultDest': 'ADM', // 金鐘
    },
    'TWL': {
      'fullNameTc': '荃灣線',
      'fullNameEn': 'Tsuen Wan Line',
      'shortName': 'TWL',
      'color': '#E2231A',
      'defaultDest': 'TWH', // 荃灣
    },
    'KTL': {
      'fullNameTc': '觀塘線',
      'fullNameEn': 'Kwun Tong Line',
      'shortName': 'KTL',
      'color': '#00B04F',
      'defaultDest': 'TIK', // 調景嶺
    },
    'TKL': {
      'fullNameTc': '將軍澳線',
      'fullNameEn': 'Tseung Kwan O Line',
      'shortName': 'TKL',
      'color': '#8B4513',
      'defaultDest': 'POA', // 寶琳
    },
    'TCL': {
      'fullNameTc': '東涌線',
      'fullNameEn': 'Tung Chung Line',
      'shortName': 'TCL',
      'color': '#FE7F1D',
      'defaultDest': 'TUC', // 東涌
    },
    'EAL': {
      'fullNameTc': '東鐵線',
      'fullNameEn': 'East Rail Line',
      'shortName': 'EAL',
      'color': '#53B7E8',
      'defaultDest': 'LMC', // 落馬洲（完整路線終點站）
    },
    'TML': {
      'fullNameTc': '屯馬線',
      'fullNameEn': 'Tuen Ma Line',
      'shortName': 'TML',
      'color': '#9A3B26',
      'defaultDest': 'TUM', // 屯門（完整路線終點站）
    },
    'SIL': {
      'fullNameTc': '南港島線',
      'fullNameEn': 'South Island Line',
      'shortName': 'SIL',
      'color': '#B5BD00',
      'defaultDest': 'SOH', // 海怡半島
    },
    'AEL': {
      'fullNameTc': '機場快線',
      'fullNameEn': 'Airport Express',
      'shortName': 'AEL',
      'color': '#1C7670',
      'defaultDest': 'AWE', // 機場
    },
  };

  // 港鐵車站資料 - 基於 stationSummary 結構 (無坐標版本)
  static const Map<String, Map<String, dynamic>> mtrStations = {
    // TML | 屯馬線
    'TUM': {
      'fullName': 'Tuen Mun',
      'line': ['TML'],
      'nameTc': '屯門',
    },
    'SIH': {
      'fullName': 'Siu Hong',
      'line': ['TML'],
      'nameTc': '兆康',
    },
    'TIS': {
      'fullName': 'Tin Shui Wai',
      'line': ['TML'],
      'nameTc': '天水圍',
    },
    'LOP': {
      'fullName': 'Long Ping',
      'line': ['TML'],
      'nameTc': '朗屏',
    },
    'YUL': {
      'fullName': 'Yuen Long',
      'line': ['TML'],
      'nameTc': '元朗',
    },
    'KSR': {
      'fullName': 'Kam Sheung Road',
      'line': ['TML'],
      'nameTc': '錦上路',
    },
    'TWW': {
      'fullName': 'Tsuen Wan West',
      'line': ['TML'],
      'nameTc': '荃灣西',
    },
    'MEF': {
      'fullName': 'Mei Foo',
      'line': ['TML', 'TWL'],
      'nameTc': '美孚',
    },
    'NAC': {
      'fullName': 'Nam Cheong',
      'line': ['TML', 'TCL'],
      'nameTc': '南昌',
    },
    'AUS': {
      'fullName': 'Austin',
      'line': ['TML'],
      'nameTc': '柯士甸',
    },
    'ETS': {
      'fullName': 'East Tsim Sha Tsui',
      'line': ['TML'],
      'nameTc': '尖東',
    },
    'HUH': {
      'fullName': 'Hong Hom',
      'line': ['TML', 'EAL'],
      'nameTc': '紅磡',
    },
    'HOM': {
      'fullName': 'Ho Man Tin',
      'line': ['TML', 'KTL'],
      'nameTc': '何文田',
    },
    'TKW': {
      'fullName': 'To Kwa Wan',
      'line': ['TML'],
      'nameTc': '土瓜灣',
    },
    'SUW': {
      'fullName': 'Sung Wong Toi',
      'line': ['TML'],
      'nameTc': '宋皇臺',
    },
    'KAT': {
      'fullName': 'Kai Tak',
      'line': ['TML'],
      'nameTc': '啟德',
    },
    'DIH': {
      'fullName': 'Diamond Hill',
      'line': ['TML', 'KTL'],
      'nameTc': '鑽石山',
    },
    'HIK': {
      'fullName': 'Hin Keng',
      'line': ['TML'],
      'nameTc': '顯徑',
    },
    'TAW': {
      'fullName': 'Tai Wai',
      'line': ['TML', 'EAL'],
      'nameTc': '大圍',
    },
    'CKT': {
      'fullName': 'Che Kung Temple',
      'line': ['TML'],
      'nameTc': '車公廟',
    },
    'STW': {
      'fullName': 'Sha Tin Wai',
      'line': ['TML'],
      'nameTc': '沙田圍',
    },
    'CIO': {
      'fullName': 'City One',
      'line': ['TML'],
      'nameTc': '第一城',
    },
    'SHM': {
      'fullName': 'Shek Mun',
      'line': ['TML'],
      'nameTc': '石門',
    },
    'TSH': {
      'fullName': 'Tai Shui Hang',
      'line': ['TML'],
      'nameTc': '大水坑',
    },
    'HEO': {
      'fullName': 'Heng On',
      'line': ['TML'],
      'nameTc': '恆安',
    },
    'MOS': {
      'fullName': 'Ma On Shan',
      'line': ['TML'],
      'nameTc': '馬鞍山',
    },
    'WKS': {
      'fullName': 'Wu Kai Sha',
      'line': ['TML'],
      'nameTc': '烏溪沙',
    },

    // TKL | 將軍澳線
    'POA': {
      'fullName': 'Po Lam',
      'line': ['TKL'],
      'nameTc': '寶琳',
    },
    'HAH': {
      'fullName': 'Hang Hau',
      'line': ['TKL'],
      'nameTc': '坑口',
    },
    'LHP': {
      'fullName': 'LOHAS Park',
      'line': ['TKL'],
      'nameTc': '康城',
    },
    'TKO': {
      'fullName': 'Tseung Kwan O',
      'line': ['TKL'],
      'nameTc': '將軍澳',
    },
    'TIK': {
      'fullName': 'Tiu Keng Leng',
      'line': ['TKL', 'KTL'],
      'nameTc': '調景嶺',
    },
    'YAT': {
      'fullName': 'Yau Tong',
      'line': ['TKL', 'KTL'],
      'nameTc': '油塘',
    },
    'QUB': {
      'fullName': 'Quarry Bay',
      'line': ['TKL', 'ISL'],
      'nameTc': '鰂魚涌',
    },
    'NOP': {
      'fullName': 'North Point',
      'line': ['TKL', 'ISL'],
      'nameTc': '北角',
    },

    // TCL | 東涌線
    'TUC': {
      'fullName': 'Tung Chung',
      'line': ['TCL'],
      'nameTc': '東涌',
    },
    'SUN': {
      'fullName': 'Sunny Bay',
      'line': ['TCL'],
      'nameTc': '欣澳',
    },
    'TSY': {
      'fullName': 'Tsing Yi',
      'line': ['TCL', 'AEL'],
      'nameTc': '青衣',
    },
    'LAK': {
      'fullName': 'Lai King',
      'line': ['TCL', 'TWL'],
      'nameTc': '荔景',
    },
    'OLY': {
      'fullName': 'Olympic',
      'line': ['TCL'],
      'nameTc': '奧運',
    },
    'KOW': {
      'fullName': 'Kowloon',
      'line': ['TCL', 'AEL'],
      'nameTc': '九龍',
    },
    'HOK': {
      'fullName': 'Hong Kong',
      'line': ['TCL', 'AEL'],
      'nameTc': '香港',
    },

    // AEL | 機場快線
    'AWE': {
      'fullName': 'AsiaWorld-Expo',
      'line': ['AEL'],
      'nameTc': '博覽館',
    },
    'AIR': {
      'fullName': 'Airport',
      'line': ['AEL'],
      'nameTc': '機場',
    },

    // EAL | 東鐵線
    'LMC': {
      'fullName': 'Lok Ma Chau',
      'line': ['EAL'],
      'nameTc': '落馬洲',
    },
    'LOW': {
      'fullName': 'Lo Wu',
      'line': ['EAL'],
      'nameTc': '羅湖',
    },
    'SHS': {
      'fullName': 'Sheung Shui',
      'line': ['EAL'],
      'nameTc': '上水',
    },
    'FAN': {
      'fullName': 'Fanling',
      'line': ['EAL'],
      'nameTc': '粉嶺',
    },
    'TWO': {
      'fullName': 'Tai Wo',
      'line': ['EAL'],
      'nameTc': '太和',
    },
    'TAP': {
      'fullName': 'Tai Po Market',
      'line': ['EAL'],
      'nameTc': '大埔墟',
    },
    'UNI': {
      'fullName': 'University',
      'line': ['EAL'],
      'nameTc': '大學',
    },
    'RAC': {
      'fullName': 'Racecourse',
      'line': ['EAL'],
      'nameTc': '馬場',
    },
    'FOT': {
      'fullName': 'Fo Tan',
      'line': ['EAL'],
      'nameTc': '火炭',
    },
    'SHT': {
      'fullName': 'Sha Tin',
      'line': ['EAL'],
      'nameTc': '沙田',
    },
    'KOT': {
      'fullName': 'Kowloon Tong',
      'line': ['EAL', 'KTL'],
      'nameTc': '九龍塘',
    },
    'MKK': {
      'fullName': 'Mong Kok East',
      'line': ['EAL'],
      'nameTc': '旺角東',
    },
    'EXC': {
      'fullName': 'Exhibition Centre',
      'line': ['EAL'],
      'nameTc': '會展',
    },
    'ADM': {
      'fullName': 'Admiralty',
      'line': ['EAL', 'SIL', 'ISL', 'TWL'],
      'nameTc': '金鐘',
    },

    // SIL | 南港島線
    'SOH': {
      'fullName': 'South Horizons',
      'line': ['SIL'],
      'nameTc': '海怡半島',
    },
    'LET': {
      'fullName': 'Lei Tung',
      'line': ['SIL'],
      'nameTc': '利東',
    },
    'WCH': {
      'fullName': 'Wong Chuk Hang',
      'line': ['SIL'],
      'nameTc': '黃竹坑',
    },
    'OCP': {
      'fullName': 'Ocean Park',
      'line': ['SIL'],
      'nameTc': '海洋公園',
    },

    // TWL | 荃灣線
    'TSW': {
      'fullName': 'Tsuen Wan',
      'line': ['TWL'],
      'nameTc': '荃灣',
    },
    'TWH': {
      'fullName': 'Tai Wo Hau',
      'line': ['TWL'],
      'nameTc': '大窩口',
    },
    'KWH': {
      'fullName': 'Kwai Hing',
      'line': ['TWL'],
      'nameTc': '葵興',
    },
    'KWF': {
      'fullName': 'Kwai Fong',
      'line': ['TWL'],
      'nameTc': '葵芳',
    },
    'LCK': {
      'fullName': 'Lai Chi Kok',
      'line': ['TWL'],
      'nameTc': '茘枝角',
    },
    'CSW': {
      'fullName': 'Cheung Sha Wan',
      'line': ['TWL'],
      'nameTc': '長沙灣',
    },
    'SSP': {
      'fullName': 'Sham Shui Po',
      'line': ['TWL'],
      'nameTc': '深水埗',
    },
    'PRE': {
      'fullName': 'Prince Edward',
      'line': ['TWL', 'KTL'],
      'nameTc': '太子',
    },
    'MOK': {
      'fullName': 'Mong Kok',
      'line': ['TWL', 'KTL'],
      'nameTc': '旺角',
    },
    'YMT': {
      'fullName': 'Yau Ma Tei',
      'line': ['TWL', 'KTL'],
      'nameTc': '油麻地',
    },
    'JOR': {
      'fullName': 'Jordan',
      'line': ['TWL'],
      'nameTc': '佐敦',
    },
    'TST': {
      'fullName': 'Tsim Sha Tsui',
      'line': ['TWL'],
      'nameTc': '尖沙咀',
    },
    'CEN': {
      'fullName': 'Central',
      'line': ['TWL', 'ISL'],
      'nameTc': '中環',
    },

    // ISL | 港島線
    'CHW': {
      'fullName': 'Chai Wan',
      'line': ['ISL'],
      'nameTc': '柴灣',
    },
    'HFC': {
      'fullName': 'Heng Fa Cheun',
      'line': ['ISL'],
      'nameTc': '杏花邨',
    },
    'SKW': {
      'fullName': 'Shau Kei Wan',
      'line': ['ISL'],
      'nameTc': '筲箕灣',
    },
    'SWH': {
      'fullName': 'Sai Wan Ho',
      'line': ['ISL'],
      'nameTc': '西灣河',
    },
    'TAK': {
      'fullName': 'Tai Koo',
      'line': ['ISL'],
      'nameTc': '太古',
    },
    'FOH': {
      'fullName': 'Fortress Hill',
      'line': ['ISL'],
      'nameTc': '炮台山',
    },
    'TIH': {
      'fullName': 'Tin Hau',
      'line': ['ISL'],
      'nameTc': '天后',
    },
    'CAB': {
      'fullName': 'Causeway Bay',
      'line': ['ISL'],
      'nameTc': '銅鑼灣',
    },
    'WAC': {
      'fullName': 'Wan Chai',
      'line': ['ISL'],
      'nameTc': '灣仔',
    },
    'SHW': {
      'fullName': 'Sheung Wan',
      'line': ['ISL'],
      'nameTc': '上環',
    },
    'SYP': {
      'fullName': 'Sai Ying Pun',
      'line': ['ISL'],
      'nameTc': '西營盤',
    },
    'HKU': {
      'fullName': 'HKU',
      'line': ['ISL'],
      'nameTc': '香港大學',
    },
    'KET': {
      'fullName': 'Kennedy Town',
      'line': ['ISL'],
      'nameTc': '堅尼地城',
    },

    // KTL | 觀塘線
    'LAT': {
      'fullName': 'Lam Tin',
      'line': ['KTL'],
      'nameTc': '藍田',
    },
    'KWT': {
      'fullName': 'Kwun Tong',
      'line': ['KTL'],
      'nameTc': '觀塘',
    },
    'NTK': {
      'fullName': 'Ngau Tau Kok',
      'line': ['KTL'],
      'nameTc': '牛頭角',
    },
    'KOB': {
      'fullName': 'Kowloon Bay',
      'line': ['KTL'],
      'nameTc': '九龍灣',
    },
    'CHH': {
      'fullName': 'Choi Hung',
      'line': ['KTL'],
      'nameTc': '彩虹',
    },
    'WTS': {
      'fullName': 'Wong Tai Sin',
      'line': ['KTL'],
      'nameTc': '黃大仙',
    },
    'LOF': {
      'fullName': 'Lok Fu',
      'line': ['KTL'],
      'nameTc': '樂富',
    },
    'SKM': {
      'fullName': 'Shek Kip Mei',
      'line': ['KTL'],
      'nameTc': '石硤尾',
    },
    'WHA': {
      'fullName': 'Whampoa',
      'line': ['KTL'],
      'nameTc': '黃埔',
    },
  };

  /// 獲取線路資料
  static Map<String, String>? getLineData(String lineCode) {
    return mtrLines[lineCode];
  }

  /// 獲取車站資料
  static Map<String, dynamic>? getStationData(String stationCode) {
    return mtrStations[stationCode];
  }

  /// 根據線路獲取所有車站
  static List<Map<String, dynamic>> getStationsByLine(String lineCode) {
    return mtrStations.values.where((station) {
      final lines = station['line'];
      if (lines is List) {
        return lines.contains(lineCode);
      }
      return false;
    }).toList();
  }

  /// 搜尋車站
  static List<Map<String, dynamic>> searchStations(String query) {
    final lowerQuery = query.toLowerCase();
    return mtrStations.values
        .where((station) =>
            station['nameTc']?.toString().contains(query) == true ||
            station['fullName']
                    ?.toString()
                    .toLowerCase()
                    .contains(lowerQuery) ==
                true)
        .toList();
  }

  /// 搜尋線路
  static List<Map<String, String>> searchLines(String query) {
    final lowerQuery = query.toLowerCase();
    return mtrLines.values
        .where((line) =>
            line['fullNameTc']!.contains(query) ||
            line['fullNameEn']!.toLowerCase().contains(lowerQuery) ||
            line['shortName']!.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// 獲取車站所屬的所有線路
  static List<String> getStationLines(String stationCode) {
    final station = mtrStations[stationCode];
    if (station != null && station['line'] is List) {
      return List<String>.from(station['line']);
    }
    return [];
  }

  /// 獲取所有線路代碼
  static Set<String> getAllLineCodes() {
    final Set<String> lineCodes = {};
    for (final station in mtrStations.values) {
      final lines = station['line'];
      if (lines is List) {
        for (final line in lines) {
          if (line is String) {
            lineCodes.add(line);
          }
        }
      }
    }
    return lineCodes;
  }
}
