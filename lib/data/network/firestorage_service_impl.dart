import 'package:firebase_storage/firebase_storage.dart';

import 'abstract/firestorage_service.dart';

class FirestorageServiceImpl implements FirestorageService{
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future addDateToFirestorage() {
    // TODO: implement addDateToFirestorage
    throw UnimplementedError();
  }

}