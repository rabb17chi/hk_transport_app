import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.symmetric(vertical: 6),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titleTop,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        titleBottom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    routeNumber,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
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
