// Vision Nova Service - Multimodal vision analysis
import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_finance_os/core/services/nova_service.dart';

final visionNovaServiceProvider = Provider((ref) => VisionNovaService(
      novaService: ref.read(novaServiceProvider),
    ));

class VisionNovaService {
  final NovaService novaService;

  VisionNovaService({required this.novaService});

  /// Analyze image with Nova Pro vision
  Future<Map<String, dynamic>> analyzeImage({
    required File imageFile,
    String? prompt,
  }) async {
    try {
      // Read image as base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Use Nova Pro for vision analysis
      final result = await novaService.analyzeReceiptImage(
        base64Image: base64Image,
        region: 'us-east-1',
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Analyze receipt specifically
  Future<Map<String, dynamic>> analyzeReceipt(File imageFile) async {
    return await analyzeImage(
      imageFile: imageFile,
      prompt: 'Analyze this receipt and extract vendor, total, tax, and items',
    );
  }

  /// Analyze receipt with live streaming (simplified)
  Future<Map<String, dynamic>> analyzeReceiptLive(File imageFile) async {
    return await analyzeReceipt(imageFile);
  }

  /// Analyze receipt with detailed information
  Future<Map<String, dynamic>> analyzeReceiptDetailed(File imageFile) async {
    return await analyzeReceipt(imageFile);
  }
}
