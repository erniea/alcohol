import 'dart:typed_data';
import 'package:alcohol/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageUploadService {
  /// 특정 칵테일의 이미지를 업데이트
  ///
  /// [drinkIdx]: 칵테일 ID
  /// [imageBytes]: 업로드할 이미지의 바이트 데이터
  /// [fileName]: 파일명 (확장자 포함)
  ///
  /// Returns: 업로드된 이미지의 공개 URL
  Future<String> uploadImageForDrink(
    int drinkIdx,
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      // 파일명 길이 제한 (최대 80자로 안전하게)
      String sanitizedFileName = _sanitizeFileName(fileName, maxLength: 80);

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(ApiConstants.uploadImage(drinkIdx)),
      );

      // 이미지 파일 추가
      request.files.add(
        http.MultipartFile.fromBytes(
          'img', // 백엔드에서 'img' 필드명 사용
          imageBytes,
          filename: sanitizedFileName,
        ),
      );

      // 요청 전송
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        // 백엔드가 전체 Drink 객체를 반환하므로 img 필드 추출
        return jsonResponse['img'] as String;
      } else {
        throw Exception(
            'Failed to upload image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Image upload error: $e');
    }
  }

  /// 파일명을 안전하게 정리
  ///
  /// - 길이 제한
  /// - 확장자 유지
  /// - 특수문자 제거
  String _sanitizeFileName(String fileName, {int maxLength = 80}) {
    // 확장자 추출
    final lastDot = fileName.lastIndexOf('.');
    String extension = '';
    String nameWithoutExt = fileName;

    if (lastDot != -1) {
      extension = fileName.substring(lastDot);
      nameWithoutExt = fileName.substring(0, lastDot);
    }

    // 파일명에서 특수문자 제거 (영문, 숫자, 하이픈, 언더스코어만 허용)
    nameWithoutExt = nameWithoutExt.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

    // 확장자를 포함한 최대 길이 계산
    final maxNameLength = maxLength - extension.length;

    // 파일명이 너무 길면 잘라내기
    if (nameWithoutExt.length > maxNameLength) {
      nameWithoutExt = nameWithoutExt.substring(0, maxNameLength);
    }

    return '$nameWithoutExt$extension';
  }
}
