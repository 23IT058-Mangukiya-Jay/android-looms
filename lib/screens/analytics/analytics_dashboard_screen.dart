import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/app_drawer.dart';

// ─── Colour palette ──────────────────────────────────────────────────────────
const Color _indigo = Color(0xFF4F46E5);
const Color _violet = Color(0xFF7C3AED);
const Color _emerald = Color(0xFF059669);
const Color _amber = Color(0xFFF59E0B);
const Color _rose = Color(0xFFE11D48);
const Color _sky = Color(0xFF0EA5E9);
const Color _orange = Color(0xFFF97316);

// ─── Sample dataset (replace with live Firestore data later) ─────────────────

/// Weekly production (meters) – Mon to Sun
final List<double> _weeklyMeters = [210, 185, 240, 195, 260, 230, 150];

/// Weekly earnings (₹)
final List<double> _weeklyEarnings = [
  2100, 1850, 2400, 1950, 2600, 2300, 1500
];

/// Machine status breakdown
const Map<String, int> _machineStatus = {
  'Active': 98,
  'Idle': 22,
  'Maintenance': 14,
  'Offline': 8,
};

/// Worker shift production share (Day vs Night)
final List<double> _shiftMeters = [
  1420, // Day
  1210, // Night
];

/// Per-loom bar data for top 6 looms
final List<_LoomData> _loomData = [
  _LoomData('Loom 01', 310, _indigo),
  _LoomData('Loom 02', 275, _violet),
  _LoomData('Loom 03', 340, _emerald),
  _LoomData('Loom 04', 290, _amber),
  _LoomData('Loom 05', 255, _rose),
  _LoomData('Loom 06', 320, _sky),
];

class _LoomData {
  final String name;
  final double meters;
  final Color color;
  const _LoomData(this.name, this.meters, this.color);
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  // Toggle between two line-chart datasets
  bool _showEarnings = false;

  // Pie chart touch index
  int _pieTouched = -1;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      drawer: const AppDrawer(),
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            // ── Gradient App Bar ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 170,
              pinned: true,
              floating: false,
              backgroundColor: _indigo,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_indigo, _violet],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -40,
                        right: -40,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: -20,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 28,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Analytics Dashboard',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Production · Machines · Earnings',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── KPI Summary Row ────────────────────────────────────────
                  _sectionHeader('This Week at a Glance'),
                  const SizedBox(height: 10),
                  _kpiRow(),
                  const SizedBox(height: 28),

                  // ── CHART 1: Line Chart – Weekly Production / Earnings ─────
                  _sectionHeader(
                    _showEarnings
                        ? 'Weekly Earnings (₹)'
                        : 'Weekly Production (meters)',
                  ),
                  const SizedBox(height: 4),
                  _chartTypeToggle(),
                  const SizedBox(height: 12),
                  _chartCard(child: _buildLineChart()),
                  const SizedBox(height: 28),

                  // ── CHART 2: Bar Chart – Per-Loom Performance ─────────────
                  _sectionHeader('Top 6 Looms – Meters Produced'),
                  const SizedBox(height: 12),
                  _chartCard(height: 240, child: _buildBarChart()),
                  const SizedBox(height: 28),

                  // ── CHART 3: Pie Chart – Machine Status ───────────────────
                  _sectionHeader('Machine Status Breakdown'),
                  const SizedBox(height: 12),
                  _buildPieSection(),
                  const SizedBox(height: 28),

                  // ── CHART 4: Horizontal Bar – Day vs Night Shift ──────────
                  _sectionHeader('Day vs Night Shift Production'),
                  const SizedBox(height: 12),
                  _buildShiftComparison(),
                  const SizedBox(height: 50),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── KPI Row ───────────────────────────────────────────────────────────────
  Widget _kpiRow() {
    final totalMeters =
        _weeklyMeters.fold(0.0, (a, b) => a + b).toStringAsFixed(0);
    final totalEarnings =
        _weeklyEarnings.fold(0.0, (a, b) => a + b).toStringAsFixed(0);
    return Row(
      children: [
        _kpiCard('Total Meters', '${totalMeters}m', Icons.straighten, _indigo),
        const SizedBox(width: 10),
        _kpiCard('Earnings', '₹$totalEarnings', Icons.currency_rupee, _emerald),
        const SizedBox(width: 10),
        _kpiCard('Avg/Day', '${(_weeklyMeters.fold(0.0, (a, b) => a + b) / 7).toStringAsFixed(0)}m',
            Icons.show_chart, _amber),
      ],
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ─── Toggle ────────────────────────────────────────────────────────────────
  Widget _chartTypeToggle() {
    return Row(
      children: [
        _toggleChip('Production', !_showEarnings, _indigo, () {
          setState(() => _showEarnings = false);
        }),
        const SizedBox(width: 10),
        _toggleChip('Earnings', _showEarnings, _emerald, () {
          setState(() => _showEarnings = true);
        }),
      ],
    );
  }

  Widget _toggleChip(
      String label, bool active, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: active ? Colors.white : color,
              fontWeight: FontWeight.w600,
              fontSize: 12),
        ),
      ),
    );
  }

  // ─── Chart card container ──────────────────────────────────────────────────
  Widget _chartCard({required Widget child, double height = 220}) {
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF1E293B)));
  }

  // ─── CHART 1: Line Chart ───────────────────────────────────────────────────
  Widget _buildLineChart() {
    final data = _showEarnings ? _weeklyEarnings : _weeklyMeters;
    final color = _showEarnings ? _emerald : _indigo;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxY =
        (data.reduce((a, b) => a > b ? a : b) * 1.2).ceilToDouble();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) => FlLine(
            color: Colors.grey.withOpacity(0.12),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (v, meta) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(days[v.toInt()],
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              getTitlesWidget: (v, meta) => Text(
                _showEarnings
                    ? '₹${(v / 1000).toStringAsFixed(1)}k'
                    : '${v.toInt()}m',
                style:
                    TextStyle(fontSize: 9, color: Colors.grey[400]),
              ),
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                data.length, (i) => FlSpot(i.toDouble(), data[i])),
            isCurved: true,
            curveSmoothness: 0.35,
            color: color,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, pct, bar, idx) =>
                  FlDotCirclePainter(
                      radius: 4,
                      color: color,
                      strokeWidth: 2,
                      strokeColor: Colors.white),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.22),
                  color.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: color,
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      _showEarnings
                          ? '₹${s.y.toStringAsFixed(0)}'
                          : '${s.y.toStringAsFixed(0)}m',
                      const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ─── CHART 2: Bar Chart – Per Loom ────────────────────────────────────────
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 400,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: const Color(0xFF1E293B),
            getTooltipItem: (group, gIdx, rod, rIdx) => BarTooltipItem(
              '${_loomData[gIdx].meters.toInt()}m',
              const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _loomData[v.toInt()].name.replaceAll('Loom ', 'L'),
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (v, meta) => Text(
                '${v.toInt()}m',
                style: TextStyle(fontSize: 9, color: Colors.grey[400]),
              ),
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) => FlLine(
            color: Colors.grey.withOpacity(0.1),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          _loomData.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: _loomData[i].meters,
                color: _loomData[i].color,
                width: 22,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 400,
                  color: Colors.grey.withOpacity(0.06),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── CHART 3: Pie Chart – Machine Status ──────────────────────────────────
  Widget _buildPieSection() {
    final colors = [_emerald, _amber, _orange, _rose];
    final entries = _machineStatus.entries.toList();
    final total = _machineStatus.values.fold(0, (a, b) => a + b);

    return Row(
      children: [
        // Pie
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      setState(() => _pieTouched = -1);
                      return;
                    }
                    setState(() => _pieTouched =
                        response.touchedSection!.touchedSectionIndex);
                  },
                ),
                sections: List.generate(entries.length, (i) {
                  final touched = i == _pieTouched;
                  return PieChartSectionData(
                    value: entries[i].value.toDouble(),
                    color: colors[i],
                    radius: touched ? 76 : 62,
                    title: touched
                        ? '${entries[i].value}\n${((entries[i].value / total) * 100).toStringAsFixed(0)}%'
                        : '${((entries[i].value / total) * 100).toStringAsFixed(0)}%',
                    titleStyle: TextStyle(
                      fontSize: touched ? 13 : 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
                sectionsSpace: 3,
                centerSpaceRadius: 32,
                startDegreeOffset: -90,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Legend
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(entries.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[i],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(entries[i].key,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                      Text(
                        '${entries[i].value}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors[i]),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // ─── CHART 4: Day vs Night Shift ──────────────────────────────────────────
  Widget _buildShiftComparison() {
    final totalShift = _shiftMeters[0] + _shiftMeters[1];
    final dayPct = (_shiftMeters[0] / totalShift * 100).toStringAsFixed(1);
    final nightPct = (_shiftMeters[1] / totalShift * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Shift row
          _shiftRow(
            icon: Icons.wb_sunny_rounded,
            label: 'Day Shift',
            meters: _shiftMeters[0],
            pct: dayPct,
            color: _amber,
            fillFraction: _shiftMeters[0] / (_weeklyMeters.reduce((a, b) => a > b ? a : b) * 7),
          ),
          const SizedBox(height: 18),
          // Night Shift row
          _shiftRow(
            icon: Icons.nightlight_round,
            label: 'Night Shift',
            meters: _shiftMeters[1],
            pct: nightPct,
            color: _indigo,
            fillFraction: _shiftMeters[1] / (_weeklyMeters.reduce((a, b) => a > b ? a : b) * 7),
          ),
          const SizedBox(height: 18),
          // Mini bar chart using fl_chart
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1800,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) => Text(
                        v == 0 ? 'Day' : 'Night',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                      toY: _shiftMeters[0],
                      color: _amber,
                      width: 48,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                    ),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                      toY: _shiftMeters[1],
                      color: _indigo,
                      width: 48,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                    ),
                  ]),
                ],
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFF1E293B),
                    getTooltipItem: (group, gIdx, rod, rIdx) =>
                        BarTooltipItem(
                      '${rod.toY.toInt()}m',
                      const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shiftRow({
    required IconData icon,
    required String label,
    required double meters,
    required String pct,
    required Color color,
    required double fillFraction,
  }) {
    final clampedFill = fillFraction.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const Spacer(),
          Text('${meters.toInt()}m',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14)),
          const SizedBox(width: 6),
          Text('($pct%)',
              style:
                  TextStyle(color: Colors.grey[500], fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: clampedFill,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
