import 'package:flutter/material.dart';
import '../../scripts/utils/responsive_utils.dart';

/// Generic transport route banner used by KMB and CTB
class TransportRouteBanner extends StatelessWidget {
  final String titleTop; // usually Traditional Chinese destination
  final String titleBottom; // usually English destination
  final String routeNumber;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? shadowColor;

  const TransportRouteBanner({
    super.key,
    required this.titleTop,
    required this.titleBottom,
    required this.routeNumber,
    required this.backgroundColor,
    required this.textColor,
    this.onTap,
    this.borderColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.getResponsiveSize(context, 6.0)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: (shadowColor ?? const Color(0x33000000)),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSize(context, 12.0),
              vertical: ResponsiveUtils.getResponsiveSize(context, 8.0),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveUtils.getResponsiveSize(context, 120.0),
                  height: ResponsiveUtils.getResponsiveSize(context, 60.0),
                  alignment: Alignment.center,
                  child: Text(
                    routeNumber,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getOverflowSafeFontSize(
                          context, 30.0),
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titleTop,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getOverflowSafeFontSize(
                              context, 24.0),
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(
                          height:
                              ResponsiveUtils.getResponsiveSize(context, 2.0)),
                      Text(
                        titleBottom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getOverflowSafeFontSize(
                              context, 14.0),
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
