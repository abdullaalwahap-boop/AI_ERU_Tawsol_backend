enum ContentFileType {
  pdf,
  image,
  doc,
  other;

  static ContentFileType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pdf':
        return ContentFileType.pdf;
      case 'image':
        return ContentFileType.image;
      case 'word':
      case 'ppt':
      case 'python':
      case 'jupyter':
        return ContentFileType.doc;
      default:
        return ContentFileType.other;
    }
  }
}
