// import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:e_commerce/secrets/secrets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

Future<String> uploadToCloudinary(FilePickerResult? filePickerResult) async {
  if (filePickerResult == null || filePickerResult.files.isEmpty) {
    return '';
  }

  File file = File(filePickerResult.files.single.path!);

  String cloudName = cloudinaryName;

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

  var request = http.MultipartRequest('POST', uri);

  var fileBytes = await file.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: file.path.split('/').last,
  );

  request.files.add(multipartFile);

  request.fields['upload_preset'] = 'preset-for-file-upload';
  request.fields['resource_type'] = 'raw';

  var response = await request.send();

  var responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    String res = await responseBody;
    return jsonDecode(res)['url'];
  } else {
    return '';
  }
}
