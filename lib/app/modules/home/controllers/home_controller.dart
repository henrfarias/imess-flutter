import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:imess/app/providers/auth_provider.dart';
import 'package:imess/app/providers/conversations_provider.dart';
import 'package:imess/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final ScrollController scrollController = ScrollController();
  final ConversationsProvider conversationsProvider =
      Get.find<ConversationsProvider>();
  final int _limitIncrement = 20;
  late String currentUserId;

  final Rx<int> _limit = 20.obs;
  final Rx<bool> _isLoading = false.obs;

  Debouncer searchDebouncer =
      Debouncer(delay: const Duration(milliseconds: 300));
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();

  get isLoading => _isLoading.value;

  get limit => _limit.value;
  increaseLimit(int value) => _limit.value += value;

  Future<void> googleSignOut() async {
    authProvider.googleSignOut();
    Get.offNamed(Routes.LOGIN);
  }

  void onBackPress() {
    openDialog();
  }

  Future<void> openDialog() async {
    await Get.defaultDialog(
        title: 'Tem certeza que deseja sair?',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        middleText: "",
        textCancel: "Não",
        cancelTextColor: Colors.black87,
        textConfirm: "Sair",
        confirmTextColor: Colors.redAccent,
        buttonColor: Colors.white,
        onConfirm: () => exit(0));
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      increaseLimit(_limitIncrement);
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
    scrollController.addListener(scrollListener);
  }
}
