import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/presentation/components/my_text_fields.dart';
import 'package:izahs/features/profile/domain/entities/profile_user.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_states.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:izahs/responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // fuction to pick the iamge
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  final bioTextController = TextEditingController();

  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    // prepare images and data
    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;

    // only update profile if there's something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    } else {
      // nothing to update -> go to previous page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is ProfileLoaded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return ConstrainedScaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), Text("Uploading....")],
            ),
          );
        } else {
          return buildEditPage();
        }
      },
    );
  }

  Widget buildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: Icon(Icons.upload))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child:
                    // display selected image for mobile
                    (!kIsWeb && imagePickedFile != null)
                        ? Image.file(
                            File(imagePickedFile!.path!),
                            fit: BoxFit.cover,
                          )
                        :

                        // display selected image for web
                        (kIsWeb && webImage != null)
                            ? Image.memory(
                                webImage!,
                                fit: BoxFit.cover,
                              )
                            :

                            // no image selected -> display existing profile pic
                            CachedNetworkImage(
                                imageUrl: widget.user.profileImageUrl,
                                // loading...
                                placeholder: (context, url) => Center(
                                    child: const CircularProgressIndicator()),

                                // error
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 72,
                                  color: Theme.of(context).colorScheme.primary,
                                ),

                                // loaded
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // pick image button
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: Text('Pick Image'),
              ),
            ),

            Text("Bio"),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MyTextFields(
                  controller: bioTextController,
                  hintText: widget.user.bio,
                  obsureText: false),
            ),
          ],
        ),
      ),
    );
  }
}
