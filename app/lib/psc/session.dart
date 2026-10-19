import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../services/history_cipher.dart';

class PscProfile {
  final String name;
  const PscProfile(this.name);
  static String validate(String value) {
    final name = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (name.isEmpty || name.length > 60) {
      throw const FormatException('Enter a name between 1 and 60 characters.');
    }
    return name;
  }
}

/// A single device-owned profile, not a remote account or email identity.
class PscProfileStore {
  final HistoryCipher cipher;
  final Future<Directory> Function() directory;
  PscProfileStore({
    this.cipher = const PlatformHistoryCipher(),
    Future<Directory> Function()? directory,
  }) : directory = directory ?? getApplicationDocumentsDirectory;
  Future<File> _file() async =>
      File('${(await directory()).path}/psc_profile.enc');
  Future<bool> exists() async => (await _file()).exists();
  Future<PscProfile> unlock() async {
    await cipher.authenticate();
    final data = await cipher.decrypt(
      await (await _file()).readAsBytes(),
      'psc-profile-v1',
    );
    final json = jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
    if (json['schema'] != 1) {
      throw const FormatException('Unsupported profile format.');
    }
    return PscProfile(PscProfile.validate(json['name'] as String));
  }

  Future<PscProfile> create(String value) async {
    final name = PscProfile.validate(value);
    if (await exists()) {
      throw StateError('This phone already has a profile. Sign in instead.');
    }
    await cipher.authenticate();
    final file = await _file();
    final encrypted = await cipher.encrypt(
      Uint8List.fromList(utf8.encode(jsonEncode({'schema': 1, 'name': name}))),
      'psc-profile-v1',
    );
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsBytes(encrypted, flush: true);
    await temporary.rename(file.path);
    return PscProfile(name);
  }
}

class PscSession extends ChangeNotifier {
  bool _disposed = false;
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  final PscProfileStore store;
  PscSession({PscProfileStore? store}) : store = store ?? PscProfileStore();
  bool ready = false;
  bool hasProfile = false;
  bool guest = false;
  PscProfile? profile;
  String? startupError;
  Future<void> initialize() async {
    try {
      hasProfile = await store.exists();
      startupError = null;
    } catch (_) {
      startupError = 'Your local profile could not be checked. Please retry.';
    }
    ready = true;
    _changed();
  }

  Future<void> create(String name) async {
    profile = await store.create(name);
    hasProfile = true;
    guest = false;
    _changed();
  }

  Future<void> signIn() async {
    profile = await store.unlock();
    guest = false;
    _changed();
  }

  void continueAsGuest() {
    guest = true;
    _changed();
  }

  Future<void> signOut() async {
    profile = null;
    guest = false;
    _changed();
    await store.cipher.lock();
  }

  String get greeting => profile?.name.split(' ').first ?? 'there';
}

class PscScope extends InheritedNotifier<PscSession> {
  const PscScope({super.key, required PscSession session, required super.child})
    : super(notifier: session);
  static PscSession? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PscScope>()?.notifier;
  static PscSession of(BuildContext context) => maybeOf(context)!;
}
