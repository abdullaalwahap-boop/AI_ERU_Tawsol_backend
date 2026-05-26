class VoiceUploadResult {
  final String fileUrl;
  final String? fileName;
  final int? fileSizeBytes;

  const VoiceUploadResult({
    required this.fileUrl,
    this.fileName,
    this.fileSizeBytes,
  });

  factory VoiceUploadResult.fromJson(Map<String, dynamic> json) {
    return VoiceUploadResult(
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String?,
      fileSizeBytes: json['file_size_bytes'] as int?,
    );
  }
}
