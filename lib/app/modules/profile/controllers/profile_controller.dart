import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imess/app/data/classes/talk_contact.dart';
import 'package:imess/app/modules/global/constants/firestore_constants.dart';
import 'package:imess/app/providers/profile_provider.dart';

class ProfileController extends GetxController {
  TextEditingController? displayNameController;
  TextEditingController? aboutMeController;
  final TextEditingController _phoneController = TextEditingController();
  final ProfileProvider profileProvider = Get.find<ProfileProvider>();
  get phoneController => _phoneController;
  late String currentUserId;
  Rx<String> dialCodeDigits = '+55'.obs;
  setDialCodeDigits(String value) => dialCodeDigits.value = value;
  String id = '';
  String displayName = '';
  Rx<String> photoUrl = ''.obs;
  Rx<String> phoneNumber = ''.obs;
  String aboutMe = '';

  final Rx<bool> _isLoading = false.obs;
  setIsLoading(bool value) => _isLoading.value = value;
  get isLoading => _isLoading.value;
  File? avatarImageFile;
  final FocusNode focusNodeNickname = FocusNode();

  @override
  void onInit() {
    super.onInit();
    readLocal();
  }

  void readLocal() {
    id = profileProvider.getData(FirestoreConstants.id) ?? '';
    displayName = profileProvider.getData(FirestoreConstants.displayName) ?? '';
    photoUrl.value = profileProvider.getData(FirestoreConstants.photoUrl) ?? '';
    phoneNumber.value =
        profileProvider.getData(FirestoreConstants.phoneNumber) ?? '';
    aboutMe = profileProvider.getData(FirestoreConstants.aboutMe) ?? '';
    displayName = profileProvider.getData(FirestoreConstants.displayName) ?? '';

    displayNameController = TextEditingController(text: displayName);
    aboutMeController = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        // ignore: body_might_complete_normally_catch_error
        .catchError((onError) {
      Get.showSnackbar(const GetSnackBar(
        title: 'Erro ao carregar foto',
        message: 'Algo aconteceu ao selecionar sua foto na galeria.',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.cancel_outlined, color: Colors.red),
      ));
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      avatarImageFile = image;
      setIsLoading(true);
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask =
        profileProvider.uploadImageFile(avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl.value = await snapshot.ref.getDownloadURL();
      TalkContact updateInfo = TalkContact(
        id: id,
        photoUrl: photoUrl.value,
        displayName: displayName,
        phoneNumber: phoneNumber.value,
        aboutMe: aboutMe,
      );
      profileProvider
          .updateFirestoreData(
              FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
          .then((value) async {
        await profileProvider.setData(FirestoreConstants.photoUrl, photoUrl.value);
        setIsLoading(false);
      });
    } on FirebaseException {
      setIsLoading(false);
      Get.showSnackbar(const GetSnackBar(
        title: 'Erro ao atualizar informações',
        message: 'Atualização falhou. =(',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.cancel_outlined, color: Colors.red),
      ));
    }
  }

  void updateFirestoreData() {
    focusNodeNickname.unfocus();
    setIsLoading(true);
    if (_phoneController.text != "") {
      phoneNumber.value = dialCodeDigits + _phoneController.text.toString();
    }
    TalkContact updateInfo = TalkContact(
        id: id,
        photoUrl: photoUrl.value,
        displayName: displayName,
        phoneNumber: phoneNumber.value,
        aboutMe: aboutMe);
    profileProvider
        .updateFirestoreData(
            FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
        .then((value) async {
      await profileProvider.setData(
          FirestoreConstants.displayName, displayName);
      await profileProvider.setData(
          FirestoreConstants.phoneNumber, phoneNumber.value);
      await profileProvider.setData(FirestoreConstants.photoUrl, photoUrl.value);
      await profileProvider.setData(FirestoreConstants.aboutMe, aboutMe);
      setIsLoading(false);

      Get.showSnackbar(const GetSnackBar(
        title: 'Perfil atualizado',
        message: 'Seus dados foram atualizados com sucesso.',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle_outline, color: Colors.green),
      ));
    }).catchError((onError) {
      Get.showSnackbar(const GetSnackBar(
        title: 'Erro ao atualizar informações',
        message: 'Atualização falhou. =(',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.cancel_outlined, color: Colors.red),
      ));
    });
  }
}
