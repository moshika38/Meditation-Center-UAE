import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/booking.card.dart';
import 'package:meditation_center/presentation/pages/item%20menus/widgets/month.date.picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemMenuPage extends StatelessWidget {
  const ItemMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List menuItems = [
      "මාසික සමාජිකත්වය ලබා ගැනීම සඳහා",
      "දානමය පිංකම් භාරගැනීම සඳහා",
      "⁠සම්බුද්ධ වන්දනා පිංකම් භාරගැනීමට",
      "දෛනික ⁠ආලෝක පූජාව භාරගැනීම සඳහා",
      "⁠විශේෂ පිංකම් පිළිබඳ විස්තර සදහා",
      "⁠whatsapp එකමුතුවට සම්බන්ධ වීම සඳහා",
      "⁠අප සන්නිවේදන ජාලය",
      "⁠අප හා සම්බන්ධ වීමට",
    ];

    Future<void> launchWhatsapp(String number, String text) async {
      final Uri url = Uri.parse('https://wa.me/$number/?text=$text');

      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    Future<void> whatsappGroup() async {
      final Uri url = Uri.parse(AppData.whatsAppGroup);

      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    Future<void> launchPhone(String phoneNumber) async {
      final Uri url = Uri(scheme: 'tel', path: phoneNumber);

      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    }

    void contactUS() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Reach Us by Phone",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.pureBlack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.phone,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          "+97 155 332 2301",
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        (context).pop();
                      },
                      child: Text(
                        "No, Later",
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppColors.gray,
                    ),
                    TextButton(
                      onPressed: () {
                        launchPhone(AppData.contactNumber);
                      },
                      child: Row(
                        children: [
                          Text("Call Now", style: theme.textTheme.bodySmall),
                          SizedBox(width: 5),
                          Icon(
                            Icons.call_made_rounded,
                            color: AppColors.gray,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListView.builder(
              itemCount: menuItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    switch (menuItems[index]) {
                      case "⁠whatsapp එකමුතුවට සම්බන්ධ වීම සඳහා":
                        // whatsapp group link
                        LoadingPopup.show('Logging...');
                        whatsappGroup();
                        EasyLoading.dismiss();
                        break;

                      case "⁠අප සන්නිවේදන ජාලය":
                        // social media page
                        context.push('/socialMedia');
                        break;

                      case "⁠අප හා සම්බන්ධ වීමට":
                        contactUS();
                        // contact detail page
                        break;
                      case "⁠විශේෂ පිංකම් පිළිබඳ විස්තර සදහා":
                        launchWhatsapp(
                          AppData.whatsAppNumber,
                          "ඉදිරියේදී පැවැත්වෙන විශේෂ පිංකම් මොනවාද?",
                        );
                        break;
                      case "මාසික සමාජිකත්වය ලබා ගැනීම සඳහා":
                        launchWhatsapp(
                          AppData.whatsAppNumber,
                          "අජ්මාන් ශ්‍රී ලංකා භාවනා මධ්‍යස්ථානයෙහි මාසික සාමාජිකත්ව ආරාම පූජාවට දායක විය හැක්කෙ කෙසේද?",
                        );
                        break;
                      case "දානමය පිංකම් භාරගැනීම සඳහා":
                        MonthDatePicker.showPopupWindow(context,"උදෑසන / දහවල දානමය පිංකම සදහා දායකත්වය ලබා ගැනීමට හැකිද?");
                        break;
                      case "⁠සම්බුද්ධ වන්දනා පිංකම් භාරගැනීමට":
                        MonthDatePicker.showPopupWindow(context,"සවස සම්බුද්ධ වන්දනා පිංකම සදහා දායකත්වය සදහා දායකත්වය ලබා ගැනීමට හැකිද?");

                        break;
                      case "දෛනික ⁠ආලෝක පූජාව භාරගැනීම සඳහා":
                        MonthDatePicker.showPopupWindow(context,"දෛනික ⁠ආලෝක පූජා දායකත්වය සදහා දායකත්වය ලබා ගැනීමට හැකිද?");

                        break;

                      default:
                        LoadingPopup.show('Logging...');
                        launchWhatsapp(
                          AppData.whatsAppNumber,
                          menuItems[index],
                        );
                        EasyLoading.dismiss();
                    }
                  },
                  child: BookingCard(
                    text: menuItems[index],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
