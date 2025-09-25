/// MTR 時刻表對話框
///
/// 顯示列車時刻表的彈出對話框，包含上行和下行方向的列車信息

import 'package:flutter/material.dart';
import 'dart:async';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../../scripts/mtr/mtr_data.dart';
import '../../scripts/utils/vibration_helper.dart';
import '../../scripts/utils/settings_service.dart';
import '../../theme/app_color_scheme.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';

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
  final Map<String, MTRScheduleResponse> _additionalResponses = {};
  String? _addingLineCode;
  Timer? _countdownTimer;
  int _secondsLeft = 15;

  @override
  void initState() {
    super.initState();
    response = widget.initialResponse;
    _startCountdownIfEnabled();

    // Listen to auto-refresh setting changes
    SettingsService.mtrAutoRefreshNotifier
        .addListener(_onAutoRefreshSettingChanged);
  }

  void _onAutoRefreshSettingChanged() {
    if (mounted) {
      _startCountdownIfEnabled();
    }
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

        // Success - no snackbar needed
      } else {
        // 顯示錯誤消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.mtrUpdateFailed),
              duration: const Duration(seconds: 2),
              backgroundColor: AppColorScheme.snackbarErrorColor,
            ),
          );
        }
      }
    } catch (e) {
      // 顯示錯誤消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${AppLocalizations.of(context)!.mtrUpdateError}: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColorScheme.snackbarErrorColor,
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

  Future<void> _refreshAllActiveLines() async {
    final List<String> refreshed = [];

    // refresh main line
    final main = await MTRScheduleService.getSchedule(
      lineCode: widget.lineCode,
      stationId: widget.stationId,
    );
    if (main != null) {
      if (mounted) setState(() => response = main);
      refreshed.add(widget.lineCode);
    }

    // refresh additional lines
    if (_additionalResponses.isNotEmpty) {
      final entries = List<String>.from(_additionalResponses.keys);
      for (final code in entries) {
        final resp = await MTRScheduleService.getSchedule(
          lineCode: code,
          stationId: widget.stationId,
        );
        if (resp != null) {
          if (mounted) {
            setState(() {
              _additionalResponses[code] = resp;
            });
          }
          refreshed.add(code);
        }
      }
    }

    if (refreshed.isNotEmpty) {
      // Haptic feedback and log
      await VibrationHelper.lightVibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final upTrains = response.getUpTrains();
    final downTrains = response.getDownTrains();
    final stationData = MTRData.getStationData(widget.stationId);
    final allLines =
        (stationData?['line'] as List<dynamic>?)?.cast<String>() ?? <String>[];
    final selectableOtherLines = allLines
        .where(
            (c) => c != widget.lineCode && !_additionalResponses.containsKey(c))
        .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 8,
      backgroundColor: AppColorScheme.dialogBackgroundColor,
      title: Row(
        children: [
          Container(
            width: 68,
            height: 28,
            decoration: BoxDecoration(
              color: _getLineColor(widget.lineCode),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                LocaleUtils.isChinese(context)
                    ? (MTRData.getLineData(widget.lineCode)?['fullNameTc'] ??
                        widget.lineCode)
                    : widget.lineCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.mtrAutoRefreshNotifier,
            builder: (context, isAutoRefreshEnabled, child) {
              if (!isAutoRefreshEnabled) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColorScheme.chipBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.mtrRefreshing} ${_secondsLeft}s',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.mtrUpdating),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 當前線路區塊（以線路顏色作為淡色背景）
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getLineColor(widget.lineCode)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (upTrains.isNotEmpty) ...[
                            _buildDirectionSection(
                                AppLocalizations.of(context)!.mtrUpDirection,
                                upTrains,
                                AppColorScheme.upDirectionColor,
                                widget.lineCode),
                          ],
                          if (upTrains.isNotEmpty && downTrains.isNotEmpty)
                            const SizedBox(height: 8),
                          if (downTrains.isNotEmpty) ...[
                            _buildDirectionSection(
                                AppLocalizations.of(context)!.mtrDownDirection,
                                downTrains,
                                AppColorScheme.downDirectionColor,
                                widget.lineCode),
                          ],
                          if (upTrains.isEmpty && downTrains.isEmpty)
                            _buildEmptyBox(),
                        ],
                      ),
                    ),

                    // 追加線路的時刻表（每個線路一個區塊，前置分隔線）
                    for (final entry in _additionalResponses.entries) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              _getLineColor(entry.key).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildSectionsForResponse(entry.value),
                        ),
                      ),
                    ],

                    // 其他線路按鈕
                    if (selectableOtherLines.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.mtrOtherLines,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColorScheme.textMediumColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectableOtherLines.map((code) {
                          final isAdding = _addingLineCode == code;
                          return OutlinedButton(
                            onPressed:
                                isAdding ? null : () => _handleAddLine(code),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: _getLineColor(code),
                              side: BorderSide(color: _getLineColor(code)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                            ),
                            child: isAdding
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    LocaleUtils.isChinese(context)
                                        ? (MTRData.getLineData(
                                                code)?['fullNameTc'] ??
                                            code)
                                        : code,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 4),
                    ],
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
          child: Text(AppLocalizations.of(context)!.mtrClose,
              style: const TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  // 觸發中等振動
                  await VibrationHelper.mediumVibrate();
                  await updateByRefresh();
                  if (mounted) {
                    // Only reset countdown if auto-refresh is enabled
                    if (SettingsService.mtrAutoRefreshNotifier.value) {
                      setState(() => _secondsLeft = 15);
                    }
                  }
                },
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.mtrRefresh),
        ),
      ],
    );
  }

  Widget _buildDirectionSection(
      String title, List<TrainInfo> trains, Color color, String lineCode) {
    // 顯示所有列車，不過濾任何終點站
    final filteredTrains = trains;

    // 獲取終點站信息
    String destInfo = '';
    String toPrefix = '';

    // Get line data to determine default destinations (use section's lineCode)
    final lineData = MTRData.getLineData(lineCode);
    final upDefaultDest = lineData?['upDefaultDest'] as List<String>? ?? [];
    final downDefaultDest = lineData?['downDefaultDest'] as List<String>? ?? [];

    // Determine if this is up or down direction based on title
    final isChinese = LocaleUtils.isChinese(context);
    final isUpDirection = title == AppLocalizations.of(context)!.mtrUpDirection;

    // Get the appropriate default destination for this direction
    final defaultDestCodes = isUpDirection ? upDefaultDest : downDefaultDest;

    if (defaultDestCodes.isNotEmpty) {
      // Get the first default destination and its localized name
      final destCode = defaultDestCodes.first;
      final stationData = MTRData.getStationData(destCode);

      if (stationData != null) {
        final destName = isChinese
            ? (stationData['nameTc'] ?? stationData['fullName'] ?? destCode)
            : (stationData['fullName'] ?? stationData['nameTc'] ?? destCode);

        destInfo = destName;
        toPrefix = isChinese ? '往 ' : 'To ';
      }
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
                '$toPrefix$destInfo',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...filteredTrains
            .map((train) => _buildTrainTile(train, color, lineCode)),
      ],
    );
  }

  List<Widget> _buildSectionsForResponse(MTRScheduleResponse resp) {
    final up = resp.getUpTrains();
    final down = resp.getDownTrains();
    final sectionLineCode = resp.lineCode ?? widget.lineCode;
    final widgets = <Widget>[];
    if (up.isNotEmpty) {
      widgets.add(_buildDirectionSection(
          AppLocalizations.of(context)!.mtrUpDirection,
          up,
          AppColorScheme.upDirectionColor,
          sectionLineCode));
      widgets.add(const SizedBox(height: 12));
    }
    if (down.isNotEmpty) {
      widgets.add(_buildDirectionSection(
          AppLocalizations.of(context)!.mtrDownDirection,
          down,
          AppColorScheme.downDirectionColor,
          sectionLineCode));
    }
    if (up.isEmpty && down.isEmpty) {
      widgets.add(_buildEmptyBox());
    }
    return widgets;
  }

  // _buildLineHeader removed: section background now conveys line identity

  Widget _buildEmptyBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorScheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          '暫無列車信息',
          style: TextStyle(
            fontSize: 16,
            color: AppColorScheme.textMutedColor,
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddLine(String code) async {
    if (_addingLineCode != null) return;
    setState(() => _addingLineCode = code);
    try {
      await VibrationHelper.lightVibrate();
      final resp = await MTRScheduleService.getSchedule(
        lineCode: code,
        stationId: widget.stationId,
      );
      if (resp != null) {
        setState(() {
          _additionalResponses[code] = resp;
        });
      }
    } finally {
      if (mounted) setState(() => _addingLineCode = null);
    }
  }

  void _startCountdownIfEnabled() {
    _countdownTimer?.cancel();
    _secondsLeft = 15;

    // Only start timer if auto-refresh is enabled
    if (SettingsService.mtrAutoRefreshNotifier.value) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) async {
        if (!mounted) {
          // Ensure timer stops if dialog is gone
          t.cancel();
          return;
        }
        if (_secondsLeft <= 1) {
          setState(() => _secondsLeft = 15);
          // auto refresh all active lines (if still enabled)
          if (SettingsService.mtrAutoRefreshNotifier.value) {
            await _refreshAllActiveLines();
          }
        } else {
          setState(() => _secondsLeft -= 1);
        }
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    SettingsService.mtrAutoRefreshNotifier
        .removeListener(_onAutoRefreshSettingChanged);
    super.dispose();
  }

  Widget _buildTrainTile(TrainInfo train, Color color, String lineCode) {
    final isChinese = LocaleUtils.isChinese(context);
    final destName = isChinese
        ? (train.destNameTc ?? train.dest ?? '--')
        : (train.destNameEn ?? train.dest ?? '--');
    final isArrivingSoon = train.isArrivingSoon;

    // Get line data to check default destinations (use section's lineCode)
    final lineData = MTRData.getLineData(lineCode);
    final upDefaultDest = lineData?['upDefaultDest'] as List<String>? ?? [];
    final downDefaultDest = lineData?['downDefaultDest'] as List<String>? ?? [];

    // Check if destination matches default destinations
    final destCode = train.dest;
    final isDefaultDest = destCode != null &&
        (upDefaultDest.contains(destCode) ||
            downDefaultDest.contains(destCode));

    // Format destination display
    final displayDestName = isDefaultDest ? '' : '($destName)';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColorScheme.cardBackgroundColor,
        border: Border.all(
          color: AppColorScheme.cardBorderColor,
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
              displayDestName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColorScheme.textDarkColor,
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
                _formatTimeDifference(train.timeDifference),
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

  String _formatTimeDifference(int? minutes) {
    if (minutes == null || minutes < 0)
      return AppLocalizations.of(context)!.mtrTimeError;
    if (minutes == 0) return AppLocalizations.of(context)!.mtrArrivingSoon;
    if (minutes < 60)
      return '${minutes}${AppLocalizations.of(context)!.mtrMinutes}';

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '${hours}${AppLocalizations.of(context)!.mtrHours}';
    } else {
      return AppLocalizations.of(context)!
          .mtrHoursMinutes(hours, remainingMinutes);
    }
  }

  Color _getTimeDifferenceColor(int? minutes) {
    if (minutes == null || minutes < 0) return Colors.grey;
    if (minutes < 1) return Colors.red;
    if (minutes <= 3) return Colors.yellow[700]!;
    return Colors.green;
  }

  Color _getLineColor(String lineCode) => MTRData.getLineColor(lineCode);
}
