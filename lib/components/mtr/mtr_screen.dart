import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../scripts/mtr/map_station_pos.dart';

class MTRScreen extends StatefulWidget {
  const MTRScreen({super.key});

  @override
  State<MTRScreen> createState() => _MTRScreenState();
}

class _MTRScreenState extends State<MTRScreen> {
  String? selectedStation;
  bool isMapVisible = true;

  // MTR Line colors
  static const Map<String, Color> lineColors = {
    'TCL': Color(0xFFE2231A), // Red Line
    'TKL': Color(0xFF8B4513), // Brown Line
    'EAL': Color(0xFF0066CC), // Blue Line
    'TML': Color(0xFF800080), // Purple Line
    'WRL': Color(0xFF00B04F), // Green Line
    'AEL': Color(0xFF00B04F), // Airport Express
    'TWL': Color(0xFFE2231A), // Tsuen Wan Line
    'KTL': Color(0xFF00B04F), // Kwun Tong Line
    'ISL': Color(0xFF0066CC), // Island Line
    'SIL': Color(0xFF800080), // South Island Line
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('港鐵 MTR'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isMapVisible ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                isMapVisible = !isMapVisible;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedStation != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                  // children: [
                  //   Text(
                  //     '已選擇車站: $selectedStation',
                  //     style: const TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //   const SizedBox(height: 8),
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         selectedStation = null;
                  //       });
                  //     },
                  //     child: const Text('清除選擇'),
                  //   ),
                  // ],
                  ),
            ),
          Expanded(
            child: isMapVisible ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.5,
              maxScale: 10.0,
              child: GestureDetector(
                onTapDown: (details) {
                  _handleMapTap(details.localPosition);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: SvgPicture.asset(
                    'lib/assets/MTR_Map.svg',
                    fit: BoxFit.contain,
                    placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(20.0),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMapTap(Offset position) {
    print('position: $position');

    // Use the station positions to detect taps
    final String? closestStation =
        MTRStationPositions.getClosestStation(position, maxDistance: 50.0);

    if (closestStation != null) {
      setState(() {
        selectedStation = closestStation;
      });
      print('selectedStation: $selectedStation');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已選擇車站: $closestStation'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('未找到附近車站，請嘗試點擊車站位置或使用列表視圖'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLineSection('港島線 Island Line', 'ISL', [
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
        ]),
        _buildLineSection('荃灣線 Tsuen Wan Line', 'TWL', [
          '中環',
          '金鐘',
          '尖沙咀',
          '佐敦',
          '油麻地',
          '旺角',
          '太子',
          '深水埗',
          '長沙灣',
          '荔枝角',
          '美孚',
          '荔景',
          '葵芳',
          '葵興',
          '大窩口',
          '荃灣'
        ]),
        _buildLineSection('觀塘線 Kwun Tong Line', 'KTL', [
          '黃埔',
          '何文田',
          '油麻地',
          '旺角',
          '太子',
          '石硤尾',
          '九龍塘',
          '樂富',
          '黃大仙',
          '鑽石山',
          '彩虹',
          '九龍灣',
          '牛頭角',
          '觀塘',
          '藍田',
          '油塘'
        ]),
        _buildLineSection('將軍澳線 Tseung Kwan O Line', 'TKL',
            ['北角', '鰂魚涌', '油塘', '調景嶺', '將軍澳', '坑口', '寶琳', '康城']),
        _buildLineSection('東鐵線 East Rail Line', 'EAL', [
          '金鐘',
          '會展',
          '紅磡',
          '旺角東',
          '九龍塘',
          '大圍',
          '沙田',
          '火炭',
          '馬場',
          '大學',
          '大埔墟',
          '太和',
          '粉嶺',
          '上水',
          '羅湖',
          '落馬洲'
        ]),
        _buildLineSection('屯馬線 Tuen Ma Line', 'TML', [
          '屯門',
          '兆康',
          '天水圍',
          '朗屏',
          '元朗',
          '錦上路',
          '荃灣西',
          '美孚',
          '南昌',
          '柯士甸',
          '尖東',
          '紅磡',
          '何文田',
          '土瓜灣',
          '宋皇臺',
          '啟德',
          '鑽石山',
          '顯徑',
          '大圍',
          '車公廟',
          '沙田圍',
          '第一城',
          '石門',
          '大水坑',
          '恆安',
          '馬鞍山',
          '烏溪沙'
        ]),
        _buildLineSection('南港島線 South Island Line', 'SIL',
            ['海怡半島', '利東', '黃竹坑', '海洋公園', '金鐘']),
        _buildLineSection(
            '機場快線 Airport Express', 'AEL', ['香港', '九龍', '青衣', '機場', '博覽館']),
      ],
    );
  }

  Widget _buildLineSection(
      String title, String lineCode, List<String> stations) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: lineColors[lineCode] ?? Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        children: stations
            .map((station) => ListTile(
                  title: Text(station),
                  onTap: () {
                    setState(() {
                      selectedStation = station;
                    });
                  },
                  selected: selectedStation == station,
                ))
            .toList(),
      ),
    );
  }
}
