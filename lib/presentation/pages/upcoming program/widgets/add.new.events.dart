import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/app.input.dart';
import 'package:meditation_center/providers/events.provider.dart';
import 'package:provider/provider.dart';

class AddNewEvents {
  static TextEditingController titleController = TextEditingController();
  static TextEditingController dateController = TextEditingController();
  static TextEditingController timeController = TextEditingController();
  static TextEditingController placeController = TextEditingController();
  static TextEditingController contactController = TextEditingController();

  static bool notify = false;

  static void showAddWindow(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
       

      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ADD NEW EVENTS",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    controller: titleController,
                    hintText: "Event Title",
                    prefixIcon: Icons.event_note_outlined,
                    suffixIcon: Icons.cancel_sharp,
                    onTapIcon: () => titleController.clear(),
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    controller: dateController,
                    hintText: "Date",
                    prefixIcon: Icons.event_note_outlined,
                    suffixIcon: Icons.cancel_sharp,
                    onTapIcon: () => dateController.clear(),
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    controller: timeController,
                    hintText: "Time",
                    prefixIcon: Icons.event_note_outlined,
                    suffixIcon: Icons.cancel_sharp,
                    onTapIcon: () => timeController.clear(),
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    controller: placeController,
                    hintText: "Place (optional)",
                    prefixIcon: Icons.event_note_outlined,
                    suffixIcon: Icons.cancel_sharp,
                    onTapIcon: () => placeController.clear(),
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    controller: contactController,
                    hintText: "Contact (optional)",
                    prefixIcon: Icons.event_note_outlined,
                    suffixIcon: Icons.cancel_sharp,
                    onTapIcon: () => contactController.clear(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Notify to all users",
                          style: Theme.of(context).textTheme.bodySmall),
                      Checkbox(
                        value: notify,
                        onChanged: (value) {
                          setState(() {
                            notify = value!;
                             debugPrint(notify.toString());
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          "Cancel",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: AppColors.primaryColor,
                              ),
                        ),
                      ),
                      Consumer<EventsProvider>(
                        builder: (context, provider, child) => TextButton(
                          onPressed: () {
                            if (timeController.text.isNotEmpty &&
                                dateController.text.isNotEmpty &&
                                titleController.text.isNotEmpty) {
                              LoadingPopup.show('Creating...');
                              provider.addNewEvent(
                                titleController.text,
                                timeController.text,
                                dateController.text,
                                placeController.text,
                                contactController.text,
                                notify,
                              );
                              context.pop();
                              EasyLoading.dismiss();
                            } else {
                              AppTopSnackbar.showTopSnackBar(
                                  context, "Please fill all fields");
                            }
                          },
                          child: Text(
                            "Next ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.primaryColor,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

}
