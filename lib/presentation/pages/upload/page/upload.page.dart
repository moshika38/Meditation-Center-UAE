import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/shimmer/upload.shimmer.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/pages/upload/widgets/post_upload_ui.dart';
import 'package:meditation_center/presentation/pages/upload/widgets/bottom.text.dart';
import 'package:meditation_center/presentation/pages/upload/widgets/image.card.dart';
import 'package:meditation_center/presentation/components/text.input.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker picker = ImagePicker();
  List<XFile> imageList = [];
  final TextEditingController descriptionController = TextEditingController();
  bool isEnabled = true;

  // pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    if (!isEnabled) return;
    setState(() => isEnabled = false);

    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          imageList.addAll(pickedFiles);
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    } finally {
      setState(() => isEnabled = true);
    }
  }

  continueUpload(
    String text,
    String userName,
    List<XFile> images,
  ) {
    PopupWindow.showPopupWindow(text, "Yes, Upload", context, () async {
      context.pop();
      final postProvider = Provider.of<PostProvider>(context, listen: false);
       

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const PostUploadUi();
        },
      );
      //  process to upload images

      final postStatus = await postProvider.createNewPost(
        descriptionController.text,
        userName,
        images,
      );

      if (postStatus) {
         

        setState(() {
          imageList.clear();
          descriptionController.text = "";
          isEnabled = true;
        });
      } else {
        // EasyLoading.dismiss();
        AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
        isEnabled = true;
        setState(() {});
      }
    }, () {
      context.pop();
      isEnabled = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer(
        builder: (
          BuildContext context,
          UserProvider userProvider,
          Widget? child,
        ) =>
            FutureBuilder(
          future:
              userProvider.getUserById(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            // error getting user
            if (snapshot.hasError) {
              AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
            }
            // loading user data
            if (snapshot.connectionState == ConnectionState.waiting) {
              UploadPageShimmer();
            }
            if (snapshot.hasData) {
              final user = snapshot.data as UserModel;

              return Column(
                children: [
                  const SizedBox(height: 20),
                  TextFieldInput.textFormField(
                    context,
                    descriptionController,
                    isEnabled,
                    "What's on your mind?",
                    5,
                  ),
                  const SizedBox(height: 20),
                  // pick image btn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButtons(
                        text: "Select",
                        isPrimary: true,
                        icon: Icons.image,
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 50,
                        onTap: () {
                          if (isEnabled) {
                            _pickImagesFromGallery();
                          }
                        },
                      ),
                      AppButtons(
                        text: "Upload",
                        isPrimary: true,
                        icon: Icons.upload,
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 50,
                        onTap: () {
                          if (imageList.isNotEmpty) {
                            setState(() {
                              isEnabled = false;
                            });

                            continueUpload(
                              " This action cannot be undone. Are you sure you want to continue?",
                              user.name,
                              imageList,
                            );
                          } else {
                            AppTopSnackbar.showTopSnackBar(
                                context, "Please select images to upload");
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  imageList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Selected:  ${imageList.length}",
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    imageList.clear();
                                  });
                                },
                                child: Text(
                                  "Clear",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  imageList.isNotEmpty
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: imageList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                //  images preview
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageCard.imageCard(
                                    imageList[index].path,
                                    () {
                                      setState(() {
                                        imageList.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : BottomText(),
                ],
              );
            } else {
              return UploadPageShimmer();
            }
          },
        ),
      ),
    );
  }
}
