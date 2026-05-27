import 'dart:async';
import 'dart:io';

import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';

/// Manages a persistent WebSocket connection to /announcements/ws/{userId}.
///
/// The backend broadcasts {"type":"new_announcement","announcement_id":X}
/// whenever any user creates a new announcement.
class AnnouncementWsService {
  AnnouncementWsService(this._storage);

  final SecureStorageService _storage;

  WebSocket? _socket;
  StreamSubscription? _sub;
  int? _connectedUserId;
  Timer? _reconnectTimer;

  final StreamController<int> _controller =
      StreamController<int>.broadcast();

  /// Emits the announcement_id of each newly created announcement.
  Stream<int> get newAnnouncements => _controller.stream;

  bool get isConnected =>
      _socket != null && _socket!.readyState == WebSocket.open;

  Future<void> ensureConnected() async {
    final userId = await _storage.getUserId();
    final token = await _storage.getAccessToken();
    if (userId == null || token == null) return;
    if (isConnected && _connectedUserId == userId) return;
    if (isConnected) disconnect();
    await _connect(userId, token);
  }

  Future<void> _connect(int userId, String token) async {
    try {
      final url = '${ApiConstants.wsAnnouncements(userId)}?token=$token';
      _socket = await WebSocket.connect(url);
      _connectedUserId = userId;

      _sub = _socket!.listen(
        _onData,
        onDone: () => _scheduleReconnect(userId, token),
        onError: (_) => _scheduleReconnect(userId, token),
        cancelOnError: false,
      );
    } catch (_) {
      _socket = null;
      _connectedUserId = null;
      _scheduleReconnect(userId, token);
    }
  }

  void _onData(dynamic raw) {
    try {
      // Lightweight parse — we only need announcement_id
      final text = raw as String;
      if (!text.contains('new_announcement')) return;
      final idMatch = RegExp(r'"announcement_id"\s*:\s*(\d+)').firstMatch(text);
      if (idMatch != null) {
        _controller.add(int.parse(idMatch.group(1)!));
      }
    } catch (_) {}
  }

  void _scheduleReconnect(int userId, String token) {
    _socket = null;
    _connectedUserId = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_controller.isClosed) _connect(userId, token);
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _sub?.cancel();
    _sub = null;
    _socket?.close();
    _socket = null;
    _connectedUserId = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
