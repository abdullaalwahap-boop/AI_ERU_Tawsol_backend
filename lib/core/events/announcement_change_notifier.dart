import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:flutter/foundation.dart';

class AnnouncementChangeNotifier extends ChangeNotifier {
  Announcement? _replaced;
  String? _deletedId;

  Announcement? get replaced => _replaced;
  String? get deletedId => _deletedId;

  void notifyReplace(Announcement ann) {
    _replaced = ann;
    _deletedId = null;
    notifyListeners();
  }

  void notifyDelete(String id) {
    _deletedId = id;
    _replaced = null;
    notifyListeners();
  }
}
