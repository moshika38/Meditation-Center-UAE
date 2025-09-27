import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class UpcomingProgram extends StatefulWidget {
  const UpcomingProgram({super.key});

  @override
  State<UpcomingProgram> createState() => _UpcomingProgramState();
}

class _UpcomingProgramState extends State<UpcomingProgram> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ඉදිරි වැඩසටහන් පෙළගැස්ම",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(Icons.event, color: AppColors.primaryColor)
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "පොහොය දින සීල භාවනා වැඩසටහන් සහ සවස බෝධි පූජාමය වැඩසටහන",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 12),
                            rowText(
                              "වේලාව : 9.00 සිට සවස 4.30 දක්වා",
                              Icons.timelapse,
                              false,
                            ),
                            SizedBox(height: 12),
                            rowText(
                              "දිනය : 2025/5/21",
                              Icons.date_range,
                              false,
                            ),
                            SizedBox(height: 12),
                            rowText(
                              "ස්ථානය : Ceylon Meditation Center",
                              Icons.place,
                              false,
                            ),
                            SizedBox(height: 12),
                            rowText(
                              "වැඩි විස්තර : 0771234567 (සමන්)",
                              Icons.person,
                              false,
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "2 min ago",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: AppColors.gray,
                                      ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowText(
    String text,
    IconData icon,
    bool isPrimary,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isPrimary ? AppColors.primaryColor : null,
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: isPrimary ? AppColors.primaryColor : null,
                fontWeight: isPrimary ? FontWeight.bold : null,
              ),
        ),
      ],
    );
  }
}
