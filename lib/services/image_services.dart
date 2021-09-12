import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageServices {
  // Future<Uri> downloadImage(String photoUrl) async {
  //   var imageMetadata = FirebaseStorage.instance.ref(photoUrl).getData();

  //   return;
  // }

  Future<String> uploadFile(Uint8List file, String path) async {
    String url = '';
    try {
      TaskSnapshot upload =
          await FirebaseStorage.instance.ref(path).putData(file);
      url = await upload.ref.getDownloadURL();
    } on Exception catch (e) {
      print('Upload file failed -> ${e.toString()}');
    }
    return url;
  }

  Future<String> uploadImage(PlatformFile file, String path) async {
    try {
      TaskSnapshot upload = await FirebaseStorage.instance
          .ref(
              '$path/${file.path}-${DateTime.now().toIso8601String()}.${file.extension}')
          .putData(
            file.bytes!,
            SettableMetadata(contentType: 'image/${file.extension}'),
          );

      String url = await upload.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return '';
    }
  }

  // Future<String> uploadProfilePhoto(html.File image, {String imageName}) async {

  //   try {
  //     //Upload Profile Photo
  //     fb.StorageReference _storage = fb.storage().ref('profilephotos/$imageName.png');
  //     fb.UploadTaskSnapshot uploadTaskSnapshot = await _storage.put(image).future;
  //     // Wait until the file is uploaded then store the download url
  //     var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
  //     url = imageUri.toString();

  //   } catch (e) {
  //     print(e);
  //   }
  //   return url;
  // }
}
