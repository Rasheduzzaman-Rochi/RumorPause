import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareReceiverService {
  StreamSubscription<List<SharedMediaFile>>? _intentSubscription;

  void listenForSharedContent({
    required void Function(String content) onContentReceived,
  }) {
    _intentSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> sharedFiles) {
      final String? content = _extractTextContent(sharedFiles);

      if (content != null && content.trim().isNotEmpty) {
        debugPrint('Shared content received from stream: $content');
        onContentReceived(content.trim());
      }
    }, onError: (Object error) {
      debugPrint('Share receive stream error: $error');
    });
  }

  Future<void> checkInitialSharedContent({
    required void Function(String content) onContentReceived,
  }) async {
    try {
      final List<SharedMediaFile> sharedFiles =
          await ReceiveSharingIntent.instance.getInitialMedia();

      final String? content = _extractTextContent(sharedFiles);

      if (content != null && content.trim().isNotEmpty) {
        debugPrint('Initial shared content received: $content');
        onContentReceived(content.trim());
      }

      await ReceiveSharingIntent.instance.reset();
    } catch (error) {
      debugPrint('Initial share receive error: $error');
    }
  }

  String? _extractTextContent(List<SharedMediaFile> sharedFiles) {
    if (sharedFiles.isEmpty) return null;

    for (final SharedMediaFile file in sharedFiles) {
      final Map<String, dynamic> data = file.toMap();

      debugPrint('SharedMediaFile data: $data');

      final Object? message = data['message'];
      final Object? path = data['path'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      if (path is String && path.trim().isNotEmpty) {
        return path;
      }
    }

    return null;
  }

  Future<void> dispose() async {
    await _intentSubscription?.cancel();
    _intentSubscription = null;
  }
}
