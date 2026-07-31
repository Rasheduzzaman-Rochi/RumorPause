import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

BoxDecoration cardDecoration() {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

class MessageCard extends StatelessWidget {
  final String message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 14 : 18),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.message_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Shared Message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 10 : 14),
          Text(
            '“$message”',
            style: TextStyle(
              fontSize: isCompact ? 17 : 19,
              height: 1.5,
              color: Color(0xFF263238),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 14 : 16),
      decoration: cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: isCompact ? 24 : 28),
          SizedBox(width: isCompact ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isCompact ? 16 : 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: isCompact ? 4 : 5),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: isCompact ? 15 : 16.5,
                    height: 1.4,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IssueItem extends StatelessWidget {
  final String text;

  const IssueItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 8 : 10),
      child: Row(
        children: [
          const Icon(Icons.close_rounded, color: AppColors.danger, size: 22),
          SizedBox(width: isCompact ? 6 : 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isCompact ? 16 : 17.5,
                color: const Color(0xFF263238),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
