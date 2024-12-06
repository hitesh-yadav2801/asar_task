import 'package:asar/core/common/widgets/shimmer_home_page.dart';
import 'package:asar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventId;
  final String title;
  final String description;
  final String iconUrl;
  final double yesAmount;
  final double noAmount;
  final VoidCallback onTapYes;
  final VoidCallback onTapNo;
  final VoidCallback onTapCard;

  const EventCard({
    super.key,
    required this.eventId,
    required this.title,
    required this.description,
    required this.yesAmount,
    required this.noAmount,
    required this.iconUrl,
    required this.onTapYes,
    required this.onTapNo,
    required this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.secondaryColor.withOpacity(0.3), width: 0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  iconUrl,
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const ShimmerCircle(size: 50);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BettingButton(
                    text: 'Yes ₹$yesAmount',
                    onPressed: onTapYes,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    textColor: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BettingButton(
                    text: 'No ₹$noAmount',
                    onPressed: onTapNo,
                    backgroundColor: Colors.red.withOpacity(0.1),
                    textColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BettingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const BettingButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
