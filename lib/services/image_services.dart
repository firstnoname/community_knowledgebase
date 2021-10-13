import 'dart:typed_data';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageServices {
  Future<String> uploadFile(Uint8List file, String fireStorePath) async {
    String url = '';
    try {
      TaskSnapshot upload =
          await FirebaseStorage.instance.ref(fireStorePath).putData(file);
      url = await upload.ref.getDownloadURL();
    } on Exception catch (e) {
      print('Upload file failed -> ${e.toString()}');
    }
    return url;
  }

  Future<String> uploadVideo(html.File videoFile, String fireStorePath) async {
    String videoUrl = '';
    try {
      TaskSnapshot uploadVideo =
          await FirebaseStorage.instance.ref(fireStorePath).putBlob(videoFile);
      videoUrl = await uploadVideo.ref.getDownloadURL();
    } on Exception catch (e) {
      print('Upload video failed -> ${e.toString()}');
    }

    return videoUrl;
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
}
