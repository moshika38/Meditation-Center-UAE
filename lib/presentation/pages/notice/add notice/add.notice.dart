import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/introduction.text.dart';
import 'package:meditation_center/presentation/components/text.input.dart';
import 'package:meditation_center/providers/notice.provider.dart';
import 'package:provider/provider.dart';

class AddNotice extends StatefulWidget {
  const AddNotice({super.key});

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  int _lineCount = 5;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> _pickImagesFromGallery() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        imageFile = file;
      });
    }
  }

  void uploadNotice() async {
    LoadingPopup.show('Uploading...');
    final provider = Provider.of<NoticeProvider>(context, listen: false);
    final status = await provider.addNewNotice(
      _titleController.text,
      _bodyController.text,
      imageFile!,
    );
    if (status) {
      _bodyController.clear();
      _titleController.clear();
      setState(() {
        imageFile = null;
      });
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Successfully',duration: Duration(seconds: 2));
    } else {
      AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new notice',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
                fontSize: 20,
              ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _bodyController.text.isNotEmpty &&
                    imageFile != null) {
                  // show conform window
                  PopupWindow.showPopupWindow(
                    "Conform to create notice, this action cannot be undone",
                    "Yes, add notice",
                    context,
                    () {
                      // upload
                      uploadNotice();
                      context.pop();
                    },
                    () {
                      // cancel
                      context.pop();
                    },
                  );
                }
              },
              icon: Icon(
                Icons.send,
                color: AppColors.whiteColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _addCard(),
      ),
    );
  }

  Widget _addCard() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntroductionText.text(theme, "Add new notice", true),
          const SizedBox(height: 10),
          TextFieldInput.textFormField(
            context,
            _titleController,
            true,
            "Notice title",
            3,
          ),
          const SizedBox(height: 20),
          IntroductionText.text(theme, "Add notice description", true),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _button(
                false,
                () {
                  if (_lineCount > 1) {
                    _lineCount--;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(width: 10),
              _button(
                true,
                () {
                  _lineCount++;
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFieldInput.textFormField(
            context,
            _bodyController,
            true,
            "Notice description",
            _lineCount,
          ),
          const SizedBox(height: 20),
          AppButtons(
            width: double.infinity,
            text: "Attach one image",
            isPrimary: true,
            icon: Icons.image,
            height: 50,
            onTap: () {
              _pickImagesFromGallery();
            },
          ),
          const SizedBox(height: 20),
          IntroductionText.text(theme, "Image preview", true),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.gray.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imageFile!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  Widget _button(bool isAdd, VoidCallback onTap) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          // ignore: deprecated_member_use
          AppColors.gray.withOpacity(0.3),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        ),
      ),
      icon: Icon(
        isAdd ? Icons.add : Icons.remove,
      ),
      onPressed: onTap,
    );
  }
}
