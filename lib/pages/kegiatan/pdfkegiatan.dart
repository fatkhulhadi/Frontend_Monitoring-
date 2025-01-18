import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:get_storage/get_storage.dart';

class LihatDokumen extends StatelessWidget {
  final String assetPath; 
  final String downloadUrl; 
  final String downloadUrl2; 

  LihatDokumen({Key? key, required this.assetPath, required this.downloadUrl,required this.downloadUrl2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Laporan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Load file from assets and open
                final file = await _loadFileFromAssets(assetPath);
                OpenFile.open(file.path);
              },
              child: Text('Open Asset File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Download file from URL 1 and open
                await _downloadFile(downloadUrl, context);
              },
              child: Text('Download and Open File 1'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Download file from URL 2 and open
                await _downloadFile(downloadUrl2, context);
              },
              child: Text('Download and Open File 2'),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _loadFileFromAssets(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File('${(await getTemporaryDirectory()).path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<void> _downloadFile(String url, BuildContext context) async {
    try {
      final box = GetStorage();
      final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes, headers: {
      'Authorization': 'Bearer ${box.read('token')}',
    },));
      final bytes = response.data;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${url.split('/').last}');

      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document downloaded to ${file.path}')),
      );

      // Open the downloaded file
      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading document: $e')),
      );
    }
  }
}