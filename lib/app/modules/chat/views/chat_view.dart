import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:imess/app/data/classes/chat_message.dart';
import 'package:imess/app/modules/global/widgets/commons.dart';
import 'package:imess/app/providers/chat_provider.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find<ChatController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(controller.peerNickname.trim()),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                buildListMessage(),
                buildMessageInput(),
              ],
            )),
      ),
    );
  }
}

Widget buildMessageInput() {
  ChatController controller = Get.find<ChatController>();
  return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
                onPressed: controller.getImage,
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  size: 28,
                ),
                color: Colors.white),
          ),
          Flexible(
              child: TextField(
            focusNode: controller.focusNode,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller.textEditingController,
            decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.indigoAccent),
                hintText: 'Envie uma mensagem...'),
            onSubmitted: (value) {
              controller.onSendMessage(
                  controller.textEditingController.text, MessageType.text);
            },
          )),
          Container(
            margin: const EdgeInsets.only(left: 4, bottom: 4),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
                onPressed: () {
                  controller.onSendMessage(
                      controller.textEditingController.text, MessageType.text);
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                )),
          )
        ],
      ));
}

Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
  ChatController controller = Get.find<ChatController>();
  if (documentSnapshot != null) {
    ChatMessage chatMessage = ChatMessage.fromDocument(documentSnapshot);
    if (chatMessage.idFrom == controller.currentUserId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              chatMessage.type == MessageType.text
                  ? messageBubble(
                      chatContent: chatMessage.content,
                      margin: const EdgeInsets.only(right: 10, top: 8),
                      color: Colors.green[50])
                  : chatMessage.type == MessageType.image
                      ? Container(
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          child: chatImage(
                              imageSrc: chatMessage.content, onTap: () {}),
                        )
                      : const SizedBox.shrink(),
              controller.isMessageSent(index)
                  ? Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.network(
                        controller.userAvatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                              value: loadingProgress.expectedTotalBytes !=
                                          null &&
                                      loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (content, object, stackTrace) {
                          return const Icon(Icons.account_circle,
                              size: 35, color: Colors.grey);
                        },
                      ),
                    )
                  : Container(
                      width: 35,
                    )
            ],
          ),
          controller.isMessageSent(index)
              ? Container(
                  margin: const EdgeInsets.only(right: 50, top: 6, bottom: 8),
                  child: Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessage.timestamp)),
                    ),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.isMessageReceived(index)
                  ? Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        controller.peerAvatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                              value: loadingProgress.expectedTotalBytes !=
                                          null &&
                                      loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return const Icon(
                            Icons.account_circle,
                            size: 35,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : Container(
                      width: 40,
                    ),
              chatMessage.type == MessageType.text
                  ? messageBubble(
                      color: Colors.deepPurple[500],
                      textColor: Colors.white,
                      chatContent: chatMessage.content,
                      margin: const EdgeInsets.only(left: 10, top: 8),
                    )
                  : chatMessage.type == MessageType.image
                      ? Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          child: chatImage(
                              imageSrc: chatMessage.content, onTap: () {}),
                        )
                      : const SizedBox.shrink(),
            ],
          ),
          controller.isMessageReceived(index)
              ? Container(
                  margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
                  child: Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(chatMessage.timestamp),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    }
  } else {
    return const SizedBox.shrink();
  }
}

Widget buildListMessage() {
  ChatController controller = Get.find<ChatController>();
  return Flexible(
      child: controller.groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: controller.chatProvider
                  .getChatMessage(controller.groupChatId, controller.limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  controller.listMessages = snapshot.data!.docs;
                  if (controller.listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: controller.scrollController,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]));
                  } else {
                    return const Center(
                      child: Text('Não existem mensagens...'),
                    );
                  }
                } else {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Colors.deepPurple));
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            ));
}
