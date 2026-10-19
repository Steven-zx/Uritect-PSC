import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uritect_psc/psc/session.dart';
import 'package:uritect_psc/services/history_cipher.dart';

// Behavioral fake only; native AES-GCM remains covered by device verification.
class ProfileTestCipher implements HistoryCipher {
  bool canceled = false;
  bool authenticated = false;
  @override
  Duration get remainingSession => const Duration(seconds: 100);
  @override
  Future<void> authenticate() async {
    if (canceled) throw PlatformException(code: 'CANCELED');
    authenticated = true;
  }

  @override
  Future<Uint8List> encrypt(Uint8List bytes, String context) async {
    if (!authenticated || context != 'psc-profile-v1') {
      throw StateError('Locked');
    }
    return Uint8List.fromList(bytes.map((v) => v ^ 0xAF).toList());
  }

  @override
  Future<Uint8List> decrypt(Uint8List bytes, String context) =>
      encrypt(bytes, context);
  @override
  Future<void> lock() async {
    authenticated = false;
  }
}

void main() {
  late Directory directory;
  late ProfileTestCipher cipher;
  late PscProfileStore store;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('psc_profile_test');
    cipher = ProfileTestCipher();
    store = PscProfileStore(cipher: cipher, directory: () async => directory);
  });
  tearDown(() async => directory.delete(recursive: true));
  test(
    'profile needs authentication and has no plaintext name on disk',
    () async {
      await store.create('  Aser   Test  ');
      final bytes = await File(
        '${directory.path}/psc_profile.enc',
      ).readAsBytes();
      expect(String.fromCharCodes(bytes), isNot(contains('Aser')));
      await cipher.lock();
      expect((await store.unlock()).name, 'Aser Test');
      expect(cipher.authenticated, true);
    },
  );
  test('canceled authentication never creates or unlocks a profile', () async {
    cipher.canceled = true;
    await expectLater(store.create('Aser'), throwsA(isA<PlatformException>()));
    expect(await store.exists(), false);
    cipher.canceled = false;
    await store.create('Aser');
    await cipher.lock();
    cipher.canceled = true;
    final session = PscSession(store: store);
    await session.initialize();
    await expectLater(session.signIn(), throwsA(isA<PlatformException>()));
    expect(session.profile, null);
    session.dispose();
  });
  test('a second profile cannot overwrite existing owner', () async {
    await store.create('First');
    await expectLater(store.create('Second'), throwsStateError);
    expect((await store.unlock()).name, 'First');
  });
  test(
    'new process starts locked; sign out preserves encrypted profile',
    () async {
      final session = PscSession(store: store);
      await session.create('Aser');
      expect(session.greeting, 'Aser');
      await session.signOut();
      expect(session.profile, null);
      expect(session.guest, false);
      expect(await store.exists(), true);
      final fresh = PscSession(store: store);
      await fresh.initialize();
      expect(fresh.hasProfile, true);
      expect(fresh.profile, null);
      session.dispose();
      fresh.dispose();
    },
  );
}
