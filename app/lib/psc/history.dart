import 'dart:async';
import 'package:flutter/material.dart';
import '../models/saved_scan_record.dart';
import '../services/scan_history_service.dart';
import '../services/history_cipher.dart';
import '../pages/protected_history_page.dart';

class PscHistoryPage extends StatefulWidget {
  const PscHistoryPage({super.key});
  @override
  State<PscHistoryPage> createState() => _PscHistoryPageState();
}

class _PscHistoryPageState extends State<PscHistoryPage>
    with WidgetsBindingObserver {
  final service = const ScanHistoryService();
  List<SavedScanRecord>? records;
  bool busy = false;
  String? error;
  Timer? timer;
  int epoch = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void hide() {
    epoch++;
    timer?.cancel();
    if (mounted) setState(() => records = null);
    unawaited(HistoryPrivacy.release(this));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && !busy) hide();
  }

  @override
  void dispose() {
    epoch++;
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(HistoryPrivacy.release(this));
    super.dispose();
  }

  Future<void> unlock() async {
    if (busy) return;
    final request = ++epoch;
    setState(() {
      busy = true;
      error = null;
      records = null;
    });
    try {
      await HistoryPrivacy.acquire(this);
      await service.authenticate();
      final loaded = await service.loadRecords();
      if (!mounted ||
          request != epoch ||
          WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        return;
      }
      await HistoryPrivacy.acquire(this);
      if (!mounted || request != epoch) return;
      setState(() => records = loaded);
      final remaining =
          service.cipher.remainingSession - const Duration(seconds: 2);
      timer = Timer(remaining.isNegative ? Duration.zero : remaining, hide);
    } catch (e) {
      if (mounted && request == epoch) {
        setState(() => error = historyAccessMessage(e));
      }
    } finally {
      if (mounted) setState(() => busy = false);
      if (records == null) await HistoryPrivacy.release(this);
    }
  }

  Future<void> remove(SavedScanRecord record) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this saved scan?'),
        content: const Text(
          'This removes its app record. Your original gallery photo is not deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await service.deleteRecord(record.id);
      if (mounted) await unlock();
    } catch (e) {
      if (mounted) setState(() => error = historyAccessMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Your saved scans'),
      actions: [
        if (records != null)
          IconButton(
            tooltip: 'Lock history',
            onPressed: () {
              hide();
              unawaited(service.lock());
            },
            icon: const Icon(Icons.lock_outline),
          ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (records == null) ...[
          const SizedBox(height: 48),
          const Icon(Icons.lock_outline, size: 64),
          const SizedBox(height: 20),
          Text(
            'A private space for your records.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Use this phone’s screen lock to open saved results. History locks when you leave the app or its access window expires.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: busy ? null : unlock,
            child: Text(busy ? 'Unlocking…' : 'Unlock saved history'),
          ),
        ] else if (records!.isEmpty) ...[
          const SizedBox(height: 60),
          const Icon(Icons.history, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Your story starts with your first saved scan.',
            textAlign: TextAlign.center,
          ),
        ] else
          for (final record in records!)
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(
                  record.patientName?.trim().isNotEmpty == true
                      ? record.patientName!
                      : 'Saved scan',
                ),
                subtitle: Text(
                  '${record.savedAt.toLocal().toString().substring(0, 16)}\n${record.clinicalAction}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Delete saved scan',
                  onPressed: () => remove(record),
                  icon: const Icon(Icons.delete_outline),
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => ProtectedHistoryPage(recordId: record.id),
                    ),
                  );
                  if (mounted) hide();
                },
              ),
            ),
      ],
    ),
  );
}
