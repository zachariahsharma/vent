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
          displaySmall: GoogleFonts.dmSerifDisplay(
            fontSize: 28,
            color: palette.ink,
          ),
          headlineMedium: GoogleFonts.dmSerifDisplay(
            fontSize: 24,
            color: palette.ink,
          ),
        ),
      ),
      home: const LoginPage(),
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
                color: palette.glacier.withOpacity(0.6),
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
                color: palette.icyBlue.withOpacity(0.3),
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

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Scaffold(
      body: VynteBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Center(
                child: Image.asset(
                  'compoundlogo.png',
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text('Welcome back', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'Control the comfort in every room.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: palette.coolGray),
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
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomeShell()),
                          );
                        },
                        child: const Text('Log in'),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: palette.coolGray),
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

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    return Scaffold(
      body: VynteBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Center(
                child: Image.asset(
                  'compoundlogo.png',
                  height: 56,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text('Create your account',
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'Set up Vynte once and enjoy room-by-room comfort.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: palette.coolGray),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomeShell()),
                          );
                        },
                        child: const Text('Create account'),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to login'),
              ),
            ],
          ),
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

  final pages = const [
    DashboardPage(),
    DevicesPage(),
    ComfortPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sensors_outlined), label: 'Devices'),
          NavigationDestination(icon: Icon(Icons.timeline_outlined), label: 'Comfort'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const palette = VyntePalette();
    final rooms = [
      RoomData('Living Room', 72, 45, 0.65),
      RoomData('Primary Suite', 70, 40, 0.4),
      RoomData('Nursery', 69, 50, 0.8),
    ];

    return VynteBackground(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Image.asset(
                'solologo.tif.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Text('Vynte', style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Cozy airflow for every room.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 20),
          _ActionRow(
            actions: [
              _QuickAction(
                label: 'Add room',
                icon: Icons.add_home_outlined,
                onTap: () {},
              ),
              _QuickAction(
                label: 'Add vent',
                icon: Icons.air_outlined,
                onTap: () {},
              ),
              _QuickAction(
                label: 'Add puck',
                icon: Icons.thermostat_outlined,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Your rooms', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...rooms.map(
            (room) => _RoomCard(
              room: room,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => RoomDetailPage(room: room)),
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
  const RoomDetailPage({super.key, required this.room});

  final RoomData room;

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
                Text(room.name, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 12),
            _FrostedCard(
              child: Column(
                children: [
                  Text('${room.temperature}°F',
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    'Current temperature',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: palette.coolGray),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vent open',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: palette.coolGray),
                      ),
                      Text('${(room.ventOpen * 100).round()}%',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  Slider(
                    value: room.ventOpen,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Schedule', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Keep things comfortable throughout the day.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: palette.coolGray),
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
                Text('Schedule', style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$roomName comfort plan',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: palette.coolGray),
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

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

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
            'Vents and temperature pucks connected to your home.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: palette.coolGray),
          ),
          const SizedBox(height: 20),
          _FrostedCard(
            child: Column(
              children: const [
                _DeviceTile(
                  icon: Icons.air_outlined,
                  title: 'Vynte Vent - Living Room',
                  subtitle: 'Online · Battery 88%',
                ),
                Divider(height: 24),
                _DeviceTile(
                  icon: Icons.air_outlined,
                  title: 'Vynte Vent - Primary Suite',
                  subtitle: 'Online · Battery 76%',
                ),
                Divider(height: 24),
                _DeviceTile(
                  icon: Icons.thermostat_outlined,
                  title: 'Temp Puck - Nursery',
                  subtitle: 'Online · Last sync 3 min ago',
                ),
              ],
            ),
          ),
        ],
      ),
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: palette.coolGray),
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
  const SettingsPage({super.key});

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
            'Tailor your Vynte experience.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: palette.coolGray),
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.glacier.withOpacity(0.4),
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
                color: palette.glacier.withOpacity(0.4),
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
              color: palette.glacier.withOpacity(0.4),
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
                color: palette.icyBlue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.home_outlined, color: palette.deepBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${room.temperature}°F · ${room.humidity}% humidity',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: palette.coolGray),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text('${(room.ventOpen * 100).round()}%',
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  'open',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: palette.coolGray),
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
            color: palette.icyBlue.withOpacity(0.3),
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
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: palette.coolGray),
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
            color: palette.glacier.withOpacity(0.6),
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
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: palette.coolGray),
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
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: palette.coolGray),
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
              color: palette.glacier.withOpacity(0.6),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: palette.coolGray),
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
  RoomData(this.name, this.temperature, this.humidity, this.ventOpen);

  final String name;
  final int temperature;
  final int humidity;
  final double ventOpen;
}
