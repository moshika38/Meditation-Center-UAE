import 'package:flutter/material.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MonthDatePicker {
  static void showPopupWindow(BuildContext context, String text) {
    final theme = Theme.of(context);
    String? selectedMonth;
    String? selectedDay;

    Future<void> launchWhatsapp(String number, String text) async {
      final Uri url = Uri.parse('https://wa.me/$number/?text=$text');

      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    final List<String> months = [
      "ජනවාරි",
      "පෙබරවාරි",
      "මාර්තු",
      "අප්‍රේල්",
      "මැයි",
      "ජූනි",
      "ජූලි",
      "අගෝස්තු",
      "සැප්තැම්බර්",
      "ඔක්තෝබර්",
      "නොවැම්බර්",
      "දෙසැම්බර්"
    ];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                "මාසය සහ දිනය ඇතුලත් කරන්න",
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedMonth,
                    decoration: InputDecoration(
                      labelStyle: theme.textTheme.bodySmall,
                      labelText: "මාසය තෝරන්න",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    items: months.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedMonth = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelStyle: theme.textTheme.bodySmall,
                      labelText: "දිනය ඇතුලත් කරන්න (උදා: 15)",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      selectedDay = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: AppColors.gray,
                      ),
                      TextButton(
                        onPressed: () {
                          if (selectedMonth != null && selectedDay != null) {
                            final day =
                                int.tryParse(selectedDay!); // safe parse
                            if (day != null && day > 0 && day <= 31) {
                              launchWhatsapp(
                                AppData.whatsAppNumber,
                                " $selectedMonth මස $day දින  $text",
                              );
                            } else {
                              // invalid day
                              AppTopSnackbar.showTopSnackBar(
                                  context, "දිනය 1–31 අතර විය යුතුයි");
                            }
                          } else {
                            // month or day not selected
                            AppTopSnackbar.showTopSnackBar(
                                context, "මාසය සහ දිනය ඇතුලත් කරන්න");
                          }
                        },
                        child: Text(
                          "Ok, Next",
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
