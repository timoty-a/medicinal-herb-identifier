import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'plant_catalog.dart';
import 'plant_classifier.dart';
import 'scan_history_store.dart';

void main() {
  runApp(const MedicinalHerbApp());
}

class MedicinalHerbApp extends StatefulWidget {
  const MedicinalHerbApp({super.key});

  @override
  State<MedicinalHerbApp> createState() => _MedicinalHerbAppState();
}

class _MedicinalHerbAppState extends State<MedicinalHerbApp> {
  static const _themeModeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_themeModeKey);
    if (!mounted || raw == null) {
      return;
    }
    setState(() {
      _themeMode = raw == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> _toggleThemeMode() async {
    final nextMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeModeKey,
      nextMode == ThemeMode.dark ? 'dark' : 'light',
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _themeMode = nextMode;
    });
  }

  ThemeData _buildTheme(Brightness brightness) {
    const seed = Color(0xFF1F9D63);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0D120F)
          : const Color(0xFFF5F7F2),
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme
          .apply(
            bodyColor: isDark
                ? const Color(0xFFF4F7F2)
                : const Color(0xFF142016),
            displayColor: isDark
                ? const Color(0xFFF4F7F2)
                : const Color(0xFF142016),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF242D24) : const Color(0xFFE8EFE6),
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9EAA9E) : const Color(0xFF708172),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HerbAI',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: HomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleThemeMode,
      ),
    );
  }
}

extension ThemePaletteExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  AppPalette get palette => AppPalette(Theme.of(this).brightness);
}

class AppPalette {
  AppPalette(this.brightness);

  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;
  Color get surface =>
      isDark ? const Color(0xFF171D18) : const Color(0xFFFFFFFF);
  Color get surfaceAlt =>
      isDark ? const Color(0xFF232B24) : const Color(0xFFEAF1E8);
  Color get border =>
      isDark ? const Color(0xFF283028) : const Color(0xFFD9E4D7);
  Color get text => isDark ? const Color(0xFFF4F7F2) : const Color(0xFF142016);
  Color get muted => isDark ? const Color(0xFFAAB4AB) : const Color(0xFF5A6B5D);
  Color get accent =>
      isDark ? const Color(0xFF9ED2AE) : const Color(0xFF0E7C49);
  Color get accentSoft =>
      isDark ? const Color(0xFF24432E) : const Color(0xFFD7ECDC);
  Color get navBg => isDark ? const Color(0xFF121814) : const Color(0xFFEEF4EC);
  Color get statusBg =>
      isDark ? const Color(0xFF171E18) : const Color(0xFFE7F1E6);
  Color get infoCard =>
      isDark ? const Color(0xFF475144) : const Color(0xFFDCE7D8);
  Color get fieldFill =>
      isDark ? const Color(0xFF242D24) : const Color(0xFFE8EFE6);
  Color get warningBg =>
      isDark ? const Color(0xFF4A3119) : const Color(0xFFF8E6CC);
  Color get warningText =>
      isDark ? const Color(0xFFF2D59E) : const Color(0xFF7A4D16);
  Color get dangerBg =>
      isDark ? const Color(0xFF4B1818) : const Color(0xFFFBE7E7);
  Color get dangerBorder =>
      isDark ? const Color(0xFF7A3030) : const Color(0xFFDEB8B8);
  Color get dangerText =>
      isDark ? const Color(0xFFF7DDDD) : const Color(0xFF6D2525);
  Color get successBg =>
      isDark ? const Color(0xFF24412E) : const Color(0xFFDDF0E3);
  Color get successText =>
      isDark ? const Color(0xFF93D2A8) : const Color(0xFF17663D);
  Color get heroButtonBg =>
      isDark ? const Color(0xAA101410) : const Color(0xF2FFFFFF);
  Color get heroButtonIcon =>
      isDark ? const Color(0xFFF4F7F2) : const Color(0xFF16301D);
  Color get preparationBg =>
      isDark ? const Color(0xFF5C5541) : const Color(0xFFF3E8D7);
  Color get preparationText =>
      isDark ? const Color(0xFFF3E7D1) : const Color(0xFF5E4724);
  Color get reviewBg =>
      isDark ? const Color(0xFF2F2618) : const Color(0xFFF9F0DE);
  Color get reviewBorder =>
      isDark ? const Color(0xFF6A5328) : const Color(0xFFE4CFA6);
  Color get reviewText =>
      isDark ? const Color(0xFFF0DEB6) : const Color(0xFF79561D);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.isDarkMode,
    required this.onToggleTheme,
    super.key,
  });

  final bool isDarkMode;
  final Future<void> Function() onToggleTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final PlantClassifier _classifier = PlantClassifier();
  final ScanHistoryStore _historyStore = ScanHistoryStore();

  int _selectedTab = 0;
  bool _isModelReady = false;
  bool _isRunning = false;
  bool _isHistoryLoaded = false;
  String? _statusMessage;
  File? _selectedImage;
  List<ScanRecord> _history = const <ScanRecord>[];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _statusMessage = 'Loading the offline model...';
    });

    try {
      final loadedHistory = await _historyStore.load();
      await _classifier.load();
      await _recoverLostImage();
      if (!mounted) {
        return;
      }
      setState(() {
        _history = loadedHistory;
        _isHistoryLoaded = true;
        _isModelReady = true;
        _statusMessage = 'Model ready. Capture or choose a leaf image.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isHistoryLoaded = true;
        _statusMessage = 'Startup failed: $error';
      });
    }
  }

  Future<void> _recoverLostImage() async {
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }

    if (response.files != null && response.files!.isNotEmpty) {
      await _runClassification(
        File(response.files!.first.path),
        sourceLabel: 'Recovered',
      );
      return;
    }

    if (response.file != null) {
      await _runClassification(
        File(response.file!.path),
        sourceLabel: 'Recovered',
      );
      return;
    }

    if (response.exception != null && mounted) {
      setState(() {
        _statusMessage = 'Recovered image flow failed: ${response.exception}';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_isModelReady || _isRunning) {
      return;
    }

    final pickedImage = await _imagePicker.pickImage(
      source: source,
      imageQuality: 95,
      maxWidth: 1800,
    );

    if (pickedImage == null) {
      return;
    }

    final sourceLabel = source == ImageSource.camera ? 'Camera' : 'Gallery';
    await _runClassification(File(pickedImage.path), sourceLabel: sourceLabel);
  }

  Future<void> _runClassification(
    File imageFile, {
    required String sourceLabel,
  }) async {
    setState(() {
      _selectedImage = imageFile;
      _isRunning = true;
      _statusMessage = 'Analyzing leaf image offline...';
    });

    try {
      final result = await _classifier.classify(imageFile);
      final profile = result.topPrediction.profile;
      final record = ScanRecord(
        modelLabel: profile.label,
        yorubaName: profile.yorubaName,
        commonName: profile.commonName,
        scientificName: profile.scientificName,
        igboName: profile.igboName,
        hausaName: profile.hausaName,
        medicinalUses: profile.medicinalUses,
        confidence: result.topPrediction.confidence,
        scannedAt: DateTime.now(),
        sourceLabel: sourceLabel,
        lowConfidence: result.isLowConfidence,
        needsReview: result.needsReview,
        likelyUnsupported: result.isLikelyUnsupported,
        confidenceGap: result.confidenceGap,
      );
      final updatedHistory = [record, ..._history];
      await _historyStore.save(updatedHistory);

      if (!mounted) {
        return;
      }
      setState(() {
        _history = updatedHistory.take(30).toList(growable: false);
        _statusMessage = result.isLowConfidence
            ? 'Plant could not be confidently identified. Please take a clearer close-up photo of a single leaf.'
            : result.isLikelyUnsupported
            ? 'Closest match only. This image may be outside the 5 supported plants.'
            : result.needsReview
            ? 'Review the result carefully. Lighting, overlap, or background may affect accuracy.'
            : 'Plant identified successfully.';
      });

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PlantDetailScreen(
            profile: profile,
            scanRecord: record,
            pageTitle: 'Identification Result',
            scannedImageFile: imageFile,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusMessage = 'Prediction failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  Future<void> _clearHistory() async {
    await _historyStore.clear();
    if (!mounted) {
      return;
    }
    setState(() {
      _history = const <ScanRecord>[];
    });
  }

  void _openPlantDetail(
    PlantProfile profile, {
    ScanRecord? record,
    String? title,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlantDetailScreen(
          profile: profile,
          scanRecord: record,
          pageTitle: title ?? profile.commonName,
        ),
      ),
    );
  }

  void _openHistoryDetail(ScanRecord record) {
    _openPlantDetail(
      PlantCatalog.profileForLabel(record.modelLabel),
      record: record,
      title: record.lowConfidence ? 'Scan Review' : 'Scan Record',
    );
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _HomeTab(
              history: _history,
              imageFile: _selectedImage,
              isModelReady: _isModelReady,
              isRunning: _isRunning,
              statusMessage: _statusMessage,
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
              onCamera: () => _pickImage(ImageSource.camera),
              onGallery: () => _pickImage(ImageSource.gallery),
              onOpenHistory: () {
                setState(() {
                  _selectedTab = 2;
                });
              },
              onOpenPlants: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              onOpenHistoryDetail: _openHistoryDetail,
            ),
            PlantsGalleryTab(
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
              onOpenPlant: _openPlantDetail,
            ),
            HistoryTab(
              history: _history,
              isLoaded: _isHistoryLoaded,
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
              onClearHistory: _clearHistory,
              onOpenRecord: _openHistoryDetail,
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        backgroundColor: context.palette.navBg,
        indicatorColor: context.palette.accentSoft,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Plants',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.history,
    required this.imageFile,
    required this.isModelReady,
    required this.isRunning,
    required this.statusMessage,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onCamera,
    required this.onGallery,
    required this.onOpenHistory,
    required this.onOpenPlants,
    required this.onOpenHistoryDetail,
  });

  final List<ScanRecord> history;
  final File? imageFile;
  final bool isModelReady;
  final bool isRunning;
  final String? statusMessage;
  final bool isDarkMode;
  final Future<void> Function() onToggleTheme;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenPlants;
  final void Function(ScanRecord record) onOpenHistoryDetail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DashboardHeader(
            isDarkMode: isDarkMode,
            onToggleTheme: onToggleTheme,
          ),
          const SizedBox(height: 18),
          _HeroScanCard(
            imageFile: imageFile,
            isModelReady: isModelReady,
            isRunning: isRunning,
            onCamera: onCamera,
            onGallery: onGallery,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.history_rounded,
                  title: 'History',
                  subtitle: history.isEmpty
                      ? 'No scans yet'
                      : '${history.length} scans',
                  accent: const Color(0xFFD58E84),
                  onTap: onOpenHistory,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.search_rounded,
                  title: 'Plant Gallery',
                  subtitle: '${PlantCatalog.speciesCount} plants',
                  accent: const Color(0xFFD2B67D),
                  onTap: onOpenPlants,
                ),
              ),
            ],
          ),
          if (statusMessage != null) ...[
            const SizedBox(height: 14),
            _StatusStrip(message: statusMessage!),
          ],
          const SizedBox(height: 18),
          const _DidYouKnowCard(),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 18),
            _RecentScansCard(
              history: history.take(3).toList(growable: false),
              onOpenHistory: onOpenHistory,
              onOpenRecord: onOpenHistoryDetail,
            ),
          ],
        ],
      ),
    );
  }
}

class PlantsGalleryTab extends StatefulWidget {
  const PlantsGalleryTab({
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onOpenPlant,
    super.key,
  });

  final bool isDarkMode;
  final Future<void> Function() onToggleTheme;
  final void Function(PlantProfile profile, {ScanRecord? record, String? title})
  onOpenPlant;

  @override
  State<PlantsGalleryTab> createState() => _PlantsGalleryTabState();
}

class _PlantsGalleryTabState extends State<PlantsGalleryTab> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final lowered = _query.trim().toLowerCase();
    final plants = PlantCatalog.profiles
        .where((profile) {
          if (lowered.isEmpty) {
            return true;
          }
          final haystack = <String>[
            profile.commonName,
            profile.scientificName,
            profile.yorubaName,
            profile.igboName,
            profile.hausaName,
            profile.medicinalUses,
            ...profile.searchKeywords,
          ].join(' ').toLowerCase();
          return haystack.contains(lowered);
        })
        .toList(growable: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Search Plants',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: palette.text,
                  ),
                ),
              ),
              _ThemeToggleButton(
                isDarkMode: widget.isDarkMode,
                onTap: widget.onToggleTheme,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Browse the five tracked medicinal plants and open full detail pages.',
            style: TextStyle(color: palette.muted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Search by Yoruba, English, scientific name, or use...',
              filled: true,
              fillColor: palette.fieldFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: plants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                mainAxisExtent: 236,
              ),
              itemBuilder: (context, index) {
                final profile = plants[index];
                return _PlantGalleryCard(
                  profile: profile,
                  onTap: () => widget.onOpenPlant(profile),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    required this.history,
    required this.isLoaded,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onClearHistory,
    required this.onOpenRecord,
    super.key,
  });

  final List<ScanRecord> history;
  final bool isLoaded;
  final bool isDarkMode;
  final Future<void> Function() onToggleTheme;
  final Future<void> Function() onClearHistory;
  final void Function(ScanRecord record) onOpenRecord;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'History',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: palette.text,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saved identifications on this device.',
                      style: TextStyle(color: palette.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ThemeToggleButton(isDarkMode: isDarkMode, onTap: onToggleTheme),
              if (history.isNotEmpty)
                TextButton.icon(
                  onPressed: () async {
                    final shouldClear = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        final dialogPalette = dialogContext.palette;
                        return AlertDialog(
                          backgroundColor: dialogPalette.surface,
                          title: Text(
                            'Clear history?',
                            style: TextStyle(color: dialogPalette.text),
                          ),
                          content: Text(
                            'This will remove saved scan records from the device.',
                            style: TextStyle(color: dialogPalette.muted),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('Clear'),
                            ),
                          ],
                        );
                      },
                    );
                    if (shouldClear == true) {
                      await onClearHistory();
                    }
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: !isLoaded
                ? const Center(child: CircularProgressIndicator())
                : history.isEmpty
                ? const _EmptyHistoryCard()
                : ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final record = history[index];
                      return _HistoryRecordCard(
                        record: record,
                        profile: PlantCatalog.profileForLabel(
                          record.modelLabel,
                        ),
                        onTap: () => onOpenRecord(record),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({
    required this.profile,
    required this.pageTitle,
    this.scanRecord,
    this.scannedImageFile,
    super.key,
  });

  final PlantProfile profile;
  final ScanRecord? scanRecord;
  final String pageTitle;
  final File? scannedImageFile;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isUnconfirmed = scanRecord?.lowConfidence ?? false;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 270,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      child: isUnconfirmed
                          ? _UnconfirmedHeroImage(
                              imageFile: scannedImageFile,
                              yorubaName: profile.yorubaName,
                            )
                          : Image.asset(
                              profile.imageAssetPath,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: palette.heroButtonBg,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: palette.heroButtonIcon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isUnconfirmed)
                      _UnconfirmedResultContent(
                        pageTitle: pageTitle,
                        scanRecord: scanRecord!,
                      )
                    else ...[
                      Text(
                        profile.yorubaName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: palette.text,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.commonName,
                        style: TextStyle(
                          color: palette.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.scientificName,
                        style: TextStyle(
                          color: palette.muted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (scanRecord != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: palette.surfaceAlt,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: palette.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pageTitle,
                                      style: TextStyle(
                                        color: palette.accent,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${scanRecord!.sourceLabel} - ${_formatTimestamp(scanRecord!.scannedAt)}',
                                      style: TextStyle(
                                        color: palette.muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _ConfidencePill(
                                confidence: scanRecord!.confidence,
                                requiresReview: scanRecord!.needsReview,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ResultNoticeCard(record: scanRecord!),
                      ],
                      const SizedBox(height: 16),
                      _DetailInfoCard(
                        icon: Icons.location_on_outlined,
                        child: Text(
                          profile.habitatNote,
                          style: TextStyle(color: palette.text, height: 1.4),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const _SectionHeading(
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile.about,
                        style: TextStyle(color: palette.text, height: 1.6),
                      ),
                      const SizedBox(height: 22),
                      const _SectionHeading(
                        icon: Icons.translate_outlined,
                        title: 'Names',
                      ),
                      const SizedBox(height: 10),
                      _LanguageTile(label: 'Yoruba', value: profile.yorubaName),
                      _LanguageTile(label: 'Igbo', value: profile.igboName),
                      _LanguageTile(label: 'Hausa', value: profile.hausaName),
                      const SizedBox(height: 22),
                      const _SectionHeading(
                        icon: Icons.favorite_border_rounded,
                        title: 'Health Benefits',
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.healthBenefits
                            .map((benefit) => _BenefitChip(text: benefit))
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 22),
                      const _SectionHeading(
                        icon: Icons.checklist_rtl_rounded,
                        title: 'Common Uses',
                      ),
                      const SizedBox(height: 10),
                      ...profile.commonUses.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _BulletRow(text: item),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _SectionHeading(
                        icon: Icons.science_outlined,
                        title: 'Preparation',
                      ),
                      const SizedBox(height: 10),
                      _DetailInfoCard(
                        color: palette.preparationBg,
                        borderColor: palette.isDark
                            ? palette.preparationBg
                            : palette.reviewBorder,
                        child: Text(
                          profile.preparation,
                          style: TextStyle(
                            color: palette.preparationText,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _SectionHeading(
                        icon: Icons.warning_amber_rounded,
                        title: 'Warnings & Precautions',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.dangerBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: palette.dangerBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...profile.warnings.map(
                              (warning) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _BulletRow(
                                  text: warning,
                                  color: palette.dangerText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Educational use only. This offline model recognizes only five supported plants and may still force other species into the closest match. Always confirm plant identity and treatment decisions with qualified professionals.',
                        style: TextStyle(color: palette.muted, height: 1.5),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnconfirmedHeroImage extends StatelessWidget {
  const _UnconfirmedHeroImage({
    required this.imageFile,
    required this.yorubaName,
  });

  final File? imageFile;
  final String yorubaName;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (imageFile != null) {
      return Image.file(imageFile!, fit: BoxFit.cover);
    }

    return Container(
      color: palette.surfaceAlt,
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_search_rounded,
            size: 52,
            color: palette.warningText,
          ),
          const SizedBox(height: 12),
          Text(
            'Scan needs a clearer photo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: palette.text,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The app could not confidently match this leaf to $yorubaName or another supported plant.',
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _UnconfirmedResultContent extends StatelessWidget {
  const _UnconfirmedResultContent({
    required this.pageTitle,
    required this.scanRecord,
  });

  final String pageTitle;
  final ScanRecord scanRecord;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plant could not be confidently identified',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: palette.text,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please take a clearer close-up photo of a single leaf.',
          style: TextStyle(color: palette.muted, fontSize: 15, height: 1.45),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.warningBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.reviewBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pageTitle,
                      style: TextStyle(
                        color: palette.warningText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scanRecord.sourceLabel} - ${_formatTimestamp(scanRecord.scannedAt)}',
                      style: TextStyle(
                        color: palette.warningText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _ConfidencePill(
                confidence: scanRecord.confidence,
                requiresReview: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.reviewBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.reviewBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: palette.warningText,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This result was below the confidence threshold',
                      style: TextStyle(
                        color: palette.reviewText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'To improve the scan:',
                style: TextStyle(
                  color: palette.reviewText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              _BulletRow(
                text: 'Photograph one leaf only, close to the camera.',
                color: palette.reviewText,
              ),
              const SizedBox(height: 10),
              _BulletRow(
                text: 'Use bright natural light and avoid heavy shadows.',
                color: palette.reviewText,
              ),
              const SizedBox(height: 10),
              _BulletRow(
                text:
                    'Keep the background plain so the leaf edges are easy to see.',
                color: palette.reviewText,
              ),
              const SizedBox(height: 10),
              _BulletRow(
                text:
                    'Make sure the image belongs to one of the 5 supported plants.',
                color: palette.reviewText,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Educational use only. When a scan falls below the threshold, HerbAI does not present a plant identification because the guess may be misleading.',
          style: TextStyle(color: palette.muted, height: 1.5),
        ),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final Future<void> Function() onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF0E7C49),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.spa_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HerbAI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: palette.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Discover nature\'s pharmacy',
                  style: TextStyle(color: palette.muted, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _ThemeToggleButton(isDarkMode: isDarkMode, onTap: onToggleTheme),
        ],
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton({required this.isDarkMode, required this.onTap});

  final bool isDarkMode;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return IconButton.filledTonal(
      onPressed: () {
        onTap();
      },
      style: IconButton.styleFrom(
        backgroundColor: palette.surfaceAlt,
        foregroundColor: palette.accent,
      ),
      icon: Icon(
        isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
    );
  }
}

class _HeroScanCard extends StatelessWidget {
  const _HeroScanCard({
    required this.imageFile,
    required this.isModelReady,
    required this.isRunning,
    required this.onCamera,
    required this.onGallery,
  });

  final File? imageFile;
  final bool isModelReady;
  final bool isRunning;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC4E4B8), Color(0xFFE8D7B7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewBox(imageFile: imageFile),
          const SizedBox(height: 14),
          const Text(
            'Identify Plants',
            style: TextStyle(
              color: Color(0xFF102816),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Take a photo to discover medicinal properties and local names. For best results, capture one clear leaf against a simple background.',
            style: TextStyle(color: Color(0xFF324A39), height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: isModelReady && !isRunning ? onCamera : null,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(isRunning ? 'Working...' : 'Open Camera'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF0E7C49),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isModelReady && !isRunning ? onGallery : null,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Choose Photo'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: const Color(0xFF15321D),
                    side: const BorderSide(color: Color(0x660E7C49)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.imageFile});

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0x180B160F),
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: imageFile == null
              ? Container(
                  color: const Color(0x120B160F),
                  padding: const EdgeInsets.all(24),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_florist_outlined,
                        color: Color(0xFF35513D),
                        size: 54,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Your selected leaf image will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF35513D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : Image.file(imageFile!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent, size: 22),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: palette.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(color: palette.muted)),
          ],
        ),
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.statusBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: palette.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: palette.text)),
          ),
        ],
      ),
    );
  }
}

class _DidYouKnowCard extends StatelessWidget {
  const _DidYouKnowCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.infoCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: palette.accent),
              const SizedBox(width: 8),
              Text(
                'Did You Know?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: palette.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Traditional medicinal plants remain an important part of health practice in many Nigerian communities, especially where fast internet or nearby clinics are not always available.',
            style: TextStyle(color: palette.text, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _RecentScansCard extends StatelessWidget {
  const _RecentScansCard({
    required this.history,
    required this.onOpenHistory,
    required this.onOpenRecord,
  });

  final List<ScanRecord> history;
  final VoidCallback onOpenHistory;
  final void Function(ScanRecord record) onOpenRecord;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Scans',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: palette.text,
                  ),
                ),
              ),
              TextButton(
                onPressed: onOpenHistory,
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...history.map((record) {
            final profile = PlantCatalog.profileForLabel(record.modelLabel);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecentScanRow(
                record: record,
                profile: profile,
                onTap: () => onOpenRecord(record),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RecordThumbnail extends StatelessWidget {
  const _RecordThumbnail({
    required this.record,
    required this.profile,
    required this.borderRadius,
  });

  final ScanRecord record;
  final PlantProfile profile;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (!record.lowConfidence) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(profile.imageAssetPath, fit: BoxFit.cover),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: palette.warningBg,
        borderRadius: borderRadius,
        border: Border.all(color: palette.reviewBorder),
      ),
      child: Center(
        child: Icon(
          Icons.help_outline_rounded,
          color: palette.warningText,
          size: 28,
        ),
      ),
    );
  }
}

class _RecentScanRow extends StatelessWidget {
  const _RecentScanRow({
    required this.record,
    required this.profile,
    required this.onTap,
  });

  final ScanRecord record;
  final PlantProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.surfaceAlt,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              height: 58,
              child: _RecordThumbnail(
                record: record,
                profile: profile,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.lowConfidence
                        ? 'Unconfirmed scan'
                        : record.yorubaName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.lowConfidence
                        ? 'Retake with one clear leaf close-up.'
                        : record.commonName,
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 12,
                      fontWeight: record.lowConfidence
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${(record.confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: palette.successText,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantGalleryCard extends StatelessWidget {
  const _PlantGalleryCard({required this.profile, required this.onTap});

  final PlantProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                height: 154,
                width: double.infinity,
                child: Image.asset(
                  profile.imageAssetPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.yorubaName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile.commonName,
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRecordCard extends StatelessWidget {
  const _HistoryRecordCard({
    required this.record,
    required this.profile,
    required this.onTap,
  });

  final ScanRecord record;
  final PlantProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 74,
              height: 74,
              child: _RecordThumbnail(
                record: record,
                profile: profile,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.lowConfidence
                        ? 'Unconfirmed scan'
                        : record.yorubaName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.lowConfidence
                        ? 'Please retake with a clearer single-leaf photo.'
                        : record.commonName,
                    style: TextStyle(
                      color: record.lowConfidence
                          ? palette.muted
                          : palette.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimestamp(record.scannedAt),
                    style: TextStyle(color: palette.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: record.needsReview
                    ? palette.warningBg
                    : palette.successBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${(record.confidence * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: record.needsReview
                      ? palette.warningText
                      : palette.successText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistoryCard extends StatelessWidget {
  const _EmptyHistoryCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_outlined, color: palette.accent, size: 56),
            const SizedBox(height: 12),
            Text(
              'No scan history yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: palette.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your identified plants will appear here after each successful scan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultNoticeCard extends StatelessWidget {
  const _ResultNoticeCard({required this.record});

  final ScanRecord record;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final title = record.likelyUnsupported
        ? 'Closest match only'
        : record.needsReview
        ? 'Review this result'
        : 'Prediction looks stable';
    final message = record.likelyUnsupported
        ? 'This app recognizes only 5 supported plants. If the photo is another species, the model may still force it into the nearest class.'
        : record.needsReview
        ? 'Leaf overlap, lighting, zoom level, or busy backgrounds may be affecting the prediction. Try a clearer photo of a single leaf.'
        : 'The image fits one of the supported classes with a clearer confidence gap than the nearest alternative.';

    final backgroundColor = record.needsReview
        ? palette.reviewBg
        : palette.successBg;
    final borderColor = record.needsReview
        ? palette.reviewBorder
        : palette.border;
    final textColor = record.needsReview ? palette.reviewText : palette.text;
    final iconColor = record.needsReview ? palette.warningText : palette.accent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            record.needsReview
                ? Icons.rule_folder_outlined
                : Icons.verified_outlined,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(color: textColor, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailInfoCard extends StatelessWidget {
  const _DetailInfoCard({
    required this.child,
    this.color = const Color(0xFF232B24),
    this.icon,
    this.borderColor,
  });

  final Widget child;
  final Color color;
  final IconData? icon;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color == const Color(0xFF232B24) ? palette.surfaceAlt : color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: palette.accent, size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Icon(icon, color: palette.accent, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: palette.text,
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: TextStyle(
                  color: palette.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: palette.text,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.accent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.palette.text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: resolvedColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: resolvedColor, height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _ConfidencePill extends StatelessWidget {
  const _ConfidencePill({
    required this.confidence,
    required this.requiresReview,
  });

  final double confidence;
  final bool requiresReview;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: requiresReview ? palette.warningBg : palette.successBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '${(confidence * 100).toStringAsFixed(1)}%',
        style: TextStyle(
          color: requiresReview ? palette.warningText : palette.successText,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

String _formatTimestamp(DateTime dateTime) {
  final local = dateTime.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final suffix = local.hour >= 12 ? 'PM' : 'AM';
  return '${local.day}/${local.month}/${local.year} - $hour:$minute $suffix';
}
