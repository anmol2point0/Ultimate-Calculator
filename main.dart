// ╔══════════════════════════════════════════════════════════════════╗
// ║   ULTIMATE STEP-BY-STEP CALCULATOR — PHASE 1 + 2 COMPLETE      ║
// ║   pubspec.yaml:                                                 ║
// ║     provider: ^6.1.1                                            ║
// ║     math_expressions: ^2.5.0                                    ║
// ║     shared_preferences: ^2.2.2                                  ║
// ╚══════════════════════════════════════════════════════════════════╝

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Opacity helper ──────────────────────────────────────────────
Color co(Color c, double o) => c.withValues(alpha: o);

// ══════════════════════════════════════════════════════════════════
// ENTRY POINT
// ══════════════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (_) => CalcProvider(prefs),
      child: const UltimateCalcApp(),
    ),
  );
}

class UltimateCalcApp extends StatelessWidget {
  const UltimateCalcApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Calculator',
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// THEME SYSTEM
// ══════════════════════════════════════════════════════════════════

// 6 Background skins
enum BgSkin { midnight, arctic, amoled, forest, sunset, ocean }

// 4 Button personalities
enum BtnStyle { neumorphic, flat, glass, outlined }

// 8 Accent colors
enum AccentColor { orange, teal, purple, gold, pink, red, cyan, lime }

class AppTheme {
  final BgSkin bg;
  final BtnStyle btn;
  final AccentColor accent;

  const AppTheme({
    this.bg = BgSkin.midnight,
    this.btn = BtnStyle.neumorphic,
    this.accent = AccentColor.orange,
  });

  // ── Background colors ──
  Color get bgColor {
    switch (bg) {
      case BgSkin.midnight: return const Color(0xFF1A1B22);
      case BgSkin.arctic:   return const Color(0xFFF5F7FA);
      case BgSkin.amoled:   return const Color(0xFF000000);
      case BgSkin.forest:   return const Color(0xFF0D1F14);
      case BgSkin.sunset:   return const Color(0xFF1C1208);
      case BgSkin.ocean:    return const Color(0xFF061525);
    }
  }

  Color get bgSecondary {
    switch (bg) {
      case BgSkin.midnight: return const Color(0xFF252730);
      case BgSkin.arctic:   return const Color(0xFFE8ECF1);
      case BgSkin.amoled:   return const Color(0xFF111111);
      case BgSkin.forest:   return const Color(0xFF142B1C);
      case BgSkin.sunset:   return const Color(0xFF251A0A);
      case BgSkin.ocean:    return const Color(0xFF0A2035);
    }
  }

  Color get cardColor {
    switch (bg) {
      case BgSkin.midnight: return const Color(0xFF21252D);
      case BgSkin.arctic:   return const Color(0xFFFFFFFF);
      case BgSkin.amoled:   return const Color(0xFF0D0D0D);
      case BgSkin.forest:   return const Color(0xFF0F2416);
      case BgSkin.sunset:   return const Color(0xFF1A1005);
      case BgSkin.ocean:    return const Color(0xFF071A2D);
    }
  }

  Color get shadowDark {
    switch (bg) {
      case BgSkin.midnight: return const Color(0xFF14161B);
      case BgSkin.arctic:   return const Color(0xFFC8CDD8);
      case BgSkin.amoled:   return const Color(0xFF000000);
      case BgSkin.forest:   return const Color(0xFF081410);
      case BgSkin.sunset:   return const Color(0xFF120B05);
      case BgSkin.ocean:    return const Color(0xFF030D18);
    }
  }

  Color get shadowLight {
    switch (bg) {
      case BgSkin.midnight: return const Color(0xFF22242D);
      case BgSkin.arctic:   return const Color(0xFFFFFFFF);
      case BgSkin.amoled:   return const Color(0xFF1A1A1A);
      case BgSkin.forest:   return const Color(0xFF163324);
      case BgSkin.sunset:   return const Color(0xFF2E200F);
      case BgSkin.ocean:    return const Color(0xFF0E2A42);
    }
  }

  Color get textPrimary {
    switch (bg) {
      case BgSkin.arctic: return const Color(0xFF111827);
      default:            return const Color(0xFFFFFFFF);
    }
  }

  Color get textSecondary {
    switch (bg) {
      case BgSkin.midnight: return const Color(0xFF5A5F72);
      case BgSkin.arctic:   return const Color(0xFF9CA3AF);
      case BgSkin.amoled:   return const Color(0xFF4B5563);
      case BgSkin.forest:   return const Color(0xFF4B7A5A);
      case BgSkin.sunset:   return const Color(0xFF78502A);
      case BgSkin.ocean:    return const Color(0xFF1E4A6A);
    }
  }

  bool get isLight => bg == BgSkin.arctic;

  // ── Accent colors ──
  Color get accentColor {
    switch (accent) {
      case AccentColor.orange: return const Color(0xFFF37B2B);
      case AccentColor.teal:   return const Color(0xFF00BFA5);
      case AccentColor.purple: return const Color(0xFFA855F7);
      case AccentColor.gold:   return const Color(0xFFF59E0B);
      case AccentColor.pink:   return const Color(0xFFEC4899);
      case AccentColor.red:    return const Color(0xFFEF4444);
      case AccentColor.cyan:   return const Color(0xFF06B6D4);
      case AccentColor.lime:   return const Color(0xFF84CC16);
    }
  }

  // Persist
  Map<String, int> toMap() => {
    'bg': bg.index, 'btn': btn.index, 'accent': accent.index
  };

  factory AppTheme.fromMap(Map<String, int> m) => AppTheme(
    bg:     BgSkin.values[m['bg'] ?? 0],
    btn:    BtnStyle.values[m['btn'] ?? 0],
    accent: AccentColor.values[m['accent'] ?? 0],
  );
}

// ══════════════════════════════════════════════════════════════════
// STEP MODEL
// ══════════════════════════════════════════════════════════════════
class CalcStep {
  final String rule;
  final String expression;
  final String value;
  final bool isFinal;
  const CalcStep({
    required this.rule,
    required this.expression,
    required this.value,
    this.isFinal = false,
  });
}

// ══════════════════════════════════════════════════════════════════
// CATEGORY MODES
// ══════════════════════════════════════════════════════════════════
enum CalcMode {
  standard, trig, algebra, stat, finance,
  geometry, physics, chemistry, logPow,
  matrix, dev, unit, numberTheory, health, datetime,
}

class CatMeta {
  final String title;
  final String emoji;
  final String description;
  final int count;
  final Color Function(AppTheme) colorFn;
  const CatMeta(this.title, this.emoji, this.description, this.count, this.colorFn);
  Color color(AppTheme t) => colorFn(t);
}

final Map<CalcMode, CatMeta> catData = {
  CalcMode.standard:     CatMeta('Standard',       '🔢', 'Basic arithmetic',          0,  (t) => t.accentColor),
  CalcMode.trig:         CatMeta('Trigonometry',    '📐', 'sin, cos, tan & more',      22, (t) => const Color(0xFF00BFA5)),
  CalcMode.algebra:      CatMeta('Algebra',         '🔢', 'Equations & sequences',     30, (t) => const Color(0xFF3D9BFF)),
  CalcMode.stat:         CatMeta('Statistics',      '📊', 'Mean, SD, probability',     25, (t) => const Color(0xFF9B72F8)),
  CalcMode.finance:      CatMeta('Finance',         '📈', 'SI, CI, EMI, GST',          30, (t) => const Color(0xFF2ECC71)),
  CalcMode.geometry:     CatMeta('Geometry',        '📏', 'Areas, volumes, shapes',    35, (t) => const Color(0xFFF37B2B)),
  CalcMode.physics:      CatMeta('Physics',         '⚡', 'Mechanics, electricity',    40, (t) => const Color(0xFFF1C40F)),
  CalcMode.chemistry:    CatMeta('Chemistry',       '⚗️', 'Moles, pH, gases',          25, (t) => const Color(0xFFFF6B81)),
  CalcMode.logPow:       CatMeta('Log & Powers',    '📝', 'Logarithms, roots, powers', 15, (t) => const Color(0xFF00BFA5)),
  CalcMode.matrix:       CatMeta('Matrix',          '⬜', 'Det, inverse, multiply',    20, (t) => const Color(0xFF9B72F8)),
  CalcMode.dev:          CatMeta('Developer',       '💻', 'Binary, hex, bitwise',      20, (t) => const Color(0xFF3D9BFF)),
  CalcMode.unit:         CatMeta('Unit Converter',  '🔄', '50+ unit conversions',      50, (t) => const Color(0xFFFF6B81)),
  CalcMode.numberTheory: CatMeta('Number Theory',   '🧮', 'Primes, GCD, Fibonacci',    15, (t) => const Color(0xFF3D9BFF)),
  CalcMode.health:       CatMeta('Health',          '💊', 'BMI, BMR, calories',        20, (t) => const Color(0xFFE74C3C)),
  CalcMode.datetime:     CatMeta('Date & Time',     '📅', 'Age, days, countdowns',     15, (t) => const Color(0xFF2ECC71)),
};

// ══════════════════════════════════════════════════════════════════
// ZONE KEYS
// ══════════════════════════════════════════════════════════════════
class ZKey {
  final String label;
  final String value;
  final bool accent;
  const ZKey(this.label, {String? value, this.accent = false})
      : value = value ?? label;
}

const Map<CalcMode, List<ZKey>> zoneKeys = {
  CalcMode.standard: [],
  CalcMode.trig: [
    ZKey('sin',   value: 'sin('),   ZKey('cos',   value: 'cos('),
    ZKey('tan',   value: 'tan('),   ZKey('π',     value: '3.14159265358979', accent: true),
    ZKey('sin⁻¹', value: 'asin('), ZKey('cos⁻¹', value: 'acos('),
    ZKey('tan⁻¹', value: 'atan('), ZKey('e',     value: '2.71828182845904', accent: true),
    ZKey('sinh',  value: 'sinh('), ZKey('cosh',  value: 'cosh('),
    ZKey('tanh',  value: 'tanh('), ZKey('sec',   value: '__SEC__'),
    ZKey('cosec', value: '__CSC__'), ZKey('cot',  value: '__COT__'),
    ZKey('°→rad', value: '*(3.14159265358979/180)'),
    ZKey('rad→°', value: '*(180/3.14159265358979)'),
  ],
  CalcMode.algebra: [
    ZKey('Quadratic',  value: '__QUAD__',   accent: true),
    ZKey('Linear',     value: '__LINEAR__', accent: true),
    ZKey('Pythagoras', value: '__PYTH__',   accent: true),
    ZKey('AP nth',     value: '__APNTH__'),
    ZKey('AP Sum',     value: '__APSUM__'),
    ZKey('GP nth',     value: '__GPNTH__'),
    ZKey('GP Sum',     value: '__GPSUM__'),
    ZKey('nCr',        value: '__NCR__'),
    ZKey('nPr',        value: '__NPR__'),
    ZKey('n!',         value: '__FACT__'),
    ZKey('HCF',        value: '__GCD__'),
    ZKey('LCM',        value: '__LCM__'),
    ZKey('|x|',        value: 'abs('),
    ZKey('x²',         value: '^2'),
    ZKey('x³',         value: '^3'),
    ZKey('√',          value: 'sqrt(', accent: true),
    ZKey('∛',          value: '__CBRT__'),
    ZKey('xⁿ',         value: '^'),
  ],
  CalcMode.stat: [
    ZKey('Mean',       value: '__MEAN__',   accent: true),
    ZKey('Median',     value: '__MEDIAN__', accent: true),
    ZKey('Mode',       value: '__MODE__'),
    ZKey('SD',         value: '__SD__',     accent: true),
    ZKey('Variance',   value: '__VAR__'),
    ZKey('Range',      value: '__RANGE__'),
    ZKey('IQR',        value: '__IQR__'),
    ZKey('Z-score',    value: '__ZSCORE__'),
    ZKey('Percentile', value: '__PERC__'),
    ZKey('nCr',        value: '__NCR__'),
    ZKey('nPr',        value: '__NPR__'),
    ZKey('n!',         value: '__FACT__'),
    ZKey('W.Mean',     value: '__WMEAN__'),
    ZKey('Lin Reg',    value: '__LINREG__'),
    ZKey('Corr r',     value: '__CORR__'),
  ],
  CalcMode.finance: [
    ZKey('SI',       value: '__SI__',      accent: true),
    ZKey('CI',       value: '__CI__',      accent: true),
    ZKey('EMI',      value: '__EMI__',     accent: true),
    ZKey('+GST 5%',  value: '__GST5__'),
    ZKey('+GST 12%', value: '__GST12__'),
    ZKey('+GST 18%', value: '__GST18__'),
    ZKey('+GST 28%', value: '__GST28__'),
    ZKey('−GST 18%', value: '__RGST18__'),
    ZKey('Profit%',  value: '__PROFIT__'),
    ZKey('Loss%',    value: '__LOSS__'),
    ZKey('Discount', value: '__DISC__'),
    ZKey('Markup',   value: '__MARKUP__'),
    ZKey('CAGR',     value: '__CAGR__'),
    ZKey('ROI',      value: '__ROI__'),
    ZKey('FV',       value: '__FV__'),
    ZKey('PV',       value: '__PV__'),
    ZKey('Break-even', value: '__BEP__'),
    ZKey('Tip Split', value: '__TIP__'),
  ],
  CalcMode.geometry: [
    ZKey('Circle A',  value: '__ACIRC__',  accent: true),
    ZKey('Rect A',    value: '__ARECT__',  accent: true),
    ZKey('Triangle A',value: '__ATRI__',   accent: true),
    ZKey('Heron',     value: '__HERON__'),
    ZKey('Trap A',    value: '__ATRAP__'),
    ZKey('Parallel A',value: '__APARA__'),
    ZKey('Sector A',  value: '__ASECT__'),
    ZKey('Ellipse A', value: '__AELL__'),
    ZKey('Sphere V',  value: '__VSPH__'),
    ZKey('Cylinder V',value: '__VCYL__'),
    ZKey('Cone V',    value: '__VCON__'),
    ZKey('Cube V',    value: '__VCUBE__'),
    ZKey('Cuboid V',  value: '__VCUBOID__'),
    ZKey('Pyramid V', value: '__VPYR__'),
    ZKey('Distance',  value: '__DIST__'),
    ZKey('Midpoint',  value: '__MID__'),
    ZKey('Slope',     value: '__SLOPE__'),
    ZKey('Pythagoras',value: '__PYTH__'),
  ],
  CalcMode.physics: [
    ZKey('F=ma',      value: '__FORCE__',  accent: true),
    ZKey('V=IR',      value: '__OHM__',    accent: true),
    ZKey('KE',        value: '__KE__'),
    ZKey('PE',        value: '__PE__'),
    ZKey('Work',      value: '__WORK__'),
    ZKey('Power',     value: '__POWER__'),
    ZKey('Speed',     value: '__SPEED__'),
    ZKey('Momentum',  value: '__MOM__'),
    ZKey('Impulse',   value: '__IMPULSE__'),
    ZKey('Centripetal',value: '__CENTRIP__'),
    ZKey('Gravity g', value: '__GRAV__'),
    ZKey('Escape v',  value: '__ESCV__'),
    ZKey('Wave v=fλ', value: '__WAVE__'),
    ZKey('E=mc²',     value: '__EMC2__'),
    ZKey('E=hf',      value: '__EHF__'),
    ZKey('P=VI',      value: '__PWRVI__'),
    ZKey('R series',  value: '__RSERIES__'),
    ZKey('R parallel',value: '__RPARA__'),
    ZKey('Q=mcΔT',    value: '__HEAT__'),
    ZKey('Snell',     value: '__SNELL__'),
  ],
  CalcMode.chemistry: [
    ZKey('Moles',     value: '__MOLES__',  accent: true),
    ZKey('Molarity',  value: '__MOLARITY__',accent: true),
    ZKey('pH',        value: '__PH__',     accent: true),
    ZKey('pOH',       value: '__POH__'),
    ZKey('PV=nRT',    value: '__GAS__'),
    ZKey('Dilution',  value: '__DIL__'),
    ZKey('% comp',    value: '__PCOMP__'),
    ZKey('Half-life', value: '__HALF__'),
    ZKey('Avogadro',  value: '6.02214076e23'),
    ZKey('R const',   value: '8.314'),
    ZKey('ΔG=ΔH-TΔS',value: '__GIBBS__'),
    ZKey('Nernst',    value: '__NERNST__'),
  ],
  CalcMode.logPow: [
    ZKey('log₁₀',    value: 'log(',   accent: true),
    ZKey('ln',        value: 'ln(',    accent: true),
    ZKey('log base',  value: '__LOGN__'),
    ZKey('antilog',   value: '__ALOG__'),
    ZKey('e^x',       value: '__EX__'),
    ZKey('10^x',      value: '__10X__'),
    ZKey('x²',        value: '^2'),
    ZKey('x³',        value: '^3'),
    ZKey('xⁿ',        value: '^'),
    ZKey('√',         value: 'sqrt('),
    ZKey('∛',         value: '__CBRT__'),
    ZKey('ⁿ√',        value: '__NROOT__'),
    ZKey('Sum n',     value: '__SUMN__'),
    ZKey('Sum n²',    value: '__SUMN2__'),
    ZKey('Sum n³',    value: '__SUMN3__'),
  ],
  CalcMode.matrix: [
    ZKey('2×2 Det',   value: '__DET2__',  accent: true),
    ZKey('3×3 Det',   value: '__DET3__',  accent: true),
    ZKey('2×2 Inv',   value: '__INV2__',  accent: true),
    ZKey('2×2 Mult',  value: '__MMUL2__'),
    ZKey('2×2 Add',   value: '__MADD2__'),
    ZKey('Transpose', value: '__TRANS__'),
    ZKey('Trace',     value: '__TRACE__'),
    ZKey('Eigenvalues',value: '__EIGEN__'),
    ZKey('Cramer 2x', value: '__CRAMER2__'),
    ZKey('Cramer 3x', value: '__CRAMER3__'),
  ],
  CalcMode.dev: [
    ZKey('→ HEX',    value: '__HEX__',   accent: true),
    ZKey('→ BIN',    value: '__BIN__',   accent: true),
    ZKey('→ OCT',    value: '__OCT__',   accent: true),
    ZKey('→ DEC',    value: '__DEC__'),
    ZKey('AND',      value: '&'),
    ZKey('OR',       value: '|'),
    ZKey('XOR',      value: '^b'),
    ZKey('NOT',      value: '__NOT__'),
    ZKey('<<',       value: '__LSH__'),
    ZKey('>>',       value: '__RSH__'),
    ZKey('2\'s comp',value: '__TWOS__'),
    ZKey('ASCII',    value: '__ASCII__'),
    ZKey('Bits→Bytes',value: '__BITTOBYTE__'),
    ZKey('MOD',      value: '%'),
  ],
  CalcMode.unit: [
    ZKey('Length',      value: '__ULEN__',  accent: true),
    ZKey('Weight',      value: '__UWGT__',  accent: true),
    ZKey('Temp',        value: '__UTEMP__', accent: true),
    ZKey('Speed',       value: '__USPD__'),
    ZKey('Area',        value: '__UAREA__'),
    ZKey('Volume',      value: '__UVOL__'),
    ZKey('Data',        value: '__UDATA__'),
    ZKey('Pressure',    value: '__UPRES__'),
    ZKey('Energy',      value: '__UENRG__'),
    ZKey('Power',       value: '__UPWR__'),
    ZKey('Force',       value: '__UFORCE__'),
    ZKey('Fuel',        value: '__UFUEL__'),
  ],
  CalcMode.numberTheory: [
    ZKey('Prime?',      value: '__ISPRIME__', accent: true),
    ZKey('Factorize',   value: '__PFACT__',   accent: true),
    ZKey('GCD',         value: '__GCD__'),
    ZKey('LCM',         value: '__LCM__'),
    ZKey('Fibonacci',   value: '__FIB__'),
    ZKey('Armstrong?',  value: '__ARM__'),
    ZKey('Perfect?',    value: '__PERF__'),
    ZKey('Palindrome?', value: '__PALIN__'),
    ZKey('Digital root',value: '__DIGROOT__'),
    ZKey('Euler φ',     value: '__EULER__'),
    ZKey('Roman',       value: '__ROMAN__'),
    ZKey('Harshad?',    value: '__HARSH__'),
  ],
  CalcMode.health: [
    ZKey('BMI',         value: '__BMI__',   accent: true),
    ZKey('BMR',         value: '__BMR__',   accent: true),
    ZKey('Ideal Wt',    value: '__IDWT__'),
    ZKey('Body Fat',    value: '__BFAT__'),
    ZKey('Daily Cal',   value: '__DCAL__'),
    ZKey('Max HR',      value: '__MHR__'),
    ZKey('Target HR',   value: '__THR__'),
    ZKey('Water/day',   value: '__WATER__'),
    ZKey('Waist-Hip',   value: '__WHR__'),
    ZKey('Due Date',    value: '__PREG__'),
    ZKey('Cal burned',  value: '__CBURN__'),
    ZKey('Run pace',    value: '__PACE__'),
  ],
  CalcMode.datetime: [
    ZKey('Age',         value: '__AGE__',   accent: true),
    ZKey('Days Btw',    value: '__DAYS__',  accent: true),
    ZKey('Add Days',    value: '__ADDD__'),
    ZKey('Day of Wk',   value: '__DOW__'),
    ZKey('Leap year?',  value: '__LEAP__'),
    ZKey('Days in yr',  value: '__DAYYR__'),
    ZKey('Work Days',   value: '__WDAYS__'),
    ZKey('Countdown',   value: '__CDWN__'),
  ],
};

// ══════════════════════════════════════════════════════════════════
// STEP ENGINE — ALL PHASE 1 FORMULAS
// ══════════════════════════════════════════════════════════════════
class StepEngine {
  static List<CalcStep> solve(String eq, {bool bodmas = false}) {
    final e = eq.trim();
    if (e.isEmpty) return [];

    // ── Route to specialist solvers ──────────────────────────────
    if (e.startsWith('__QUAD__'))    return _quad(e);
    if (e.startsWith('__LINEAR__'))  return _linear(e);
    if (e.startsWith('__PYTH__'))    return _pyth(e);
    if (e.startsWith('__APNTH__'))   return _apNth(e);
    if (e.startsWith('__APSUM__'))   return _apSum(e);
    if (e.startsWith('__GPNTH__'))   return _gpNth(e);
    if (e.startsWith('__GPSUM__'))   return _gpSum(e);
    if (e.startsWith('__NCR__'))     return _ncr(e);
    if (e.startsWith('__NPR__'))     return _npr(e);
    if (e.startsWith('__FACT__'))    return _fact(e);
    if (e.startsWith('__GCD__'))     return _gcd(e);
    if (e.startsWith('__LCM__'))     return _lcm(e);
    if (e.startsWith('__CBRT__'))    return _cbrt(e);
    if (e.startsWith('__MEAN__'))    return _mean(e);
    if (e.startsWith('__MEDIAN__'))  return _median(e);
    if (e.startsWith('__MODE__'))    return _mode(e);
    if (e.startsWith('__SD__'))      return _sd(e);
    if (e.startsWith('__VAR__'))     return _variance(e);
    if (e.startsWith('__RANGE__'))   return _range(e);
    if (e.startsWith('__IQR__'))     return _iqr(e);
    if (e.startsWith('__PERC__'))    return _percentile(e);
    if (e.startsWith('__ZSCORE__'))  return _zscore(e);
    if (e.startsWith('__WMEAN__'))   return _wmean(e);
    if (e.startsWith('__LINREG__'))  return _linreg(e);
    if (e.startsWith('__CORR__'))    return _corr(e);
    if (e.startsWith('__SI__'))      return _si(e);
    if (e.startsWith('__CI__'))      return _ci(e);
    if (e.startsWith('__EMI__'))     return _emi(e);
    if (e.startsWith('__GST5__'))   return _gst(e);
    if (e.startsWith('__GST12__'))  return _gst(e);
    if (e.startsWith('__GST18__'))  return _gst(e);
    if (e.startsWith('__GST28__'))  return _gst(e);
    if (e.startsWith('__RGST5__'))  return _rgst(e);
    if (e.startsWith('__RGST12__')) return _rgst(e);
    if (e.startsWith('__RGST18__')) return _rgst(e);
    if (e.startsWith('__RGST28__')) return _rgst(e);
    if (e.startsWith('__PROFIT__'))  return _profitLoss(e, true);
    if (e.startsWith('__LOSS__'))    return _profitLoss(e, false);
    if (e.startsWith('__DISC__'))    return _discount(e);
    if (e.startsWith('__MARKUP__'))  return _markup(e);
    if (e.startsWith('__CAGR__'))    return _cagr(e);
    if (e.startsWith('__ROI__'))     return _roi(e);
    if (e.startsWith('__FV__'))      return _fv(e);
    if (e.startsWith('__PV__'))      return _pv(e);
    if (e.startsWith('__BEP__'))     return _bep(e);
    if (e.startsWith('__TIP__'))     return _tip(e);
    if (e.startsWith('__ACIRC__'))   return _aCircle(e);
    if (e.startsWith('__ARECT__'))   return _aRect(e);
    if (e.startsWith('__ATRI__'))    return _aTriangle(e);
    if (e.startsWith('__HERON__'))   return _heron(e);
    if (e.startsWith('__ATRAP__'))   return _aTrap(e);
    if (e.startsWith('__APARA__'))   return _aPara(e);
    if (e.startsWith('__ASECT__'))   return _aSector(e);
    if (e.startsWith('__AELL__'))    return _aEllipse(e);
    if (e.startsWith('__VSPH__'))    return _vSphere(e);
    if (e.startsWith('__VCYL__'))    return _vCylinder(e);
    if (e.startsWith('__VCON__'))    return _vCone(e);
    if (e.startsWith('__VCUBE__'))   return _vCube(e);
    if (e.startsWith('__VCUBOID__')) return _vCuboid(e);
    if (e.startsWith('__VPYR__'))    return _vPyramid(e);
    if (e.startsWith('__DIST__'))    return _distance(e);
    if (e.startsWith('__MID__'))     return _midpoint(e);
    if (e.startsWith('__SLOPE__'))   return _slope(e);
    if (e.startsWith('__FORCE__'))   return _force(e);
    if (e.startsWith('__OHM__'))     return _ohm(e);
    if (e.startsWith('__KE__'))      return _ke(e);
    if (e.startsWith('__PE__'))      return _pe(e);
    if (e.startsWith('__WORK__'))    return _work(e);
    if (e.startsWith('__POWER__'))   return _power(e);
    if (e.startsWith('__SPEED__'))   return _speed(e);
    if (e.startsWith('__MOM__'))     return _momentum(e);
    if (e.startsWith('__IMPULSE__')) return _impulse(e);
    if (e.startsWith('__CENTRIP__')) return _centripetal(e);
    if (e.startsWith('__WAVE__'))    return _wave(e);
    if (e.startsWith('__EMC2__'))    return _emc2(e);
    if (e.startsWith('__PWRVI__'))   return _powerVI(e);
    if (e.startsWith('__RSERIES__')) return _rSeries(e);
    if (e.startsWith('__RPARA__'))   return _rParallel(e);
    if (e.startsWith('__HEAT__'))    return _heat(e);
    if (e.startsWith('__SNELL__'))   return _snell(e);
    if (e.startsWith('__EHF__'))     return _planck(e);
    if (e.startsWith('__ESCV__'))    return _escapeVel(e);
    if (e.startsWith('__GRAV__'))    return _surfaceGravity(e);
    if (e.startsWith('__MOLES__'))   return _moles(e);
    if (e.startsWith('__MOLARITY__'))return _molarity(e);
    if (e.startsWith('__PH__'))      return _ph(e);
    if (e.startsWith('__POH__'))     return _poh(e);
    if (e.startsWith('__GAS__'))     return _gas(e);
    if (e.startsWith('__DIL__'))     return _dilution(e);
    if (e.startsWith('__HALF__'))    return _halfLife(e);
    if (e.startsWith('__GIBBS__'))   return _gibbs(e);
    if (e.startsWith('__NERNST__'))  return _nernst(e);
    if (e.startsWith('__PCOMP__'))   return _percentComp(e);
    if (e.startsWith('__DET2__'))    return _det2(e);
    if (e.startsWith('__DET3__'))    return _det3(e);
    if (e.startsWith('__INV2__'))    return _inv2(e);
    if (e.startsWith('__CRAMER2__')) return _cramer2(e);
    if (e.startsWith('__CRAMER3__')) return _cramer3(e);
    if (e.startsWith('__MADD2__'))   return _matAdd(e);
    if (e.startsWith('__MMUL2__'))   return _matMul(e);
    if (e.startsWith('__TRANS__'))   return _matTranspose(e);
    if (e.startsWith('__TRACE__'))   return _matTrace(e);
    if (e.startsWith('__EIGEN__'))   return _matEigen(e);
    if (e.startsWith('__ISPRIME__')) return _isPrime(e);
    if (e.startsWith('__PFACT__'))   return _primeFact(e);
    if (e.startsWith('__FIB__'))     return _fibonacci(e);
    if (e.startsWith('__ARM__'))     return _armstrong(e);
    if (e.startsWith('__PERF__'))    return _perfect(e);
    if (e.startsWith('__PALIN__'))   return _palindrome(e);
    if (e.startsWith('__EULER__'))   return _euler(e);
    if (e.startsWith('__ROMAN__'))   return _roman(e);
    if (e.startsWith('__DIGROOT__')) return _digitalRoot(e);
    if (e.startsWith('__HARSH__'))   return _harshad(e);
    if (e.startsWith('__BMI__'))     return _bmi(e);
    if (e.startsWith('__BMR__'))     return _bmr(e);
    if (e.startsWith('__IDWT__'))    return _idealWeight(e);
    if (e.startsWith('__MHR__'))     return _maxHR(e);
    if (e.startsWith('__THR__'))     return _targetHR(e);
    if (e.startsWith('__WATER__'))   return _water(e);
    if (e.startsWith('__WHR__'))     return _whr(e);
    if (e.startsWith('__PREG__'))    return _pregnancy(e);
    if (e.startsWith('__BFAT__'))    return _bodyFat(e);
    if (e.startsWith('__DCAL__'))    return _dailyCal(e);
    if (e.startsWith('__CBURN__'))   return _caloriesBurned(e);
    if (e.startsWith('__PACE__'))    return _runPace(e);
    if (e.startsWith('__AGE__'))     return _age(e);
    if (e.startsWith('__DAYS__'))    return _daysBetween(e);
    if (e.startsWith('__DOW__'))     return _dayOfWeek(e);
    if (e.startsWith('__LEAP__'))    return _leapYear(e);
    if (e.startsWith('__ADDD__'))    return _addDays(e);
    if (e.startsWith('__CDWN__'))    return _countdown(e);
    if (e.startsWith('__DAYYR__'))   return _daysInYear(e);
    if (e.startsWith('__WDAYS__'))   return _workingDays(e);
    if (e.startsWith('__HEX__') || e.startsWith('__BIN__') ||
        e.startsWith('__OCT__') || e.startsWith('__DEC__'))
        return _baseConvert(e);
    if (e.startsWith('__NOT__'))     return _bitwiseNot(e);
    if (e.startsWith('__ASCII__'))   return _ascii(e);
    if (e.startsWith('__BITTOBYTE__')) return _bitToBytes(e);
    if (e.startsWith('__LSH__'))     return _leftShift(e);
    if (e.startsWith('__RSH__'))     return _rightShift(e);
    if (e.startsWith('__TWOS__'))    return _twosComp(e);
    if (e.startsWith('__SEC__'))     return _sec(e);
    if (e.startsWith('__CSC__'))     return _csc(e);
    if (e.startsWith('__COT__'))     return _cot(e);
    if (e.startsWith('__LOGN__'))    return _logBase(e);
    if (e.startsWith('__SUMN__'))    return _sumN(e);
    if (e.startsWith('__10X__'))     return _tenPowX(e);
    if (e.startsWith('__EX__'))      return _ePowX(e);
    if (e.startsWith('__ALOG__'))    return _antilog(e);
    if (e.startsWith('__NROOT__'))   return _nthRoot(e);
    if (e.startsWith('__SUMN2__'))   return _sumN2(e);
    if (e.startsWith('__SUMN3__'))   return _sumN3(e);
    if (e.startsWith('__ULEN__'))    return _uLen(e);
    if (e.startsWith('__UWGT__'))    return _uWgt(e);
    if (e.startsWith('__UTEMP__'))   return _uTemp(e);
    if (e.startsWith('__USPD__'))    return _uSpd(e);
    if (e.startsWith('__UDATA__'))   return _uData(e);
    if (e.startsWith('__UAREA__'))   return _uArea(e);
    if (e.startsWith('__UVOL__'))    return _uVol(e);
    if (e.startsWith('__UPRES__'))   return _uPressure(e);
    if (e.startsWith('__UENRG__'))   return _uEnergy(e);
    if (e.startsWith('__UPWR__'))    return _uPower(e);
    if (e.startsWith('__UFORCE__'))  return _uForce(e);
    if (e.startsWith('__UFUEL__'))   return _uFuel(e);

    return _expression(e, bodmas: bodmas);
  }


  // ══ LOG & POWERS — Phase 2 ═══════════════════════════════════

  static List<CalcStep> _tenPowX(String eq) {
    final x = _d(_parts(eq,'__10X__').firstOrNull??'3');
    final res = math.pow(10, x).toDouble();
    return [
      const CalcStep(rule: '10^x',expression: 'Result = 10^x',value: ''),
      CalcStep(rule: '10^${_f(x)}',expression: '',value: '= ${_f(res)}'),
      CalcStep(rule: 'Answer',expression: '10^${_f(x)}',value:_f(res),isFinal:true),
    ];
  }

  static List<CalcStep> _ePowX(String eq) {
    final x = _d(_parts(eq,'__EX__').firstOrNull??'1');
    final res = math.exp(x);
    return [
      const CalcStep(rule: 'e^x',expression: 'e = 2.71828...',value: ''),
      CalcStep(rule: 'e^${_f(x)}',expression: '',value: '= ${_f(res)}'),
      CalcStep(rule: 'Answer',expression: 'e^${_f(x)}',value:_f(res),isFinal:true),
    ];
  }

  static List<CalcStep> _antilog(String eq) {
    final x = _d(_parts(eq,'__ALOG__').firstOrNull??'3');
    final res = math.pow(10, x).toDouble();
    return [
      const CalcStep(rule: 'Antilog',expression: 'antilog(x) = 10^x',value: ''),
      CalcStep(rule: '10^${_f(x)}',expression: '',value: '= ${_f(res)}'),
      CalcStep(rule: 'Answer',expression: 'antilog(${_f(x)})',value:_f(res),isFinal:true),
    ];
  }

  static List<CalcStep> _nthRoot(String eq) {
    final p = _parts(eq,'__NROOT__');
    if (p.length < 2) return _usage('nth Root','Enter x,n (finds nth root of x)','e.g. 27,3');
    final x = _d(p[0]), n = _d(p[1]);
    final res = math.pow(x, 1/n).toDouble();
    return [
      const CalcStep(rule: 'nth Root',expression: 'ⁿ√x = x^(1/n)',value: ''),
      CalcStep(rule: 'Given',expression: 'x=${_f(x)}, n=${_f(n)}',value: ''),
      CalcStep(rule: '${_f(n)}√${_f(x)} = ${_f(x)}^(1/${_f(n)})',expression: '',value: '= ${_f(res)}'),
      CalcStep(rule: 'Answer',expression: '${_f(n)}th root of ${_f(x)}',value:_f(res),isFinal:true),
    ];
  }

  // ══ MATRIX — Phase 2 ═════════════════════════════════════════

  static List<CalcStep> _matAdd(String eq) {
    final p = _parts(eq,'__MADD2__');
    if (p.length < 8) return _usage('Matrix Add 2×2','Enter a1,b1,c1,d1,a2,b2,c2,d2','e.g. 1,2,3,4,5,6,7,8');
    final a1=_d(p[0]),b1=_d(p[1]),c1=_d(p[2]),d1=_d(p[3]);
    final a2=_d(p[4]),b2=_d(p[5]),c2=_d(p[6]),d2=_d(p[7]);
    return [
      const CalcStep(rule: 'Matrix Addition', expression: 'A + B = add corresponding elements',value: ''),
      CalcStep(rule: 'A', expression: '[${_f(a1)} ${_f(b1)}; ${_f(c1)} ${_f(d1)}]',value: ''),
      CalcStep(rule: 'B', expression: '[${_f(a2)} ${_f(b2)}; ${_f(c2)} ${_f(d2)}]',value: ''),
      CalcStep(rule: 'A+B', expression: '[${_f(a1+a2)} ${_f(b1+b2)}; ${_f(c1+c2)} ${_f(d1+d2)}]',value: ''),
      CalcStep(rule: 'Answer', expression: 'A+B', value: '[${_f(a1+a2)}, ${_f(b1+b2)}; ${_f(c1+c2)}, ${_f(d1+d2)}]',isFinal:true),
    ];
  }

  static List<CalcStep> _matMul(String eq) {
    final p = _parts(eq,'__MMUL2__');
    if (p.length < 8) return _usage('Matrix Multiply 2×2','Enter a1,b1,c1,d1,a2,b2,c2,d2','e.g. 1,2,3,4,5,6,7,8');
    final a1=_d(p[0]),b1=_d(p[1]),c1=_d(p[2]),d1=_d(p[3]);
    final a2=_d(p[4]),b2=_d(p[5]),c2=_d(p[6]),d2=_d(p[7]);
    final r00=a1*a2+b1*c2, r01=a1*b2+b1*d2;
    final r10=c1*a2+d1*c2, r11=c1*b2+d1*d2;
    return [
      const CalcStep(rule: 'Matrix Multiply',expression: 'C = A × B  (row × col)',value: ''),
      CalcStep(rule: 'A', expression: '[${_f(a1)} ${_f(b1)}; ${_f(c1)} ${_f(d1)}]',value: ''),
      CalcStep(rule: 'B', expression: '[${_f(a2)} ${_f(b2)}; ${_f(c2)} ${_f(d2)}]',value: ''),
      CalcStep(rule: 'C[0,0]', expression: '${_f(a1)}×${_f(a2)} + ${_f(b1)}×${_f(c2)}',value: '= ${_f(r00)}'),
      CalcStep(rule: 'C[0,1]', expression: '${_f(a1)}×${_f(b2)} + ${_f(b1)}×${_f(d2)}',value: '= ${_f(r01)}'),
      CalcStep(rule: 'C[1,0]', expression: '${_f(c1)}×${_f(a2)} + ${_f(d1)}×${_f(c2)}',value: '= ${_f(r10)}'),
      CalcStep(rule: 'C[1,1]', expression: '${_f(c1)}×${_f(b2)} + ${_f(d1)}×${_f(d2)}',value: '= ${_f(r11)}'),
      CalcStep(rule: 'Answer',expression: 'A×B', value: '[${_f(r00)}, ${_f(r01)}; ${_f(r10)}, ${_f(r11)}]',isFinal:true),
    ];
  }

  static List<CalcStep> _matTranspose(String eq) {
    final p = _parts(eq,'__TRANS__');
    if (p.length < 4) return _usage('Transpose 2×2','Enter a,b,c,d','e.g. 1,2,3,4');
    final a=_d(p[0]),b=_d(p[1]),c=_d(p[2]),d=_d(p[3]);
    return [
      const CalcStep(rule: 'Transpose',expression: 'Swap rows and columns',value: ''),
      CalcStep(rule: 'Original A', expression: '[${_f(a)} ${_f(b)}; ${_f(c)} ${_f(d)}]',value: ''),
      CalcStep(rule: 'Aᵀ', expression: '[${_f(a)} ${_f(c)}; ${_f(b)} ${_f(d)}]',value: ''),
      CalcStep(rule: 'Answer',expression: 'Transpose Aᵀ', value: '[${_f(a)}, ${_f(c)}; ${_f(b)}, ${_f(d)}]',isFinal:true),
    ];
  }

  static List<CalcStep> _matTrace(String eq) {
    final p = _parts(eq,'__TRACE__');
    if (p.length < 4) return _usage('Trace 2×2','Enter a,b,c,d','e.g. 3,1,2,5');
    final a=_d(p[0]),b=_d(p[1]),c=_d(p[2]),d=_d(p[3]);
    final trace = a + d;
    return [
      const CalcStep(rule: 'Trace',expression: 'tr(A) = sum of diagonal elements',value: ''),
      CalcStep(rule: 'Matrix', expression: '[${_f(a)} ${_f(b)}; ${_f(c)} ${_f(d)}]',value: ''),
      CalcStep(rule: 'tr(A) = a + d', expression: '${_f(a)} + ${_f(d)}',value: '= ${_f(trace)}'),
      CalcStep(rule: 'Answer',expression: 'Trace',value:_f(trace),isFinal:true),
    ];
  }

  static List<CalcStep> _matEigen(String eq) {
    final p = _parts(eq,'__EIGEN__');
    if (p.length < 4) return _usage('Eigenvalues 2×2','Enter a,b,c,d','e.g. 4,1,2,3');
    final a=_d(p[0]),b=_d(p[1]),c=_d(p[2]),d=_d(p[3]);
    final trace = a+d, det = a*d - b*c;
    final disc = trace*trace - 4*det;
    if (disc < 0) {
      return [
        const CalcStep(rule: 'Eigenvalues',expression: 'λ² − tr(A)λ + det(A) = 0',value: ''),
        CalcStep(rule: 'Discriminant < 0',expression: 'Complex eigenvalues',value: 'No real eigenvalues',isFinal:true),
      ];
    }
    final sq = math.sqrt(disc);
    final l1 = (trace + sq)/2, l2 = (trace - sq)/2;
    return [
      const CalcStep(rule: 'Eigenvalues',expression: 'λ² − tr(A)λ + det(A) = 0',value: ''),
      CalcStep(rule: 'tr(A)', expression: '${_f(a)} + ${_f(d)}',value: '= ${_f(trace)}'),
      CalcStep(rule: 'det(A)', expression: '${_f(a*d)} − ${_f(b*c)}',value: '= ${_f(det)}'),
      CalcStep(rule: 'Discriminant', expression: '${_f(trace)}² − 4×${_f(det)}',value: '= ${_f(disc)}'),
      CalcStep(rule: 'λ₁ = (tr+√D)/2', expression: '(${_f(trace)}+${_f(sq)})/2',value: '= ${_f(l1)}'),
      CalcStep(rule: 'λ₂ = (tr−√D)/2', expression: '(${_f(trace)}−${_f(sq)})/2',value: '= ${_f(l2)}'),
      CalcStep(rule: 'Answer',expression: 'Eigenvalues', value: 'λ₁=${_f(l1)},  λ₂=${_f(l2)}',isFinal:true),
    ];
  }

  static List<CalcStep> _cramer3(String eq) {
    final p = _parts(eq,'__CRAMER3__');
    if (p.length < 12) return _usage('Cramer 3×3','Enter a1..c3,d1,d2,d3','e.g. 1,1,1,2,-1,1,1,2,-1,6,3,2');
    final a1=_d(p[0]),b1=_d(p[1]),c1=_d(p[2]);
    final a2=_d(p[3]),b2=_d(p[4]),c2=_d(p[5]);
    final a3=_d(p[6]),b3=_d(p[7]),c3=_d(p[8]);
    final d1=_d(p[9]),d2=_d(p[10]),d3=_d(p[11]);
    double det3(double r0c0,double r0c1,double r0c2,
                double r1c0,double r1c1,double r1c2,
                double r2c0,double r2c1,double r2c2) =>
      r0c0*(r1c1*r2c2-r1c2*r2c1)
      -r0c1*(r1c0*r2c2-r1c2*r2c0)
      +r0c2*(r1c0*r2c1-r1c1*r2c0);
    final D  = det3(a1,b1,c1, a2,b2,c2, a3,b3,c3);
    if (D == 0) return [const CalcStep(rule: 'No Solution',expression: 'D=0',value: 'No unique solution',isFinal:true)];
    final Dx = det3(d1,b1,c1, d2,b2,c2, d3,b3,c3);
    final Dy = det3(a1,d1,c1, a2,d2,c2, a3,d3,c3);
    final Dz = det3(a1,b1,d1, a2,b2,d2, a3,b3,d3);
    final x=Dx/D, y=Dy/D, z=Dz/D;
    return [
      const CalcStep(rule: "Cramer's Rule 3×3",expression: '3 equations, 3 unknowns',value: ''),
      CalcStep(rule: 'D (coefficient det)',expression: '',value: '= ${_f(D)}'),
      CalcStep(rule: 'Dx',expression: '',value: '= ${_f(Dx)}'),
      CalcStep(rule: 'Dy',expression: '',value: '= ${_f(Dy)}'),
      CalcStep(rule: 'Dz',expression: '',value: '= ${_f(Dz)}'),
      CalcStep(rule: 'x = Dx/D', expression: '${_f(Dx)}/${_f(D)}',value: '= ${_f(x)}'),
      CalcStep(rule: 'y = Dy/D', expression: '${_f(Dy)}/${_f(D)}',value: '= ${_f(y)}'),
      CalcStep(rule: 'z = Dz/D', expression: '${_f(Dz)}/${_f(D)}',value: '= ${_f(z)}'),
      CalcStep(rule: 'Answer',expression: 'Solution', value: 'x=${_f(x)}, y=${_f(y)}, z=${_f(z)}',isFinal:true),
    ];
  }

  // ══ DEVELOPER — Phase 2 ════════════════════════════════════════

  static List<CalcStep> _ascii(String eq) {
    final raw = eq.replaceAll('__ASCII__','').trim();
    if (raw.isEmpty) return _usage('ASCII','Type a character or number','e.g. A  or  65');
    final n = int.tryParse(raw);
    if (n != null && n >= 0 && n <= 127) {
      final ch = String.fromCharCode(n);
      return [
        CalcStep(rule: 'ASCII → Character',expression: 'Code: $n',value: ''),
        CalcStep(rule: 'Character',expression: '',value:ch),
        CalcStep(rule: 'Answer',expression: 'ASCII $n',value:ch,isFinal:true),
      ];
    } else {
      final ch = raw[0];
      final code = ch.codeUnitAt(0);
      return [
        CalcStep(rule: 'Character → ASCII',expression: 'Char: $ch',value: ''),
        CalcStep(rule: 'ASCII code',expression: '',value: '$code'),
        CalcStep(rule: 'Answer',expression: "'$ch'",value: 'ASCII = $code',isFinal:true),
      ];
    }
  }

  static List<CalcStep> _bitToBytes(String eq) {
    final p = _parts(eq,'__BITTOBYTE__');
    if (p.isEmpty || p[0].isEmpty) return _usage('Bits→Bytes','Enter number of bits','e.g. 8');
    final bits = _d(p[0]);
    final bytes = bits/8, kb = bytes/1024, mb = kb/1024;
    return [
      const CalcStep(rule: 'Bits → Bytes',expression: '1 Byte = 8 Bits',value: ''),
      CalcStep(rule: 'Bits',expression: '${_f(bits)}',value: ''),
      CalcStep(rule: '÷ 8 = Bytes',expression: '',value: '= ${_f(bytes)} B'),
      CalcStep(rule: '÷ 1024 = KB',expression: '',value: '= ${_f(kb)} KB'),
      CalcStep(rule: '÷ 1024 = MB',expression: '',value: '= ${_f(mb)} MB'),
      CalcStep(rule: 'Answer',expression: '${_f(bits)} bits',value: '${_f(bytes)} Bytes',isFinal:true),
    ];
  }

  static List<CalcStep> _leftShift(String eq) {
    final p = _parts(eq,'__LSH__');
    if (p.length < 2) return _usage('Left Shift','Enter number,shift','e.g. 5,2');
    final n = _i(p[0]), shift = _i(p[1]);
    final res = n << shift;
    return [
      const CalcStep(rule: 'Left Shift <<',expression: 'n << k  =  n × 2^k',value: ''),
      CalcStep(rule: 'Binary of $n', expression:n.toRadixString(2),value: ''),
      CalcStep(rule: 'Shift left by $shift', expression: '= ${res.toRadixString(2)}',value: ''),
      CalcStep(rule: '$n × 2^$shift', expression: '${n} × ${math.pow(2,shift).toInt()}',value: '= $res'),
      CalcStep(rule: 'Answer',expression: '$n << $shift',value: '$res',isFinal:true),
    ];
  }

  static List<CalcStep> _rightShift(String eq) {
    final p = _parts(eq,'__RSH__');
    if (p.length < 2) return _usage('Right Shift','Enter number,shift','e.g. 20,2');
    final n = _i(p[0]), shift = _i(p[1]);
    final res = n >> shift;
    return [
      const CalcStep(rule: 'Right Shift >>',expression: 'n >> k  =  n ÷ 2^k',value: ''),
      CalcStep(rule: 'Binary of $n', expression:n.toRadixString(2),value: ''),
      CalcStep(rule: 'Shift right by $shift', expression: '= ${res.toRadixString(2)}',value: ''),
      CalcStep(rule: '$n ÷ 2^$shift (floor)', expression: '',value: '= $res'),
      CalcStep(rule: 'Answer',expression: '$n >> $shift',value: '$res',isFinal:true),
    ];
  }

  static List<CalcStep> _twosComp(String eq) {
    final n = int.tryParse(eq.replaceAll("__TWOS__",'').trim()) ?? 0;
    final inv = ~n;
    final twos = inv + 1;
    return [
      CalcStep(rule: "2's Complement",expression: 'Step 1: Flip bits (1s complement)',value: ''),
      CalcStep(rule: 'Original $n', expression:n.toRadixString(2).padLeft(8,'0'),value: ''),
      CalcStep(rule: "1's complement", expression:inv.toUnsigned(8).toRadixString(2).padLeft(8,'0'),value: '= $inv (signed)'),
      CalcStep(rule: "2's = 1's + 1", expression: '$inv + 1',value: '= $twos'),
      CalcStep(rule: 'Answer',expression: "2's complement of $n",value: '$twos',isFinal:true),
    ];
  }

  // ══ PHYSICS — Phase 2 ══════════════════════════════════════════

  static List<CalcStep> _planck(String eq) {
    final f = _d(_parts(eq,'__EHF__').firstOrNull??'6e14');
    const h = 6.626e-34;
    final e = h * f;
    return [
      const CalcStep(rule: "Planck's Equation",expression: 'E = hf  (h = 6.626×10⁻³⁴ J⋅s)',value: ''),
      CalcStep(rule: 'Given',expression: 'f = ${f.toStringAsExponential(2)} Hz',value: ''),
      CalcStep(rule: 'E = h × f', expression: '6.626×10⁻³⁴ × ${f.toStringAsExponential(2)}',value: '= ${e.toStringAsExponential(3)} J'),
      CalcStep(rule: 'Answer',expression: 'Photon Energy',value: '${e.toStringAsExponential(3)} J',isFinal:true),
    ];
  }

  static List<CalcStep> _escapeVel(String eq) {
    final p = _parts(eq,'__ESCV__');
    if (p.length < 2) return _usage('Escape Velocity','Enter mass(kg),radius(m)','e.g. 5.97e24,6.37e6');
    final m = _d(p[0]), r = _d(p[1]);
    const G = 6.674e-11;
    final v = math.sqrt(2 * G * m / r);
    return [
      const CalcStep(rule: 'Escape Velocity',expression: 'v = √(2GM/r)  G=6.674×10⁻¹¹',value: ''),
      CalcStep(rule: 'Given',expression: 'M=${m.toStringAsExponential(2)} kg, R=${r.toStringAsExponential(2)} m',value: ''),
      CalcStep(rule: 'v = √(2×G×M/R)', expression: '',value: '= ${_f(v)} m/s'),
      CalcStep(rule: 'In km/s', expression: '',value: '= ${_f(v/1000)} km/s'),
      CalcStep(rule: 'Answer',expression: 'Escape Velocity',value: '${_f(v/1000)} km/s',isFinal:true),
    ];
  }

  static List<CalcStep> _surfaceGravity(String eq) {
    final p = _parts(eq,'__GRAV__');
    if (p.length < 2) return _usage('Surface Gravity','Enter mass(kg),radius(m)','e.g. 5.97e24,6.37e6');
    final m = _d(p[0]), r = _d(p[1]);
    const G = 6.674e-11;
    final g = G * m / (r * r);
    return [
      const CalcStep(rule: 'Surface Gravity',expression: 'g = GM / r²  G=6.674×10⁻¹¹',value: ''),
      CalcStep(rule: 'Given',expression: 'M=${m.toStringAsExponential(2)} kg, R=${r.toStringAsExponential(2)} m',value: ''),
      CalcStep(rule: 'g = G×M/R²', expression: '',value: '= ${_f(g)} m/s²'),
      CalcStep(rule: 'Compare to Earth 9.81', expression: 'Ratio = ${_f(g/9.81)}×g',value: ''),
      CalcStep(rule: 'Answer',expression: 'Surface gravity',value: '${_f(g)} m/s²',isFinal:true),
    ];
  }

  // ══ CHEMISTRY — Phase 2 ════════════════════════════════════════

  static List<CalcStep> _gibbs(String eq) {
    final p = _parts(eq,'__GIBBS__');
    if (p.length < 3) return _usage('Gibbs Free Energy','Enter ΔH(kJ),T(K),ΔS(J/K)','e.g. -286,298,163');
    final dh = _d(p[0]), t = _d(p[1]), ds = _d(p[2]);
    final dhJ = dh * 1000;
    final dg = dhJ - t * ds;
    final dgKJ = dg / 1000;
    String spont = dg < 0 ? 'Spontaneous ✓' : dg > 0 ? 'Non-spontaneous ✗' : 'At equilibrium';
    return [
      const CalcStep(rule: 'Gibbs Free Energy',expression: 'ΔG = ΔH − TΔS',value: ''),
      CalcStep(rule: 'Given',expression: 'ΔH=${_f(dh)} kJ, T=${_f(t)} K, ΔS=${_f(ds)} J/K',value: ''),
      CalcStep(rule: 'TΔS', expression: '${_f(t)} × ${_f(ds)}',value: '= ${_f(t*ds)} J'),
      CalcStep(rule: 'ΔG = ${_f(dhJ)} − ${_f(t*ds)} J', expression: '',value: '= ${_f(dg)} J'),
      CalcStep(rule: 'ΔG in kJ', expression: '',value: '= ${_f(dgKJ)} kJ/mol'),
      CalcStep(rule: 'Spontaneity', expression: 'ΔG<0 Spontaneous | ΔG>0 Non-spont.',value:spont),
      CalcStep(rule: 'Answer',expression: 'ΔG',value: '${_f(dgKJ)} kJ/mol — $spont',isFinal:true),
    ];
  }

  static List<CalcStep> _nernst(String eq) {
    final p = _parts(eq,'__NERNST__');
    if (p.length < 4) return _usage('Nernst Equation','Enter E°(V),n(electrons),T(K),Q','e.g. 1.1,2,298,0.01');
    final e0 = _d(p[0]), n = _d(p[1]), t = _d(p[2]), q = _d(p[3]);
    const R = 8.314, F = 96485.0;
    final e = e0 - (R * t / (n * F)) * math.log(q);
    return [
      const CalcStep(rule: 'Nernst Equation',expression: 'E = E° − (RT/nF)×ln(Q)',value: ''),
      CalcStep(rule: 'Given',expression: 'E°=${_f(e0)}V, n=${_f(n)}, T=${_f(t)}K, Q=${_f(q)}',value: ''),
      CalcStep(rule: 'RT/nF', expression: '(8.314×${_f(t)})/(${_f(n)}×96485)',value: '= ${_f(R*t/(n*F))}'),
      CalcStep(rule: 'ln(Q)', expression: 'ln(${_f(q)})',value: '= ${_f(math.log(q))}'),
      CalcStep(rule: 'E = ${_f(e0)} − ${_f(R*t/(n*F))}×${_f(math.log(q))}', expression: '',value: '= ${_f(e)} V'),
      CalcStep(rule: 'Answer',expression: 'Cell potential E',value: '${_f(e)} V',isFinal:true),
    ];
  }

  static List<CalcStep> _percentComp(String eq) {
    final p = _parts(eq,'__PCOMP__');
    if (p.length < 2) return _usage('% Composition','Enter element mass, molar mass','e.g. 12,44  (C in CO₂)');
    final elementMass = _d(p[0]), molarMass = _d(p[1]);
    final pct = (elementMass / molarMass) * 100;
    return [
      const CalcStep(rule: '% Composition',expression: '% = (element mass / molar mass) × 100',value: ''),
      CalcStep(rule: 'Element mass', expression: '${_f(elementMass)} g/mol',value: ''),
      CalcStep(rule: 'Molar mass', expression: '${_f(molarMass)} g/mol',value: ''),
      CalcStep(rule: '% = (${_f(elementMass)}/${_f(molarMass)})×100', expression: '',value: '= ${_f(pct)}%'),
      CalcStep(rule: 'Answer',expression: '% by mass',value: '${_f(pct)}%',isFinal:true),
    ];
  }

  // ══ HEALTH — Phase 2 ═══════════════════════════════════════════

  static List<CalcStep> _bodyFat(String eq) {
    final p = _parts(eq,'__BFAT__');
    if (p.length < 4) return _usage('Body Fat %','Enter waist,neck,height(cm),sex(1=M,0=F)','e.g. 85,38,175,1');
    final waist=_d(p[0]),neck=_d(p[1]),height=_d(p[2]);
    final male = _i(p[3]) == 1;
    double bf;
    if (male) {
      bf = 86.010 * (math.log(waist - neck)/math.ln10) - 70.041 * (math.log(height)/math.ln10) + 36.76;
    } else {
      final hip = p.length > 4 ? _d(p[4]) : waist * 1.05;
      bf = 163.205 * (math.log(waist + hip - neck)/math.ln10) - 97.684 * (math.log(height)/math.ln10) - 78.387;
    }
    bf = bf.clamp(0, 60);
    String cat = male
        ? (bf < 6 ? 'Essential' : bf < 14 ? 'Athlete' : bf < 18 ? 'Fitness' : bf < 25 ? 'Acceptable' : 'Obese')
        : (bf < 14 ? 'Essential' : bf < 21 ? 'Athlete' : bf < 25 ? 'Fitness' : bf < 32 ? 'Acceptable' : 'Obese');
    return [
      const CalcStep(rule: 'Body Fat % (US Navy)',expression: 'Uses waist, neck, height measurements',value: ''),
      CalcStep(rule: 'Given',expression: 'Waist=${_f(waist)}cm, Neck=${_f(neck)}cm, H=${_f(height)}cm',value: ''),
      CalcStep(rule: 'Body Fat %', expression:male?'Male formula':'Female formula',value: '= ${_f(bf)}%'),
      CalcStep(rule: 'Category',expression:male?'<6 Essential | 6-13 Athlete | 14-17 Fit | 18-24 OK':'<14 Essential | 14-20 Athlete | 21-24 Fit | 25-31 OK',value:cat),
      CalcStep(rule: 'Answer',expression: 'Body Fat',value: '${_f(bf)}% — $cat',isFinal:true),
    ];
  }

  static List<CalcStep> _dailyCal(String eq) {
    final p = _parts(eq,'__DCAL__');
    if (p.length < 5) return _usage('Daily Calories','Enter weight,height,age,sex(1=M,0=F),activity(1-5)','e.g. 70,175,25,1,3');
    final w=_d(p[0]),h=_d(p[1]),age=_d(p[2]);
    final male = _i(p[3])==1;
    final act = _i(p[4]);
    final bmr = male ? 88.362+13.397*w+4.799*h-5.677*age : 447.593+9.247*w+3.098*h-4.330*age;
    const factors = [1.2, 1.375, 1.55, 1.725, 1.9];
    final factor = factors[(act-1).clamp(0,4)];
    const levels = ['Sedentary','Lightly active','Moderately active','Very active','Extra active'];
    final tdee = bmr * factor;
    return [
      const CalcStep(rule: 'Daily Calorie Need (TDEE)',expression: 'TDEE = BMR × Activity Factor',value: ''),
      CalcStep(rule: 'BMR', expression:male?'Mifflin-St Jeor (Male)':'Mifflin-St Jeor (Female)',value: '= ${_f(bmr)} kcal'),
      CalcStep(rule: 'Activity level', expression:levels[(act-1).clamp(0,4)],value: '× $factor'),
      CalcStep(rule: 'TDEE = ${_f(bmr)} × ${_f(factor)}', expression: '',value: '= ${_f(tdee)} kcal'),
      CalcStep(rule: 'Answer',expression: 'Daily calories to maintain weight',value: '${_f(tdee)} kcal',isFinal:true),
    ];
  }

  static List<CalcStep> _caloriesBurned(String eq) {
    final p = _parts(eq,'__CBURN__');
    if (p.length < 3) return _usage('Calories Burned','Enter weight(kg),distance(km),speed(kmh)','e.g. 70,5,6');
    final w=_d(p[0]),dist=_d(p[1]),speed=_d(p[2]);
    final isRun = speed > 8;
    final met = isRun ? 0.035 * speed + 3.5 : 0.1 * speed + 3.5;
    final time = dist / speed;
    final cal = met * w * time;
    return [
      CalcStep(rule: 'Calories Burned (${isRun?"Running":"Walking"})',expression: 'Cal = MET × weight × time(hr)',value: ''),
      CalcStep(rule: 'MET estimate', expression: '≈ ${_f(met)}',value: ''),
      CalcStep(rule: 'Time', expression: '${_f(dist)} km ÷ ${_f(speed)} km/h',value: '= ${_f(time)} hr'),
      CalcStep(rule: 'Cal = ${_f(met)}×${_f(w)}×${_f(time)}', expression: '',value: '= ${_f(cal)} kcal'),
      CalcStep(rule: 'Answer',expression: 'Calories burned',value: '${_f(cal)} kcal',isFinal:true),
    ];
  }

  static List<CalcStep> _runPace(String eq) {
    final p = _parts(eq,'__PACE__');
    if (p.length < 2) return _usage('Running Pace','Enter distance(km),time(minutes)','e.g. 5,30');
    final dist=_d(p[0]),mins=_d(p[1]);
    final paceMin = mins/dist;
    final paceSec = (paceMin - paceMin.floor()) * 60;
    final speed = dist/(mins/60);
    return [
      const CalcStep(rule: 'Running Pace',expression: 'Pace = time / distance',value: ''),
      CalcStep(rule: 'Pace', expression: '${_f(mins)} min ÷ ${_f(dist)} km',value: '= ${_f(paceMin)} min/km'),
      CalcStep(rule: '= ${paceMin.floor()} min ${paceSec.round()} sec / km', expression: '',value: ''),
      CalcStep(rule: 'Speed', expression: '${_f(dist)} ÷ ${_f(mins/60)} hr',value: '= ${_f(speed)} km/h'),
      CalcStep(rule: 'Answer',expression: 'Pace',value: '${paceMin.floor()}:${paceSec.round().toString().padLeft(2,'0')} min/km',isFinal:true),
    ];
  }

  // ══ NUMBER THEORY — Phase 2 ════════════════════════════════════

  static List<CalcStep> _digitalRoot(String eq) {
    final n = _i(_parts(eq,'__DIGROOT__').firstOrNull??'9875');
    int num = n.abs();
    final steps2 = <String>[];
    while (num > 9) {
      final digits = num.toString().split('').map(int.parse).toList();
      final sum = digits.reduce((a,b)=>a+b);
      steps2.add('$num → ${digits.join("+")} = $sum');
      num = sum;
    }
    return [
      CalcStep(rule: 'Digital Root',expression: 'Sum digits repeatedly until single digit',value: ''),
      CalcStep(rule: 'Starting with $n', expression: '',value: ''),
      for (final s in steps2) CalcStep(rule:s,expression: '',value: ''),
      CalcStep(rule: 'Answer',expression: 'Digital Root of $n',value: '$num',isFinal:true),
    ];
  }

  static List<CalcStep> _harshad(String eq) {
    final n = _i(_parts(eq,'__HARSH__').firstOrNull??'18');
    final digits = n.toString().split('').map(int.parse).toList();
    final digitSum = digits.reduce((a,b)=>a+b);
    final isH = n % digitSum == 0;
    return [
      CalcStep(rule: 'Harshad Number',expression: 'Is $n divisible by its digit sum?',value: ''),
      CalcStep(rule: 'Digit sum', expression:digits.join('+'),value: '= $digitSum'),
      CalcStep(rule: '$n ÷ $digitSum', expression: 'remainder = ${n % digitSum}',value:isH?'✓ divisible':'✗ not divisible'),
      CalcStep(rule: 'Answer',expression: '$n',value:isH?'✓ Harshad number':'✗ Not a Harshad number',isFinal:true),
    ];
  }

  // ══ UNIT CONVERTER — Phase 2 ═══════════════════════════════════

  static List<CalcStep> _uArea(String eq) {
    final p = _parts(eq,'__UAREA__');
    if (p.length < 3) return _usage('Area Converter','Enter value,from,to(m2,km2,cm2,ft2,in2,acre,hectare)','e.g. 1,hectare,acre');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toM2 = {'m2':1.0,'km2':1e6,'cm2':1e-4,'mm2':1e-6,'ft2':0.0929,'in2':6.452e-4,'acre':4046.86,'hectare':10000.0,'yd2':0.8361};
    if (!toM2.containsKey(from)||!toM2.containsKey(to)) {
      return [const CalcStep(rule: 'Error',expression: 'Use m2,km2,cm2,ft2,in2,acre,hectare',value: '',isFinal:true)];
    }
    final res = v*toM2[from]!/toM2[to]!;
    return [
      CalcStep(rule: 'Area Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: '${_f(v)} $from in m²', expression: '',value: '= ${_f(v*toM2[from]!)} m²'),
      CalcStep(rule: 'Convert to $to', expression: '÷ ${_f(toM2[to]!)}',value: '= ${_f(res)} $to'),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uVol(String eq) {
    final p = _parts(eq,'__UVOL__');
    if (p.length < 3) return _usage('Volume Converter','Enter value,from,to(L,mL,m3,cm3,gallon,pint,cup,floz)','e.g. 1,gallon,L');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toL = {'l':1.0,'ml':0.001,'m3':1000.0,'cm3':0.001,'gallon':3.78541,'pint':0.473176,'cup':0.236588,'floz':0.0295735,'tbsp':0.0147868,'tsp':0.00492892};
    if (!toL.containsKey(from)||!toL.containsKey(to)) {
      return [const CalcStep(rule: 'Error',expression: 'Use L,mL,m3,gallon,pint,cup,floz',value: '',isFinal:true)];
    }
    final res = v*toL[from]!/toL[to]!;
    return [
      CalcStep(rule: 'Volume Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uPressure(String eq) {
    final p = _parts(eq,'__UPRES__');
    if (p.length < 3) return _usage('Pressure Converter','Enter value,from,to(pa,kpa,bar,atm,psi,mmhg,torr)','e.g. 1,atm,pa');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toPa = {'pa':1.0,'kpa':1000.0,'mpa':1e6,'bar':1e5,'atm':101325.0,'psi':6894.76,'mmhg':133.322,'torr':133.322,'inhg':3386.39};
    if (!toPa.containsKey(from)||!toPa.containsKey(to)) {
      return [const CalcStep(rule: 'Error',expression: 'Use pa,kpa,bar,atm,psi,mmhg,torr',value: '',isFinal:true)];
    }
    final res = v*toPa[from]!/toPa[to]!;
    return [
      CalcStep(rule: 'Pressure Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: '${_f(v)} $from in Pa', expression: '',value: '= ${_f(v*toPa[from]!)} Pa'),
      CalcStep(rule: 'Convert to $to', expression: '÷ ${_f(toPa[to]!)}',value: '= ${_f(res)} $to'),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uEnergy(String eq) {
    final p = _parts(eq,'__UENRG__');
    if (p.length < 3) return _usage('Energy Converter','Enter value,from,to(j,kj,cal,kcal,kwh,btu,ev)','e.g. 1,kcal,j');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toJ = {'j':1.0,'kj':1000.0,'mj':1e6,'cal':4.184,'kcal':4184.0,'kwh':3.6e6,'btu':1055.06,'ev':1.602e-19,'wh':3600.0};
    if (!toJ.containsKey(from)||!toJ.containsKey(to)) {
      return [const CalcStep(rule: 'Error',expression: 'Use J,kJ,cal,kcal,kWh,BTU,eV',value: '',isFinal:true)];
    }
    final res = v*toJ[from]!/toJ[to]!;
    return [
      CalcStep(rule: 'Energy Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uPower(String eq) {
    final p = _parts(eq,'__UPWR__');
    if (p.length < 3) return _usage('Power Converter','Enter value,from,to(w,kw,mw,hp,btuh)','e.g. 1,hp,w');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toW = {'w':1.0,'kw':1000.0,'mw':1e6,'hp':745.7,'btuh':0.293071,'calps':4.184,'kgms':9.80665};
    if (!toW.containsKey(from)||!toW.containsKey(to)) {
      return [const CalcStep(rule: 'Error',expression: 'Use W,kW,MW,hp,btuh',value: '',isFinal:true)];
    }
    final res = v*toW[from]!/toW[to]!;
    return [
      CalcStep(rule: 'Power Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uForce(String eq) {
    final p = _parts(eq,'__UFORCE__');
    if (p.length < 3) return _usage('Force Converter','Enter value,from,to(n,kn,lbf,kgf,dyne)','e.g. 1,kgf,n');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toN = {'n':1.0,'kn':1000.0,'lbf':4.44822,'kgf':9.80665,'dyne':1e-5,'pdl':0.138255};
    if (!toN.containsKey(from)||!toN.containsKey(to)) {
      return [const CalcStep(rule: 'Error',expression: 'Use N,kN,lbf,kgf,dyne',value: '',isFinal:true)];
    }
    final res = v*toN[from]!/toN[to]!;
    return [
      CalcStep(rule: 'Force Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uFuel(String eq) {
    final p = _parts(eq,'__UFUEL__');
    if (p.length < 3) return _usage('Fuel Economy','Enter value,from,to(kml,l100km,mpg)','e.g. 15,kml,mpg');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    double toKml(double val, String unit) {
      switch(unit) {
        case 'kml': return val;
        case 'l100km': return 100/val;
        case 'mpg': return val * 0.425144;
        case 'mpguk': return val * 0.354006;
        default: return val;
      }
    }
    double fromKml(double val, String unit) {
      switch(unit) {
        case 'kml': return val;
        case 'l100km': return 100/val;
        case 'mpg': return val / 0.425144;
        case 'mpguk': return val / 0.354006;
        default: return val;
      }
    }
    final inKml = toKml(v, from);
    final res = fromKml(inKml, to);
    return [
      CalcStep(rule: 'Fuel Economy Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: '${_f(v)} $from in km/L', expression: '',value: '= ${_f(inKml)} km/L'),
      CalcStep(rule: 'Convert to $to', expression: '',value: '= ${_f(res)} $to'),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  // ══ DATE & TIME — Phase 2 ══════════════════════════════════════

  static List<CalcStep> _addDays(String eq) {
    final p = _parts(eq,'__ADDD__');
    if (p.length < 4) return _usage('Add Days','Enter day,month,year,days to add','e.g. 1,1,2024,100');
    final d=_i(p[0]),m=_i(p[1]),y=_i(p[2]),daysToAdd=_i(p[3]);
    final date = DateTime(y,m,d);
    final result = date.add(Duration(days:daysToAdd));
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return [
      CalcStep(rule: 'Add Days to Date',expression: 'Starting: $d/${m}/$y',value: ''),
      CalcStep(rule: 'Adding $daysToAdd days', expression: '',value: ''),
      CalcStep(rule: 'Answer',expression: 'Result date',value: '${result.day} ${months[result.month-1]} ${result.year}',isFinal:true),
    ];
  }

  static List<CalcStep> _countdown(String eq) {
    final p = _parts(eq,'__CDWN__');
    if (p.length < 3) return _usage('Countdown','Enter target day,month,year','e.g. 31,12,2025');
    final d=_i(p[0]),m=_i(p[1]),y=_i(p[2]);
    final target = DateTime(y,m,d);
    final now = DateTime.now();
    final diff = target.difference(now);
    final days = diff.inDays;
    if (days < 0) {
      return [
        CalcStep(rule: 'Countdown',expression: '$d/$m/$y',value: ''),
        CalcStep(rule: 'Answer',expression: 'That date has passed',value: '${days.abs()} days ago',isFinal:true),
      ];
    }
    return [
      CalcStep(rule: 'Countdown to $d/$m/$y', expression: 'From today: ${now.day}/${now.month}/${now.year}',value: ''),
      CalcStep(rule: 'Remaining', expression: '',value: '$days days'),
      CalcStep(rule: '= ${days~/7} weeks ${days%7} days', expression: '',value: ''),
      CalcStep(rule: 'Answer',expression: 'Days remaining',value: '$days days',isFinal:true),
    ];
  }

  static List<CalcStep> _daysInYear(String eq) {
    final y = _i(_parts(eq,'__DAYYR__').firstOrNull??'2024');
    final isLeap = (y%4==0 && y%100!=0) || y%400==0;
    final days = isLeap ? 366 : 365;
    final now = DateTime.now();
    final dayOfYear = now.year == y
        ? now.difference(DateTime(y,1,1)).inDays + 1
        : 0;
    return [
      CalcStep(rule: 'Days in Year $y', expression:isLeap?'Leap year':'Regular year',value: ''),
      CalcStep(rule: 'Total days', expression: '',value: '$days days'),
      if (now.year == y) CalcStep(rule: "Today is day $dayOfYear of $y", expression: '',value: '${days - dayOfYear} days remaining'),
      CalcStep(rule: 'Answer',expression: '$y has',value: '$days days',isFinal:true),
    ];
  }

  static List<CalcStep> _workingDays(String eq) {
    final p = _parts(eq,'__WDAYS__');
    if (p.length < 6) return _usage('Working Days','Enter d1,m1,y1,d2,m2,y2','e.g. 1,1,2024,31,1,2024');
    final d1 = DateTime(_i(p[2]),_i(p[1]),_i(p[0]));
    final d2 = DateTime(_i(p[5]),_i(p[4]),_i(p[3]));
    int working = 0, total = d2.difference(d1).inDays.abs();
    DateTime cur = d1.isBefore(d2) ? d1 : d2;
    final end = d1.isBefore(d2) ? d2 : d1;
    while (cur.isBefore(end) || cur.isAtSameMomentAs(end)) {
      if (cur.weekday != DateTime.saturday && cur.weekday != DateTime.sunday) working++;
      cur = cur.add(const Duration(days:1));
    }
    final weekends = total + 1 - working;
    return [
      const CalcStep(rule: 'Working Days (Mon–Fri)',expression: 'Excludes weekends',value: ''),
      CalcStep(rule: 'Date 1', expression: '${_i(p[0])}/${_i(p[1])}/${_i(p[2])}',value: ''),
      CalcStep(rule: 'Date 2', expression: '${_i(p[3])}/${_i(p[4])}/${_i(p[5])}',value: ''),
      CalcStep(rule: 'Total calendar days', expression: '',value: '${total+1}'),
      CalcStep(rule: 'Weekend days', expression: '',value: '$weekends'),
      CalcStep(rule: 'Answer',expression: 'Working days',value: '$working',isFinal:true),
    ];
  }


  // ── Percentile ─────────────────────────────────────────────────────
  static List<CalcStep> _percentile(String eq) {
    final p = _parts(eq, '__PERC__');
    if (p.length < 2) return _usage('Percentile', 'Enter k%,num1,num2,...', 'e.g. 75,10,20,30,40,50,60,70,80,90,100');
    final k = _d(p[0]);
    final nums = p.skip(1).map((s) => _d(s)).toList()..sort();
    if (nums.isEmpty) return _usage('Percentile', 'Need numbers after k', 'e.g. 75,10,20,30');
    final index = (k / 100) * (nums.length - 1);
    final lower = index.floor(), upper = index.ceil();
    final weight = index - lower;
    final val = nums[lower] * (1 - weight) + (upper < nums.length ? nums[upper] * weight : 0);
    return [
      CalcStep(rule: 'Percentile', expression: 'k=${_f(k)}%, n=${nums.length} values', value: ''),
      CalcStep(rule: 'Sorted data', expression: nums.map(_f).join(', '), value: ''),
      CalcStep(rule: 'Index = (k/100)×(n−1)', expression: '(${_f(k)}/100)×${nums.length-1}', value: '= ${_f(index)}'),
      CalcStep(rule: 'Interpolated value', expression: '', value: _f(val)),
      CalcStep(rule: 'Answer', expression: '${_f(k)}th percentile', value: _f(val), isFinal: true),
    ];
  }

  // ── Standard expression ─────────────────────────────────────────
  static List<CalcStep> _expression(String eq, {bool bodmas = false}) {
    final steps = <CalcStep>[CalcStep(rule: 'Input', expression: eq, value: '')];
    final hasTrig  = RegExp(r'(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh)\(').hasMatch(eq);
    final hasLog   = RegExp(r'(log|ln)\(').hasMatch(eq);
    final hasSqrt  = eq.contains('sqrt(');
    final hasPow   = eq.contains('^');
    final hasPct   = eq.contains('/100');

    if (bodmas) {
      final hasMixed = (eq.contains('(') || hasPow || hasTrig || hasLog || hasSqrt) &&
          (eq.contains('+') || eq.contains('-') || eq.contains('*') || eq.contains('/'));
      if (hasMixed) {
        steps.add(const CalcStep(rule: '📚 BODMAS', expression: 'Brackets → Powers → ×÷ → +−', value: ''));
      }
    }

    if (hasTrig) {
      final m = RegExp(r'(sin|cos|tan|asin|acos|atan)\((\d+\.?\d*)').firstMatch(eq);
      if (m != null) {
        final fn = m.group(1)!; final ang = m.group(2)!;
        final deg = double.tryParse(ang);
        if (deg != null && deg <= 360) {
          steps.add(CalcStep(rule: 'Convert → radians', expression: '$ang° × π/180', value: '= ${_f(deg * math.pi / 180)} rad'));
        }
        final exact = _trigExact(fn, ang);
        if (exact != null) steps.add(CalcStep(rule: 'Exact value', expression: '$fn($ang°)', value: '= $exact'));
      }
    }
    if (hasLog) steps.add(const CalcStep(rule: 'Log rule', expression: 'log=log₁₀  |  ln=logₑ', value: ''));
    if (hasSqrt) {
      final m = RegExp(r'sqrt\((\d+\.?\d*)\)').firstMatch(eq);
      if (m != null) {
        final n = double.tryParse(m.group(1) ?? '') ?? 0;
        steps.add(CalcStep(rule: 'Square root', expression: '√${m.group(1)} = ${m.group(1)}^½', value: '= ${_f(math.sqrt(n))}'));
      }
    }
    if (hasPct) steps.add(const CalcStep(rule: 'Percentage', expression: 'x% = x ÷ 100', value: ''));
    if (hasPow) {
      final m = RegExp(r'(\d+\.?\d*)\^(\d+\.?\d*)').firstMatch(eq);
      if (m != null) {
        steps.add(CalcStep(rule: 'Power', expression: '${m.group(1)}^${m.group(2)}',
            value: '= ${_f(math.pow(double.parse(m.group(1)!), double.parse(m.group(2)!)).toDouble())}'));
      }
    }
    final result = _eval(eq);
    if (result != null) {
      steps.add(CalcStep(rule: 'Simplify', expression: eq, value: '= $result'));
      steps.add(CalcStep(rule: 'Answer', expression: eq, value: result, isFinal: true));
    } else {
      steps.add(const CalcStep(rule: 'Error', expression: 'Cannot evaluate', value: 'Check input', isFinal: true));
    }
    return steps;
  }

  // ══ ALGEBRA ═══════════════════════════════════════════════════
  static List<CalcStep> _quad(String eq) {
    final p = _parts(eq, '__QUAD__');
    if (p.length < 3) return _usage('Quadratic', 'Enter a,b,c', 'e.g. 1,-5,6');
    final a = _d(p[0]), b = _d(p[1]), c = _d(p[2]);
    final disc = b*b - 4*a*c;
    final steps = [
      const CalcStep(rule: 'Quadratic', expression: 'ax² + bx + c = 0', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)}, b=${_f(b)}, c=${_f(c)}', value: ''),
      const CalcStep(rule: 'Formula', expression: 'x = (−b ± √(b²−4ac)) / 2a', value: ''),
      CalcStep(rule: 'D = b²−4ac', expression: '${_f(b*b)} − ${_f(4*a*c)}', value: '= ${_f(disc)}'),
    ];
    if (disc < 0) { steps.add(const CalcStep(rule: 'D < 0', expression: 'No real roots', value: 'Complex roots only', isFinal: true)); return steps; }
    final sq = math.sqrt(disc);
    steps.add(CalcStep(rule: '√D', expression: '√${_f(disc)}', value: '= ${_f(sq)}'));
    final x1 = (-b + sq) / (2*a), x2 = (-b - sq) / (2*a);
    steps.add(CalcStep(rule: 'x₁ = (−b+√D)/2a', expression: '(${_f(-b)}+${_f(sq)}) / ${_f(2*a)}', value: '= ${_f(x1)}'));
    if (disc > 0) {
      steps.add(CalcStep(rule: 'x₂ = (−b−√D)/2a', expression: '(${_f(-b)}−${_f(sq)}) / ${_f(2*a)}', value: '= ${_f(x2)}'));
      steps.add(CalcStep(rule: 'Answer', expression: 'Two roots', value: 'x₁=${_f(x1)},  x₂=${_f(x2)}', isFinal: true));
    } else {
      steps.add(CalcStep(rule: 'Answer', expression: 'One repeated root', value: 'x = ${_f(x1)}', isFinal: true));
    }
    return steps;
  }

  static List<CalcStep> _linear(String eq) {
    final p = _parts(eq, '__LINEAR__');
    if (p.length < 2) return _usage('Linear', 'Enter a,b for ax+b=0', 'e.g. 2,−6');
    final a = _d(p[0]), b = _d(p[1]);
    final x = -b / a;
    return [
      const CalcStep(rule: 'Linear Equation', expression: 'ax + b = 0', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)}, b=${_f(b)}', value: ''),
      CalcStep(rule: 'Solve for x', expression: 'x = −b/a = ${_f(-b)}/${_f(a)}', value: '= ${_f(x)}'),
      CalcStep(rule: 'Answer', expression: 'x', value: _f(x), isFinal: true),
    ];
  }

  static List<CalcStep> _pyth(String eq) {
    final p = _parts(eq, '__PYTH__');
    if (p.length < 2) return _usage('Pythagoras', 'Enter a,b — finds c', 'e.g. 3,4');
    final a = _d(p[0]), b = _d(p[1]);
    final c = math.sqrt(a*a + b*b);
    return [
      const CalcStep(rule: "Pythagoras", expression: 'c² = a² + b²', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)},  b=${_f(b)}', value: ''),
      CalcStep(rule: 'a² + b²', expression: '${_f(a*a)} + ${_f(b*b)}', value: '= ${_f(a*a+b*b)}'),
      CalcStep(rule: 'c = √(a²+b²)', expression: '√${_f(a*a+b*b)}', value: '= ${_f(c)}'),
      CalcStep(rule: 'Answer', expression: 'Hypotenuse', value: _f(c), isFinal: true),
    ];
  }

  static List<CalcStep> _apNth(String eq) {
    final p = _parts(eq, '__APNTH__');
    if (p.length < 3) return _usage('AP nth term', 'Enter a,d,n', 'e.g. 2,3,10');
    final a = _d(p[0]), d = _d(p[1]), n = _d(p[2]);
    final nth = a + (n-1)*d;
    return [
      const CalcStep(rule: 'AP nth Term', expression: 'aₙ = a + (n−1)d', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)}, d=${_f(d)}, n=${_f(n)}', value: ''),
      CalcStep(rule: 'aₙ = ${_f(a)} + (${_f(n)}−1)×${_f(d)}', expression: '= ${_f(a)} + ${_f((n-1)*d)}', value: '= ${_f(nth)}'),
      CalcStep(rule: 'Answer', expression: 'Term $n', value: _f(nth), isFinal: true),
    ];
  }

  static List<CalcStep> _apSum(String eq) {
    final p = _parts(eq, '__APSUM__');
    if (p.length < 3) return _usage('AP Sum', 'Enter a,d,n', 'e.g. 1,2,10');
    final a = _d(p[0]), d = _d(p[1]), n = _d(p[2]);
    final s = (n/2) * (2*a + (n-1)*d);
    return [
      const CalcStep(rule: 'AP Sum', expression: 'Sₙ = n/2 × (2a + (n−1)d)', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)}, d=${_f(d)}, n=${_f(n)}', value: ''),
      CalcStep(rule: 'Sₙ', expression: '${_f(n)}/2 × (2×${_f(a)} + (${_f(n)}−1)×${_f(d)})', value: '= ${_f(s)}'),
      CalcStep(rule: 'Answer', expression: 'Sum of $n terms', value: _f(s), isFinal: true),
    ];
  }

  static List<CalcStep> _gpNth(String eq) {
    final p = _parts(eq, '__GPNTH__');
    if (p.length < 3) return _usage('GP nth term', 'Enter a,r,n', 'e.g. 2,3,5');
    final a = _d(p[0]), r = _d(p[1]), n = _d(p[2]);
    final nth = a * math.pow(r, n-1);
    return [
      const CalcStep(rule: 'GP nth Term', expression: 'aₙ = a × rⁿ⁻¹', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)}, r=${_f(r)}, n=${_f(n)}', value: ''),
      CalcStep(rule: 'aₙ = ${_f(a)} × ${_f(r)}^${_f(n-1)}', expression: '', value: '= ${_f(nth.toDouble())}'),
      CalcStep(rule: 'Answer', expression: 'Term $n', value: _f(nth.toDouble()), isFinal: true),
    ];
  }

  static List<CalcStep> _gpSum(String eq) {
    final p = _parts(eq, '__GPSUM__');
    if (p.length < 3) return _usage('GP Sum', 'Enter a,r,n', 'e.g. 1,2,8');
    final a = _d(p[0]), r = _d(p[1]), n = _d(p[2]);
    final s = r == 1 ? a*n : a * (math.pow(r,n) - 1) / (r - 1);
    return [
      const CalcStep(rule: 'GP Sum', expression: 'Sₙ = a(rⁿ−1)/(r−1)', value: ''),
      CalcStep(rule: 'Given', expression: 'a=${_f(a)}, r=${_f(r)}, n=${_f(n)}', value: ''),
      CalcStep(rule: 'Sₙ', expression: '${_f(a)}×(${_f(r)}^${_f(n)}−1)/(${_f(r)}−1)', value: '= ${_f(s.toDouble())}'),
      CalcStep(rule: 'Answer', expression: 'Sum of $n terms', value: _f(s.toDouble()), isFinal: true),
    ];
  }

  static List<CalcStep> _ncr(String eq) {
    final tok = eq.startsWith('__NCR__') ? '__NCR__' : '__NCR__';
    final p = _parts(eq, tok);
    if (p.length < 2) return _usage('nCr', 'Enter n,r', 'e.g. 5,2');
    final n = _i(p[0]), r = _i(p[1]);
    final nf = _factorial(n), rf = _factorial(r), nrf = _factorial(n-r);
    final res = nf ~/ (rf * nrf);
    return [
      const CalcStep(rule: 'Combination', expression: 'ⁿCᵣ = n! / (r! × (n−r)!)', value: ''),
      CalcStep(rule: 'Given', expression: 'n=$n, r=$r', value: ''),
      CalcStep(rule: 'Factorials', expression: '$n!=$nf,  $r!=$rf,  ${n-r}!=$nrf', value: ''),
      CalcStep(rule: 'Calculate', expression: '$nf / ($rf × $nrf)', value: '= $res'),
      CalcStep(rule: 'Answer', expression: '${n}C$r', value: '$res', isFinal: true),
    ];
  }

  static List<CalcStep> _npr(String eq) {
    final p = _parts(eq, '__NPR__');
    if (p.length < 2) return _usage('nPr', 'Enter n,r', 'e.g. 5,2');
    final n = _i(p[0]), r = _i(p[1]);
    final nf = _factorial(n), nrf = _factorial(n-r);
    final res = nf ~/ nrf;
    return [
      const CalcStep(rule: 'Permutation', expression: 'ⁿPᵣ = n! / (n−r)!', value: ''),
      CalcStep(rule: 'Given', expression: 'n=$n, r=$r', value: ''),
      CalcStep(rule: 'Factorials', expression: '$n!=$nf,  ${n-r}!=$nrf', value: ''),
      CalcStep(rule: 'Answer', expression: '${n}P$r', value: '$res', isFinal: true),
    ];
  }

  static List<CalcStep> _fact(String eq) {
    final n = _i(_parts(eq, '__FACT__').firstOrNull ?? '5');
    final res = _factorial(n);
    return [
      CalcStep(rule: 'Factorial', expression: '$n! = $n × ${n-1} × ... × 1', value: ''),
      CalcStep(rule: 'Answer', expression: '$n!', value: '$res', isFinal: true),
    ];
  }

  static List<CalcStep> _gcd(String eq) {
    final tok = eq.startsWith('__GCD__') ? '__GCD__' : '__HCF__';
    final p = _parts(eq, tok);
    if (p.length < 2) return _usage('GCD / HCF', 'Enter a,b', 'e.g. 48,18');
    int a = _i(p[0]), b = _i(p[1]);
    final oa = a, ob = b;
    final steps = <CalcStep>[
      const CalcStep(rule: 'GCD / HCF (Euclidean)', expression: 'Repeatedly: a = b, b = a mod b', value: ''),
      CalcStep(rule: 'Given', expression: 'a=$oa, b=$ob', value: ''),
    ];
    while (b != 0) { int t = b; b = a % b; a = t; }
    steps.add(CalcStep(rule: 'Answer', expression: 'GCD($oa,$ob)', value: '$a', isFinal: true));
    return steps;
  }

  static List<CalcStep> _lcm(String eq) {
    final p = _parts(eq, '__LCM__');
    if (p.length < 2) return _usage('LCM', 'Enter a,b', 'e.g. 4,6');
    int a = _i(p[0]), b = _i(p[1]);
    final oa = a, ob = b;
    int ga = a, gb = b;
    while (gb != 0) { int t = gb; gb = ga % gb; ga = t; }
    final lcm = (oa * ob) ~/ ga;
    return [
      const CalcStep(rule: 'LCM', expression: 'LCM = (a×b) / GCD(a,b)', value: ''),
      CalcStep(rule: 'GCD($oa,$ob)', expression: '', value: '= $ga'),
      CalcStep(rule: 'LCM = ($oa×$ob)/$ga', expression: '${oa*ob}/$ga', value: '= $lcm'),
      CalcStep(rule: 'Answer', expression: 'LCM', value: '$lcm', isFinal: true),
    ];
  }

  static List<CalcStep> _cbrt(String eq) {
    final val = double.tryParse(eq.replaceAll('__CBRT__', '').trim()) ?? 0;
    final res = math.pow(val, 1/3).toDouble();
    return [
      CalcStep(rule: 'Cube Root', expression: '∛$val = $val^(1/3)', value: ''),
      CalcStep(rule: 'Answer', expression: '∛${_f(val)}', value: _f(res), isFinal: true),
    ];
  }

  // ══ STATISTICS ════════════════════════════════════════════════
  static List<CalcStep> _mean(String eq) {
    final nums = _nums(eq, '__MEAN__');
    if (nums == null) return _usage('Mean', 'Enter numbers', 'e.g. 2,4,6,8,10');
    final sum = nums.reduce((a,b)=>a+b), mean = sum/nums.length;
    return [
      const CalcStep(rule: 'Mean = Sum / Count', expression: '', value: ''),
      CalcStep(rule: 'Values', expression: nums.map(_f).join(', '), value: ''),
      CalcStep(rule: 'Sum', expression: nums.map(_f).join(' + '), value: '= ${_f(sum)}'),
      CalcStep(rule: 'n', expression: '', value: '= ${nums.length}'),
      CalcStep(rule: 'Mean = ${_f(sum)} / ${nums.length}', expression: '', value: '= ${_f(mean)}'),
      CalcStep(rule: 'Answer', expression: 'Mean', value: _f(mean), isFinal: true),
    ];
  }

  static List<CalcStep> _median(String eq) {
    final nums = _nums(eq, '__MEDIAN__');
    if (nums == null) return _usage('Median', 'Enter numbers', 'e.g. 3,1,4,1,5');
    nums.sort();
    final n = nums.length;
    final med = n.isOdd ? nums[n~/2] : (nums[n~/2-1]+nums[n~/2])/2;
    return [
      const CalcStep(rule: 'Median', expression: 'Middle value of sorted data', value: ''),
      CalcStep(rule: 'Sorted', expression: nums.map(_f).join(', '), value: ''),
      CalcStep(rule: n.isOdd ? 'Middle element' : 'Average of 2 middle', expression: '', value: _f(med)),
      CalcStep(rule: 'Answer', expression: 'Median', value: _f(med), isFinal: true),
    ];
  }

  static List<CalcStep> _mode(String eq) {
    final nums = _nums(eq, '__MODE__');
    if (nums == null) return _usage('Mode', 'Enter numbers', 'e.g. 1,2,2,3,3,3');
    final freq = <double, int>{};
    for (final n in nums) freq[n] = (freq[n] ?? 0) + 1;
    final maxFreq = freq.values.reduce(math.max);
    final modes = freq.entries.where((e) => e.value == maxFreq).map((e) => _f(e.key)).toList();
    return [
      const CalcStep(rule: 'Mode', expression: 'Most frequently occurring value', value: ''),
      CalcStep(rule: 'Frequencies', expression: freq.entries.map((e) => '${_f(e.key)}:${e.value}').join(', '), value: ''),
      CalcStep(rule: 'Answer', expression: modes.length==1 ? 'Mode' : 'Modes', value: modes.join(', '), isFinal: true),
    ];
  }

  static List<CalcStep> _sd(String eq) {
    final nums = _nums(eq, '__SD__');
    if (nums == null || nums.length < 2) return _usage('Std Dev', 'Enter numbers', 'e.g. 2,4,4,4,5,5,7,9');
    final mean = nums.reduce((a,b)=>a+b)/nums.length;
    final diffs = nums.map((x) => math.pow(x-mean, 2).toDouble()).toList();
    final variance = diffs.reduce((a,b)=>a+b)/nums.length;
    final sd = math.sqrt(variance);
    return [
      const CalcStep(rule: 'Std Dev σ', expression: 'σ = √(Σ(x−x̄)² / n)', value: ''),
      CalcStep(rule: 'Mean x̄', expression: '', value: '= ${_f(mean)}'),
      CalcStep(rule: '(x−x̄)²', expression: diffs.map(_f).join(', '), value: ''),
      CalcStep(rule: 'Σ(x−x̄)²', expression: '', value: '= ${_f(diffs.reduce((a,b)=>a+b))}'),
      CalcStep(rule: 'Variance = Σ/n', expression: '/${nums.length}', value: '= ${_f(variance)}'),
      CalcStep(rule: 'σ = √variance', expression: '√${_f(variance)}', value: '= ${_f(sd)}'),
      CalcStep(rule: 'Answer', expression: 'Std Deviation σ', value: _f(sd), isFinal: true),
    ];
  }

  static List<CalcStep> _variance(String eq) {
    final nums = _nums(eq, '__VAR__');
    if (nums == null || nums.length < 2) return _usage('Variance', 'Enter numbers', 'e.g. 2,4,4,4,5');
    final mean = nums.reduce((a,b)=>a+b)/nums.length;
    final variance = nums.map((x)=>math.pow(x-mean,2).toDouble()).reduce((a,b)=>a+b)/nums.length;
    return [
      const CalcStep(rule: 'Variance', expression: 'σ² = Σ(x−x̄)² / n', value: ''),
      CalcStep(rule: 'Mean', expression: '', value: '= ${_f(mean)}'),
      CalcStep(rule: 'Answer', expression: 'Variance σ²', value: _f(variance), isFinal: true),
    ];
  }

  static List<CalcStep> _range(String eq) {
    final nums = _nums(eq, '__RANGE__');
    if (nums == null) return _usage('Range', 'Enter numbers', 'e.g. 2,8,3,5,1');
    final mn = nums.reduce(math.min), mx = nums.reduce(math.max);
    return [
      const CalcStep(rule: 'Range', expression: 'Max − Min', value: ''),
      CalcStep(rule: 'Max', expression: '', value: '= ${_f(mx)}'),
      CalcStep(rule: 'Min', expression: '', value: '= ${_f(mn)}'),
      CalcStep(rule: 'Answer', expression: '${_f(mx)} − ${_f(mn)}', value: _f(mx-mn), isFinal: true),
    ];
  }

  static List<CalcStep> _iqr(String eq) {
    final nums = _nums(eq, '__IQR__');
    if (nums == null || nums.length < 4) return _usage('IQR', 'Enter at least 4 numbers', 'e.g. 1,2,3,4,5,6,7');
    nums.sort();
    final n = nums.length;
    final q1 = nums[n~/4], q3 = nums[(3*n)~/4];
    return [
      const CalcStep(rule: 'IQR', expression: 'Q3 − Q1', value: ''),
      CalcStep(rule: 'Sorted', expression: nums.map(_f).join(', '), value: ''),
      CalcStep(rule: 'Q1 (25th %ile)', expression: '', value: '= ${_f(q1)}'),
      CalcStep(rule: 'Q3 (75th %ile)', expression: '', value: '= ${_f(q3)}'),
      CalcStep(rule: 'Answer', expression: 'IQR = Q3−Q1', value: _f(q3-q1), isFinal: true),
    ];
  }

  static List<CalcStep> _zscore(String eq) {
    final p = _parts(eq, '__ZSCORE__');
    if (p.length < 3) return _usage('Z-score', 'Enter x,mean,sd', 'e.g. 75,70,5');
    final x = _d(p[0]), mean = _d(p[1]), sd = _d(p[2]);
    final z = (x - mean) / sd;
    return [
      const CalcStep(rule: 'Z-score', expression: 'z = (x − μ) / σ', value: ''),
      CalcStep(rule: 'Given', expression: 'x=${_f(x)}, μ=${_f(mean)}, σ=${_f(sd)}', value: ''),
      CalcStep(rule: 'z = (${_f(x)}−${_f(mean)}) / ${_f(sd)}', expression: '= ${_f(x-mean)}/${_f(sd)}', value: '= ${_f(z)}'),
      CalcStep(rule: 'Answer', expression: 'Z-score', value: _f(z), isFinal: true),
    ];
  }

  static List<CalcStep> _wmean(String eq) {
    final p = _parts(eq, '__WMEAN__');
    if (p.length < 4 || p.length.isOdd) return _usage('Weighted Mean', 'Enter x1,w1,x2,w2,...', 'e.g. 80,3,70,2,90,5');
    double sumWX = 0, sumW = 0;
    for (int i = 0; i < p.length-1; i += 2) {
      sumWX += _d(p[i]) * _d(p[i+1]);
      sumW  += _d(p[i+1]);
    }
    final wm = sumWX / sumW;
    return [
      const CalcStep(rule: 'Weighted Mean', expression: 'Σ(x×w) / Σw', value: ''),
      CalcStep(rule: 'Σ(x×w)', expression: '', value: '= ${_f(sumWX)}'),
      CalcStep(rule: 'Σw', expression: '', value: '= ${_f(sumW)}'),
      CalcStep(rule: 'Answer', expression: 'Weighted Mean', value: _f(wm), isFinal: true),
    ];
  }

  static List<CalcStep> _linreg(String eq) {
    final nums = _nums(eq, '__LINREG__');
    if (nums == null || nums.length < 4 || nums.length.isOdd)
      return _usage('Linear Regression', 'Enter x1,y1,x2,y2,...', 'e.g. 1,2,2,4,3,5');
    final xs = <double>[], ys = <double>[];
    for (int i = 0; i < nums.length-1; i += 2) { xs.add(nums[i]); ys.add(nums[i+1]); }
    final n = xs.length;
    final mx = xs.reduce((a,b)=>a+b)/n, my = ys.reduce((a,b)=>a+b)/n;
    double num = 0, den = 0;
    for (int i = 0; i < n; i++) { num += (xs[i]-mx)*(ys[i]-my); den += math.pow(xs[i]-mx,2); }
    final m = num/den, b2 = my - m*mx;
    return [
      const CalcStep(rule: 'Linear Regression', expression: 'y = mx + c', value: ''),
      CalcStep(rule: 'slope m = Σ(x−x̄)(y−ȳ)/Σ(x−x̄)²', expression: '', value: '= ${_f(m)}'),
      CalcStep(rule: 'intercept c = ȳ − m×x̄', expression: '', value: '= ${_f(b2)}'),
      CalcStep(rule: 'Answer', expression: 'y = ${_f(m)}x + ${_f(b2)}', value: 'y = ${_f(m)}x + ${_f(b2)}', isFinal: true),
    ];
  }

  static List<CalcStep> _corr(String eq) {
    final nums = _nums(eq, '__CORR__');
    if (nums == null || nums.length < 4 || nums.length.isOdd)
      return _usage('Correlation', 'Enter x1,y1,x2,y2,...', 'e.g. 1,2,2,4,3,6');
    final xs = <double>[], ys = <double>[];
    for (int i = 0; i < nums.length-1; i += 2) { xs.add(nums[i]); ys.add(nums[i+1]); }
    final n = xs.length;
    final mx = xs.reduce((a,b)=>a+b)/n, my = ys.reduce((a,b)=>a+b)/n;
    double num = 0, dx = 0, dy = 0;
    for (int i = 0; i < n; i++) {
      num += (xs[i]-mx)*(ys[i]-my);
      dx  += math.pow(xs[i]-mx, 2);
      dy  += math.pow(ys[i]-my, 2);
    }
    final r = num / math.sqrt(dx*dy);
    return [
      const CalcStep(rule: 'Pearson Correlation r', expression: 'r = Σ(x−x̄)(y−ȳ) / √(Σ(x−x̄)²×Σ(y−ȳ)²)', value: ''),
      CalcStep(rule: 'Answer', expression: 'r ranges −1 to +1', value: _f(r), isFinal: true),
    ];
  }

  // ══ FINANCE ══════════════════════════════════════════════════
  static List<CalcStep> _si(String eq) {
    final p = _parts(eq, '__SI__');
    if (p.length < 3) return _usage('Simple Interest', 'Enter P,R%,T(years)', 'e.g. 1000,5,2');
    final p1 = _d(p[0]), r = _d(p[1]), t = _d(p[2]);
    final si = (p1*r*t)/100, amt = p1+si;
    return [
      const CalcStep(rule: 'Simple Interest', expression: 'SI = (P × R × T) / 100', value: ''),
      CalcStep(rule: 'Given', expression: 'P=₹${_f(p1)}, R=${_f(r)}%, T=${_f(t)}yrs', value: ''),
      CalcStep(rule: 'SI = (${_f(p1)}×${_f(r)}×${_f(t)})/100', expression: '', value: '= ₹${_f(si)}'),
      CalcStep(rule: 'Amount = P + SI', expression: '${_f(p1)} + ${_f(si)}', value: '= ₹${_f(amt)}'),
      CalcStep(rule: 'Answer', expression: 'SI=₹${_f(si)}  |  Amount=₹${_f(amt)}', value: '₹${_f(si)}', isFinal: true),
    ];
  }

  static List<CalcStep> _ci(String eq) {
    final p = _parts(eq, '__CI__');
    if (p.length < 3) return _usage('Compound Interest', 'Enter P,R%,T,n(times/yr)', 'e.g. 1000,10,2,1');
    final p1 = _d(p[0]), r = _d(p[1]), t = _d(p[2]), n = p.length>3?_d(p[3]):1;
    final rate = r/(n*100);
    final amt = p1 * math.pow(1+rate, n*t).toDouble();
    final ci = amt - p1;
    return [
      const CalcStep(rule: 'Compound Interest', expression: 'A = P(1 + R/n)^(nT)', value: ''),
      CalcStep(rule: 'Given', expression: 'P=₹${_f(p1)}, R=${_f(r)}%, T=${_f(t)}yr, n=${_f(n)}', value: ''),
      CalcStep(rule: 'Rate/period = R/(n×100)', expression: '${_f(r)}/(${_f(n)}×100)', value: '= ${_f(rate)}'),
      CalcStep(rule: 'A = ${_f(p1)}×(1+${_f(rate)})^${_f(n*t)}', expression: '', value: '= ₹${_f(amt)}'),
      CalcStep(rule: 'CI = A − P', expression: '${_f(amt)} − ${_f(p1)}', value: '= ₹${_f(ci)}'),
      CalcStep(rule: 'Answer', expression: 'CI=₹${_f(ci)}  |  Amount=₹${_f(amt)}', value: '₹${_f(ci)}', isFinal: true),
    ];
  }

  static List<CalcStep> _emi(String eq) {
    final p = _parts(eq, '__EMI__');
    if (p.length < 3) return _usage('EMI', 'Enter P,R%(annual),N(months)', 'e.g. 100000,10,12');
    final p1 = _d(p[0]), r = _d(p[1]), n = _d(p[2]);
    final rm = r/(12*100);
    final emi = (p1*rm*math.pow(1+rm,n)) / (math.pow(1+rm,n)-1);
    final total = emi*n, interest = total-p1;
    return [
      const CalcStep(rule: 'EMI Formula', expression: 'EMI = P×r×(1+r)ⁿ / ((1+r)ⁿ−1)', value: ''),
      CalcStep(rule: 'Monthly rate r', expression: '${_f(r)}/(12×100)', value: '= ${_f(rm)}'),
      CalcStep(rule: 'Monthly EMI', expression: '', value: '= ₹${_f(emi)}'),
      CalcStep(rule: 'Total paid', expression: 'EMI × ${_f(n)} months', value: '= ₹${_f(total)}'),
      CalcStep(rule: 'Total interest', expression: 'Total − Principal', value: '= ₹${_f(interest)}'),
      CalcStep(rule: 'Answer', expression: 'Monthly EMI', value: '₹${_f(emi)}', isFinal: true),
    ];
  }

  static List<CalcStep> _gst(String eq) {
    int rate = 18;
    if (eq.startsWith('__GST5__'))  rate = 5;
    if (eq.startsWith('__GST12__')) rate = 12;
    if (eq.startsWith('__GST28__')) rate = 28;
    final tok = '__GST${rate}__';
    final p = _parts(eq, tok);
    if (p.isEmpty || p[0].trim().isEmpty) return _usage('GST +$rate%', 'Enter base amount', 'e.g. 1000');
    final val = _d(p[0]);
    final gst = val*rate/100, total = val+gst;
    return [
      CalcStep(rule: 'GST +$rate%', expression: 'GST = Amount × $rate/100', value: ''),
      CalcStep(rule: 'Base amount', expression: '₹${_f(val)}', value: ''),
      CalcStep(rule: 'GST', expression: '${_f(val)} × $rate/100', value: '= ₹${_f(gst)}'),
      CalcStep(rule: 'Total incl GST', expression: '${_f(val)} + ${_f(gst)}', value: '= ₹${_f(total)}'),
      CalcStep(rule: 'Answer', expression: 'Amount with GST', value: '₹${_f(total)}', isFinal: true),
    ];
  }

  static List<CalcStep> _rgst(String eq) {
    int rate = 18;
    if (eq.startsWith('__RGST5__'))  rate = 5;
    if (eq.startsWith('__RGST12__')) rate = 12;
    if (eq.startsWith('__RGST28__')) rate = 28;
    final tok = '__RGST${rate}__';
    final p = _parts(eq, tok);
    if (p.isEmpty) return _usage('Remove GST $rate%', 'Enter GST-inclusive amount', 'e.g. 1180');
    final val = _d(p[0]);
    final base = val/(1+rate/100), gst = val-base;
    return [
      CalcStep(rule: 'Remove GST $rate%', expression: 'Base = Amount / (1 + $rate/100)', value: ''),
      CalcStep(rule: 'GST-inclusive', expression: '₹${_f(val)}', value: ''),
      CalcStep(rule: 'Base amount', expression: '${_f(val)} / ${_f(1+rate/100)}', value: '= ₹${_f(base)}'),
      CalcStep(rule: 'GST portion', expression: '', value: '= ₹${_f(gst)}'),
      CalcStep(rule: 'Answer', expression: 'Base (excl GST)', value: '₹${_f(base)}', isFinal: true),
    ];
  }

  static List<CalcStep> _profitLoss(String eq, bool isProfit) {
    final tok = isProfit ? '__PROFIT__' : '__LOSS__';
    final p = _parts(eq, tok);
    if (p.length < 2) return _usage(isProfit?'Profit%':'Loss%', 'Enter CP,SP', 'e.g. 100,120');
    final cp = _d(p[0]), sp = _d(p[1]);
    final diff = (sp-cp).abs(), pct = (diff/cp)*100, profit = sp>cp;
    return [
      CalcStep(rule: 'Cost Price', expression: '₹${_f(cp)}', value: ''),
      CalcStep(rule: 'Selling Price', expression: '₹${_f(sp)}', value: ''),
      CalcStep(rule: profit?'Profit':'Loss', expression: '|SP−CP|', value: '= ₹${_f(diff)}'),
      CalcStep(rule: '${profit?"Profit":"Loss"} %', expression: '(${_f(diff)}/${_f(cp)})×100', value: '= ${_f(pct)}%'),
      CalcStep(rule: 'Answer', expression: '${profit?"Profit":"Loss"} %', value: '${_f(pct)}%', isFinal: true),
    ];
  }

  static List<CalcStep> _discount(String eq) {
    final p = _parts(eq, '__DISC__');
    if (p.length < 2) return _usage('Discount', 'Enter original,discount%', 'e.g. 500,20');
    final orig = _d(p[0]), disc = _d(p[1]);
    final discAmt = orig*disc/100, final_ = orig-discAmt;
    return [
      const CalcStep(rule: 'Discount', expression: 'Discount = Original × rate/100', value: ''),
      CalcStep(rule: 'Discount amount', expression: '${_f(orig)} × ${_f(disc)}/100', value: '= ₹${_f(discAmt)}'),
      CalcStep(rule: 'Final price', expression: '${_f(orig)} − ${_f(discAmt)}', value: '= ₹${_f(final_)}'),
      CalcStep(rule: 'Answer', expression: 'After ${_f(disc)}% discount', value: '₹${_f(final_)}', isFinal: true),
    ];
  }

  static List<CalcStep> _markup(String eq) {
    final p = _parts(eq, '__MARKUP__');
    if (p.length < 2) return _usage('Markup', 'Enter cost,markup%', 'e.g. 100,40');
    final cost = _d(p[0]), mu = _d(p[1]);
    final sp = cost*(1+mu/100);
    return [
      const CalcStep(rule: 'Markup', expression: 'SP = Cost × (1 + markup/100)', value: ''),
      CalcStep(rule: 'SP = ${_f(cost)} × ${_f(1+mu/100)}', expression: '', value: '= ₹${_f(sp)}'),
      CalcStep(rule: 'Answer', expression: 'Selling Price', value: '₹${_f(sp)}', isFinal: true),
    ];
  }

  static List<CalcStep> _cagr(String eq) {
    final p = _parts(eq, '__CAGR__');
    if (p.length < 3) return _usage('CAGR', 'Enter start,end,years', 'e.g. 1000,2000,5');
    final start = _d(p[0]), end = _d(p[1]), yrs = _d(p[2]);
    final cagr = (math.pow(end/start, 1/yrs).toDouble()-1)*100;
    return [
      const CalcStep(rule: 'CAGR', expression: '(End/Start)^(1/n) − 1', value: ''),
      CalcStep(rule: 'Given', expression: 'Start=₹${_f(start)}, End=₹${_f(end)}, n=${_f(yrs)}yrs', value: ''),
      CalcStep(rule: 'CAGR', expression: '(${_f(end/start)})^(1/${_f(yrs)}) − 1', value: '= ${_f(cagr)}%'),
      CalcStep(rule: 'Answer', expression: 'CAGR', value: '${_f(cagr)}%', isFinal: true),
    ];
  }

  static List<CalcStep> _roi(String eq) {
    final p = _parts(eq, '__ROI__');
    if (p.length < 2) return _usage('ROI', 'Enter cost,gain', 'e.g. 10000,15000');
    final cost = _d(p[0]), gain = _d(p[1]);
    final roi = ((gain-cost)/cost)*100;
    return [
      const CalcStep(rule: 'ROI', expression: '(Gain − Cost) / Cost × 100', value: ''),
      CalcStep(rule: 'ROI = (${_f(gain)}−${_f(cost)})/${_f(cost)}×100', expression: '', value: '= ${_f(roi)}%'),
      CalcStep(rule: 'Answer', expression: 'Return on Investment', value: '${_f(roi)}%', isFinal: true),
    ];
  }

  static List<CalcStep> _fv(String eq) {
    final p = _parts(eq, '__FV__');
    if (p.length < 3) return _usage('Future Value', 'Enter PV,rate%,years', 'e.g. 1000,8,10');
    final pv = _d(p[0]), r = _d(p[1]), n = _d(p[2]);
    final fv = pv * math.pow(1+r/100, n).toDouble();
    return [
      const CalcStep(rule: 'Future Value', expression: 'FV = PV × (1+r)ⁿ', value: ''),
      CalcStep(rule: 'FV = ${_f(pv)}×(1+${_f(r/100)})^${_f(n)}', expression: '', value: '= ₹${_f(fv)}'),
      CalcStep(rule: 'Answer', expression: 'Future Value', value: '₹${_f(fv)}', isFinal: true),
    ];
  }

  static List<CalcStep> _pv(String eq) {
    final p = _parts(eq, '__PV__');
    if (p.length < 3) return _usage('Present Value', 'Enter FV,rate%,years', 'e.g. 2000,8,10');
    final fv = _d(p[0]), r = _d(p[1]), n = _d(p[2]);
    final pv = fv / math.pow(1+r/100, n).toDouble();
    return [
      const CalcStep(rule: 'Present Value', expression: 'PV = FV / (1+r)ⁿ', value: ''),
      CalcStep(rule: 'PV = ${_f(fv)}/(1+${_f(r/100)})^${_f(n)}', expression: '', value: '= ₹${_f(pv)}'),
      CalcStep(rule: 'Answer', expression: 'Present Value', value: '₹${_f(pv)}', isFinal: true),
    ];
  }

  static List<CalcStep> _bep(String eq) {
    final p = _parts(eq, '__BEP__');
    if (p.length < 3) return _usage('Break-Even', 'Enter fixed cost,price,variable cost', 'e.g. 10000,50,30');
    final fc = _d(p[0]), price = _d(p[1]), vc = _d(p[2]);
    final bep = fc/(price-vc);
    return [
      const CalcStep(rule: 'Break-Even Point', expression: 'BEP = Fixed Cost / (Price − Variable Cost)', value: ''),
      CalcStep(rule: 'Contribution = Price−VC', expression: '${_f(price)}−${_f(vc)}', value: '= ${_f(price-vc)}'),
      CalcStep(rule: 'BEP = FC/Contribution', expression: '${_f(fc)}/${_f(price-vc)}', value: '= ${_f(bep)} units'),
      CalcStep(rule: 'Answer', expression: 'Break-even quantity', value: '${_f(bep)} units', isFinal: true),
    ];
  }

  static List<CalcStep> _tip(String eq) {
    final p = _parts(eq, '__TIP__');
    if (p.length < 3) return _usage('Tip & Split', 'Enter bill,tip%,people', 'e.g. 1200,15,4');
    final bill = _d(p[0]), tipPct = _d(p[1]), people = _d(p[2]);
    final tipAmt = bill*tipPct/100, total = bill+tipAmt, perPerson = total/people;
    return [
      const CalcStep(rule: 'Tip & Split', expression: 'Total = Bill + Tip', value: ''),
      CalcStep(rule: 'Tip ${_f(tipPct)}%', expression: '${_f(bill)} × ${_f(tipPct)}/100', value: '= ₹${_f(tipAmt)}'),
      CalcStep(rule: 'Total', expression: '${_f(bill)} + ${_f(tipAmt)}', value: '= ₹${_f(total)}'),
      CalcStep(rule: 'Per person (${_f(people)} people)', expression: '${_f(total)} / ${_f(people)}', value: '= ₹${_f(perPerson)}'),
      CalcStep(rule: 'Answer', expression: 'Each person pays', value: '₹${_f(perPerson)}', isFinal: true),
    ];
  }

  // ══ GEOMETRY ═════════════════════════════════════════════════
  static List<CalcStep> _aCircle(String eq) {
    final r = double.tryParse(eq.replaceAll('__ACIRC__','').trim()) ?? 0;
    final a = math.pi*r*r, c = 2*math.pi*r;
    return [
      const CalcStep(rule: 'Circle', expression: 'A = πr²,  C = 2πr', value: ''),
      CalcStep(rule: 'r = ${_f(r)}', expression: '', value: ''),
      CalcStep(rule: 'Area A = π × ${_f(r)}²', expression: '', value: '= ${_f(a)} units²'),
      CalcStep(rule: 'Circumference C = 2π × ${_f(r)}', expression: '', value: '= ${_f(c)} units'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(a)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _aRect(String eq) {
    final p = _parts(eq, '__ARECT__');
    if (p.length < 2) return _usage('Rectangle', 'Enter l,w', 'e.g. 5,3');
    final l = _d(p[0]), w = _d(p[1]);
    return [
      const CalcStep(rule: 'Rectangle', expression: 'A = l×w,  P = 2(l+w)', value: ''),
      CalcStep(rule: 'Area = ${_f(l)} × ${_f(w)}', expression: '', value: '= ${_f(l*w)} units²'),
      CalcStep(rule: 'Perimeter = 2(${_f(l)}+${_f(w)})', expression: '', value: '= ${_f(2*(l+w))} units'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(l*w)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _aTriangle(String eq) {
    final p = _parts(eq, '__ATRI__');
    if (p.length < 2) return _usage('Triangle', 'Enter base,height', 'e.g. 6,4');
    final b = _d(p[0]), h = _d(p[1]), a = 0.5*b*h;
    return [
      const CalcStep(rule: 'Triangle', expression: 'A = ½ × b × h', value: ''),
      CalcStep(rule: 'A = 0.5 × ${_f(b)} × ${_f(h)}', expression: '', value: '= ${_f(a)} units²'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(a)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _heron(String eq) {
    final p = _parts(eq, '__HERON__');
    if (p.length < 3) return _usage('Heron\'s Formula', 'Enter a,b,c (sides)', 'e.g. 3,4,5');
    final a = _d(p[0]), b = _d(p[1]), c = _d(p[2]);
    final s = (a+b+c)/2, area = math.sqrt(s*(s-a)*(s-b)*(s-c));
    return [
      const CalcStep(rule: 'Heron\'s Formula', expression: 'A = √(s(s−a)(s−b)(s−c))', value: ''),
      CalcStep(rule: 's = (a+b+c)/2', expression: '(${_f(a)}+${_f(b)}+${_f(c)})/2', value: '= ${_f(s)}'),
      CalcStep(rule: 'A = √(${_f(s)}×${_f(s-a)}×${_f(s-b)}×${_f(s-c)})', expression: '', value: '= ${_f(area)} units²'),
      CalcStep(rule: 'Answer', expression: 'Area by Heron\'s formula', value: '${_f(area)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _aTrap(String eq) {
    final p = _parts(eq, '__ATRAP__');
    if (p.length < 3) return _usage('Trapezoid', 'Enter a,b,h', 'e.g. 6,4,3');
    final a = _d(p[0]), b = _d(p[1]), h = _d(p[2]);
    final area = 0.5*(a+b)*h;
    return [
      const CalcStep(rule: 'Trapezoid', expression: 'A = ½(a+b)×h', value: ''),
      CalcStep(rule: 'A = ½(${_f(a)}+${_f(b)})×${_f(h)}', expression: '', value: '= ${_f(area)} units²'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(area)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _aPara(String eq) {
    final p = _parts(eq, '__APARA__');
    if (p.length < 2) return _usage('Parallelogram', 'Enter base,height', 'e.g. 8,5');
    final b = _d(p[0]), h = _d(p[1]);
    return [
      const CalcStep(rule: 'Parallelogram', expression: 'A = b × h', value: ''),
      CalcStep(rule: 'A = ${_f(b)} × ${_f(h)}', expression: '', value: '= ${_f(b*h)} units²'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(b*h)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _aSector(String eq) {
    final p = _parts(eq, '__ASECT__');
    if (p.length < 2) return _usage('Sector', 'Enter r,angle(degrees)', 'e.g. 5,60');
    final r = _d(p[0]), deg = _d(p[1]);
    final rad = deg*math.pi/180, area = 0.5*r*r*rad, arc = r*rad;
    return [
      const CalcStep(rule: 'Sector', expression: 'A = ½r²θ,  Arc = rθ (θ in radians)', value: ''),
      CalcStep(rule: 'θ = ${_f(deg)}° = ${_f(rad)} rad', expression: '', value: ''),
      CalcStep(rule: 'Area A = ½×${_f(r)}²×${_f(rad)}', expression: '', value: '= ${_f(area)} units²'),
      CalcStep(rule: 'Arc length = ${_f(r)}×${_f(rad)}', expression: '', value: '= ${_f(arc)} units'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(area)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _aEllipse(String eq) {
    final p = _parts(eq, '__AELL__');
    if (p.length < 2) return _usage('Ellipse', 'Enter semi-major a, semi-minor b', 'e.g. 5,3');
    final a = _d(p[0]), b = _d(p[1]), area = math.pi*a*b;
    return [
      const CalcStep(rule: 'Ellipse', expression: 'A = π × a × b', value: ''),
      CalcStep(rule: 'A = π × ${_f(a)} × ${_f(b)}', expression: '', value: '= ${_f(area)} units²'),
      CalcStep(rule: 'Answer', expression: 'Area', value: '${_f(area)} units²', isFinal: true),
    ];
  }

  static List<CalcStep> _vSphere(String eq) {
    final r = double.tryParse(eq.replaceAll('__VSPH__','').trim()) ?? 0;
    final v = (4/3)*math.pi*r*r*r, sa = 4*math.pi*r*r;
    return [
      const CalcStep(rule: 'Sphere', expression: 'V = (4/3)πr³,  SA = 4πr²', value: ''),
      CalcStep(rule: 'r = ${_f(r)}', expression: '', value: ''),
      CalcStep(rule: 'Volume V', expression: '(4/3)×π×${_f(r)}³', value: '= ${_f(v)} units³'),
      CalcStep(rule: 'Surface Area SA', expression: '4×π×${_f(r)}²', value: '= ${_f(sa)} units²'),
      CalcStep(rule: 'Answer', expression: 'Volume', value: '${_f(v)} units³', isFinal: true),
    ];
  }

  static List<CalcStep> _vCylinder(String eq) {
    final p = _parts(eq, '__VCYL__');
    if (p.length < 2) return _usage('Cylinder', 'Enter r,h', 'e.g. 3,5');
    final r = _d(p[0]), h = _d(p[1]);
    final v = math.pi*r*r*h, sa = 2*math.pi*r*(r+h);
    return [
      const CalcStep(rule: 'Cylinder', expression: 'V = πr²h,  SA = 2πr(r+h)', value: ''),
      CalcStep(rule: 'Volume', expression: 'π×${_f(r)}²×${_f(h)}', value: '= ${_f(v)} units³'),
      CalcStep(rule: 'Surface Area', expression: '2×π×${_f(r)}×(${_f(r)}+${_f(h)})', value: '= ${_f(sa)} units²'),
      CalcStep(rule: 'Answer', expression: 'Volume', value: '${_f(v)} units³', isFinal: true),
    ];
  }

  static List<CalcStep> _vCone(String eq) {
    final p = _parts(eq, '__VCON__');
    if (p.length < 2) return _usage('Cone', 'Enter r,h', 'e.g. 3,4');
    final r = _d(p[0]), h = _d(p[1]);
    final v = (1/3)*math.pi*r*r*h, l = math.sqrt(r*r+h*h), sa = math.pi*r*(r+l);
    return [
      const CalcStep(rule: 'Cone', expression: 'V = (1/3)πr²h', value: ''),
      CalcStep(rule: 'Slant height l = √(r²+h²)', expression: '', value: '= ${_f(l)}'),
      CalcStep(rule: 'Volume', expression: '(1/3)×π×${_f(r)}²×${_f(h)}', value: '= ${_f(v)} units³'),
      CalcStep(rule: 'Surface Area', expression: 'π×${_f(r)}×(${_f(r)}+${_f(l)})', value: '= ${_f(sa)} units²'),
      CalcStep(rule: 'Answer', expression: 'Volume', value: '${_f(v)} units³', isFinal: true),
    ];
  }

  static List<CalcStep> _vCube(String eq) {
    final s = double.tryParse(eq.replaceAll('__VCUBE__','').trim()) ?? 0;
    return [
      const CalcStep(rule: 'Cube', expression: 'V = s³,  SA = 6s²', value: ''),
      CalcStep(rule: 'Volume', expression: '${_f(s)}³', value: '= ${_f(s*s*s)} units³'),
      CalcStep(rule: 'Surface Area', expression: '6×${_f(s)}²', value: '= ${_f(6*s*s)} units²'),
      CalcStep(rule: 'Answer', expression: 'Volume', value: '${_f(s*s*s)} units³', isFinal: true),
    ];
  }

  static List<CalcStep> _vCuboid(String eq) {
    final p = _parts(eq, '__VCUBOID__');
    if (p.length < 3) return _usage('Cuboid', 'Enter l,w,h', 'e.g. 4,3,2');
    final l = _d(p[0]), w = _d(p[1]), h = _d(p[2]);
    final v = l*w*h, sa = 2*(l*w+w*h+l*h);
    return [
      const CalcStep(rule: 'Cuboid', expression: 'V = l×w×h,  SA = 2(lw+wh+lh)', value: ''),
      CalcStep(rule: 'Volume', expression: '${_f(l)}×${_f(w)}×${_f(h)}', value: '= ${_f(v)} units³'),
      CalcStep(rule: 'Surface Area', expression: '2(${_f(l*w)}+${_f(w*h)}+${_f(l*h)})', value: '= ${_f(sa)} units²'),
      CalcStep(rule: 'Answer', expression: 'Volume', value: '${_f(v)} units³', isFinal: true),
    ];
  }

  static List<CalcStep> _vPyramid(String eq) {
    final p = _parts(eq, '__VPYR__');
    if (p.length < 2) return _usage('Pyramid', 'Enter base area,height', 'e.g. 25,6');
    final ba = _d(p[0]), h = _d(p[1]), v = (1/3)*ba*h;
    return [
      const CalcStep(rule: 'Pyramid', expression: 'V = (1/3) × base area × h', value: ''),
      CalcStep(rule: 'V = (1/3)×${_f(ba)}×${_f(h)}', expression: '', value: '= ${_f(v)} units³'),
      CalcStep(rule: 'Answer', expression: 'Volume', value: '${_f(v)} units³', isFinal: true),
    ];
  }

  static List<CalcStep> _distance(String eq) {
    final p = _parts(eq, '__DIST__');
    if (p.length < 4) return _usage('Distance', 'Enter x1,y1,x2,y2', 'e.g. 0,0,3,4');
    final x1=_d(p[0]),y1=_d(p[1]),x2=_d(p[2]),y2=_d(p[3]);
    final d = math.sqrt(math.pow(x2-x1,2)+math.pow(y2-y1,2));
    return [
      const CalcStep(rule: 'Distance Formula', expression: 'd = √((x₂−x₁)²+(y₂−y₁)²)', value: ''),
      CalcStep(rule: 'Given', expression: '(${_f(x1)},${_f(y1)}) to (${_f(x2)},${_f(y2)})', value: ''),
      CalcStep(rule: 'd = √(${_f(x2-x1)}²+${_f(y2-y1)}²)', expression: '= √${_f(math.pow(x2-x1,2)+math.pow(y2-y1,2))}', value: '= ${_f(d)}'),
      CalcStep(rule: 'Answer', expression: 'Distance', value: _f(d), isFinal: true),
    ];
  }

  static List<CalcStep> _midpoint(String eq) {
    final p = _parts(eq, '__MID__');
    if (p.length < 4) return _usage('Midpoint', 'Enter x1,y1,x2,y2', 'e.g. 2,4,8,10');
    final x1=_d(p[0]),y1=_d(p[1]),x2=_d(p[2]),y2=_d(p[3]);
    final mx=(x1+x2)/2, my=(y1+y2)/2;
    return [
      const CalcStep(rule: 'Midpoint', expression: 'M = ((x₁+x₂)/2, (y₁+y₂)/2)', value: ''),
      CalcStep(rule: 'Mx = (${_f(x1)}+${_f(x2)})/2', expression: '', value: '= ${_f(mx)}'),
      CalcStep(rule: 'My = (${_f(y1)}+${_f(y2)})/2', expression: '', value: '= ${_f(my)}'),
      CalcStep(rule: 'Answer', expression: 'Midpoint', value: '(${_f(mx)}, ${_f(my)})', isFinal: true),
    ];
  }

  static List<CalcStep> _slope(String eq) {
    final p = _parts(eq, '__SLOPE__');
    if (p.length < 4) return _usage('Slope', 'Enter x1,y1,x2,y2', 'e.g. 1,2,3,6');
    final x1=_d(p[0]),y1=_d(p[1]),x2=_d(p[2]),y2=_d(p[3]);
    final m=(y2-y1)/(x2-x1), b=y1-m*x1;
    return [
      const CalcStep(rule: 'Slope', expression: 'm = (y₂−y₁)/(x₂−x₁)', value: ''),
      CalcStep(rule: 'm = (${_f(y2)}−${_f(y1)})/(${_f(x2)}−${_f(x1)})', expression: '', value: '= ${_f(m)}'),
      CalcStep(rule: 'y-intercept c = y₁−m×x₁', expression: '', value: '= ${_f(b)}'),
      CalcStep(rule: 'Answer', expression: 'Line: y = ${_f(m)}x + ${_f(b)}', value: 'm = ${_f(m)}', isFinal: true),
    ];
  }

  // ══ PHYSICS ══════════════════════════════════════════════════
  static List<CalcStep> _force(String eq) {
    final p = _parts(eq, '__FORCE__');
    if (p.length < 2) return _usage('Force', 'Enter mass(kg),acceleration(m/s²)', 'e.g. 10,9.8');
    final m=_d(p[0]),a=_d(p[1]),f=m*a;
    return [
      const CalcStep(rule: 'Newton\'s 2nd Law', expression: 'F = m × a', value: ''),
      CalcStep(rule: 'Given', expression: 'm=${_f(m)}kg, a=${_f(a)}m/s²', value: ''),
      CalcStep(rule: 'F = ${_f(m)} × ${_f(a)}', expression: '', value: '= ${_f(f)} N'),
      CalcStep(rule: 'Answer', expression: 'Force', value: '${_f(f)} N', isFinal: true),
    ];
  }

  static List<CalcStep> _ohm(String eq) {
    final p = _parts(eq, '__OHM__');
    if (p.length < 2) return _usage('Ohm\'s Law', 'Enter I(A),R(Ω)', 'e.g. 2,5');
    final i=_d(p[0]),r=_d(p[1]),v=i*r;
    return [
      const CalcStep(rule: 'Ohm\'s Law', expression: 'V = I × R', value: ''),
      CalcStep(rule: 'V = ${_f(i)} × ${_f(r)}', expression: '', value: '= ${_f(v)} V'),
      CalcStep(rule: 'Answer', expression: 'Voltage', value: '${_f(v)} V', isFinal: true),
    ];
  }

  static List<CalcStep> _ke(String eq) {
    final p = _parts(eq, '__KE__');
    if (p.length < 2) return _usage('Kinetic Energy', 'Enter m(kg),v(m/s)', 'e.g. 5,10');
    final m=_d(p[0]),v=_d(p[1]),ke=0.5*m*v*v;
    return [
      const CalcStep(rule: 'Kinetic Energy', expression: 'KE = ½mv²', value: ''),
      CalcStep(rule: 'KE = 0.5×${_f(m)}×${_f(v)}²', expression: '', value: '= ${_f(ke)} J'),
      CalcStep(rule: 'Answer', expression: 'KE', value: '${_f(ke)} J', isFinal: true),
    ];
  }

  static List<CalcStep> _pe(String eq) {
    final p = _parts(eq, '__PE__');
    if (p.length < 2) return _usage('Potential Energy', 'Enter m(kg),h(m)', 'e.g. 5,10');
    final m=_d(p[0]),h=_d(p[1]),pe=m*9.81*h;
    return [
      const CalcStep(rule: 'Potential Energy', expression: 'PE = mgh  (g=9.81 m/s²)', value: ''),
      CalcStep(rule: 'PE = ${_f(m)}×9.81×${_f(h)}', expression: '', value: '= ${_f(pe)} J'),
      CalcStep(rule: 'Answer', expression: 'PE', value: '${_f(pe)} J', isFinal: true),
    ];
  }

  static List<CalcStep> _work(String eq) {
    final p = _parts(eq, '__WORK__');
    if (p.length < 2) return _usage('Work', 'Enter F(N),d(m),angle°(optional)', 'e.g. 10,5,0');
    final f=_d(p[0]),d=_d(p[1]),angle=p.length>2?_d(p[2]):0;
    final w=f*d*math.cos(angle*math.pi/180);
    return [
      const CalcStep(rule: 'Work Done', expression: 'W = F × d × cos(θ)', value: ''),
      CalcStep(rule: 'W = ${_f(f)}×${_f(d)}×cos(${_f(angle)}°)', expression: '', value: '= ${_f(w)} J'),
      CalcStep(rule: 'Answer', expression: 'Work done', value: '${_f(w)} J', isFinal: true),
    ];
  }

  static List<CalcStep> _power(String eq) {
    final p = _parts(eq, '__POWER__');
    if (p.length < 2) return _usage('Power', 'Enter W(J),t(s)', 'e.g. 100,5');
    final w=_d(p[0]),t=_d(p[1]),pw=w/t;
    return [
      const CalcStep(rule: 'Power', expression: 'P = W / t', value: ''),
      CalcStep(rule: 'P = ${_f(w)} / ${_f(t)}', expression: '', value: '= ${_f(pw)} W'),
      CalcStep(rule: 'Answer', expression: 'Power', value: '${_f(pw)} W', isFinal: true),
    ];
  }

  static List<CalcStep> _speed(String eq) {
    final p = _parts(eq, '__SPEED__');
    if (p.length < 2) return _usage('Speed', 'Enter distance(m),time(s)', 'e.g. 100,10');
    final d=_d(p[0]),t=_d(p[1]),s=d/t;
    return [
      const CalcStep(rule: 'Speed', expression: 'v = d / t', value: ''),
      CalcStep(rule: 'v = ${_f(d)} / ${_f(t)}', expression: '', value: '= ${_f(s)} m/s'),
      CalcStep(rule: 'Answer', expression: 'Speed', value: '${_f(s)} m/s', isFinal: true),
    ];
  }

  static List<CalcStep> _momentum(String eq) {
    final p = _parts(eq, '__MOM__');
    if (p.length < 2) return _usage('Momentum', 'Enter m(kg),v(m/s)', 'e.g. 2,10');
    final m=_d(p[0]),v=_d(p[1]),mo=m*v;
    return [
      const CalcStep(rule: 'Momentum', expression: 'p = m × v', value: ''),
      CalcStep(rule: 'p = ${_f(m)} × ${_f(v)}', expression: '', value: '= ${_f(mo)} kg⋅m/s'),
      CalcStep(rule: 'Answer', expression: 'Momentum', value: '${_f(mo)} kg⋅m/s', isFinal: true),
    ];
  }

  static List<CalcStep> _impulse(String eq) {
    final p = _parts(eq, '__IMPULSE__');
    if (p.length < 2) return _usage('Impulse', 'Enter F(N),t(s)', 'e.g. 10,2');
    final f=_d(p[0]),t=_d(p[1]),j=f*t;
    return [
      const CalcStep(rule: 'Impulse', expression: 'J = F × t', value: ''),
      CalcStep(rule: 'J = ${_f(f)} × ${_f(t)}', expression: '', value: '= ${_f(j)} N⋅s'),
      CalcStep(rule: 'Answer', expression: 'Impulse', value: '${_f(j)} N⋅s', isFinal: true),
    ];
  }

  static List<CalcStep> _centripetal(String eq) {
    final p = _parts(eq, '__CENTRIP__');
    if (p.length < 3) return _usage('Centripetal Force', 'Enter m(kg),v(m/s),r(m)', 'e.g. 2,10,5');
    final m=_d(p[0]),v=_d(p[1]),r=_d(p[2]),f=m*v*v/r;
    return [
      const CalcStep(rule: 'Centripetal Force', expression: 'F = mv²/r', value: ''),
      CalcStep(rule: 'F = ${_f(m)}×${_f(v)}²/${_f(r)}', expression: '', value: '= ${_f(f)} N'),
      CalcStep(rule: 'Answer', expression: 'Centripetal Force', value: '${_f(f)} N', isFinal: true),
    ];
  }

  static List<CalcStep> _wave(String eq) {
    final p = _parts(eq, '__WAVE__');
    if (p.length < 2) return _usage('Wave Speed', 'Enter frequency(Hz),wavelength(m)', 'e.g. 440,0.78');
    final f=_d(p[0]),lam=_d(p[1]),v=f*lam;
    return [
      const CalcStep(rule: 'Wave Speed', expression: 'v = f × λ', value: ''),
      CalcStep(rule: 'v = ${_f(f)} × ${_f(lam)}', expression: '', value: '= ${_f(v)} m/s'),
      CalcStep(rule: 'Answer', expression: 'Wave Speed', value: '${_f(v)} m/s', isFinal: true),
    ];
  }

  static List<CalcStep> _emc2(String eq) {
    final m = double.tryParse(eq.replaceAll('__EMC2__','').trim()) ?? 0;
    const c = 299792458.0;
    final e = m*c*c;
    return [
      const CalcStep(rule: 'Einstein\'s E=mc²', expression: 'c = 3×10⁸ m/s', value: ''),
      CalcStep(rule: 'E = ${_f(m)} × (${_f(c)})²', expression: '', value: '= ${e.toStringAsExponential(3)} J'),
      CalcStep(rule: 'Answer', expression: 'Energy', value: e.toStringAsExponential(3), isFinal: true),
    ];
  }

  static List<CalcStep> _powerVI(String eq) {
    final p = _parts(eq, '__PWRVI__');
    if (p.length < 2) return _usage('Electrical Power', 'Enter V(volts),I(amps)', 'e.g. 230,5');
    final v=_d(p[0]),i=_d(p[1]),pw=v*i;
    return [
      const CalcStep(rule: 'Electrical Power', expression: 'P = V × I', value: ''),
      CalcStep(rule: 'P = ${_f(v)} × ${_f(i)}', expression: '', value: '= ${_f(pw)} W'),
      CalcStep(rule: 'Answer', expression: 'Power', value: '${_f(pw)} W', isFinal: true),
    ];
  }

  static List<CalcStep> _rSeries(String eq) {
    final nums = _nums(eq, '__RSERIES__');
    if (nums == null) return _usage('Resistors Series', 'Enter R1,R2,R3,...', 'e.g. 10,20,30');
    final total = nums.reduce((a,b)=>a+b);
    return [
      const CalcStep(rule: 'Resistors in Series', expression: 'R = R₁+R₂+R₃+...', value: ''),
      CalcStep(rule: 'Sum', expression: nums.map(_f).join(' + '), value: '= ${_f(total)} Ω'),
      CalcStep(rule: 'Answer', expression: 'Total Resistance', value: '${_f(total)} Ω', isFinal: true),
    ];
  }

  static List<CalcStep> _rParallel(String eq) {
    final nums = _nums(eq, '__RPARA__');
    if (nums == null) return _usage('Resistors Parallel', 'Enter R1,R2,R3,...', 'e.g. 10,20,30');
    final sumRecip = nums.map((r)=>1/r).reduce((a,b)=>a+b);
    final total = 1/sumRecip;
    return [
      const CalcStep(rule: 'Resistors in Parallel', expression: '1/R = 1/R₁+1/R₂+...', value: ''),
      CalcStep(rule: '1/R = ${nums.map((r)=>"1/${_f(r)}").join("+")}', expression: '', value: '= ${_f(sumRecip)}'),
      CalcStep(rule: 'R = 1/${_f(sumRecip)}', expression: '', value: '= ${_f(total)} Ω'),
      CalcStep(rule: 'Answer', expression: 'Total Resistance', value: '${_f(total)} Ω', isFinal: true),
    ];
  }

  static List<CalcStep> _heat(String eq) {
    final p = _parts(eq, '__HEAT__');
    if (p.length < 3) return _usage('Heat Transfer', 'Enter m(kg),c(J/kg°C),ΔT(°C)', 'e.g. 2,4186,10');
    final m=_d(p[0]),c=_d(p[1]),dt=_d(p[2]),q=m*c*dt;
    return [
      const CalcStep(rule: 'Heat Transfer', expression: 'Q = m × c × ΔT', value: ''),
      CalcStep(rule: 'Q = ${_f(m)}×${_f(c)}×${_f(dt)}', expression: '', value: '= ${_f(q)} J'),
      CalcStep(rule: 'Answer', expression: 'Heat energy', value: '${_f(q)} J', isFinal: true),
    ];
  }

  static List<CalcStep> _snell(String eq) {
    final p = _parts(eq, '__SNELL__');
    if (p.length < 3) return _usage('Snell\'s Law', 'Enter n1,θ1(°),n2', 'e.g. 1,45,1.5');
    final n1=_d(p[0]),t1=_d(p[1]),n2=_d(p[2]);
    final sinT2 = n1*math.sin(t1*math.pi/180)/n2;
    final t2 = sinT2.abs()<=1 ? math.asin(sinT2)*180/math.pi : double.nan;
    return [
      const CalcStep(rule: 'Snell\'s Law', expression: 'n₁sin(θ₁) = n₂sin(θ₂)', value: ''),
      CalcStep(rule: 'sin(θ₂) = n₁×sin(θ₁)/n₂', expression: '${_f(n1)}×sin(${_f(t1)}°)/${_f(n2)}', value: '= ${_f(sinT2)}'),
      CalcStep(rule: 'θ₂ = sin⁻¹(${_f(sinT2)})', expression: '', value: t2.isNaN ? 'Total internal reflection' : '= ${_f(t2)}°'),
      CalcStep(rule: 'Answer', expression: 'Refracted angle θ₂', value: t2.isNaN ? 'TIR' : '${_f(t2)}°', isFinal: true),
    ];
  }

  // ══ CHEMISTRY ════════════════════════════════════════════════
  static List<CalcStep> _moles(String eq) {
    final p = _parts(eq, '__MOLES__');
    if (p.length < 2) return _usage('Moles', 'Enter mass(g),molar mass(g/mol)', 'e.g. 18,18');
    final mass=_d(p[0]),mm=_d(p[1]),moles=mass/mm;
    return [
      const CalcStep(rule: 'Moles', expression: 'n = mass / molar mass', value: ''),
      CalcStep(rule: 'n = ${_f(mass)} / ${_f(mm)}', expression: '', value: '= ${_f(moles)} mol'),
      CalcStep(rule: 'Answer', expression: 'Moles', value: '${_f(moles)} mol', isFinal: true),
    ];
  }

  static List<CalcStep> _molarity(String eq) {
    final p = _parts(eq, '__MOLARITY__');
    if (p.length < 2) return _usage('Molarity', 'Enter moles,volume(L)', 'e.g. 2,0.5');
    final n=_d(p[0]),v=_d(p[1]),m=n/v;
    return [
      const CalcStep(rule: 'Molarity', expression: 'M = moles / volume(L)', value: ''),
      CalcStep(rule: 'M = ${_f(n)} / ${_f(v)}', expression: '', value: '= ${_f(m)} mol/L'),
      CalcStep(rule: 'Answer', expression: 'Molarity', value: '${_f(m)} M', isFinal: true),
    ];
  }

  static List<CalcStep> _ph(String eq) {
    final h = double.tryParse(eq.replaceAll('__PH__','').trim()) ?? 0;
    final ph = -math.log(h)/math.ln10;
    String nature = ph<7 ? 'Acidic' : ph>7 ? 'Basic' : 'Neutral';
    return [
      const CalcStep(rule: 'pH', expression: 'pH = −log[H⁺]', value: ''),
      CalcStep(rule: '[H⁺] = ${h.toStringAsExponential(3)} mol/L', expression: '', value: ''),
      CalcStep(rule: 'pH = −log(${h.toStringAsExponential(2)})', expression: '', value: '= ${_f(ph)}'),
      CalcStep(rule: 'Nature', expression: 'pH < 7 Acidic | pH = 7 Neutral | pH > 7 Basic', value: nature),
      CalcStep(rule: 'Answer', expression: 'pH', value: _f(ph), isFinal: true),
    ];
  }

  static List<CalcStep> _poh(String eq) {
    final oh = double.tryParse(eq.replaceAll('__POH__','').trim()) ?? 0;
    final poh = -math.log(oh)/math.ln10, ph = 14 - poh;
    return [
      const CalcStep(rule: 'pOH', expression: 'pOH = −log[OH⁻],  pH + pOH = 14', value: ''),
      CalcStep(rule: 'pOH = −log(${oh.toStringAsExponential(2)})', expression: '', value: '= ${_f(poh)}'),
      CalcStep(rule: 'pH = 14 − pOH', expression: '14 − ${_f(poh)}', value: '= ${_f(ph)}'),
      CalcStep(rule: 'Answer', expression: 'pOH | pH', value: '${_f(poh)} | ${_f(ph)}', isFinal: true),
    ];
  }

  static List<CalcStep> _gas(String eq) {
    final p = _parts(eq, '__GAS__');
    if (p.length < 3) return _usage('Ideal Gas PV=nRT', 'Enter P(atm),V(L),n(mol)', 'e.g. 1,22.4,1');
    final p1=_d(p[0]),v=_d(p[1]),n=_d(p[2]);
    const r=0.0821; final t = (p1*v)/(n*r);
    return [
      const CalcStep(rule: 'Ideal Gas Law', expression: 'PV = nRT  (R=0.0821 L⋅atm/mol⋅K)', value: ''),
      CalcStep(rule: 'T = PV/(nR)', expression: '(${_f(p1)}×${_f(v)})/(${_f(n)}×0.0821)', value: '= ${_f(t)} K'),
      CalcStep(rule: 'T in Celsius', expression: '${_f(t)} − 273.15', value: '= ${_f(t-273.15)} °C'),
      CalcStep(rule: 'Answer', expression: 'Temperature', value: '${_f(t)} K', isFinal: true),
    ];
  }

  static List<CalcStep> _dilution(String eq) {
    final p = _parts(eq, '__DIL__');
    if (p.length < 3) return _usage('Dilution', 'Enter M1,V1,V2 (find M2)', 'e.g. 2,100,200');
    final m1=_d(p[0]),v1=_d(p[1]),v2=_d(p[2]),m2=m1*v1/v2;
    return [
      const CalcStep(rule: 'Dilution', expression: 'M₁V₁ = M₂V₂', value: ''),
      CalcStep(rule: 'M₂ = M₁×V₁/V₂', expression: '${_f(m1)}×${_f(v1)}/${_f(v2)}', value: '= ${_f(m2)} M'),
      CalcStep(rule: 'Answer', expression: 'Final Molarity M₂', value: '${_f(m2)} M', isFinal: true),
    ];
  }

  static List<CalcStep> _halfLife(String eq) {
    final p = _parts(eq, '__HALF__');
    if (p.length < 2) return _usage('Half-Life', 'Enter N0,t½ — then time', 'e.g. 100,5730,11460');
    final n0=_d(p[0]),t12=_d(p[1]),t=p.length>2?_d(p[2]):t12;
    final n = n0 * math.pow(0.5, t/t12).toDouble();
    final k = 0.693/t12;
    return [
      const CalcStep(rule: 'Radioactive Decay', expression: 'N = N₀ × (½)^(t/t½)', value: ''),
      CalcStep(rule: 'k = 0.693/t½', expression: '0.693/${_f(t12)}', value: '= ${_f(k)} /unit time'),
      CalcStep(rule: 'N = ${_f(n0)}×(0.5)^(${_f(t)}/${_f(t12)})', expression: '', value: '= ${_f(n)}'),
      CalcStep(rule: 'Answer', expression: 'Remaining amount', value: _f(n), isFinal: true),
    ];
  }

  // ══ MATRIX ═══════════════════════════════════════════════════
  static List<CalcStep> _det2(String eq) {
    final p = _parts(eq, '__DET2__');
    if (p.length < 4) return [];
    final a=_d(p[0]),b=_d(p[1]),c=_d(p[2]),d=_d(p[3]);
    final det = a*d - b*c;
    return [
      const CalcStep(rule: '2×2 Determinant', expression: '|A| = (a×d) − (b×c)', value: ''),
      CalcStep(rule: 'Matrix', expression: '[${_f(a)} ${_f(b)}] [${_f(c)} ${_f(d)}]', value: ''),
      CalcStep(rule: '(a×d) − (b×c)', expression: '(${_f(a)}×${_f(d)}) − (${_f(b)}×${_f(c)})', value: '= ${_f(a*d)} − ${_f(b*c)}'),
      CalcStep(rule: 'Answer', expression: '|A|', value: _f(det), isFinal: true),
    ];
  }

  static List<CalcStep> _det3(String eq) {
    final p = _parts(eq, '__DET3__');
    if (p.length < 9) return [];
    final a=_d(p[0]),b=_d(p[1]),c=_d(p[2]);
    final d=_d(p[3]),e=_d(p[4]),f=_d(p[5]);
    final g=_d(p[6]),h=_d(p[7]),i=_d(p[8]);
    final pA=a*(e*i-f*h), pB=b*(d*i-f*g), pC=c*(d*h-e*g);
    final det=pA-pB+pC;
    return [
      const CalcStep(rule: '3×3 Determinant', expression: '|A| = a(ei−fh) − b(di−fg) + c(dh−eg)', value: ''),
      CalcStep(rule: 'Cofactor expansion', expression: '', value: ''),
      CalcStep(rule: 'a(ei−fh)', expression: '${_f(a)}(${_f(e*i-f*h)})', value: '= ${_f(pA)}'),
      CalcStep(rule: 'b(di−fg)', expression: '${_f(b)}(${_f(d*i-f*g)})', value: '= ${_f(pB)}'),
      CalcStep(rule: 'c(dh−eg)', expression: '${_f(c)}(${_f(d*h-e*g)})', value: '= ${_f(pC)}'),
      CalcStep(rule: '|A| = ${_f(pA)} − ${_f(pB)} + ${_f(pC)}', expression: '', value: '= ${_f(det)}'),
      CalcStep(rule: 'Answer', expression: '|A|', value: _f(det), isFinal: true),
    ];
  }

  static List<CalcStep> _inv2(String eq) {
    final p = _parts(eq, '__INV2__');
    if (p.length < 4) return [];
    final a=_d(p[0]),b=_d(p[1]),c=_d(p[2]),d=_d(p[3]);
    final det = a*d - b*c;
    if (det == 0) {
      return [const CalcStep(rule: 'No Inverse', expression: 'Determinant = 0', value: 'Matrix is singular', isFinal: true)];
    }
    final ia=d/det, ib=-b/det, ic=-c/det, id2=a/det;
    return [
      const CalcStep(rule: '2×2 Inverse', expression: 'A⁻¹ = (1/|A|) × [d −b; −c a]', value: ''),
      CalcStep(rule: '|A| = ${_f(a*d)} − ${_f(b*c)}', expression: '', value: '= ${_f(det)}'),
      CalcStep(rule: 'A⁻¹', expression: '[${_f(ia)} ${_f(ib)}]  [${_f(ic)} ${_f(id2)}]', value: ''),
      CalcStep(rule: 'Answer', expression: 'Inverse matrix', value: '[${_f(ia)}, ${_f(ib)}; ${_f(ic)}, ${_f(id2)}]', isFinal: true),
    ];
  }

  static List<CalcStep> _cramer2(String eq) {
    final p = _parts(eq, '__CRAMER2__');
    if (p.length < 6) return _usage('Cramer\'s Rule 2×2', 'Enter a1,b1,c1,a2,b2,c2', 'e.g. 2,1,5,3,-1,1');
    final a1=_d(p[0]),b1=_d(p[1]),c1=_d(p[2]);
    final a2=_d(p[3]),b2=_d(p[4]),c2=_d(p[5]);
    final d=a1*b2-b1*a2, dx=c1*b2-b1*c2, dy=a1*c2-c1*a2;
    if (d == 0) return [const CalcStep(rule: 'No Solution', expression: 'D=0', value: 'No unique solution', isFinal: true)];
    final x=dx/d, y=dy/d;
    return [
      const CalcStep(rule: 'Cramer\'s Rule', expression: 'a₁x+b₁y=c₁,  a₂x+b₂y=c₂', value: ''),
      CalcStep(rule: 'D = a₁b₂−b₁a₂', expression: '', value: '= ${_f(d)}'),
      CalcStep(rule: 'Dx = c₁b₂−b₁c₂', expression: '', value: '= ${_f(dx)}'),
      CalcStep(rule: 'Dy = a₁c₂−c₁a₂', expression: '', value: '= ${_f(dy)}'),
      CalcStep(rule: 'x = Dx/D', expression: '${_f(dx)}/${_f(d)}', value: '= ${_f(x)}'),
      CalcStep(rule: 'y = Dy/D', expression: '${_f(dy)}/${_f(d)}', value: '= ${_f(y)}'),
      CalcStep(rule: 'Answer', expression: 'Solution', value: 'x=${_f(x)},  y=${_f(y)}', isFinal: true),
    ];
  }

  // ══ TRIG EXTRAS ══════════════════════════════════════════════
  static List<CalcStep> _sec(String eq) {
    final x = double.tryParse(eq.replaceAll('__SEC__','').trim()) ?? 0;
    final rad = x*math.pi/180, v = 1/math.cos(rad);
    return [
      const CalcStep(rule: 'Secant', expression: 'sec(x) = 1 / cos(x)', value: ''),
      CalcStep(rule: 'sec(${_f(x)}°)', expression: '1/cos(${_f(x)}°)', value: '= ${_f(v)}'),
      CalcStep(rule: 'Answer', expression: 'sec(${_f(x)}°)', value: _f(v), isFinal: true),
    ];
  }

  static List<CalcStep> _csc(String eq) {
    final x = double.tryParse(eq.replaceAll('__CSC__','').trim()) ?? 0;
    final rad = x*math.pi/180, v = 1/math.sin(rad);
    return [
      const CalcStep(rule: 'Cosecant', expression: 'cosec(x) = 1 / sin(x)', value: ''),
      CalcStep(rule: 'cosec(${_f(x)}°)', expression: '1/sin(${_f(x)}°)', value: '= ${_f(v)}'),
      CalcStep(rule: 'Answer', expression: 'cosec(${_f(x)}°)', value: _f(v), isFinal: true),
    ];
  }

  static List<CalcStep> _cot(String eq) {
    final x = double.tryParse(eq.replaceAll('__COT__','').trim()) ?? 0;
    final rad = x*math.pi/180, v = math.cos(rad)/math.sin(rad);
    return [
      const CalcStep(rule: 'Cotangent', expression: 'cot(x) = cos(x)/sin(x)', value: ''),
      CalcStep(rule: 'cot(${_f(x)}°)', expression: '', value: '= ${_f(v)}'),
      CalcStep(rule: 'Answer', expression: 'cot(${_f(x)}°)', value: _f(v), isFinal: true),
    ];
  }

  static List<CalcStep> _logBase(String eq) {
    final p = _parts(eq, '__LOGN__');
    if (p.length < 2) return _usage('Log base n', 'Enter x,base', 'e.g. 1000,10');
    final x=_d(p[0]),base=_d(p[1]),v=math.log(x)/math.log(base);
    return [
      const CalcStep(rule: 'Log change of base', expression: 'log_b(x) = ln(x)/ln(b)', value: ''),
      CalcStep(rule: 'log_${_f(base)}(${_f(x)})', expression: 'ln(${_f(x)})/ln(${_f(base)})', value: '= ${_f(v)}'),
      CalcStep(rule: 'Answer', expression: 'log_${_f(base)}(${_f(x)})', value: _f(v), isFinal: true),
    ];
  }

  static List<CalcStep> _sumN(String eq) {
    final n = _i(_parts(eq,'__SUMN__').firstOrNull??'10');
    final s = n*(n+1)~/2;
    return [
      const CalcStep(rule: 'Sum of 1..n', expression: 'S = n(n+1)/2', value: ''),
      CalcStep(rule: 'S = $n×${n+1}/2', expression: '', value: '= $s'),
      CalcStep(rule: 'Answer', expression: 'Sum 1 to $n', value: '$s', isFinal: true),
    ];
  }

  static List<CalcStep> _sumN2(String eq) {
    final n = _i(_parts(eq,'__SUMN2__').firstOrNull??'10');
    final s = n*(n+1)*(2*n+1)~/6;
    return [
      const CalcStep(rule: 'Sum of squares', expression: 'S = n(n+1)(2n+1)/6', value: ''),
      CalcStep(rule: 'Answer', expression: '1²+2²+...+$n²', value: '$s', isFinal: true),
    ];
  }

  static List<CalcStep> _sumN3(String eq) {
    final n = _i(_parts(eq,'__SUMN3__').firstOrNull??'10');
    final s = math.pow(n*(n+1)~/2, 2).toInt();
    return [
      const CalcStep(rule: 'Sum of cubes', expression: 'S = (n(n+1)/2)²', value: ''),
      CalcStep(rule: 'Answer', expression: '1³+2³+...+$n³', value: '$s', isFinal: true),
    ];
  }

  // ══ NUMBER THEORY ═════════════════════════════════════════════
  static List<CalcStep> _isPrime(String eq) {
    final n = _i(_parts(eq,'__ISPRIME__').firstOrNull??'17');
    bool prime = n > 1;
    for (int i=2; i<=math.sqrt(n.toDouble()).toInt(); i++) { if(n%i==0){prime=false;break;} }
    return [
      CalcStep(rule: 'Prime Check', expression: 'Is $n prime?', value: ''),
      CalcStep(rule: 'Check divisors 2 to √$n', expression: '', value: prime?'None found':'Divisor found'),
      CalcStep(rule: 'Answer', expression: '$n', value: prime?'✓ Prime':'✗ Not prime', isFinal: true),
    ];
  }

  static List<CalcStep> _primeFact(String eq) {
    int n = _i(_parts(eq,'__PFACT__').firstOrNull??'60');
    final orig = n;
    final facts = <int>[];
    for (int i=2; i*i<=n; i++) { while(n%i==0){facts.add(i);n~/=i;} }
    if (n>1) facts.add(n);
    return [
      CalcStep(rule: 'Prime Factorization', expression: '$orig', value: ''),
      CalcStep(rule: 'Factors', expression: facts.join(' × '), value: '= $orig'),
      CalcStep(rule: 'Answer', expression: 'Prime factors of $orig', value: facts.join(' × '), isFinal: true),
    ];
  }

  static List<CalcStep> _fibonacci(String eq) {
    final n = _i(_parts(eq,'__FIB__').firstOrNull??'10');
    final seq = <int>[0,1];
    for(int i=2;i<n;i++) seq.add(seq[i-1]+seq[i-2]);
    return [
      CalcStep(rule: 'Fibonacci', expression: 'First $n terms', value: ''),
      CalcStep(rule: 'Sequence', expression: seq.take(n).join(', '), value: ''),
      CalcStep(rule: 'Answer', expression: 'Term $n', value: '${seq[n-1]}', isFinal: true),
    ];
  }

  static List<CalcStep> _armstrong(String eq) {
    final n = _i(_parts(eq,'__ARM__').firstOrNull??'153');
    final digits = n.toString().split('').map(int.parse).toList();
    final p = digits.length;
    final sum = digits.map((d)=>math.pow(d,p).toInt()).reduce((a,b)=>a+b);
    final is_ = sum == n;
    return [
      CalcStep(rule: 'Armstrong Number', expression: 'Sum of digits^$p = $n?', value: ''),
      CalcStep(rule: 'Digits: ${digits.join(",$p → ")}$p', expression: 'Sum = $sum', value: ''),
      CalcStep(rule: 'Answer', expression: '$n', value: is_?'✓ Armstrong':'✗ Not Armstrong', isFinal: true),
    ];
  }

  static List<CalcStep> _perfect(String eq) {
    final n = _i(_parts(eq,'__PERF__').firstOrNull??'28');
    final divs = <int>[];
    for(int i=1;i<n;i++) if(n%i==0) divs.add(i);
    final sum = divs.isEmpty?0:divs.reduce((a,b)=>a+b);
    return [
      CalcStep(rule: 'Perfect Number', expression: 'Sum of proper divisors = $n?', value: ''),
      CalcStep(rule: 'Divisors', expression: divs.join(', '), value: ''),
      CalcStep(rule: 'Sum = $sum', expression: '', value: sum==n?'= $n ✓':'≠ $n ✗'),
      CalcStep(rule: 'Answer', expression: '$n', value: sum==n?'✓ Perfect':'✗ Not Perfect', isFinal: true),
    ];
  }

  static List<CalcStep> _palindrome(String eq) {
    final s = eq.replaceAll('__PALIN__','').trim();
    final rev = s.split('').reversed.join('');
    final is_ = s == rev;
    return [
      CalcStep(rule: 'Palindrome Check', expression: '$s', value: ''),
      CalcStep(rule: 'Reversed', expression: rev, value: ''),
      CalcStep(rule: 'Answer', expression: '$s', value: is_?'✓ Palindrome':'✗ Not Palindrome', isFinal: true),
    ];
  }

  static List<CalcStep> _euler(String eq) {
    final orig = _i(_parts(eq,'__EULER__').firstOrNull??'12');
    int temp = orig;
    int phi = orig;
    for (int p2=2; p2*p2<=temp; p2++) {
      if (temp%p2==0) {
        while(temp%p2==0) temp~/=p2;
        phi -= phi~/p2;
      }
    }
    if (temp>1) phi -= phi~/temp;
    return [
      CalcStep(rule: 'Euler\'s Totient φ(n)', expression: 'Count integers 1..n coprime to n', value: ''),
      CalcStep(rule: 'φ($orig)', expression: '', value: '= $phi'),
      CalcStep(rule: 'Answer', expression: 'φ($orig)', value: '$phi', isFinal: true),
    ];
  }

  static List<CalcStep> _roman(String eq) {
    int n = _i(_parts(eq,'__ROMAN__').firstOrNull??'2024');
    const vals = [1000,900,500,400,100,90,50,40,10,9,5,4,1];
    const syms = ['M','CM','D','CD','C','XC','L','XL','X','IX','V','IV','I'];
    String roman = '';
    int rem = n;
    for(int i=0;i<vals.length;i++){while(rem>=vals[i]){roman+=syms[i];rem-=vals[i];}}
    return [
      CalcStep(rule: 'Roman Numerals', expression: '$n', value: ''),
      CalcStep(rule: 'Answer', expression: '$n in Roman', value: roman, isFinal: true),
    ];
  }

  // ══ HEALTH ════════════════════════════════════════════════════
  static List<CalcStep> _bmi(String eq) {
    final p = _parts(eq, '__BMI__');
    if (p.length < 2) return _usage('BMI', 'Enter weight(kg),height(m)', 'e.g. 70,1.75');
    final w=_d(p[0]),h=_d(p[1]),bmi=w/(h*h);
    String cat = bmi<18.5?'Underweight':bmi<25?'Normal weight':bmi<30?'Overweight':'Obese';
    return [
      const CalcStep(rule: 'BMI', expression: 'BMI = weight / height²', value: ''),
      CalcStep(rule: 'Given', expression: '${_f(w)}kg, ${_f(h)}m', value: ''),
      CalcStep(rule: 'BMI = ${_f(w)} / ${_f(h)}²', expression: '', value: '= ${_f(bmi)}'),
      CalcStep(rule: 'Category', expression: '<18.5 Under | 18.5-25 Normal | 25-30 Over | >30 Obese', value: cat),
      CalcStep(rule: 'Answer', expression: 'BMI', value: '${_f(bmi)} — $cat', isFinal: true),
    ];
  }

  static List<CalcStep> _bmr(String eq) {
    final p = _parts(eq, '__BMR__');
    if (p.length < 4) return _usage('BMR', 'Enter weight(kg),height(cm),age,sex(1=M,0=F)', 'e.g. 70,175,25,1');
    final w=_d(p[0]),h=_d(p[1]),age=_d(p[2]);
    final male = (_i(p[3]))==1;
    final bmr = male ? 88.362+13.397*w+4.799*h-5.677*age : 447.593+9.247*w+3.098*h-4.330*age;
    return [
      const CalcStep(rule: 'BMR (Mifflin-St Jeor)', expression: 'Calories burned at rest', value: ''),
      CalcStep(rule: 'Formula', expression: male?'88.36+13.4w+4.8h−5.68a':'447.6+9.25w+3.1h−4.33a', value: ''),
      CalcStep(rule: 'BMR', expression: '', value: '= ${_f(bmr)} kcal/day'),
      CalcStep(rule: 'Answer', expression: 'Daily calorie need (rest)', value: '${_f(bmr)} kcal', isFinal: true),
    ];
  }

  static List<CalcStep> _idealWeight(String eq) {
    final p = _parts(eq, '__IDWT__');
    if (p.length < 2) return _usage('Ideal Weight', 'Enter height(cm),sex(1=M,0=F)', 'e.g. 175,1');
    final h=_d(p[0]); final male=(_i(p[1]))==1;
    final iw = male ? 50 + 0.91*(h-152.4) : 45.5 + 0.91*(h-152.4);
    return [
      const CalcStep(rule: 'Ideal Body Weight (Devine)', expression: 'M: 50+0.91(h−152.4)  F: 45.5+0.91(h−152.4)', value: ''),
      CalcStep(rule: 'h=${_f(h)}cm, ${male?"Male":"Female"}', expression: '', value: ''),
      CalcStep(rule: 'Answer', expression: 'Ideal Weight', value: '${_f(iw)} kg', isFinal: true),
    ];
  }

  static List<CalcStep> _maxHR(String eq) {
    final age = _i(_parts(eq,'__MHR__').firstOrNull??'25');
    final mhr = 220 - age;
    return [
      const CalcStep(rule: 'Max Heart Rate', expression: 'MHR = 220 − age', value: ''),
      CalcStep(rule: 'MHR = 220 − $age', expression: '', value: '= $mhr bpm'),
      CalcStep(rule: 'Answer', expression: 'Max Heart Rate', value: '$mhr bpm', isFinal: true),
    ];
  }

  static List<CalcStep> _targetHR(String eq) {
    final p = _parts(eq, '__THR__');
    if (p.length < 2) return _usage('Target HR', 'Enter age,intensity%(50-85)', 'e.g. 30,70');
    final age=_i(p[0]), pct=_d(p[1]);
    final mhr=220-age, thr=mhr*pct/100;
    return [
      const CalcStep(rule: 'Target Heart Rate', expression: 'THR = MHR × intensity%', value: ''),
      CalcStep(rule: 'MHR = 220 − $age', expression: '', value: '= $mhr bpm'),
      CalcStep(rule: 'THR = $mhr × ${_f(pct)}%', expression: '', value: '= ${_f(thr)} bpm'),
      CalcStep(rule: 'Answer', expression: 'Target HR at ${_f(pct)}%', value: '${_f(thr)} bpm', isFinal: true),
    ];
  }

  static List<CalcStep> _water(String eq) {
    final w = _d(_parts(eq,'__WATER__').firstOrNull??'70');
    final liters = w * 0.033;
    return [
      const CalcStep(rule: 'Daily Water Intake', expression: 'Water = weight × 0.033 litres', value: ''),
      CalcStep(rule: '${_f(w)}kg × 0.033', expression: '', value: '= ${_f(liters)} L'),
      CalcStep(rule: 'Answer', expression: 'Recommended daily water', value: '${_f(liters)} L', isFinal: true),
    ];
  }

  static List<CalcStep> _whr(String eq) {
    final p = _parts(eq, '__WHR__');
    if (p.length < 2) return _usage('Waist-Hip Ratio', 'Enter waist(cm),hip(cm)', 'e.g. 80,95');
    final w=_d(p[0]),h=_d(p[1]),r=w/h;
    String risk = r<0.85?'Low risk':'High risk (cardiovascular)';
    return [
      const CalcStep(rule: 'Waist-Hip Ratio', expression: 'WHR = waist / hip', value: ''),
      CalcStep(rule: '${_f(w)} / ${_f(h)}', expression: '', value: '= ${_f(r)}'),
      CalcStep(rule: 'Risk', expression: '<0.85 Low | >0.85 High', value: risk),
      CalcStep(rule: 'Answer', expression: 'WHR', value: '${_f(r)} — $risk', isFinal: true),
    ];
  }

  static List<CalcStep> _pregnancy(String eq) {
    final p = _parts(eq, '__PREG__');
    if (p.length < 3) return _usage('Due Date', 'Enter LMP day,month,year', 'e.g. 1,3,2025');
    final day=_i(p[0]),month=_i(p[1]),year=_i(p[2]);
    final lmp = DateTime(year,month,day);
    final due = lmp.add(const Duration(days: 280));
    return [
      const CalcStep(rule: 'Naegele\'s Rule', expression: 'Due = LMP + 280 days', value: ''),
      CalcStep(rule: 'LMP date', expression: '$day/$month/$year', value: ''),
      CalcStep(rule: 'Answer', expression: 'Estimated Due Date', value: '${due.day}/${due.month}/${due.year}', isFinal: true),
    ];
  }

  // ══ DATE & TIME ═══════════════════════════════════════════════
  static List<CalcStep> _age(String eq) {
    final p = _parts(eq, '__AGE__');
    if (p.length < 3) return _usage('Age Calculator', 'Enter day,month,year of birth', 'e.g. 15,8,2000');
    final day=_i(p[0]),month=_i(p[1]),year=_i(p[2]);
    final dob = DateTime(year,month,day);
    final now = DateTime.now();
    int years = now.year-dob.year;
    int months = now.month-dob.month;
    int days = now.day-dob.day;
    if(days<0){months--;days+=30;}
    if(months<0){years--;months+=12;}
    return [
      const CalcStep(rule: 'Age Calculator', expression: 'Today\'s date − Date of birth', value: ''),
      CalcStep(rule: 'DOB', expression: '$day/$month/$year', value: ''),
      CalcStep(rule: 'Today', expression: '${now.day}/${now.month}/${now.year}', value: ''),
      CalcStep(rule: 'Answer', expression: 'Age', value: '$years yrs $months mo $days days', isFinal: true),
    ];
  }

  static List<CalcStep> _daysBetween(String eq) {
    final p = _parts(eq, '__DAYS__');
    if (p.length < 6) return _usage('Days Between', 'Enter d1,m1,y1,d2,m2,y2', 'e.g. 1,1,2024,1,1,2025');
    final d1=DateTime(_i(p[2]),_i(p[1]),_i(p[0]));
    final d2=DateTime(_i(p[5]),_i(p[4]),_i(p[3]));
    final diff=d2.difference(d1).inDays.abs();
    return [
      const CalcStep(rule: 'Days Between Dates', expression: '|Date2 − Date1|', value: ''),
      CalcStep(rule: 'Date 1', expression: '${_i(p[0])}/${_i(p[1])}/${_i(p[2])}', value: ''),
      CalcStep(rule: 'Date 2', expression: '${_i(p[3])}/${_i(p[4])}/${_i(p[5])}', value: ''),
      CalcStep(rule: 'Answer', expression: 'Difference', value: '$diff days', isFinal: true),
    ];
  }

  static List<CalcStep> _dayOfWeek(String eq) {
    final p = _parts(eq, '__DOW__');
    if (p.length < 3) return _usage('Day of Week', 'Enter day,month,year', 'e.g. 15,8,2024');
    final d=DateTime(_i(p[2]),_i(p[1]),_i(p[0]));
    const days=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return [
      CalcStep(rule: 'Day of Week', expression: '${_i(p[0])}/${_i(p[1])}/${_i(p[2])}', value: ''),
      CalcStep(rule: 'Answer', expression: 'Day', value: days[d.weekday-1], isFinal: true),
    ];
  }

  static List<CalcStep> _leapYear(String eq) {
    final n = _i(_parts(eq,'__LEAP__').firstOrNull??'2024');
    final is_ = (n%4==0 && n%100!=0) || n%400==0;
    return [
      const CalcStep(rule: 'Leap Year', expression: 'Div by 4 (not 100) OR div by 400', value: ''),
      CalcStep(rule: '$n', expression: '', value: ''),
      CalcStep(rule: 'Answer', expression: '$n', value: is_?'✓ Leap year':'✗ Not a leap year', isFinal: true),
    ];
  }

  // ══ BASE CONVERSION ═══════════════════════════════════════════
  static List<CalcStep> _baseConvert(String eq) {
    String base='HEX', token='__HEX__';
    if(eq.startsWith('__BIN__')){base='BIN';token='__BIN__';}
    if(eq.startsWith('__OCT__')){base='OCT';token='__OCT__';}
    if(eq.startsWith('__DEC__')){base='DEC';token='__DEC__';}
    final raw=eq.replaceAll(token,'').trim();
    if(raw.isEmpty) return _usage('Base Converter','Type number then tap →$base','e.g. 255');
    try {
      int n;
      if(raw.startsWith('0x')) n=int.parse(raw.substring(2),radix:16);
      else if(raw.startsWith('0b')) n=int.parse(raw.substring(2),radix:2);
      else if(raw.startsWith('0o')) n=int.parse(raw.substring(2),radix:8);
      else n=double.parse(raw).toInt();
      final conv = switch(base){
        'HEX'=>'0x${n.toRadixString(16).toUpperCase()}',
        'BIN'=>'0b${n.toRadixString(2)}',
        'OCT'=>'0o${n.toRadixString(8)}',
        _=>'$n',
      };
      return [
        CalcStep(rule: 'Base Conversion',expression: 'Decimal: $n',value: ''),
        CalcStep(rule: '→ $base',expression: '',value:conv),
        CalcStep(rule: 'Answer',expression:base,value:conv,isFinal:true),
      ];
    } catch(_) {
      return [const CalcStep(rule: 'Error',expression: 'Invalid number',value: '',isFinal:true)];
    }
  }

  static List<CalcStep> _bitwiseNot(String eq) {
    final n=int.tryParse(eq.replaceAll('__NOT__','').trim())??0;
    final r=~n;
    return [
      CalcStep(rule: 'Bitwise NOT',expression: '~$n',value: '= $r'),
      CalcStep(rule: 'Answer',expression: 'NOT $n',value: '$r',isFinal:true),
    ];
  }

  // ══ UNIT CONVERTER ════════════════════════════════════════════
  static List<CalcStep> _uLen(String eq) {
    final p=_parts(eq,'__ULEN__');
    if(p.length<3) return _usage('Length','Enter value,from,to\n(km,m,cm,mm,mile,ft,in)','e.g. 1,km,m');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toM={'km':1000.0,'m':1.0,'cm':0.01,'mm':0.001,'mile':1609.34,'ft':0.3048,'in':0.0254,'yard':0.9144,'nm':1852.0};
    if(!toM.containsKey(from)||!toM.containsKey(to)) return [const CalcStep(rule: 'Error',expression: 'Unknown unit',value: '',isFinal:true)];
    final res=v*toM[from]!/toM[to]!;
    return [
      CalcStep(rule: 'Length Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: '${_f(v)} $from in metres',expression: '',value: '= ${_f(v*toM[from]!)} m'),
      CalcStep(rule: 'Convert to $to',expression: '÷ ${_f(toM[to]!)}',value: '= ${_f(res)} $to'),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uWgt(String eq) {
    final p=_parts(eq,'__UWGT__');
    if(p.length<3) return _usage('Weight','Enter value,from,to\n(kg,g,mg,lb,oz,tonne)','e.g. 1,kg,lb');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toKg={'kg':1.0,'g':0.001,'mg':0.000001,'lb':0.453592,'oz':0.0283495,'tonne':1000.0,'stone':6.35029};
    if(!toKg.containsKey(from)||!toKg.containsKey(to)) return [const CalcStep(rule: 'Error',expression: 'Unknown unit',value: '',isFinal:true)];
    final res=v*toKg[from]!/toKg[to]!;
    return [
      CalcStep(rule: 'Weight Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uTemp(String eq) {
    final p=_parts(eq,'__UTEMP__');
    if(p.length<3) return _usage('Temperature','Enter value,from,to\n(C,F,K,R)','e.g. 100,C,F');
    final v=_d(p[0]),from=p[1].trim().toUpperCase(),to=p[2].trim().toUpperCase();
    double c;
    switch(from){
      case 'C':c=v; break;
      case 'F':c=(v-32)*5/9; break;
      case 'K':c=v-273.15; break;
      case 'R':c=(v-491.67)*5/9; break;
      default:return [const CalcStep(rule: 'Error',expression: 'Use C,F,K,R',value: '',isFinal:true)];
    }
    double res;
    switch(to){
      case 'C':res=c; break;
      case 'F':res=c*9/5+32; break;
      case 'K':res=c+273.15; break;
      case 'R':res=(c+273.15)*9/5; break;
      default:return [const CalcStep(rule: 'Error',expression: 'Use C,F,K,R',value: '',isFinal:true)];
    }
    return [
      CalcStep(rule: 'Temperature Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: '${_f(v)}°$from to Celsius',expression: '',value: '= ${_f(c)}°C'),
      CalcStep(rule: '${_f(c)}°C to $to',expression: '',value: '= ${_f(res)}°$to'),
      CalcStep(rule: 'Answer',expression: '${_f(v)}°$from',value: '${_f(res)}°$to',isFinal:true),
    ];
  }

  static List<CalcStep> _uSpd(String eq) {
    final p=_parts(eq,'__USPD__');
    if(p.length<3) return _usage('Speed','Enter value,from,to\n(kmh,ms,mph,knots,mach)','e.g. 100,kmh,ms');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toMs={'kmh':1/3.6,'ms':1.0,'mph':0.44704,'knots':0.514444,'mach':343.0,'fts':0.3048};
    if(!toMs.containsKey(from)||!toMs.containsKey(to)) return [const CalcStep(rule: 'Error',expression: 'Unknown unit',value: '',isFinal:true)];
    final res=v*toMs[from]!/toMs[to]!;
    return [
      CalcStep(rule: 'Speed Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  static List<CalcStep> _uData(String eq) {
    final p=_parts(eq,'__UDATA__');
    if(p.length<3) return _usage('Data','Enter value,from,to\n(bit,byte,KB,MB,GB,TB)','e.g. 1,GB,MB');
    final v=_d(p[0]),from=p[1].trim().toLowerCase(),to=p[2].trim().toLowerCase();
    final toBits={'bit':1.0,'byte':8.0,'kb':8000.0,'mb':8000000.0,'gb':8000000000.0,'tb':8000000000000.0,'kib':8192.0,'mib':8388608.0,'gib':8589934592.0};
    if(!toBits.containsKey(from)||!toBits.containsKey(to)) return [const CalcStep(rule: 'Error',expression: 'Use bit,byte,KB,MB,GB,TB',value: '',isFinal:true)];
    final res=v*toBits[from]!/toBits[to]!;
    return [
      CalcStep(rule: 'Data Conversion',expression: '$from → $to',value: ''),
      CalcStep(rule: 'Answer',expression: '${_f(v)} $from',value: '${_f(res)} $to',isFinal:true),
    ];
  }

  // ══ HELPERS ══════════════════════════════════════════════════
  static List<CalcStep> _usage(String fn, String desc, String example) => [
    CalcStep(rule: fn, expression: desc, value: ''),
    CalcStep(rule: 'Example', expression: example, value: ''),
    CalcStep(rule: 'Tap the button then edit the equation above', expression: '', value: '', isFinal: true),
  ];

  static List<String> _parts(String eq, String token) =>
      eq.replaceAll(token,'').split(',').map((s)=>s.trim()).toList();

  static List<double>? _nums(String eq, String token) {
    final raw = eq.replaceAll(token,'');
    if(raw.trim().isEmpty) return null;
    final nums = raw.split(',').map((s)=>double.tryParse(s.trim())).whereType<double>().toList();
    return nums.isEmpty ? null : nums;
  }

  static double _d(String s) => double.tryParse(s.trim()) ?? 0;
  static int    _i(String s) => int.tryParse(s.trim()) ?? 0;

  static String? _eval(String eq) {
    try {
      final e = eq.replaceAll('×','*').replaceAll('÷','/').replaceAll('−','-');
      final exp = GrammarParser().parse(e);
      final val = exp.evaluate(EvaluationType.REAL, ContextModel()) as double;
      if(val.isNaN||val.isInfinite) return 'Error';
      return _f(val);
    } catch(_) { return null; }
  }

  static String _f(num val) {
    if(val==val.truncateToDouble()) return val.toInt().toString();
    String s = val.toStringAsFixed(6);
    s = s.replaceAll(RegExp(r'0+$'),'');
    s = s.replaceAll(RegExp(r'\.$'),'');
    return s;
  }

  static int _factorial(int n) { if(n<=1)return 1; return n*_factorial(n-1); }

  static String? _trigExact(String fn, String ang) {
    const m = {
      'sin_0':'0','sin_30':'1/2','sin_45':'√2/2','sin_60':'√3/2','sin_90':'1',
      'cos_0':'1','cos_30':'√3/2','cos_45':'√2/2','cos_60':'1/2','cos_90':'0',
      'tan_0':'0','tan_30':'1/√3','tan_45':'1','tan_60':'√3','tan_90':'∞',
    };
    final a = double.tryParse(ang);
    return a==null ? null : m['${fn}_${a.toInt()}'];
  }
}

// ══════════════════════════════════════════════════════════════════
// CALC PROVIDER
// ══════════════════════════════════════════════════════════════════
class CalcProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  String         _equation   = '';
  List<CalcStep> _steps      = [];
  bool           _justEvaled = false;
  CalcMode       _mode       = CalcMode.standard;
  bool           _drawerOpen = false;
  bool           _bodmas     = false;
  AppTheme       _theme      = const AppTheme();
  bool           _themePickerOpen = false;
  final List<Map<String,String>> _history = [];

  CalcProvider(this._prefs) {
    _loadTheme();
  }

  String         get equation        => _equation;
  List<CalcStep> get steps           => _steps;
  CalcMode       get mode            => _mode;
  bool           get drawerOpen      => _drawerOpen;
  bool           get justEvaled      => _justEvaled;
  bool           get bodmas          => _bodmas;
  AppTheme       get theme           => _theme;
  bool           get themePickerOpen => _themePickerOpen;
  List<Map<String,String>> get history => _history;

  String get result {
    if(_steps.isEmpty) return '0';
    final fin = _steps.lastWhere((s)=>s.isFinal, orElse:()=>_steps.last);
    return fin.value.isEmpty ? '0' : fin.value;
  }

  // ── Theme ─────────────────────────────────────────────────────
  void _loadTheme() {
    final bg     = _prefs.getInt('theme_bg') ?? 0;
    final btn    = _prefs.getInt('theme_btn') ?? 0;
    final accent = _prefs.getInt('theme_accent') ?? 0;
    _theme = AppTheme(
      bg:     BgSkin.values[bg],
      btn:    BtnStyle.values[btn],
      accent: AccentColor.values[accent],
    );
  }

  void setTheme(AppTheme t) {
    _theme = t;
    _prefs.setInt('theme_bg',     t.bg.index);
    _prefs.setInt('theme_btn',    t.btn.index);
    _prefs.setInt('theme_accent', t.accent.index);
    notifyListeners();
  }

  void toggleThemePicker() {
    _themePickerOpen = !_themePickerOpen;
    notifyListeners();
  }

  // ── Navigation ────────────────────────────────────────────────
  void toggleDrawer() {
    _drawerOpen = !_drawerOpen;
    if(_drawerOpen && _mode != CalcMode.standard) _mode = CalcMode.standard;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void toggleBodmas() {
    _bodmas = !_bodmas;
    if(_equation.isNotEmpty) _livePreview();
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void setMode(CalcMode m) {
    _mode       = m;
    _drawerOpen = false;
    _equation   = '';
    _steps      = [];
    _justEvaled = false;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void goBack() {
    if(_mode != CalcMode.standard) {
      _mode       = CalcMode.standard;
      _drawerOpen = true;
      _equation   = '';
      _steps      = [];
    } else {
      _drawerOpen = false;
    }
    notifyListeners();
  }

  // ── Input ─────────────────────────────────────────────────────
  void input(String key) {
    if(key.startsWith('__')) { _promptSolver(key); return; }

    switch(key) {
      case 'C':
        _equation=''; _steps=[]; _justEvaled=false;
        break;
      case '⌫':
        if(_equation.isNotEmpty) {
          final fn = RegExp(r'(sin\(|cos\(|tan\(|asin\(|acos\(|atan\(|sinh\(|cosh\(|tanh\(|log\(|ln\(|sqrt\(|abs\()$').firstMatch(_equation);
          if(fn!=null) _equation=_equation.substring(0,fn.start);
          else _equation=_equation.substring(0,_equation.length-1);
        }
        if(_equation.isEmpty) _steps=[]; else _livePreview();
        _justEvaled=false;
        break;
      case '=':
        if(_equation.isNotEmpty) {
          _steps=StepEngine.solve(_equation, bodmas: _bodmas);
          _justEvaled=true;
          HapticFeedback.mediumImpact();
          if(_steps.isNotEmpty) {
            _history.insert(0,{'eq':_equation,'res':result});
            if(_history.length>50) _history.removeLast();
          }
        }
        break;
      case '+/-':
        if(_equation.isEmpty) break;
        _equation=_equation.startsWith('-')?_equation.substring(1):'-$_equation';
        _livePreview();
        break;
      case '%':
        if(_equation.isNotEmpty) {
          _equation+='/100';
          _steps=StepEngine.solve(_equation, bodmas: _bodmas);
          _justEvaled=true;
        }
        break;
      default:
        const ops=['+','−','×','÷','^','&','|'];
        if(_justEvaled && RegExp(r'^[0-9.]$').hasMatch(key)) {
          _equation=key; _steps=[]; _justEvaled=false;
        } else if(_justEvaled && ops.contains(key)) {
          _equation=result+key; _justEvaled=false;
        } else {
          if(ops.contains(key)&&_equation.isNotEmpty&&ops.contains(_equation[_equation.length-1])) {
            _equation=_equation.substring(0,_equation.length-1);
          }
          if(key=='.') {
            final segs=_equation.split(RegExp(r'[+\−×÷^&|]'));
            if(segs.last.contains('.')) break;
            if(segs.last.isEmpty) _equation+='0';
          }
          _equation+=key; _justEvaled=false;
        }
        _livePreview();
    }
    notifyListeners();
  }

  void _livePreview() {
    final s = StepEngine.solve(_equation, bodmas: _bodmas);
    if(s.isNotEmpty) _steps=s;
  }

  void _promptSolver(String key) {
    // Smart templates — show example so user can edit values
    final t = <String,String>{
      '__QUAD__':    '__QUAD__1,-5,6',
      '__LINEAR__':  '__LINEAR__2,-6',
      '__PYTH__':    '__PYTH__3,4',
      '__APNTH__':   '__APNTH__2,3,10',
      '__APSUM__':   '__APSUM__1,2,10',
      '__GPNTH__':   '__GPNTH__2,3,5',
      '__GPSUM__':   '__GPSUM__1,2,8',
      '__NCR__':     '__NCR__5,2',
      '__NPR__':     '__NPR__5,2',
      '__FACT__':    '__FACT__5',
      '__GCD__':     '__GCD__48,18',
      '__HCF__':     '__GCD__48,18',
      '__LCM__':     '__LCM__4,6',
      '__CBRT__':    '__CBRT__27',
      '__MEAN__':    '__MEAN__2,4,6,8,10',
      '__MEDIAN__':  '__MEDIAN__3,1,4,1,5',
      '__MODE__':    '__MODE__1,2,2,3,3,3',
      '__SD__':      '__SD__2,4,4,4,5,5,7,9',
      '__VAR__':     '__VAR__2,4,4,4,5',
      '__RANGE__':   '__RANGE__2,8,3,5,1',
      '__IQR__':     '__IQR__1,2,3,4,5,6,7',
      '__ZSCORE__':  '__ZSCORE__75,70,5',
      '__WMEAN__':   '__WMEAN__80,3,70,2,90,5',
      '__LINREG__':  '__LINREG__1,2,2,4,3,5',
      '__CORR__':    '__CORR__1,2,2,4,3,6',
      '__SI__':      '__SI__1000,5,2',
      '__CI__':      '__CI__1000,10,2,1',
      '__EMI__':     '__EMI__100000,10,12',
      '__GST5__':    '__GST5__1000',
      '__GST12__':   '__GST12__1000',
      '__GST18__':   '__GST18__1000',
      '__GST28__':   '__GST28__1000',
      '__RGST18__':  '__RGST18__1180',
      '__PROFIT__':  '__PROFIT__100,120',
      '__LOSS__':    '__LOSS__100,80',
      '__DISC__':    '__DISC__500,20',
      '__MARKUP__':  '__MARKUP__100,40',
      '__CAGR__':    '__CAGR__1000,2000,5',
      '__ROI__':     '__ROI__10000,15000',
      '__FV__':      '__FV__1000,8,10',
      '__PV__':      '__PV__2000,8,10',
      '__BEP__':     '__BEP__10000,50,30',
      '__TIP__':     '__TIP__1200,15,4',
      '__ACIRC__':   '__ACIRC__7',
      '__ARECT__':   '__ARECT__5,3',
      '__ATRI__':    '__ATRI__6,4',
      '__HERON__':   '__HERON__3,4,5',
      '__ATRAP__':   '__ATRAP__6,4,3',
      '__APARA__':   '__APARA__8,5',
      '__ASECT__':   '__ASECT__5,60',
      '__AELL__':    '__AELL__5,3',
      '__VSPH__':    '__VSPH__4',
      '__VCYL__':    '__VCYL__3,5',
      '__VCON__':    '__VCON__3,4',
      '__VCUBE__':   '__VCUBE__4',
      '__VCUBOID__': '__VCUBOID__4,3,2',
      '__VPYR__':    '__VPYR__25,6',
      '__DIST__':    '__DIST__0,0,3,4',
      '__MID__':     '__MID__2,4,8,10',
      '__SLOPE__':   '__SLOPE__1,2,3,6',
      '__FORCE__':   '__FORCE__10,9.8',
      '__OHM__':     '__OHM__2,5',
      '__KE__':      '__KE__5,10',
      '__PE__':      '__PE__5,10',
      '__WORK__':    '__WORK__10,5,0',
      '__POWER__':   '__POWER__100,5',
      '__SPEED__':   '__SPEED__100,10',
      '__MOM__':     '__MOM__2,10',
      '__IMPULSE__': '__IMPULSE__10,2',
      '__CENTRIP__': '__CENTRIP__2,10,5',
      '__WAVE__':    '__WAVE__440,0.78',
      '__EMC2__':    '__EMC2__0.001',
      '__PWRVI__':   '__PWRVI__230,5',
      '__RSERIES__': '__RSERIES__10,20,30',
      '__RPARA__':   '__RPARA__10,20,30',
      '__HEAT__':    '__HEAT__2,4186,10',
      '__SNELL__':   '__SNELL__1,45,1.5',
      '__MOLES__':   '__MOLES__18,18',
      '__MOLARITY__':'__MOLARITY__2,0.5',
      '__PH__':      '__PH__0.001',
      '__POH__':     '__POH__0.0001',
      '__GAS__':     '__GAS__1,22.4,1',
      '__DIL__':     '__DIL__2,100,200',
      '__HALF__':    '__HALF__100,5730,11460',
      '__DET2__':    '__DET2__1,2,3,4',
      '__DET3__':    '__DET3__1,2,3,4,5,6,7,8,9',
      '__INV2__':    '__INV2__4,3,2,1',
      '__CRAMER2__': '__CRAMER2__2,1,5,3,-1,1',
      '__ISPRIME__': '__ISPRIME__17',
      '__PFACT__':   '__PFACT__60',
      '__FIB__':     '__FIB__10',
      '__ARM__':     '__ARM__153',
      '__PERF__':    '__PERF__28',
      '__PALIN__':   '__PALIN__12321',
      '__EULER__':   '__EULER__12',
      '__ROMAN__':   '__ROMAN__2024',
      '__BMI__':     '__BMI__70,1.75',
      '__BMR__':     '__BMR__70,175,25,1',
      '__IDWT__':    '__IDWT__175,1',
      '__MHR__':     '__MHR__30',
      '__THR__':     '__THR__30,70',
      '__WATER__':   '__WATER__70',
      '__WHR__':     '__WHR__80,95',
      '__PREG__':    '__PREG__1,3,2025',
      '__AGE__':     '__AGE__15,8,2000',
      '__DAYS__':    '__DAYS__1,1,2024,1,1,2025',
      '__DOW__':     '__DOW__15,8,2024',
      '__LEAP__':    '__LEAP__2024',
      '__SEC__':     '__SEC__60',
      '__CSC__':     '__CSC__30',
      '__COT__':     '__COT__45',
      '__LOGN__':    '__LOGN__1000,10',
      '__SUMN__':    '__SUMN__10',
      '__SUMN2__':   '__SUMN2__10',
      '__SUMN3__':   '__SUMN3__10',
      '__ULEN__':    '__ULEN__1,km,m',
      '__UWGT__':    '__UWGT__1,kg,lb',
      '__UTEMP__':   '__UTEMP__100,C,F',
      '__USPD__':    '__USPD__100,kmh,ms',
      '__UDATA__':   '__UDATA__1,GB,MB',
      '__PERC__':    '__PERC__75,10,20,30,40,50,60,70,80,90,100',
      '__HEX__':     '__HEX__255',
      '__BIN__':     '__BIN__255',
      '__OCT__':     '__OCT__255',
      '__DEC__':     '__DEC__0xFF',
      '__NOT__':     '__NOT__255',
      '__10X__':     '__10X__3',
      '__EX__':      '__EX__1',
      '__ALOG__':    '__ALOG__3',
      '__NROOT__':   '__NROOT__27,3',
      '__MADD2__':   '__MADD2__1,2,3,4,5,6,7,8',
      '__MMUL2__':   '__MMUL2__1,2,3,4,5,6,7,8',
      '__TRANS__':   '__TRANS__1,2,3,4',
      '__TRACE__':   '__TRACE__3,1,2,5',
      '__EIGEN__':   '__EIGEN__4,1,2,3',
      '__CRAMER3__': '__CRAMER3__1,1,1,2,-1,1,1,2,-1,6,3,2',
      '__ASCII__':   '__ASCII__65',
      '__BITTOBYTE__':'__BITTOBYTE__8',
      '__LSH__':     '__LSH__5,2',
      '__RSH__':     '__RSH__20,2',
      '__TWOS__':    '__TWOS__5',
      '__EHF__':     '__EHF__6e14',
      '__ESCV__':    '__ESCV__5.97e24,6.37e6',
      '__GRAV__':    '__GRAV__5.97e24,6.37e6',
      '__GIBBS__':   '__GIBBS__-286,298,163',
      '__NERNST__':  '__NERNST__1.1,2,298,0.01',
      '__PCOMP__':   '__PCOMP__12,44',
      '__DIGROOT__': '__DIGROOT__9875',
      '__HARSH__':   '__HARSH__18',
      '__BFAT__':    '__BFAT__85,38,175,1',
      '__DCAL__':    '__DCAL__70,175,25,1,3',
      '__CBURN__':   '__CBURN__70,5,6',
      '__PACE__':    '__PACE__5,30',
      '__ADDD__':    '__ADDD__1,1,2024,100',
      '__CDWN__':    '__CDWN__31,12,2025',
      '__DAYYR__':   '__DAYYR__2024',
      '__WDAYS__':   '__WDAYS__1,1,2024,31,1,2024',
      '__UAREA__':   '__UAREA__1,hectare,acre',
      '__UVOL__':    '__UVOL__1,gallon,L',
      '__UPRES__':   '__UPRES__1,atm,pa',
      '__UENRG__':   '__UENRG__1,kcal,j',
      '__UPWR__':    '__UPWR__1,hp,w',
      '__UFORCE__':  '__UFORCE__1,kgf,n',
      '__UFUEL__':   '__UFUEL__15,kml,mpg',
    };
    final template = t[key];
    if(template!=null) {
      _equation   = template;
      _steps      = StepEngine.solve(_equation, bodmas: _bodmas);
      _justEvaled = true;
    }
    notifyListeners();
  }
}

// ══════════════════════════════════════════════════════════════════
// SHADOW HELPER
// ══════════════════════════════════════════════════════════════════
List<BoxShadow> neu(AppTheme t, {double blur=10, double spread=1, double d=4}) {
  if(t.btn == BtnStyle.flat || t.btn == BtnStyle.glass) return [];
  return [
    BoxShadow(color: t.shadowDark, offset: Offset(d,d),   blurRadius: blur, spreadRadius: spread),
    BoxShadow(color: t.shadowLight, offset: Offset(-d,-d), blurRadius: blur, spreadRadius: spread),
  ];
}

BoxDecoration btnDecor(AppTheme t, {bool accent=false, bool pressed=false}) {
  final bg = accent ? t.accentColor : t.bgSecondary;
  final pressBg = pressed ? (accent ? co(t.accentColor,0.6) : t.shadowDark) : bg;

  switch(t.btn) {
    case BtnStyle.neumorphic:
      return BoxDecoration(
        color: pressBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: pressed ? [] : neu(t),
      );
    case BtnStyle.flat:
      return BoxDecoration(
        color: accent ? t.accentColor : t.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      );
    case BtnStyle.glass:
      return BoxDecoration(
        color: accent ? co(t.accentColor, 0.85) : co(Colors.white, 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent ? co(t.accentColor, 0.5) : co(Colors.white, 0.12),
          width: 0.5,
        ),
      );
    case BtnStyle.outlined:
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent ? t.accentColor : co(t.textPrimary, 0.2),
          width: 1.5,
        ),
      );
  }
}

// ══════════════════════════════════════════════════════════════════
// MAIN SCREEN
// ══════════════════════════════════════════════════════════════════
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalcProvider>(
      builder: (context, calc, _) {
        final t = calc.theme;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          color: t.bgColor,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Display — always visible
                  const Expanded(flex: 38, child: DisplayArea()),
                  // Workspace — morphs between 3 states
                  Expanded(
                    flex: 62,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: t.bgSecondary,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, anim) => SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0.08,0), end: Offset.zero).animate(anim),
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: calc.drawerOpen
                              ? const CategoryDrawer()
                              : calc.mode == CalcMode.standard
                                  ? const AnchorPad()
                                  : const AdvancedWorkspace(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// DISPLAY AREA
// ══════════════════════════════════════════════════════════════════
class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalcProvider>(
      builder: (context, calc, _) {
        final t   = calc.theme;
        final acc = t.accentColor;
        final sub = t.textSecondary;
        final txt = t.textPrimary;
        final modeMeta = catData[calc.mode]!;

        return Column(
          children: [
            // ── Top bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Row(
                children: [
                  // Back / History
                  _TopBtn(
                    icon: (calc.mode != CalcMode.standard || calc.drawerOpen)
                        ? Icons.arrow_back_ios_new_rounded
                        : Icons.history_rounded,
                    theme: t,
                    onTap: () {
                      if(calc.mode != CalcMode.standard || calc.drawerOpen) {
                        calc.goBack();
                      } else {
                        _showHistory(context, calc);
                      }
                    },
                  ),

                  const SizedBox(width: 8),

                  // BODMAS
                  _TopBtn(
                    label: '📚',
                    theme: t,
                    active: calc.bodmas,
                    activeColor: const Color(0xFFF1C40F),
                    onTap: calc.toggleBodmas,
                  ),

                  const Spacer(),

                  // Theme picker
                  _TopBtn(
                    icon: Icons.palette_outlined,
                    theme: t,
                    active: calc.themePickerOpen,
                    activeColor: acc,
                    onTap: calc.toggleThemePicker,
                  ),

                  const SizedBox(width: 8),

                  // ADVANCED pill
                  GestureDetector(
                    onTap: calc.toggleDrawer,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: calc.drawerOpen ? acc : t.bgSecondary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: neu(t, blur: 6, spread: 0, d: 3),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          calc.drawerOpen ? Icons.close_rounded : Icons.apps_rounded,
                          size: 14,
                          color: calc.drawerOpen ? (t.isLight ? const Color(0xFF111827) : Colors.white) : acc),
                        const SizedBox(width: 5),
                        Text(
                          calc.drawerOpen ? 'CLOSE' : 'ADVANCED',
                          style: TextStyle(
                            color: calc.drawerOpen ? (t.isLight ? const Color(0xFF111827) : Colors.white) : acc,
                            fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Theme picker panel
            if(calc.themePickerOpen) _ThemePickerPanel(calc: calc),

            // Mode badge
            if(calc.mode != CalcMode.standard)
              Padding(
                padding: const EdgeInsets.fromLTRB(18,6,18,0),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: co(modeMeta.color(t), 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: co(modeMeta.color(t), 0.3)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(modeMeta.emoji, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 5),
                      Text(modeMeta.title,
                        style: TextStyle(color: modeMeta.color(t), fontSize: 11, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ]),
              ),

            // Step tape
            Expanded(
              child: calc.steps.isEmpty
                  ? _emptyState(txt, sub)
                  : _stepTape(calc, t, txt, sub),
            ),

            // Live equation
            if(calc.equation.isNotEmpty && !calc.justEvaled)
              Padding(
                padding: const EdgeInsets.fromLTRB(18,2,18,4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, reverse: true,
                  child: Text(calc.equation,
                    style: TextStyle(color: sub, fontSize: 18, letterSpacing: 0.8)),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _emptyState(Color txt, Color sub) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('0', style: TextStyle(color: txt, fontSize: 72, fontWeight: FontWeight.bold, height: 1)),
      const SizedBox(height: 6),
      Text('Start typing to calculate', style: TextStyle(color: sub, fontSize: 12)),
    ],
  ));

  Widget _stepTape(CalcProvider calc, AppTheme t, Color txt, Color sub) {
    final acc = catData[calc.mode]!.color(t);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14,4,14,4),
      itemCount: calc.steps.length,
      itemBuilder: (context, i) {
        final step = calc.steps[i];
        if(step.isFinal) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin:0.0,end:1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (ctx,v,child) => Opacity(opacity: v,
              child: Transform.translate(offset: Offset(0,16*(1-v)), child: child)),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors:[co(acc,0.15),co(acc,0.04)],begin: Alignment.centerLeft,end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: co(acc,0.3),width: 1.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('= ${step.expression}', style: TextStyle(color: sub, fontSize: 11)),
                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight,
                  child: Text(step.value, style: TextStyle(color: acc, fontSize: 44, fontWeight: FontWeight.bold, height: 1.1))),
              ]),
            ),
          );
        }
        if(step.rule=='Input') {
          return Padding(
            padding: const EdgeInsets.only(bottom:2,top:4,right:4),
            child: Align(alignment: Alignment.centerRight,
              child: Text(step.expression, style: TextStyle(color: sub, fontSize: 16, letterSpacing: 0.8))),
          );
        }
        return TweenAnimationBuilder<double>(
          tween: Tween(begin:0.0,end:1.0),
          duration: Duration(milliseconds: 180+i*35),
          curve: Curves.easeOut,
          builder: (ctx,v,child) => Opacity(opacity: v,
            child: Transform.translate(offset: Offset(0,8*(1-v)), child: child)),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: t.cardColor, borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(step.rule, style: TextStyle(color: acc, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                if(step.expression.isNotEmpty)
                  Text(step.expression, style: TextStyle(color: txt, fontSize: 12)),
              ])),
              if(step.value.isNotEmpty)
                Text(step.value, style: TextStyle(color: txt, fontSize: 13, fontWeight: FontWeight.w700)),
            ]),
          ),
        );
      },
    );
  }

  void _showHistory(BuildContext context, CalcProvider calc) {
    final t = calc.theme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: t.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width:40,height:4,decoration: BoxDecoration(color: t.textSecondary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Text('History', style: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: calc.history.isEmpty
                ? Center(child: Text('No history yet', style: TextStyle(color: t.textSecondary)))
                : ListView.builder(
                    itemCount: calc.history.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (_,i) {
                      final h = calc.history[i];
                      return ListTile(
                        title: Text(h['eq']??'', style: TextStyle(color: t.textSecondary, fontSize: 13)),
                        trailing: Text(h['res']??'', style: TextStyle(color: t.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        onTap: () {
                          calc.input('C');
                          for(final ch in (h['eq']??'').split('')) calc.input(ch);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

// ── Top icon button ─────────────────────────────────────────────
class _TopBtn extends StatelessWidget {
  final IconData? icon;
  final String?   label;
  final AppTheme  theme;
  final bool      active;
  final Color     activeColor;
  final VoidCallback onTap;

  const _TopBtn({
    this.icon, this.label,
    required this.theme,
    required this.onTap,
    this.active = false,
    this.activeColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: active ? activeColor : t.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: neu(t, blur: 5, spread: 0, d: 2),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: 16, color: active ? Colors.white : t.textSecondary)
              : Text(label!, style: TextStyle(fontSize: 14, color: active ? (t.isLight ? const Color(0xFF111827) : Colors.white) : t.textSecondary)),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// THEME PICKER PANEL
// ══════════════════════════════════════════════════════════════════
class _ThemePickerPanel extends StatefulWidget {
  final CalcProvider calc;
  const _ThemePickerPanel({required this.calc});

  @override
  State<_ThemePickerPanel> createState() => _ThemePickerPanelState();
}

class _ThemePickerPanelState extends State<_ThemePickerPanel> {
  late BgSkin       _bg;
  late BtnStyle     _btn;
  late AccentColor  _accent;

  @override
  void initState() {
    super.initState();
    _bg     = widget.calc.theme.bg;
    _btn    = widget.calc.theme.btn;
    _accent = widget.calc.theme.accent;
  }

  void _apply() {
    widget.calc.setTheme(AppTheme(bg: _bg, btn: _btn, accent: _accent));
    widget.calc.toggleThemePicker();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.calc.theme;
    final sub = t.textSecondary;

    const bgColors = [Color(0xFF1A1B22),Color(0xFFF5F7FA),Color(0xFF000000),Color(0xFF0D1F14),Color(0xFF1C1208),Color(0xFF061525)];
    const accColors = [Color(0xFFF37B2B),Color(0xFF00BFA5),Color(0xFFA855F7),Color(0xFFF59E0B),Color(0xFFEC4899),Color(0xFFEF4444),Color(0xFF06B6D4),Color(0xFF84CC16)];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: co(t.accentColor, 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Background
          Text('BACKGROUND', style: TextStyle(color: sub, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          const SizedBox(height: 6),
          Row(children: List.generate(6, (i) {
            final sel = _bg == BgSkin.values[i];
            return GestureDetector(
              onTap: () => setState(() => _bg = BgSkin.values[i]),
              child: Container(
                width: 32, height: 32, margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: bgColors[i],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: sel ? t.accentColor : Colors.transparent, width: 2),
                ),
                child: sel ? Icon(Icons.check, size: 14, color: t.accentColor) : null,
              ),
            );
          })),

          const SizedBox(height: 10),

          // Button style
          Text('BUTTON STYLE', style: TextStyle(color: sub, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          const SizedBox(height: 6),
          Row(children: ['Neumorph','Flat','Glass','Outlined'].asMap().entries.map((e) {
            final sel = _btn == BtnStyle.values[e.key];
            return GestureDetector(
              onTap: () => setState(() => _btn = BtnStyle.values[e.key]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: sel ? t.accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: sel ? t.accentColor : co(t.textPrimary, 0.2)),
                ),
                child: Text(e.value,
                  style: TextStyle(color: sel ? Colors.white : t.textSecondary, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            );
          }).toList()),

          const SizedBox(height: 10),

          // Accent colors
          Text('ACCENT COLOR', style: TextStyle(color: sub, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          const SizedBox(height: 6),
          Row(children: List.generate(8, (i) {
            final sel = _accent == AccentColor.values[i];
            return GestureDetector(
              onTap: () => setState(() => _accent = AccentColor.values[i]),
              child: Container(
                width: 26, height: 26, margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: accColors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: sel ? t.textPrimary : Colors.transparent, width: 2),
                ),
                child: sel ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
            );
          })),

          const SizedBox(height: 10),

          // Apply button
          GestureDetector(
            onTap: _apply,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: t.accentColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: co(t.accentColor,0.4), blurRadius: 8, offset: const Offset(0,3))],
              ),
              child: const Center(child: Text('APPLY THEME', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1))),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CATEGORY DRAWER
// ══════════════════════════════════════════════════════════════════
class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});
  @override State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalcProvider>(context);
    final t    = calc.theme;
    final modes = CalcMode.values.where((m) {
      if(m==CalcMode.standard) return false;
      return catData[m]!.title.toLowerCase().contains(_q.toLowerCase());
    }).toList();

    return Container(
      key: const ValueKey('drawer'),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(children: [
        const SizedBox(height: 8),
        // Search
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: t.cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: neu(t, blur: 4, spread: 0, d: 2),
          ),
          child: Row(children: [
            Icon(Icons.search, color: t.textSecondary, size: 16),
            const SizedBox(width: 8),
            Expanded(child: TextField(
              onChanged: (v) => setState(()=>_q=v),
              style: TextStyle(color: t.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search 300+ functions...',
                hintStyle: TextStyle(color: t.textSecondary, fontSize: 13),
                border: InputBorder.none,
              ),
            )),
          ]),
        ),
        const SizedBox(height: 8),
        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5,
            ),
            itemCount: modes.length,
            itemBuilder: (context, i) {
              final m    = modes[i];
              final meta = catData[m]!;
              final mc   = meta.color(t);
              return GestureDetector(
                onTap: () => calc.setMode(m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: t.bgColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: neu(t, blur: 7, d: 3),
                    border: Border.all(color: co(mc, 0.25), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(meta.emoji, style: const TextStyle(fontSize: 24)),
                        Icon(Icons.arrow_forward_ios_rounded, size: 10, color: t.textSecondary),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(meta.title,
                          style: TextStyle(color: t.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 1),
                        Text('${meta.count} functions',
                          style: TextStyle(color: co(mc,0.85), fontSize: 9, fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// ADVANCED WORKSPACE
// ══════════════════════════════════════════════════════════════════
class AdvancedWorkspace extends StatelessWidget {
  const AdvancedWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalcProvider>(context);
    final t    = calc.theme;
    final meta = catData[calc.mode]!;
    final mc   = meta.color(t);
    final keys = zoneKeys[calc.mode] ?? [];

    return Container(
      key: const ValueKey('workspace'),
      child: Column(children: [
        // Category header
        Padding(
          padding: const EdgeInsets.fromLTRB(18,8,18,4),
          child: Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: mc, shape: BoxShape.circle)),
            const SizedBox(width: 7),
            Text(meta.title.toUpperCase(),
              style: TextStyle(color: mc, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(width: 8),
            Text(meta.description,
              style: TextStyle(color: t.textSecondary, fontSize: 9)),
          ]),
        ),

        // Function buttons
        Expanded(
          flex: 4,
          child: keys.isEmpty
              ? Center(child: Text('Coming soon 🚧', style: TextStyle(color: mc, fontSize: 15)))
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 2.4, crossAxisSpacing: 6, mainAxisSpacing: 6),
                  itemCount: keys.length,
                  itemBuilder: (context, i) => _FnBtn(zk: keys[i], mc: mc, theme: t),
                ),
        ),

        Divider(height: 1, color: co(t.textSecondary, 0.15)),
        const SizedBox(height: 4),

        // Anchor pad always below
        const Expanded(flex: 5, child: AnchorPad()),
      ]),
    );
  }
}

class _FnBtn extends StatefulWidget {
  final ZKey zk; final Color mc; final AppTheme theme;
  const _FnBtn({required this.zk, required this.mc, required this.theme});
  @override State<_FnBtn> createState() => _FnBtnState();
}

class _FnBtnState extends State<_FnBtn> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    final isAcc = widget.zk.accent;
    final t = widget.theme;
    return GestureDetector(
      onTapDown: (_) { setState(()=>_p=true); HapticFeedback.selectionClick(); },
      onTapUp: (_) {
        setState(()=>_p=false);
        final val = widget.zk.value;
        if(val == '__DET2__') {
          _showMatrixModal(context, 2, Provider.of<CalcProvider>(context,listen:false), widget.mc);
        } else if(val == '__DET3__') {
          _showMatrixModal(context, 3, Provider.of<CalcProvider>(context,listen:false), widget.mc);
        } else if(val == '__INV2__') {
          _showMatrixModal(context, 2, Provider.of<CalcProvider>(context,listen:false), widget.mc, mode: 'inv');
        } else if(val == '__CRAMER2__') {
          _showCramerModal(context, Provider.of<CalcProvider>(context,listen:false), widget.mc);
        } else {
          Provider.of<CalcProvider>(context,listen:false).input(val);
        }
      },
      onTapCancel: () => setState(()=>_p=false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        decoration: BoxDecoration(
          color: _p
              ? (isAcc ? co(widget.mc,0.4) : t.bgColor)
              : (isAcc ? co(widget.mc,0.15) : t.cardColor),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isAcc ? co(widget.mc,0.45) : co(t.textSecondary,0.1),
            width: isAcc ? 1 : 0.5),
        ),
        child: Center(
          child: FittedBox(fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(widget.zk.label,
                style: TextStyle(color: _p ? co(widget.mc,0.5) : widget.mc,
                  fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

void _showMatrixModal(BuildContext context, int size, CalcProvider calc, Color accent, {String mode='det'}) {
  final ctrls = List.generate(size*size, (_)=>TextEditingController());
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) {
      final t = calc.theme;
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: t.cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${size}×$size Matrix ${mode=="inv"?"Inverse":"Determinant"}',
              style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 16),
            for(int r=0;r<size;r++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(r==0) Text('[', style: TextStyle(color: t.textPrimary, fontSize: size==2?70:100, fontWeight: FontWeight.w200, height: 1)),
                  Column(children: [
                    for(int rr=0;rr<size;rr++)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        for(int cc=0;cc<size;cc++)
                          Container(
                            width: 56, height: 46, margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(color: t.bgColor, borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              controller: ctrls[rr*size+cc],
                              keyboardType: const TextInputType.numberWithOptions(signed:true,decimal:true),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(border: InputBorder.none),
                            ),
                          ),
                      ]),
                  ]),
                  if(r==0) Text(']', style: TextStyle(color: t.textPrimary, fontSize: size==2?70:100, fontWeight: FontWeight.w200, height: 1)),
                ].where((w)=>true).toList(),
              ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                final vals = ctrls.map((c)=>c.text.isEmpty?'0':c.text).join(',');
                final token = mode=='inv' ? '__INV2__' : (size==2?'__DET2__':'__DET3__');
                calc.input('C'); calc.input('$token$vals'); calc.input('=');
                Navigator.pop(ctx);
              },
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: accent, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: co(accent,0.4), blurRadius: 10, offset: const Offset(0,4))]),
                child: Center(child: Text(
                  mode=='inv'?'FIND INVERSE':'FIND DETERMINANT',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900))),
              ),
            ),
          ]),
        ),
      );
    },
  );
}

void _showCramerModal(BuildContext context, CalcProvider calc, Color accent) {
  final ctrls = List.generate(6, (_) => TextEditingController());
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) {
      final t = calc.theme;
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: t.cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Cramer\'s Rule — 2 equations',
              style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('a₁x + b₁y = c₁  |  a₂x + b₂y = c₂',
              style: TextStyle(color: t.textSecondary, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LabeledInput('a₁',ctrls[0],t,accent),
                _LabeledInput('b₁',ctrls[1],t,accent),
                _LabeledInput('c₁',ctrls[2],t,accent),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LabeledInput('a₂',ctrls[3],t,accent),
                _LabeledInput('b₂',ctrls[4],t,accent),
                _LabeledInput('c₂',ctrls[5],t,accent),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                final vals = ctrls.map((c)=>c.text.isEmpty?'0':c.text).join(',');
                calc.input('C'); calc.input('__CRAMER2__$vals'); calc.input('=');
                Navigator.pop(ctx);
              },
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: accent, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: co(accent,0.4), blurRadius: 10, offset: const Offset(0,4))]),
                child: const Center(child: Text('SOLVE', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900))),
              ),
            ),
          ]),
        ),
      );
    },
  );
}

class _LabeledInput extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final AppTheme theme;
  final Color accent;
  const _LabeledInput(this.label, this.ctrl, this.theme, this.accent);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Container(
        width: 64, height: 46,
        decoration: BoxDecoration(color: theme.bgColor, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(signed:true,decimal:true),
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════
// ANCHOR PAD — immovable number foundation
// ══════════════════════════════════════════════════════════════════
class AnchorPad extends StatelessWidget {
  const AnchorPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalcProvider>(
      builder: (context, calc, _) {
        final t   = calc.theme;
        final acc = catData[calc.mode]!.color(t);
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Column(children: [
                  Expanded(child: _ARow(['C','⌫','+/-'], t, acc)),
                  Expanded(child: _ARow(['7','8','9'],    t, acc)),
                  Expanded(child: _ARow(['4','5','6'],    t, acc)),
                  Expanded(child: _ARow(['1','2','3'],    t, acc)),
                  Expanded(child: Row(children: [
                    Expanded(flex:2, child: Padding(padding: const EdgeInsets.all(4), child: _ABtn('0', t, acc))),
                    Expanded(child:          Padding(padding: const EdgeInsets.all(4), child: _ABtn('.', t, acc))),
                  ])),
                ]),
              ),
              SizedBox(
                width: 68,
                child: Column(children: [
                  Expanded(child: Padding(padding: const EdgeInsets.all(4), child: _ABtn('÷', t, acc))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(4), child: _ABtn('×', t, acc))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(4), child: _ABtn('−', t, acc))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(4), child: _ABtn('+', t, acc))),
                  Expanded(flex:2, child: Padding(padding: const EdgeInsets.all(4), child: _EqBtn(theme: t, accent: acc))),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ARow extends StatelessWidget {
  final List<String> keys;
  final AppTheme theme;
  final Color accent;
  const _ARow(this.keys, this.theme, this.accent);

  @override
  Widget build(BuildContext context) => Row(
    children: keys.map((k) => Expanded(
      child: Padding(padding: const EdgeInsets.all(4), child: _ABtn(k, theme, accent)))).toList(),
  );
}

class _ABtn extends StatefulWidget {
  final String label; final AppTheme theme; final Color accent;
  const _ABtn(this.label, this.theme, this.accent);
  @override State<_ABtn> createState() => _ABtnState();
}

class _ABtnState extends State<_ABtn> {
  bool _p = false;
  bool get _isOp   => ['÷','×','−','+'].contains(widget.label);
  bool get _isUtil => ['C','⌫','+/-'].contains(widget.label);

  @override
  Widget build(BuildContext context) {
    final t   = widget.theme;
    final txt = (_isOp||_isUtil) ? widget.accent : t.textPrimary;
    return GestureDetector(
      onTapDown: (_) { setState(()=>_p=true); HapticFeedback.lightImpact(); },
      onTapUp: (_) {
        setState(()=>_p=false);
        Provider.of<CalcProvider>(context,listen:false).input(widget.label);
      },
      onTapCancel: () => setState(()=>_p=false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        decoration: btnDecor(t, pressed: _p),
        child: Center(
          child: Text(widget.label,
            style: TextStyle(
              fontSize: widget.label.length>1 ? 15 : 24,
              fontWeight: FontWeight.w500,
              color: _p ? co(txt,0.5) : txt)),
        ),
      ),
    );
  }
}

class _EqBtn extends StatefulWidget {
  final AppTheme theme; final Color accent;
  const _EqBtn({required this.theme, required this.accent});
  @override State<_EqBtn> createState() => _EqBtnState();
}

class _EqBtnState extends State<_EqBtn> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { setState(()=>_p=true); HapticFeedback.mediumImpact(); },
      onTapUp: (_) {
        setState(()=>_p=false);
        Provider.of<CalcProvider>(context,listen:false).input('=');
      },
      onTapCancel: () => setState(()=>_p=false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        decoration: BoxDecoration(
          color: _p ? co(widget.accent,0.6) : widget.accent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: _p ? [] : [
            BoxShadow(color: co(widget.accent,0.45), blurRadius: 12, offset: const Offset(0,5)),
            ...neu(widget.theme),
          ],
        ),
        child: const Center(child: Text('=',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
      ),
    );
  }
}