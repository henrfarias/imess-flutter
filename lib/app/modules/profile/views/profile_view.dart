import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imess/app/modules/loading/views/loading_view.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => controller.getImage(),
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(20),
                          child: Obx(
                            () => controller.avatarImageFile == null
                                ? controller.photoUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.network(
                                            controller.photoUrl.value,
                                            fit: BoxFit.cover,
                                            width: 120,
                                            height: 120, errorBuilder:
                                                (context, object, stackTrace) {
                                          return const Icon(
                                              Icons.account_circle,
                                              size: 90,
                                              color: Colors.grey);
                                        }, loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return SizedBox(
                                              width: 90,
                                              height: 90,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                    color: Colors.grey,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null),
                                              ));
                                        }))
                                    : const Icon(Icons.account_circle,
                                        size: 90, color: Colors.grey)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                        controller.avatarImageFile!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover)),
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Nome',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.indigoAccent),
                              hintText: 'Escreva seu nome'),
                          controller: controller.displayNameController,
                          onChanged: (value) {
                            controller.displayName = value;
                          },
                          focusNode: controller.focusNodeNickname,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Sobre mim',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.indigoAccent),
                              hintText: 'Escreva sobre você...'),
                          onChanged: (value) {
                            controller.aboutMe = value;
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Selecione o código do país',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CountryCodePicker(
                            onChanged: (country) {
                              controller.setDialCodeDigits(country.dialCode!);
                            },
                            initialSelection: 'BR',
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            favorite: const ["+55", "BR"],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Telefone',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelStyle:
                                  const TextStyle(color: Colors.indigoAccent),
                              hintText: 'Número de telefone',
                              prefix: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Obx(() => Text(
                                        controller.dialCodeDigits.value,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )))),
                          controller: controller.phoneController,
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: controller.updateFirestoreData,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Atualizar informações'),
                        ))
                  ],
                )),
            Positioned(
                child: controller.isLoading
                    ? const LoadingView()
                    : const SizedBox.shrink())
          ],
        ));
  }
}
