import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';
import '../../../utils/visibility.dart';
import 'create_group_view_model_provider.dart';

class CreateGroupScreen extends HookConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(creatGroupViewModelProvider);

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        viewModel.file = File(image.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Créer un groupe',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                backgroundImage:
                    viewModel.file != null ? FileImage(viewModel.file!) : null,
                child: viewModel.file == null
                    ? const Icon(Icons.camera_alt, size: 60, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: viewModel.groupName,
              onChanged: (value) => viewModel.groupName = value,
              decoration: InputDecoration(
                labelText: 'Nom du groupe',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.group),
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<GroupType>(
              value: viewModel.visibility,
              onChanged: (newValue) {
                if (newValue != null) {
                  viewModel.visibility = newValue;
                  viewModel.groupType = newValue.toString().split('.').last;
                }
              },
              items: GroupType.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Type de groupe',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.visibility),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 35.h,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: viewModel.enabled
                    ? () async {
                        await viewModel.write();
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: viewModel.enabled
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ), icon: const Icon(UniconsLine.plus_circle, color: Colors.white),
                label: Text(
                  "Créer le groupe",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold, // Texte en gras pour plus de présence
                  color: Colors.white, // Assure que le texte est blanc pour tous les boutons
                ),
              ),
            )
            )],
        ),
      ),
    );
  }
}
