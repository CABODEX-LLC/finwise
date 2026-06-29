import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const FinWiseApp());

class FinWiseApp extends StatelessWidget {
  const FinWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(primary: AppColors.lime, surface: AppColors.surface),
        fontFamily: 'Roboto',
      ),
      home: const RootScreen(),
    );
  }
}

class AppColors {
  static const bg = Color(0xFF0D1014);
  static const surface = Color(0xFF161A20);
  static const surface2 = Color(0xFF1E242C);
  static const lime = Color(0xFFC8FF3C);
  static const blue = Color(0xFF5B8DEF);
  static const coral = Color(0xFFFF6B5E);
  static const amber = Color(0xFFFFC24B);
  static const violet = Color(0xFF8E7BEF);
  static const text = Color(0xFFF4F6F8);
  static const muted = Color(0xFF8B92A0);
}

class Category {
  final String name;
  final double value;
  final Color color;
  final IconData icon;
  const Category(this.name, this.value, this.color, this.icon);
}

const _categories = [
  Category('Shopping', 420, AppColors.lime, Icons.shopping_bag_outlined),
  Category('Food', 280, AppColors.coral, Icons.restaurant),
  Category('Transport', 160, AppColors.blue, Icons.directions_car_outlined),
  Category('Bills', 240, AppColors.amber, Icons.receipt_long),
];

class Txn {
  final String name, time;
  final double amount;
  final Color color;
  final IconData icon;
  const Txn(this.name, this.time, this.amount, this.color, this.icon);
}

const _txns = [
  Txn('Spotify', 'Today · 09:24', -9.99, AppColors.violet, Icons.music_note),
  Txn('Salary', 'Yesterday', 2400.00, AppColors.lime, Icons.account_balance),
  Txn('Whole Foods', 'Yesterday', -64.20, AppColors.coral, Icons.restaurant),
  Txn('Uber', 'Mon · 18:10', -14.50, AppColors.blue, Icons.directions_car_outlined),
];

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;
  final _pages = const [DashboardPage(), _ComingSoon(icon: Icons.bar_chart, title: 'Stats', subtitle: 'Spending trends and monthly insights.'), _ComingSoon(icon: Icons.credit_card, title: 'Cards', subtitle: 'Manage your linked cards and budgets.'), _ComingSoon(icon: Icons.person, title: 'Profile', subtitle: 'Account, security and preferences.')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.lime,
              child: const Icon(Icons.add, color: AppColors.bg),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: Color(0xFF232A33))),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.lime.withValues(alpha: 0.16),
            labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11, color: AppColors.muted)),
          ),
          child: NavigationBar(
            height: 64,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined, color: AppColors.muted), selectedIcon: Icon(Icons.home, color: AppColors.lime), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.bar_chart_outlined, color: AppColors.muted), selectedIcon: Icon(Icons.bar_chart, color: AppColors.lime), label: 'Stats'),
              NavigationDestination(icon: Icon(Icons.credit_card_outlined, color: AppColors.muted), selectedIcon: Icon(Icons.credit_card, color: AppColors.lime), label: 'Cards'),
              NavigationDestination(icon: Icon(Icons.person_outline, color: AppColors.muted), selectedIcon: Icon(Icons.person, color: AppColors.lime), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final total = _categories.fold<double>(0, (s, c) => s + c.value);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Welcome back,', style: TextStyle(color: AppColors.muted, fontSize: 14)),
                  Text('FinWise', style: TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const Icon(Icons.notifications_none, color: AppColors.text),
          ],
        ),
        const SizedBox(height: 20),
        _BalanceCard(),
        const SizedBox(height: 24),
        const Text('Spending breakdown', style: TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        _SpendingCard(total: total),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Recent transactions', style: TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.w700)),
            Text('See all', style: TextStyle(color: AppColors.lime, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        ..._txns.map((t) => _TxnTile(txn: t)),
        const SizedBox(height: 28),
        const _BrandFooter(),
      ],
    );
  }
}

class _BrandFooter extends StatelessWidget {
  const _BrandFooter();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(children: const [
          TextSpan(text: 'Crafted by ', style: TextStyle(color: AppColors.muted, fontSize: 12)),
          TextSpan(text: 'Cabodex', style: TextStyle(color: AppColors.lime, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [Color(0xFF26331A), Color(0xFF12161B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: AppColors.lime.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total balance', style: TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 6),
          const Text('\$12,480.50', style: TextStyle(color: AppColors.text, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(child: _MoneyPill(icon: Icons.arrow_downward, label: 'Income', value: '\$3,200', color: AppColors.lime)),
              SizedBox(width: 12),
              Expanded(child: _MoneyPill(icon: Icons.arrow_upward, label: 'Expense', value: '\$1,100', color: AppColors.coral)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoneyPill extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _MoneyPill({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.bg.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            height: 32, width: 32,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              Text(value, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpendingCard extends StatelessWidget {
  final double total;
  const _SpendingCard({required this.total});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF232A33)),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 120, width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: const Size(120, 120), painter: _DonutPainter(_categories)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 18)),
                    const Text('spent', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              children: _categories.map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(height: 10, width: 10, decoration: BoxDecoration(color: c.color, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(c.name, style: const TextStyle(color: AppColors.text, fontSize: 13))),
                      Text('\$${c.value.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.muted, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<Category> cats;
  _DonutPainter(this.cats);
  @override
  void paint(Canvas canvas, Size size) {
    final total = cats.fold<double>(0, (s, c) => s + c.value);
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 9;
    var start = -math.pi / 2;
    for (final c in cats) {
      final sweep = 2 * math.pi * (c.value / total) - 0.06;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..color = c.color;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, false, paint);
      start += 2 * math.pi * (c.value / total);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => false;
}

class _TxnTile extends StatelessWidget {
  final Txn txn;
  const _TxnTile({required this.txn});
  @override
  Widget build(BuildContext context) {
    final positive = txn.amount >= 0;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A33)),
      ),
      child: Row(
        children: [
          Container(
            height: 42, width: 42,
            decoration: BoxDecoration(color: txn.color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
            child: Icon(txn.icon, color: txn.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.name, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(txn.time, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${positive ? '+' : '-'}\$${txn.amount.abs().toStringAsFixed(2)}',
            style: TextStyle(color: positive ? AppColors.lime : AppColors.text, fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _ComingSoon({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.lime, size: 44),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: AppColors.text, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          ),
          const SizedBox(height: 24),
          const _BrandFooter(),
        ],
      ),
    );
  }
}
