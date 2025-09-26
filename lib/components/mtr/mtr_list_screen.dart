import 'package:flutter/material.dart';
import '../../scripts/mtr/mtr_data.dart';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../../scripts/mtr/mtr_station_order.dart';
import '../../scripts/utils/vibration_helper.dart';
import 'mtr_schedule_dialog.dart';
import '../../scripts/bookmarks/mtr_bookmarks_service.dart';
import '../../l10n/locale_utils.dart';
import '../../scripts/utils/settings_service.dart';

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
  bool _isLoadingSchedule = false;
  bool _reverseStations = false;

  @override
  void initState() {
    super.initState();
    // Load persisted settings and listen for changes
    SettingsService.load();
    _reverseStations = SettingsService.mtrReverseStationsNotifier.value;
    SettingsService.mtrReverseStationsNotifier.addListener(_onReverseChanged);
    MTRBookmarksService.refreshTrigger.addListener(_onBookmarkChanged);
  }

  @override
  void dispose() {
    SettingsService.mtrReverseStationsNotifier
        .removeListener(_onReverseChanged);
    MTRBookmarksService.refreshTrigger.removeListener(_onBookmarkChanged);
    super.dispose();
  }

  void _onReverseChanged() {
    setState(() {
      _reverseStations = SettingsService.mtrReverseStationsNotifier.value;
    });
  }

  void _onBookmarkChanged() {
    setState(() {
      // Trigger rebuild to refresh bookmark status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildStationList(),
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
        trailing: const SizedBox.shrink(),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                LocaleUtils.isChinese(context) ? lineNameTc : lineNameEn,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isLineSelected ? lineColor : null,
                ),
              ),
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
          List<Map<String, dynamic>> sortedStations =
              MTRStationOrder.sortStationsByLine(lineCode, stations);
          if (_reverseStations) {
            sortedStations =
                List<Map<String, dynamic>>.from(sortedStations.reversed);
          }

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
    // Removed selection visuals; no checked state for station buttons
    final isChinese = LocaleUtils.isChinese(context);
    final displayTitle = isChinese ? stationNameTc : stationNameEn;
    final displaySubtitle = isChinese ? stationNameEn : stationNameTc;

    return FutureBuilder<bool>(
      future: _isStationBookmarked(
          stationKey, lineCode, stationNameTc, stationNameEn),
      builder: (context, snapshot) {
        final isBookmarked = snapshot.data ?? false;

        return Container(
          color: isBookmarked ? Colors.pink[50] : null,
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  stationKey,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    displayTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isBookmarked
                            ? Colors.black
                            : Theme.of(context).colorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Builder(
                  builder: (_) {
                    final lines =
                        (station['line'] as List<dynamic>?)?.cast<String>() ??
                            <String>[];
                    final otherLines =
                        lines.where((c) => c != lineCode).toList();
                    if (otherLines.isEmpty) return const SizedBox.shrink();
                    return Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children:
                          otherLines.map((c) => _buildLineBadge(c)).toList(),
                    );
                  },
                ),
              ],
            ),
            subtitle: Text(displaySubtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isBookmarked
                        ? Colors.black
                        : Theme.of(context).colorScheme.onSurface)),
            trailing: null,
            onTap: _isLoadingSchedule
                ? null
                : () async {
                    await VibrationHelper.mediumVibrate();

                    _selectStation(displayTitle, stationKey, lineCode);
                  },
            onLongPress: () async {
              await VibrationHelper.mediumVibrate();
              final item = MTRBookmarkItem(
                lineCode: lineCode,
                stationId: stationKey,
                stationNameTc: stationNameTc,
                stationNameEn: stationNameEn,
              );
              final isBookmarked = await MTRBookmarksService.isBookmarked(item);
              if (isBookmarked) {
                await MTRBookmarksService.removeBookmark(item);
              } else {
                await MTRBookmarksService.addBookmark(item);
              }
              // Refresh the UI to show updated bookmark status
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Future<bool> _isStationBookmarked(String stationKey, String lineCode,
      String stationNameTc, String stationNameEn) async {
    final item = MTRBookmarkItem(
      lineCode: lineCode,
      stationId: stationKey,
      stationNameTc: stationNameTc,
      stationNameEn: stationNameEn,
    );
    return await MTRBookmarksService.isBookmarked(item);
  }

  void _selectStation(
      String stationName, String stationId, String lineCode) async {
    if (_isLoadingSchedule) {
      return; // Prevent multi-click while loading
    }
    setState(() {
      _isLoadingSchedule = true;
    });
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
    try {
      if (stationData != null) {
        // 調用MTR API獲取時刻表
        final response = await MTRScheduleService.getSchedule(
          lineCode: selectedLineCode,
          stationId: stationId,
        );

        if (!mounted) return;

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('找不到車站資料'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSchedule = false;
        });
      } else {
        _isLoadingSchedule = false;
      }
    }

    setState(() {
      selectedStation = stationName;
      selectedStationId = stationId;
      selectedLineCode = selectedLineCode;
    });
  }

  Color _getLineColor(String lineCode) => MTRData.getLineColor(lineCode);

  Widget _buildLineBadge(String code) {
    final color = _getLineColor(code);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
