abstract class FirestoreService {
  Future addDataToFirestore(Map<String, dynamic> data, String collectionName, String docName);

  Future updateDataToFirestore(Map<String, dynamic> data, String collectionName, String docName);

  Future getUserDataFromFirestore(String collectionName, String docName);
}