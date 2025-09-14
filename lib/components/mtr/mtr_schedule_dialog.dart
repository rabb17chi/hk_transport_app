/// MTR 時刻表對話框
///
/// 顯示列車時刻表的彈出對話框，包含上行和下行方向的列車信息

import 'package:flutter/material.dart';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../../scripts/mtr/mtr_data.dart';
import '../../scripts/vibration_helper.dart';

class MTRScheduleDialog extends StatefulWidget {
  final MTRScheduleResponse initialResponse;
  final String stationName;
  final String lineCode;
  final String stationId;

  const MTRScheduleDialog({
    Key? key,
    required this.initialResponse,
    required this.stationName,
    required this.lineCode,
    required this.stationId,
  }) : super(key: key);

  @override
  State<MTRScheduleDialog> createState() => _MTRScheduleDialogState();
}

class _MTRScheduleDialogState extends State<MTRScheduleDialog> {
  late MTRScheduleResponse response;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    response = widget.initialResponse;
  }

  Future<void> updateByRefresh() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newResponse = await MTRScheduleService.getSchedule(
        lineCode: widget.lineCode,
        stationId: widget.stationId,
      );

      if (newResponse != null) {
        setState(() {
          response = newResponse;
        });

        // 顯示成功消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已更新 ${widget.stationName} 時刻表'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // 顯示錯誤消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('無法更新時刻表，請稍後重試'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 顯示錯誤消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新失敗: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final upTrains = response.getUpTrains();
    final downTrains = response.getDownTrains();
    final lineColor = _getLineColor(widget.lineCode);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      shadowColor: lineColor.withOpacity(0.8),
      title: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _getLineColor(widget.lineCode),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.stationName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  _getLineDisplayName(response.lineCode),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('正在更新時刻表...'),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 上行方向
                    if (upTrains.isNotEmpty) ...[
                      _buildDirectionSection('上行方向', upTrains, Colors.green),
                      const SizedBox(height: 12),
                    ],

                    // 下行方向
                    if (downTrains.isNotEmpty) ...[
                      _buildDirectionSection('下行方向', downTrains, Colors.orange),
                    ],

                    // 無數據提示
                    if (upTrains.isEmpty && downTrains.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '暫無列車信息',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // 觸發中等振動
            await VibrationHelper.mediumVibrate();
            Navigator.of(context).pop();
          },
          child: const Text('關閉'),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  // 觸發中等振動
                  await VibrationHelper.mediumVibrate();
                  updateByRefresh();
                },
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('刷新'),
        ),
      ],
    );
  }

  Widget _buildDirectionSection(
      String title, List<TrainInfo> trains, Color color) {
    // 顯示所有列車，不過濾任何終點站
    final filteredTrains = trains;

    // 獲取終點站信息
    String destInfo = '';
    if (filteredTrains.isNotEmpty) {
      final firstTrain = filteredTrains.first;
      final destName = firstTrain.destNameTc ?? firstTrain.dest ?? '未知';
      destInfo = destName;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              color: color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '往 $destInfo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...filteredTrains.map((train) => _buildTrainTile(train, color)),
      ],
    );
  }

  Widget _buildTrainTile(TrainInfo train, Color color) {
    final destName = train.destNameTc ?? train.dest ?? '未知/資料未更新';
    final isArrivingSoon = train.isArrivingSoon;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.grey[300]!,
          width: isArrivingSoon ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 終點站
          Expanded(
            flex: 2,
            child: Text(
              destName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),

          // 時間差
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTimeDifferenceColor(train.timeDifference),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                train.formattedTimeDifference ?? '--',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLineDisplayName(String? lineCode) {
    if (lineCode == null) return '未知線路';

    final lineData = MTRData.getLineData(lineCode);
    if (lineData != null) {
      final nameTc = lineData['fullNameTc'] ?? '';
      final nameEn = lineData['fullNameEn'] ?? '';
      return '$nameTc ($nameEn)';
    }

    return lineCode; // 如果找不到資料，返回原始代碼
  }

  Color _getTimeDifferenceColor(int? minutes) {
    if (minutes == null || minutes < 0) return Colors.grey;
    if (minutes < 1) return Colors.red;
    if (minutes <= 3) return Colors.yellow[700]!;
    return Colors.green;
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
