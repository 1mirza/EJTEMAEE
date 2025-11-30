import 'dart:ui'; // برای افکت شیشه‌ای
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // پکیج نمایش SVG
import 'package:shared_preferences/shared_preferences.dart';
import '../data/data_manager.dart';
import 'lesson_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String username = '';
  late AnimationController _bgController; // کنترلر انیمیشن پس‌زمینه

  @override
  void initState() {
    super.initState();
    _loadUsername();

    // تنظیم انیمیشن پس‌زمینه (چرخش آرام)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'دانش‌آموز';
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // بدنه اصلی با پس‌زمینه رنگی و متحرک
      body: Stack(
        children: [
          // 1. پس‌زمینه متحرک و رنگارنگ
          _buildAnimatedBackground(),

          // 2. محتوای اصلی روی شیشه
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(height: 10),
                Expanded(
                  child: DataManager.allLessons.isEmpty
                      ? const Center(
                          child: Text(
                            'درسی یافت نشد',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          itemCount: DataManager.allLessons.length,
                          itemBuilder: (context, index) {
                            final lesson = DataManager.allLessons[index];
                            // انیمیشن ورود آیتم‌ها (Staggered Animation)
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 400 + (index * 100),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 50 * (1 - value)),
                                  child: Opacity(opacity: value, child: child),
                                );
                              },
                              child: _buildGlassLessonCard(lesson, index),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ویجت پس‌زمینه متحرک
  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)], // بنفش و آبی جذاب
        ),
      ),
      child: Stack(
        children: [
          // دایره‌های متحرک برای زیبایی
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Positioned(
                top: -100 + (_bgController.value * 50),
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pinkAccent.withOpacity(0.3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.5),
                        blurRadius: 50,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Positioned(
                bottom: 100 - (_bgController.value * 30),
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyanAccent.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // لایه بلور کلی برای یکدست شدن پس‌زمینه
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  // اپ‌بار شیشه‌ای
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سلام $username 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'آماده یادگیری هستی؟',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  tooltip: 'خروج',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // کارت درس شیشه‌ای (Glassmorphic Card)
  Widget _buildGlassLessonCard(dynamic lesson, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // شفافیت شیشه
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonDetailScreen(lesson: lesson),
                    ),
                  );
                },
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // آیکون SVG درس
                      Hero(
                        tag: 'lesson_icon_${lesson.id}',
                        child: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SvgPicture.string(
                            _getSvgForLesson(lesson.id),
                            placeholderBuilder: (context) =>
                                const Icon(Icons.book, color: Colors.indigo),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // متن و عنوان
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: Colors.amberAccent,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'شامل فعالیت و نکات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // دکمه فلش دایره‌ای
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xFF4A00E0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تالار آیکون‌های SVG (کدهای SVG برای هر درس)
  String _getSvgForLesson(int id) {
    // آیکون درس ۱: دوستی (دست دادن/قلب)
    const String friendshipSvg = '''
    <svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#FF512F;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#DD2476;stop-opacity:1" />
        </linearGradient>
      </defs>
      <path d="M256 0C114.6 0 0 114.6 0 256s114.6 256 256 256 256-114.6 256-256S397.4 0 256 0zm0 472c-119.1 0-216-96.9-216-216S136.9 40 256 40s216 96.9 216 216-96.9 216-216 216z" fill="url(#grad1)" opacity="0.2"/>
      <path d="M352 128c-53 0-96 43-96 96s43 96 96 96 96-43 96-96-43-96-96-96zm0 160c-35.3 0-64-28.7-64-64s28.7-64 64-64 64 28.7 64 64-28.7 64-64 64zM160 128c-53 0-96 43-96 96s43 96 96 96 96-43 96-96-43-96-96-96zm0 160c-35.3 0-64-28.7-64-64s28.7-64 64-64 64 28.7 64 64-28.7 64-64 64zM256 320c-55.2 0-104 31.3-128 72 2.7 4.5 5.6 8.8 8.8 12.9 20.2-34.1 63.6-60.9 119.2-60.9s99 26.8 119.2 60.9c3.2-4.1 6.1-8.4 8.8-12.9-24-40.7-72.8-72-128-72z" fill="url(#grad1)"/>
    </svg>
    ''';

    // آیکون درس ۲: تصمیم‌گیری (مسیر/مغز)
    const String decisionSvg = '''
    <svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="grad2" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#4facfe;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#00f2fe;stop-opacity:1" />
        </linearGradient>
      </defs>
      <circle cx="256" cy="256" r="240" fill="url(#grad2)" opacity="0.2"/>
      <path d="M256 96c-88.4 0-160 71.6-160 160 0 88.4 71.6 160 160 160s160-71.6 160-160c0-88.4-71.6-160-160-160zm0 288c-70.7 0-128-57.3-128-128 0-70.7 57.3-128 128-128s128 57.3 128 128c0 70.7-57.3 128-128 128z" fill="url(#grad2)"/>
      <path d="M256 176c-8.8 0-16 7.2-16 16v48h-32c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h48c8.8 0 16-7.2 16-16v-96c0-8.8-7.2-16-16-16zM320 256h-32c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h48c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16z" fill="white"/>
    </svg>
    ''';

    // آیکون عمومی (کتاب) برای سایر دروس
    const String bookSvg = '''
    <svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="grad3" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#11998e;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#38ef7d;stop-opacity:1" />
        </linearGradient>
      </defs>
      <path d="M464 64H48C21.5 64 0 85.5 0 112v288c0 26.5 21.5 48 48 48h416c26.5 0 48-21.5 48-48V112c0-26.5-21.5-48-48-48zM232 400H48v-16h184v16zm0-48H48v-16h184v16zm0-48H48v-16h184v16zm232 96H280V112h184v288z" fill="url(#grad3)"/>
      <path d="M320 160h112v32H320zM320 224h112v32H320z" fill="white" opacity="0.6"/>
    </svg>
    ''';

    // انتخاب بر اساس آیدی درس
    switch (id) {
      case 1:
        return friendshipSvg; // درس ۱: دوستی
      case 2:
        return decisionSvg; // درس ۲: تصمیم گیری
      default:
        return bookSvg; // سایر دروس
    }
  }
}
