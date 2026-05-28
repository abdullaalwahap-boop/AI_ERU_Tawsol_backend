import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:flutter/foundation.dart';

class AnnouncementChangeNotifier extends ChangeNotifier {
  Announcement? _replaced;
  String? _deletedId;
  String? _markedReadId;
  Announcement? _added;

  Announcement? get replaced => _replaced;
  String? get deletedId => _deletedId;
  String? get markedReadId => _markedReadId;
  Announcement? get added => _added;

  void notifyReplace(Announcement ann) {
    _replaced = ann;
    _deletedId = null;
    _markedReadId = null;
    _added = null;
    notifyListeners();
  }

  void notifyDelete(String id) {
    _deletedId = id;
    _replaced = null;
    _markedReadId = null;
    _added = null;
    notifyListeners();
  }

  void notifyMarkRead(String id) {
    _markedReadId = id;
    _replaced = null;
    _deletedId = null;
    _added = null;
    notifyListeners();
  }

  void notifyNew(Announcement ann) {
    _added = ann;
    _replaced = null;
    _deletedId = null;
    _markedReadId = null;
    notifyListeners();
  }
}
