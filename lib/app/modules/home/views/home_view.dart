import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imess/app/data/classes/talk_contact.dart';
import 'package:imess/app/modules/global/constants/firestore_constants.dart';
import 'package:imess/app/modules/loading/views/loading_view.dart';
import 'package:imess/app/routes/app_pages.dart';
import 'package:imess/app/utils/keyboard_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('IMess'),
          actions: [
            IconButton(
                onPressed: () => {Get.toNamed(Routes.PROFILE)},
                icon: const Icon(Icons.person)),
            IconButton(
                onPressed: () => controller.googleSignOut(),
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: PopScope(
          onPopInvoked: (bool didPop) => controller.onBackPress(),
          canPop: false,
          child: Stack(
            children: [
              Column(
                children: [
                  buildSearchBar(),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: controller.conversationsProvider.getFirestoreData(
                        FirestoreConstants.pathUserCollection,
                        controller.limit,
                        controller.textSearch),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0) {
                          return ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => buildItem(
                                  context, snapshot.data?.docs[index]),
                              controller: controller.scrollController,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider());
                        } else {
                          return const Center(
                              child: Column(
                            children: [Text("Nenhum contato encontrado...")],
                          ));
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ))
                ],
              ),
              Positioned(
                  child: controller.isLoading
                      ? const LoadingView()
                      : const SizedBox.shrink())
            ],
          ),
        ));
  }

  Widget buildSearchBar() {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black12,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(Icons.person_search, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
                decoration: const InputDecoration.collapsed(
                    hintText: 'Pesquise aqui...',
                    hintStyle: TextStyle(color: Colors.white)),
                textInputAction: TextInputAction.search,
                controller: controller.searchTextEditingController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.buttonClearController.add(true);
                    controller.changeSearchText(value);
                  } else {
                    controller.buttonClearController.add(false);
                    controller.changeSearchText("");
                  }
                }),
          ),
          StreamBuilder(
              stream: controller.buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          controller.searchTextEditingController.clear();
                          controller.buttonClearController.add(false);
                          controller.changeSearchText("");
                        },
                        child: const Icon(Icons.clear_rounded,
                            color: Colors.grey, size: 20),
                      )
                    : const SizedBox.shrink();
              }),
          const SizedBox(width: 20),
        ]));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    final FirebaseAuth firebaseAuth =
        controller.authProvider.authController.firebaseAuth;
    if (documentSnapshot != null) {
      TalkContact contact = TalkContact.fromDocument(documentSnapshot);
      if (contact.id == controller.currentUserId) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing(context)) {
              KeyboardUtils.closeKeyboard(context);
            }
            var params = <String, String>{
              "peerId": contact.id,
              "peerAvatar": contact.photoUrl,
              "peerNickname": contact.displayName,
              "userAvatar": firebaseAuth.currentUser!.photoURL!
            };
            Get.toNamed(Routes.CHAT, parameters: params);
          },
          child: ListTile(
            leading: contact.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      contact.photoUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null));
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ))
                : const Icon(Icons.account_circle, size: 50),
            title: Text(contact.displayName,
                style: const TextStyle(color: Colors.black)),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
