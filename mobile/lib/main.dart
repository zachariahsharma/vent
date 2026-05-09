import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: palette.frost,
        colorScheme: ColorScheme.fromSeed(
          seedColor: palette.deepBlue,
          primary: palette.deepBlue,
          secondary: palette.icyBlue,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: palette.ink,
        ),
        textTheme: textTheme.copyWith(
          displaySmall: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: palette.ink,
          ),
          headlineMedium: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: palette.ink,
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Center(child: VynteLogoLockup(size: 96))),
    );
  }
}

class VynteLogoLockup extends StatelessWidget {
  const VynteLogoLockup({super.key, this.size = 48, this.dark = true});

  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : const VyntePalette().ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('vynte_logo.png', height: size, fit: BoxFit.contain),
        SizedBox(width: size * 0.16),
        Text(
          'VYNTE',
          style: GoogleFonts.montserrat(
            fontSize: size * 0.54,
            fontWeight: FontWeight.w800,
            letterSpacing: size * 0.015,
            height: 0.95,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class VyntePalette {
  const VyntePalette();

  final Color deepBlue = const Color(0xFF2C6BB5);
  final Color icyBlue = const Color(0xFF8FD3FE);
  final Color frost = const Color(0xFFF4FAFF);
  final Color mist = const Color(0xFFE3F1FF);
  final Color glacier = const Color(0xFFCCE9FF);
  final Color ink = const Color(0xFF1E2A3A);
  final Color coolGray = const Color(0xFF6D7C8B);
}

class VynteBackground extends StatelessWidget {
  const VynteBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [palette.frost, palette.mist],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: palette.glacier.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: palette.icyBlue.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
  }

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Scaffold(
      body: VynteBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 6),
            const Center(child: VynteLogoLockup(size: 56, dark: false)),
            const SizedBox(height: 16),
            Text(
              'Welcome back',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Control the comfort in every room.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
            ),
            const SizedBox(height: 28),
            _FrostedCard(
              child: Column(
                children: [
                  _VynteField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 16),
                  _VynteField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _logIn,
                      child: const Text('Log in'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  double _strengthFor(String value) {
    var score = 0;
    if (value.length >= 8) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(value)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(value)) score += 1;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score += 1;
    return score / 4;
  }

  Color _strengthColor(double value) {
    const palette = VyntePalette();
    if (value >= 0.75) return palette.deepBlue;
    if (value >= 0.5) return palette.icyBlue;
    return palette.coolGray;
  }

  String _strengthLabel(double value) {
    if (value >= 0.75) return 'Strong';
    if (value >= 0.5) return 'Good';
    if (value >= 0.25) return 'Weak';
    return 'Very weak';
  }

  void _createAccount() {
    final password = passwordController.text;
    if (password != confirmController.text) {
      setState(() => errorText = 'Passwords do not match.');
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Scaffold(
      body: VynteBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 6),
            const Center(child: VynteLogoLockup(size: 52, dark: false)),
            const SizedBox(height: 16),
            Text(
              'Create your account',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Set up VYNTE once and enjoy room-by-room comfort.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
            ),
            const SizedBox(height: 24),
            _FrostedCard(
              child: Column(
                children: [
                  _VynteField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 16),
                  _VynteField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: passwordController,
                    builder: (context, value, _) {
                      final strength = _strengthFor(value.text);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: strength,
                            minHeight: 8,
                            color: _strengthColor(strength),
                            backgroundColor: palette.glacier,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Password strength: ${_strengthLabel(strength)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: palette.coolGray),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _VynteField(
                    controller: confirmController,
                    label: 'Confirm password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _createAccount,
                      child: const Text('Create account'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final List<RoomData> _rooms = [];
  final List<VentDevice> _vents = [];

  Future<RoomData?> _addRoom() async {
    final room = await showModalBottomSheet<RoomData>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddRoomSheet(),
    );

    if (room == null || !mounted) {
      return null;
    }

    setState(() => _rooms.add(room));
    return room;
  }

  void _deleteRoom(RoomData room) {
    setState(() {
      for (final vent in room.vents) {
        vent.roomName = null;
      }
      _rooms.remove(room);
    });
  }

  Future<void> _pairVent() async {
    final result = await Navigator.of(context).push<PairingResult>(
      MaterialPageRoute(builder: (_) => const PairVentPage()),
    );

    if (result == null || !mounted) {
      return;
    }

    final assignment = await Navigator.of(context).push<RoomData>(
      MaterialPageRoute(
        builder: (_) => AssignVentRoomPage(
          rooms: _rooms,
          onCreateRoom: _addRoom,
          ventIpAddress: result.ipAddress,
        ),
      ),
    );

    if (assignment == null || !mounted) {
      return;
    }

    final vent = VentDevice(
      id: result.ipAddress,
      name: result.usesSetupWifi ? 'VYNTE Vent (Debug)' : 'VYNTE Vent',
      ipAddress: result.ipAddress,
      baseUrl: result.baseUrl,
      roomName: assignment.name,
      usesSetupWifi: result.usesSetupWifi,
    );

    setState(() {
      _vents.removeWhere((existing) => existing.id == vent.id);
      for (final room in _rooms) {
        room.vents.removeWhere((existing) => existing.id == vent.id);
      }
      _vents.add(vent);
      assignment.vents.add(vent);
      _index = 1;
    });
  }

  Future<void> _setVentOpen(VentDevice vent, double value) async {
    setState(() {
      vent.ventOpen = value;
      vent.pendingVentOpen = value;
    });

    if (!vent.isSyncing) {
      unawaited(_flushVentOpenQueue(vent));
    }
  }

  Future<void> _flushVentOpenQueue(VentDevice vent) async {
    setState(() => vent.isSyncing = true);

    while (mounted && vent.pendingVentOpen != null) {
      final value = vent.pendingVentOpen!;
      vent.pendingVentOpen = null;

      try {
        await VynteDeviceApi(vent.baseUrl).setVentOpen((value * 100).round());
        vent.syncNoticeShown = false;
      } catch (_) {
        if (!mounted) {
          return;
        }

        if (vent.pendingVentOpen == null) {
          setState(() => vent.pendingVentOpen = value);
        }
        if (!vent.syncNoticeShown) {
          vent.syncNoticeShown = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${vent.name} will sync when reachable.')),
          );
        }
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }

    if (mounted) {
      setState(() => vent.isSyncing = false);
    }
  }

  void _logOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        rooms: _rooms,
        onAddRoom: _addRoom,
        onAddVent: _pairVent,
        onDeleteRoom: _deleteRoom,
        onSetVentOpen: _setVentOpen,
      ),
      DevicesPage(
        vents: _vents,
        onAddVent: _pairVent,
        onSetVentOpen: _setVentOpen,
      ),
      const ComfortPage(),
      SettingsPage(onLogout: _logOut),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.sensors_outlined),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            label: 'Comfort',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.rooms,
    required this.onAddRoom,
    required this.onAddVent,
    required this.onDeleteRoom,
    required this.onSetVentOpen,
  });

  final List<RoomData> rooms;
  final VoidCallback onAddRoom;
  final VoidCallback onAddVent;
  final ValueChanged<RoomData> onDeleteRoom;
  final Future<void> Function(VentDevice vent, double value) onSetVentOpen;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();

    return VynteBackground(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(children: [const VynteLogoLockup(size: 36, dark: false)]),
          const SizedBox(height: 8),
          Text(
            'Cozy airflow for every room.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 20),
          _ActionRow(
            actions: [
              _QuickAction(
                label: 'Add room',
                icon: Icons.add_home_outlined,
                onTap: onAddRoom,
              ),
              _QuickAction(
                label: 'Add vent',
                icon: Icons.air_outlined,
                onTap: onAddVent,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Your rooms', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          if (rooms.isEmpty)
            _FrostedCard(
              child: Column(
                children: [
                  Icon(
                    Icons.add_home_outlined,
                    size: 44,
                    color: palette.deepBlue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No rooms yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add a room to start grouping vents and schedules.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                ],
              ),
            )
          else
            ...rooms.map(
              (room) => _RoomCard(
                room: room,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RoomDetailPage(
                        room: room,
                        onDelete: () => onDeleteRoom(room),
                        onSetVentOpen: onSetVentOpen,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class RoomDetailPage extends StatelessWidget {
  const RoomDetailPage({
    super.key,
    required this.room,
    required this.onDelete,
    required this.onSetVentOpen,
  });

  final RoomData room;
  final VoidCallback onDelete;
  final Future<void> Function(VentDevice vent, double value) onSetVentOpen;

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${room.name}?'),
        content: const Text('This removes the room from your VYNTE dashboard.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    onDelete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Scaffold(
      body: VynteBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  room.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FrostedCard(
              child: Column(
                children: [
                  Text(
                    '${room.temperature}°F',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    'Current temperature',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vent open',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.coolGray,
                        ),
                      ),
                      Text(
                        '${(room.ventOpen * 100).round()}%',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  if (room.vents.isEmpty)
                    Text(
                      'No vent assigned to this room yet.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                    )
                  else
                    ...room.vents.map(
                      (vent) => _VentControl(
                        vent: vent,
                        onChanged: (value) => onSetVentOpen(vent, value),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep things comfortable throughout the day.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SchedulePage(roomName: room.name),
                          ),
                        );
                      },
                      child: const Text('Edit schedule'),
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete room'),
            ),
          ],
        ),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key, required this.roomName});

  final String roomName;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    final schedule = [
      _ScheduleBlock('Wake up', '6:30 AM', '71°F'),
      _ScheduleBlock('Midday', '12:00 PM', '69°F'),
      _ScheduleBlock('Evening', '6:00 PM', '72°F'),
      _ScheduleBlock('Sleep', '10:30 PM', '68°F'),
    ];

    return Scaffold(
      body: VynteBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$roomName comfort plan',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
            ),
            const SizedBox(height: 16),
            ...schedule,
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add schedule block'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRoomSheet extends StatefulWidget {
  const AddRoomSheet({super.key});

  @override
  State<AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends State<AddRoomSheet> {
  final nameController = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      setState(() => errorText = 'Enter a room name.');
      return;
    }

    Navigator.of(context).pop(RoomData(name, 72, 45));
  }

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add room', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Name the room where your VYNTE devices will live.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Room name',
              prefixIcon: const Icon(Icons.home_outlined),
              errorText: errorText,
              filled: true,
              fillColor: palette.frost,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: palette.glacier),
              ),
            ),
            onSubmitted: (_) => _save(),
            onChanged: (_) {
              if (errorText != null) {
                setState(() => errorText = null);
              }
            },
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.add_home_outlined),
              label: const Text('Add room'),
            ),
          ),
        ],
      ),
    );
  }
}

class PairVentPage extends StatefulWidget {
  const PairVentPage({super.key});

  @override
  State<PairVentPage> createState() => _PairVentPageState();
}

class _PairVentPageState extends State<PairVentPage>
    with WidgetsBindingObserver {
  static const setupBaseUrl = 'http://192.168.4.1';
  static const setupSsid = 'Vynte';
  static const setupPassword = 'vynte1234';

  final passwordController = TextEditingController();
  final manualSsidController = TextEditingController();
  final setupApi = VynteDeviceApi(setupBaseUrl);

  List<WifiNetwork> networks = [];
  WifiNetwork? selectedNetwork;
  bool checkingDevice = false;
  bool loadingNetworks = false;
  bool provisioning = false;
  bool deviceReachable = false;
  String? message;
  String? pairedIpAddress;

  void _log(String message) {
    debugPrint('[VYNTE pairing] $message');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkDevice();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    passwordController.dispose();
    manualSsidController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDevice();
    }
  }

  Future<void> _checkDevice() async {
    _log('checkDevice start');
    setState(() {
      checkingDevice = true;
      message = null;
    });

    try {
      final status = await setupApi.statusWithRetry();
      _log(
        'checkDevice success connected=${status.connected} staIp=${status.stationIp} provisioning=${status.provisioning} error=${status.provisionError}',
      );
      if (!mounted) {
        return;
      }

      setState(() {
        deviceReachable = true;
        pairedIpAddress = status.stationIp.isEmpty ? null : status.stationIp;
        message = 'Connected to the VYNTE setup network.';
      });
    } catch (error, stackTrace) {
      _log('checkDevice failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await _printDeviceDebugLog('checkDevice failure');
      if (!mounted) {
        return;
      }

      setState(() {
        deviceReachable = false;
        message =
            'Connect this iPhone to the "$setupSsid" Wi-Fi network, then return here.';
      });
    } finally {
      if (mounted) {
        setState(() => checkingDevice = false);
      }
    }
  }

  Future<void> _loadNetworks() async {
    _log('loadNetworks start');
    setState(() {
      loadingNetworks = true;
      message = null;
    });

    try {
      final foundNetworks = await setupApi.networks();
      _log('loadNetworks success count=${foundNetworks.length}');
      if (!mounted) {
        return;
      }

      setState(() {
        networks = foundNetworks;
        selectedNetwork = foundNetworks.isEmpty ? null : foundNetworks.first;
        manualSsidController.text = selectedNetwork?.ssid ?? '';
      });
    } catch (error, stackTrace) {
      _log('loadNetworks failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await _printDeviceDebugLog('loadNetworks failure');
      if (!mounted) {
        return;
      }

      setState(() {
        message =
            'Could not scan from the vent. Make sure you are still on "$setupSsid".';
      });
    } finally {
      if (mounted) {
        setState(() => loadingNetworks = false);
      }
    }
  }

  Future<void> _provision() async {
    final ssid = (selectedNetwork?.ssid ?? manualSsidController.text).trim();
    if (ssid.isEmpty) {
      setState(() => message = 'Choose or enter your home Wi-Fi name.');
      return;
    }

    _log(
      'provision start ssid=$ssid passwordLength=${passwordController.text.length}',
    );
    setState(() {
      provisioning = true;
      message = 'Sending Wi-Fi details to the vent...';
    });

    try {
      final result = await setupApi.provision(
        ssid: ssid,
        password: passwordController.text,
      );
      _log(
        'provision response ok=${result.ok} pending=${result.pending} ip=${result.ipAddress} error=${result.error}',
      );
      await _printDeviceDebugLog('provision response');

      if (!mounted) {
        return;
      }

      if (!result.ok) {
        setState(() {
          message =
              result.error ?? 'The vent could not join that Wi-Fi network.';
        });
        return;
      }

      if (result.ipAddress.isNotEmpty) {
        setState(() {
          pairedIpAddress = result.ipAddress;
          message = 'Vent joined $ssid at ${result.ipAddress}.';
        });
        return;
      }

      setState(() {
        message = 'The vent is joining $ssid. Keep this screen open.';
      });
      await _waitForProvisioning(ssid);
    } catch (error, stackTrace) {
      _log('provision request failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await _printDeviceDebugLog('provision request failure');
      if (!mounted) {
        return;
      }

      setState(() {
        message =
            'The setup connection dropped while the vent was receiving Wi-Fi details. Waiting to see if it joins $ssid...';
      });
      await _waitForProvisioning(ssid);
    } finally {
      if (mounted) {
        setState(() => provisioning = false);
      }
    }
  }

  Future<void> _waitForProvisioning(String ssid) async {
    _log('waitForProvisioning start ssid=$ssid');
    for (var attempt = 0; attempt < 24; attempt++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) {
        return;
      }

      try {
        final status = await setupApi.statusWithRetry();
        _log(
          'wait attempt=${attempt + 1} connected=${status.connected} staIp=${status.stationIp} provisioning=${status.provisioning} error=${status.provisionError}',
        );
        if (!mounted) {
          return;
        }

        if (status.connected && status.stationIp.isNotEmpty) {
          setState(() {
            pairedIpAddress = status.stationIp;
            message = 'Vent joined $ssid at ${status.stationIp}.';
          });
          return;
        }

        if (!status.provisioning && status.provisionError.isNotEmpty) {
          setState(() {
            message =
                'The vent could not join $ssid. Check the Wi-Fi password and try again.';
          });
          return;
        }
      } catch (error) {
        _log('wait attempt=${attempt + 1} status failed: $error');
        await _printDeviceDebugLog('wait attempt ${attempt + 1} failure');
        if (!mounted) {
          return;
        }

        setState(() {
          message =
              'The vent is still joining Wi-Fi. If the phone left "$setupSsid", reconnect to it and wait here.';
        });
      }
    }

    if (!mounted || pairedIpAddress != null) {
      return;
    }

    await _printDeviceDebugLog('provision timeout');
    if (!mounted || pairedIpAddress != null) {
      return;
    }

    setState(() {
      message =
          'The vent did not report a home Wi-Fi IP yet. Reconnect to "$setupSsid", verify the password, and try again.';
    });
  }

  Future<void> _printDeviceDebugLog(String reason) async {
    try {
      final lines = await setupApi.debugLog();
      _log('device debug log for $reason (${lines.length} lines)');
      for (final line in lines) {
        debugPrint('[VYNTE device debug] $line');
      }
    } catch (debugError) {
      _log('device debug log unavailable for $reason: $debugError');
    }
  }

  void _finish() {
    final ip = pairedIpAddress;
    if (ip == null || ip.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(
      context,
    ).pop(PairingResult(ipAddress: ip, baseUrl: 'http://$ip'));
  }

  void _finishWithSetupWifi() {
    Navigator.of(context).pop(
      const PairingResult(
        ipAddress: '192.168.4.1',
        baseUrl: setupBaseUrl,
        usesSetupWifi: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    final canProvision = deviceReachable && !provisioning;

    return Scaffold(
      body: VynteBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    'Add VYNTE vent',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Connect to setup Wi-Fi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join "$setupSsid" in iOS Wi-Fi settings. Use password "$setupPassword", then come back to VYNTE.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: checkingDevice ? null : _checkDevice,
                      icon: checkingDevice
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_find),
                      label: const Text('I am connected to Vynte'),
                    ),
                  ),
                  if (deviceReachable) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _finishWithSetupWifi,
                        icon: const Icon(Icons.bug_report_outlined),
                        label: const Text('Debug: control on Vynte Wi-Fi'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2. Choose home Wi-Fi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The vent scans nearby networks and receives the password locally over its setup Wi-Fi.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: deviceReachable && !loadingNetworks
                          ? _loadNetworks
                          : null,
                      icon: loadingNetworks
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: const Text('Scan Wi-Fi networks'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (networks.isNotEmpty)
                    DropdownButtonFormField<WifiNetwork>(
                      initialValue: selectedNetwork,
                      decoration: const InputDecoration(
                        labelText: 'Home Wi-Fi',
                        prefixIcon: Icon(Icons.wifi),
                      ),
                      items: networks
                          .map(
                            (network) => DropdownMenuItem(
                              value: network,
                              child: Text(
                                '${network.ssid} (${network.rssi} dBm)',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (network) {
                        setState(() {
                          selectedNetwork = network;
                          manualSsidController.text = network?.ssid ?? '';
                        });
                      },
                    )
                  else
                    _VynteField(
                      controller: manualSsidController,
                      label: 'Home Wi-Fi name',
                      icon: Icons.wifi,
                    ),
                  const SizedBox(height: 16),
                  _VynteField(
                    controller: passwordController,
                    label: 'Home Wi-Fi password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: canProvision ? _provision : null,
                      icon: provisioning
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.router_outlined),
                      label: const Text('Connect vent to home Wi-Fi'),
                    ),
                  ),
                ],
              ),
            ),
            if (message != null)
              _FrostedCard(
                child: Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (pairedIpAddress != null)
              FilledButton(
                onPressed: _finish,
                child: const Text('Finish setup'),
              ),
          ],
        ),
      ),
    );
  }
}

class VynteDeviceApi {
  VynteDeviceApi(this.baseUrl);

  final String baseUrl;

  void _log(String message) {
    debugPrint('[VYNTE device API] $message');
  }

  Future<DeviceStatus> status() async {
    final data = await _getJson('/api/status');
    return DeviceStatus.fromJson(data);
  }

  Future<DeviceStatus> statusWithRetry() async {
    Object? lastError;

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        _log('statusWithRetry attempt=${attempt + 1}');
        return await status();
      } catch (error) {
        _log('statusWithRetry attempt=${attempt + 1} failed: $error');
        lastError = error;
        if (attempt < 2) {
          await Future<void>.delayed(const Duration(milliseconds: 450));
        }
      }
    }

    throw lastError ?? const SocketException('Unable to reach VYNTE setup AP');
  }

  Future<List<WifiNetwork>> networks() async {
    final data = await _getJson(
      '/api/networks',
      timeout: const Duration(seconds: 20),
    );
    final rawNetworks = data['networks'];
    if (rawNetworks is! List) {
      return [];
    }

    final seen = <String>{};
    return rawNetworks
        .whereType<Map<String, dynamic>>()
        .map(WifiNetwork.fromJson)
        .where((network) => network.ssid.isNotEmpty && seen.add(network.ssid))
        .toList()
      ..sort((a, b) => b.rssi.compareTo(a.rssi));
  }

  Future<ProvisionResult> provision({
    required String ssid,
    required String password,
  }) async {
    final data = await _postForm('/api/provision', {
      'ssid': ssid,
      'password': password,
    }, timeout: const Duration(seconds: 22));
    return ProvisionResult.fromJson(data);
  }

  Future<DeviceStatus> setVentOpen(int percent) async {
    final data = await _postForm('/api/vent', {'open': '$percent'});
    return DeviceStatus.fromJson(data);
  }

  Future<List<String>> debugLog() async {
    final data = await _getJson(
      '/api/debug',
      timeout: const Duration(seconds: 3),
    );
    final rawLog = data['log'];
    if (rawLog is! List) {
      return const [];
    }
    return rawLog.whereType<String>().toList(growable: false);
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final uri = Uri.parse('$baseUrl$path');
      _log('GET $uri');
      final request = await client.getUrl(uri).timeout(timeout);
      final response = await request.close().timeout(timeout);
      final data = await _decodeResponse(response);
      _log('GET $uri ok keys=${data.keys.join(",")}');
      return data;
    } catch (error) {
      _log('GET $baseUrl$path failed: $error');
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> _postForm(
    String path,
    Map<String, String> fields, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final uri = Uri.parse('$baseUrl$path');
      final body = fields.entries
          .map(
            (entry) =>
                '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}',
          )
          .join('&');
      final bodyBytes = utf8.encode(body);
      final request = await client.postUrl(uri).timeout(timeout);
      _log(
        'POST $uri fields=${fields.keys.join(",")} bodyLength=${body.length}',
      );
      request.persistentConnection = false;
      request.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
      );
      request.headers.set(HttpHeaders.connectionHeader, 'close');
      request.contentLength = bodyBytes.length;
      request.add(bodyBytes);
      final response = await request.close().timeout(timeout);
      final data = await _decodeResponse(response);
      _log('POST $uri ok keys=${data.keys.join(",")}');
      return data;
    } catch (error) {
      _log('POST $baseUrl$path failed: $error');
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> _decodeResponse(
    HttpClientResponse response,
  ) async {
    if (response.statusCode >= 400) {
      throw HttpException(
        'Device returned HTTP ${response.statusCode}',
        uri: response.redirects.isNotEmpty
            ? response.redirects.last.location
            : null,
      );
    }

    final body = await response.transform(utf8.decoder).join();
    debugPrint(
      '[VYNTE device API] response status=${response.statusCode} length=${body.length}',
    );
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw const FormatException('Expected JSON object');
  }
}

class WifiNetwork {
  const WifiNetwork({
    required this.ssid,
    required this.rssi,
    required this.secure,
  });

  factory WifiNetwork.fromJson(Map<String, dynamic> json) {
    return WifiNetwork(
      ssid: json['ssid'] as String? ?? '',
      rssi: json['rssi'] as int? ?? -100,
      secure: json['secure'] as bool? ?? true,
    );
  }

  final String ssid;
  final int rssi;
  final bool secure;
}

class DeviceStatus {
  const DeviceStatus({
    required this.connected,
    required this.stationIp,
    required this.ventOpen,
    required this.provisioning,
    required this.provisionError,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      connected: json['connected'] as bool? ?? false,
      stationIp: json['staIp'] as String? ?? '',
      ventOpen: json['ventOpen'] as int? ?? 0,
      provisioning: json['provisioning'] as bool? ?? false,
      provisionError: json['provisionError'] as String? ?? '',
    );
  }

  final bool connected;
  final String stationIp;
  final int ventOpen;
  final bool provisioning;
  final String provisionError;
}

class ProvisionResult {
  const ProvisionResult({
    required this.ok,
    required this.ipAddress,
    required this.pending,
    this.error,
  });

  factory ProvisionResult.fromJson(Map<String, dynamic> json) {
    return ProvisionResult(
      ok: json['ok'] as bool? ?? false,
      ipAddress: json['staIp'] as String? ?? '',
      pending: json['pending'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }

  final bool ok;
  final String ipAddress;
  final bool pending;
  final String? error;
}

class PairingResult {
  const PairingResult({
    required this.ipAddress,
    required this.baseUrl,
    this.usesSetupWifi = false,
  });

  final String ipAddress;
  final String baseUrl;
  final bool usesSetupWifi;
}

class DevicesPage extends StatelessWidget {
  const DevicesPage({
    super.key,
    required this.vents,
    required this.onAddVent,
    required this.onSetVentOpen,
  });

  final List<VentDevice> vents;
  final VoidCallback onAddVent;
  final Future<void> Function(VentDevice vent, double value) onSetVentOpen;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return VynteBackground(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Devices', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            'Vents connected to your home.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAddVent,
            icon: const Icon(Icons.add),
            label: const Text('Add vent'),
          ),
          const SizedBox(height: 16),
          if (vents.isEmpty)
            _FrostedCard(
              child: Column(
                children: [
                  Icon(Icons.air_outlined, size: 44, color: palette.deepBlue),
                  const SizedBox(height: 10),
                  Text(
                    'No devices yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pair a VYNTE vent to start controlling airflow.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                ],
              ),
            )
          else
            ...vents.map(
              (vent) => _FrostedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DeviceTile(
                      icon: Icons.air_outlined,
                      title: vent.name,
                      subtitle:
                          '${vent.roomName ?? 'Unassigned'} · ${vent.usesSetupWifi ? 'Vynte Wi-Fi' : vent.ipAddress}',
                    ),
                    const SizedBox(height: 16),
                    _VentControl(
                      vent: vent,
                      onChanged: (value) => onSetVentOpen(vent, value),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AssignVentRoomPage extends StatefulWidget {
  const AssignVentRoomPage({
    super.key,
    required this.rooms,
    required this.onCreateRoom,
    required this.ventIpAddress,
  });

  final List<RoomData> rooms;
  final Future<RoomData?> Function() onCreateRoom;
  final String ventIpAddress;

  @override
  State<AssignVentRoomPage> createState() => _AssignVentRoomPageState();
}

class _AssignVentRoomPageState extends State<AssignVentRoomPage> {
  RoomData? selectedRoom;

  Future<void> _createRoom() async {
    final room = await widget.onCreateRoom();
    if (room == null || !mounted) {
      return;
    }

    setState(() => selectedRoom = room);
  }

  void _finish() {
    final room = selectedRoom;
    if (room == null) {
      return;
    }

    Navigator.of(context).pop(room);
  }

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    final rooms = widget.rooms;

    return Scaffold(
      body: VynteBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    'Assign vent',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FrostedCard(
              child: _DeviceTile(
                icon: Icons.air_outlined,
                title: 'VYNTE Vent',
                subtitle: 'Connected at ${widget.ventIpAddress}',
              ),
            ),
            _FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a room',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Assign this vent so it appears in the right room controls.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                  ),
                  const SizedBox(height: 16),
                  if (rooms.isEmpty)
                    Text(
                      'Create a room to continue.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
                    )
                  else
                    DropdownButtonFormField<RoomData>(
                      initialValue: selectedRoom,
                      decoration: const InputDecoration(
                        labelText: 'Room',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                      items: rooms
                          .map(
                            (room) => DropdownMenuItem(
                              value: room,
                              child: Text(room.name),
                            ),
                          )
                          .toList(),
                      onChanged: (room) => setState(() => selectedRoom = room),
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _createRoom,
                      icon: const Icon(Icons.add_home_outlined),
                      label: const Text('Create new room'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: selectedRoom == null ? null : _finish,
                      icon: const Icon(Icons.check),
                      label: const Text('Finish setup'),
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

class _VentControl extends StatefulWidget {
  const _VentControl({required this.vent, required this.onChanged});

  final VentDevice vent;
  final ValueChanged<double> onChanged;

  @override
  State<_VentControl> createState() => _VentControlState();
}

class _VentControlState extends State<_VentControl> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.vent.ventOpen;
  }

  @override
  void didUpdateWidget(covariant _VentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vent.id != widget.vent.id) {
      value = widget.vent.ventOpen;
    }
  }

  void _change(double nextValue) {
    setState(() => value = nextValue);
    widget.vent.ventOpen = nextValue;
    widget.onChanged(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Vent fins', style: Theme.of(context).textTheme.titleMedium),
            Text(
              widget.vent.isSyncing
                  ? '${(value * 100).round()}% open · syncing'
                  : '${(value * 100).round()}% open',
            ),
          ],
        ),
        Slider(value: value, onChanged: _change),
      ],
    );
  }
}

class ComfortPage extends StatelessWidget {
  const ComfortPage({super.key});

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return VynteBackground(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Comfort', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            'Quick scenes for cozy airflow.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 20),
          _FrostedCard(
            child: Column(
              children: [
                _SceneTile(
                  title: 'Cozy Evening',
                  subtitle: '72°F · 40% open',
                  icon: Icons.local_fire_department_outlined,
                ),
                const Divider(height: 24),
                _SceneTile(
                  title: 'Fresh Morning',
                  subtitle: '70°F · 60% open',
                  icon: Icons.wb_sunny_outlined,
                ),
                const Divider(height: 24),
                _SceneTile(
                  title: 'Quiet Sleep',
                  subtitle: '68°F · 30% open',
                  icon: Icons.bedtime_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return VynteBackground(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Settings', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            'Tailor your VYNTE experience.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 20),
          _FrostedCard(
            child: Column(
              children: const [
                _SettingToggle(
                  title: 'Auto-balance rooms',
                  subtitle: 'Adjust vents to match target temps',
                  value: true,
                ),
                Divider(height: 24),
                _SettingToggle(
                  title: 'Smart notifications',
                  subtitle: 'Get alerts when rooms drift',
                  value: true,
                ),
                Divider(height: 24),
                _SettingToggle(
                  title: 'Eco mode',
                  subtitle: 'Save energy during low use',
                  value: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Units', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  children: [
                    ChoiceChip(label: Text('Fahrenheit'), selected: true),
                    ChoiceChip(label: Text('Celsius'), selected: false),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Back to login'),
          ),
        ],
      ),
    );
  }
}

class _FrostedCard extends StatelessWidget {
  const _FrostedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.glacier.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _VynteField extends StatelessWidget {
  const _VynteField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: palette.frost,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.glacier),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.actions});

  final List<_QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions,
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: palette.glacier.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: palette.deepBlue),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.onTap});

  final RoomData room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: palette.glacier.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: palette.icyBlue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.home_outlined, color: palette.deepBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room.temperature}°F · ${room.humidity}% humidity',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.coolGray),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${(room.ventOpen * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'open',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.coolGray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: palette.icyBlue.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: palette.deepBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.coolGray),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SceneTile extends StatelessWidget {
  const _SceneTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: palette.glacier.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: palette.deepBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.coolGray),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title;
  final String subtitle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.coolGray),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: (_) {}),
      ],
    );
  }
}

class _ScheduleBlock extends StatelessWidget {
  const _ScheduleBlock(this.title, this.time, this.temp);

  final String title;
  final String time;
  final String temp;

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return _FrostedCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.glacier.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.schedule, color: palette.deepBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  time,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.coolGray),
                ),
              ],
            ),
          ),
          Text(temp, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class RoomData {
  RoomData(this.name, this.temperature, this.humidity);

  final String name;
  final int temperature;
  final int humidity;
  final List<VentDevice> vents = [];

  double get ventOpen {
    if (vents.isEmpty) {
      return 0;
    }

    final total = vents.fold<double>(0, (sum, vent) => sum + vent.ventOpen);
    return total / vents.length;
  }
}

class VentDevice {
  VentDevice({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.baseUrl,
    required this.roomName,
    this.usesSetupWifi = false,
    this.ventOpen = 1,
    this.isSyncing = false,
    this.syncNoticeShown = false,
  });

  final String id;
  final String name;
  final String ipAddress;
  final String baseUrl;
  final bool usesSetupWifi;
  String? roomName;
  double ventOpen;
  double? pendingVentOpen;
  bool isSyncing;
  bool syncNoticeShown;
}
