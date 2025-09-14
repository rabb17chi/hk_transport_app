import 'package:flutter/material.dart';
import '../../scripts/mtr/mtr_data.dart';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../../scripts/mtr/mtr_station_order.dart';
import '../../scripts/vibration_helper.dart';
import 'mtr_schedule_dialog.dart';

/// MTR 列表式車站選擇界面
///
/// 專注於列表式車站選擇，不包含地圖功能
class MTRListScreen extends StatefulWidget {
  const MTRListScreen({super.key});

  @override
  State<MTRListScreen> createState() => _MTRListScreenState();
}

class _MTRListScreenState extends State<MTRListScreen> {
  String? selectedStation;
  String? selectedStationId;
  String? selectedLineCode;
  String? currentLineCode; // 當前選擇的線路代碼

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('港鐵 MTR'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            onPressed: () async {
              // 觸發中等振動
              await VibrationHelper.mediumVibrate();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('模式切換'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: '模式切換',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildStationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStationList() {
    // 獲取所有車站並按線路分組
    final stationsByLine = <String, List<Map<String, dynamic>>>{};

    for (final station in MTRData.mtrStations.values) {
      final lines = station['line'] as List<String>?;
      if (lines != null) {
        for (final lineCode in lines) {
          if (!stationsByLine.containsKey(lineCode)) {
            stationsByLine[lineCode] = [];
          }
          stationsByLine[lineCode]!.add(station);
        }
      }
    }

    // 顯示所有線路
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stationsByLine.length,
      itemBuilder: (context, index) {
        final lineCode = stationsByLine.keys.elementAt(index);
        final stations = stationsByLine[lineCode]!;

        return _buildLineSection(lineCode, stations);
      },
    );
  }

  Widget _buildLineSection(
      String lineCode, List<Map<String, dynamic>> stations) {
    final lineData = MTRData.mtrLines[lineCode];
    final lineNameTc = lineData?['fullNameTc'] ?? lineCode;
    final lineNameEn = lineData?['fullNameEn'] ?? lineCode;
    final lineColor = _getLineColor(lineCode);

    final isLineSelected = currentLineCode == lineCode;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: lineColor, width: 2),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lineNameTc,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isLineSelected ? lineColor : null,
                    ),
                  ),
                  Text(
                    lineNameEn,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  '${stations.length} 站',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        onExpansionChanged: (isExpanded) async {
          // 觸發輕微振動
          await VibrationHelper.lightVibrate();

          if (isExpanded) {
            // 當展開線路時，設定當前線路代碼
            setState(() {
              currentLineCode = lineCode;
              // 清除之前的車站選擇
              selectedStation = null;
              selectedStationId = null;
              selectedLineCode = null;
            });

            // 線路已選擇
          } else {
            // 當關閉線路時，清除當前線路代碼
            setState(() {
              if (currentLineCode == lineCode) {
                currentLineCode = null;
                selectedStation = null;
                selectedStationId = null;
                selectedLineCode = null;
              }
            });
          }
        },
        children: () {
          // 使用新的排序邏輯
          final sortedStations =
              MTRStationOrder.sortStationsByLine(lineCode, stations);

          // 轉換為 Widget
          return sortedStations.map((station) {
            // 從車站數據中查找對應的key
            String? stationKey;
            for (final entry in MTRData.mtrStations.entries) {
              if (entry.value == station) {
                stationKey = entry.key;
                break;
              }
            }
            return _buildStationTile(station, stationKey ?? '', lineCode);
          }).toList();
        }(),
      ),
    );
  }

  Widget _buildStationTile(
      Map<String, dynamic> station, String stationKey, String lineCode) {
    final stationNameTc = station['nameTc'] as String;
    final stationNameEn = station['fullName'] as String;
    final isSelected = selectedStationId == stationNameEn; // 使用 fullName 作為比較

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? _getLineColor(lineCode) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            stationKey,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      title: Text(
        stationNameTc,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? _getLineColor(lineCode) : null,
        ),
      ),
      subtitle: Text(stationNameEn),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: _getLineColor(lineCode),
            )
          : null,
      onTap: () async {
        // 觸發中等振動
        await VibrationHelper.mediumVibrate();

        _selectStation(stationNameTc, stationKey, lineCode);
      },
    );
  }

  void _selectStation(
      String stationName, String stationId, String lineCode) async {
    // 如果沒有選擇的線路，使用傳入的線路代碼
    var selectedLineCode = currentLineCode ?? lineCode;

    // 更新當前線路代碼
    if (currentLineCode != lineCode) {
      setState(() {
        currentLineCode = lineCode;
      });
    }

    // 獲取完整的車站資料
    final stationData = MTRData.getStationData(stationId);

    // 打印車站詳細信息
    if (stationData != null) {
      // 調用MTR API獲取時刻表
      final response = await MTRScheduleService.getSchedule(
        lineCode: selectedLineCode,
        stationId: stationId,
      );

      if (response != null) {
        // 顯示時刻表對話框
        showDialog(
          context: context,
          builder: (context) => MTRScheduleDialog(
            initialResponse: response,
            stationName: stationName,
            lineCode: selectedLineCode,
            stationId: stationId,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('無法獲取時刻表，請稍後重試'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('找不到車站資料'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }

    setState(() {
      selectedStation = stationName;
      selectedStationId = stationId;
      selectedLineCode = selectedLineCode;
    });
  }

  Color _getLineColor(String lineCode) {
    const Map<String, Color> lineColors = {
      'TWL': Color(0xFFE2231A), // 荃灣線 - 紅色
      'KTL': Color(0xFF00B04F), // 觀塘線 - 綠色
      'ISL': Color(0xFF0066CC), // 港島線 - 藍色
      'TKL': Color(0xFF8B4513), // 將軍澳線 - 棕色
      'TCL': Color(0xFFFE7F1D), // 東涌線 - 橙色
      'AEL': Color(0xFF1C7670), // 機場快線 - 深綠色
      'EAL': Color(0xFF53B7E8), // 東鐵線 - 淺藍色
      'TML': Color(0xFF9A3B26), // 屯馬線 - 深紅色
      'SIL': Color(0xFFB5BD00), // 南港島線 - 黃綠色
    };

    return lineColors[lineCode] ?? const Color(0xFF000000);
  }
}
