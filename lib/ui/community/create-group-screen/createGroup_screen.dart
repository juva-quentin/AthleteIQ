import 'dart:io';

import 'package:athlete_iq/ui/community/create-group-screen/create_group_view_model_provider.dart';
import 'package:athlete_iq/ui/components/loading_layer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/utils.dart';

class CreateGroupScreen extends ConsumerWidget {
  const CreateGroupScreen({Key, key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = creatGroupViewModelProvider;
    final model = ref.watch(creatGroupViewModelProvider);
    return SafeArea(
      child: LoadingLayer(
        child: AlertDialog(
          title: const Text("Créer un groupe", textAlign: TextAlign.start),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    final lol = File(picked.path);
                    model.file = File(picked.path);
                  }
                },
                child: Consumer(builder: (context, ref, child) {
                  ref.watch(provider.select((value) => value.file));
                  return Container(
                    height: height * .2,
                    width: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        image: (model.image != null || model.file != null)
                            ? DecorationImage(
                                image: model.file != null
                                    ? FileImage(model.file!)
                                    : NetworkImage(model.image!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (model.image == null && model.file == null)
                          Expanded(
                            child: Center(
                              child: Icon(
                                Icons.photo,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        Material(
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Choisir une image".toUpperCase(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: model.changeType,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: width * .34,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        padding: EdgeInsets.fromLTRB(width * .02, height * .02,
                            width * .02, height * .02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              model.switchCaseChangeType(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                onChanged: (v) => model.groupName = v,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: const Text(
                "Annuler",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                ref.watch(provider);
                return ElevatedButton(
                  onPressed: model.enabled
                      ? () async {
                          try {
                            await model.write();
                            Navigator.pop(context);
                          } catch (e) {
                            Utils.flushBarErrorMessage(e.toString(), context);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("Créer",
                      style: TextStyle(color: Colors.white)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
