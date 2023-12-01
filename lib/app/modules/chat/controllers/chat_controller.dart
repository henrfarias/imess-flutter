import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imess/app/modules/global/constants/firestore_constants.dart';
import 'package:imess/app/providers/auth_provider.dart';
import 'package:imess/app/providers/chat_provider.dart';
import 'package:imess/app/routes/app_pages.dart';

class ChatController extends GetxController {
  String peerId = '';
  String peerAvatar = '';
  String peerNickname = '';
  String userAvatar = '';

  late String currentUserId;
  List<QueryDocumentSnapshot> listMessages = [];

  final Rx<int> _limit = 20.obs;
  get limit => _limit.value;
  increaseLimit(int value) => _limit.value += value;
  final int _limitIncrement = 20;

  String groupChatId = '';
  File? imageFile;
  String imageUrl = '';

  final Rx<bool> _isLoading = false.obs;
  get isLoading => _isLoading.value;
  setIsLoading(bool value) => _isLoading.value = value;

  final Rx<bool> _isShowSticker = false.obs;
  get isShowSticker => _isShowSticker.value;
  setIsShowSticker(bool value) => _isShowSticker.value = value;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  ChatProvider chatProvider = Get.find();
  AuthProvider authProvider = Get.find();

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(onFocusChanged);
    scrollController.addListener(scrollListener);
    readLocal();
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      increaseLimit(_limitIncrement);
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setIsShowSticker(false);
    }
  }

  void readLocal() {
    peerId = Get.arguments['peerId'];
    peerAvatar = Get.arguments['peerAvatar'];
    peerNickname = Get.arguments['peerNickname'];
    userAvatar = Get.arguments['userAvatar'];
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId - $peerId';
    } else {
      groupChatId = '$peerId - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: peerId});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setIsLoading(true);
        uploadImageFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setIsShowSticker(!isShowSticker);
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setIsShowSticker(false);
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void uploadImageFile() async {
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, filename);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setIsLoading(false);
      onSendMessage(imageUrl, MessageType.image);
    } on FirebaseException {
      setIsLoading(false);
      Get.showSnackbar(const GetSnackBar(
        title: 'Erro ao enviar imagem.',
        message: 'Não conseguimos enviar sua imagem.',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error_outline, color: Colors.red),
      ));
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendChatMessage(
          content, type, groupChatId, currentUserId, peerId);
      if (scrollController.hasClients) {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Não tem nada aqui para enviarmos.',
        message: 'Escreva sua mensagem.',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning_amber_outlined, color: Colors.deepOrange),
      ));
    }
  }

  bool isMessageReceived(int index) {
    return ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0);
  }

  bool isMessageSent(int index) {
    return ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0);
  }
}
