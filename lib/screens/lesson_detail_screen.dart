import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/lesson_model.dart';

class LessonDetailScreen extends StatefulWidget {
  final LessonModel lesson;
  final int initialTabIndex;

  const LessonDetailScreen({
    Key? key,
    required this.lesson,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // انیمیشن پس‌زمینه (آرام و شناور)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // برای اینکه اپ‌بار روی پس‌زمینه بیفتد
      body: Stack(
        children: [
          // 1. پس‌زمینه متحرک (تم گرم: نارنجی/صورتی)
          _buildAnimatedBackground(),

          // 2. محتوای اصلی
          Column(
            children: [
              _buildGlassAppBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildContentTab(
                      widget.lesson.activities,
                      'assets/activity.svg',
                      'فعالیت‌ها',
                      Colors.orangeAccent,
                    ),
                    _buildContentTab(
                      widget.lesson.worksheets,
                      'assets/worksheet.svg',
                      'کاربرگ‌ها',
                      Colors.greenAccent,
                    ),
                    _buildNotesTab(widget.lesson.notes),
                    _buildContentTab(
                      widget.lesson.textQuestions,
                      'assets/question.svg',
                      'سوالات متن',
                      Colors.cyanAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // پس‌زمینه متحرک با تم گرم
  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF512F), // نارنجی تند
            Color(0xFFDD2476), // صورتی تیره
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Positioned(
                top: -50 + (_bgController.value * 30),
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                      0.1,
                    ), // کمی محو تر برای مزاحم نشدن
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 60,
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
                bottom: 100 - (_bgController.value * 40),
                right: -60,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 60,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // لایه بلور
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  // اپ‌بار شیشه‌ای با تب‌بار
  Widget _buildGlassAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(
              0.2,
            ), // تیره‌تر برای خوانایی متن سفید اپ‌بار
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.lesson.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // تب‌بار سفارشی
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  labelColor: const Color(0xFFDD2476), // رنگ متن تب انتخاب شده
                  unselectedLabelColor: Colors.white, // رنگ متن تب‌های دیگر
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: '  فعالیت‌ها  '),
                    Tab(text: '  کاربرگ‌ها  '),
                    Tab(text: '  نکات مهم  '),
                    Tab(text: '  سوالات  '),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // لیست‌های محتوا (پرسش و پاسخ) - اصلاح شده برای خوانایی
  Widget _buildContentTab(
    List<QnA> items,
    String iconAsset,
    String title,
    Color accentColor,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'موردی وجود ندارد',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
      itemCount: items.length + 1, // +1 برای هدر
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSectionHeader(title, _getSvgIcon(title));
        }
        final item = items[index - 1];
        // انیمیشن ورود
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutQuart,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Container(
              // حذف BackdropFilter برای پرفورمنس بهتر و خوانایی بیشتر
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  0.92,
                ), // زمینه تقریبا سفید برای خوانایی عالی
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDD2476).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline_rounded,
                          color: Color(0xFFDD2476),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.question,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50), // رنگ متن تیره برای سوال
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.black12, thickness: 1),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.answer,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.8, // فاصله خطوط بیشتر برای خوانایی
                            color: Colors.black87, // رنگ متن تیره برای جواب
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // لیست نکات (اصلاح شده برای خوانایی)
  Widget _buildNotesTab(List<String> notes) {
    if (notes.isEmpty) return const Center(child: Text('نکته‌ای وجود ندارد'));

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
      itemCount: notes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return _buildSectionHeader('نکات مهم', _getSvgIcon('نکات مهم'));
        final note = notes[index - 1];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95), // زمینه سفید برای نکات
              borderRadius: BorderRadius.circular(16),
              border: Border(
                right: BorderSide(color: const Color(0xFFFF512F), width: 4),
              ), // خط رنگی سمت راست
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    note,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // هدر هر بخش
  Widget _buildSectionHeader(String title, String svgData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: SvgPicture.string(svgData),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
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
          ],
        ),
      ),
    );
  }

  // کدهای SVG داخلی
  String _getSvgIcon(String type) {
    // آیکون فعالیت (مداد و برگه)
    const String activitySvg = '''
    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" fill="white" fill-opacity="0.2"/>
      <path d="M16 8L8 16" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      <path d="M8 8H16V16" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    ''';

    // آیکون نکات (لامپ)
    const String bulbSvg = '''
    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 22C12 22 20 18 20 12C20 7.58172 16.4183 4 12 4C7.58172 4 4 7.58172 4 12C4 18 12 22 12 22Z" fill="#FFEB3B" fill-opacity="0.8"/>
      <path d="M9 12H15" stroke="black" stroke-width="1.5" stroke-linecap="round"/>
    </svg>
    ''';

    // آیکون سوال (علامت سوال)
    const String questionSvg = '''
    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke="white" stroke-width="2"/>
      <path d="M9.09 9C9.3251 8.33167 9.78915 7.76811 10.4 7.40913C11.0108 7.05016 11.7289 6.91894 12.4272 7.03871C13.1255 7.15849 13.7588 7.52152 14.2151 8.06353C14.6713 8.60553 14.9211 9.29152 14.92 10C14.92 12 11.92 13 11.92 13" stroke="white" stroke-width="2" stroke-linecap="round"/>
      <path d="M12 17H12.01" stroke="white" stroke-width="3" stroke-linecap="round"/>
    </svg>
    ''';

    // آیکون کاربرگ (برگه چک لیست)
    const String sheetSvg = '''
    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <rect x="5" y="4" width="14" height="16" rx="2" fill="white" fill-opacity="0.2" stroke="white" stroke-width="2"/>
      <path d="M9 9H15" stroke="white" stroke-width="2" stroke-linecap="round"/>
      <path d="M9 13H15" stroke="white" stroke-width="2" stroke-linecap="round"/>
      <path d="M9 17H13" stroke="white" stroke-width="2" stroke-linecap="round"/>
    </svg>
    ''';

    if (type.contains('نکات')) return bulbSvg;
    if (type.contains('سوال')) return questionSvg;
    if (type.contains('کاربرگ')) return sheetSvg;
    return activitySvg;
  }
}
