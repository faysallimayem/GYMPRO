import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../routes/app_routes.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({Key? key}) : super(key: key);

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int currentHeight = 170; // Default height from screenshot
  final int minHeight = 140;
  final int maxHeight = 220;
  
  // Using FixedExtentScrollController for precise height selection
  late final FixedExtentScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
      initialItem: maxHeight - currentHeight, // Reverse initial item calculation
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    
    // Responsive font sizes and paddings based on screen size
    final double titleFontSize = screenWidth * 0.06;
    final double headingFontSize = screenWidth * 0.065;
    final double heightValueFontSize = screenWidth * 0.25; // Relative to screen width
    final double cmLabelFontSize = screenWidth * 0.065;
    final double buttonFontSize = screenWidth * 0.045;
    
    // Responsive paddings
    final double verticalSpacing = screenHeight * 0.02;
    final double horizontalPadding = screenWidth * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // GYM PRO title
                Text(
                  "GYM PRO",
                  style: TextStyle(
                    color: Color(0xFFFF4500), // Orange color from screenshot
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                
                // What Is Your Height? heading
                Text(
                  "What Is Your Height?",
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                
                // Height value display - using FittedBox for responsive sizing
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currentHeight.toString(),
                        style: TextStyle(
                          fontSize: heightValueFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        "cm",
                        style: TextStyle(
                          fontSize: cmLabelFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: verticalSpacing),
                
                // Height selector area
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        width: screenWidth * 0.2, // Relative width
                        height: constraints.maxHeight * 0.7, // Relative height
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5), // Light gray background
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            controller: _scrollController,
                            physics: FixedExtentScrollPhysics(),
                            itemExtent: constraints.maxHeight * 0.05, // Responsive item height
                            diameterRatio: 2.0, // Make the wheel flatter
                            perspective: 0.005,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                currentHeight = maxHeight - index; // Reverse value calculation
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: maxHeight - minHeight + 1,
                              builder: (context, index) {
                                final height = maxHeight - index; // Reverse height calculation
                                final bool isMajor = height % 5 == 0;
                                
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: screenWidth * 0.025),
                                    // Height label (only for multiples of 5)
                                    if (isMajor) 
                                      Container(
                                        width: screenWidth * 0.075,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          height.toString(),
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    
                                    // Tick mark
                                    SizedBox(width: isMajor ? screenWidth * 0.01 : screenWidth * 0.035),
                                    Container(
                                      width: isMajor ? screenWidth * 0.06 : screenWidth * 0.035,
                                      height: isMajor ? 2.0 : 1.0,
                                      color: isMajor ? Colors.black87 : Colors.grey[400],
                                    ),
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      // Adjusted orange triangle indicator with responsive positioning
                      Positioned(
                        right: screenWidth * 0.1, // 10% of screen width
                        top: constraints.maxHeight * 0.35 - (screenWidth * 0.03),
                        child: CustomPaint(
                          size: Size(screenWidth * 0.06, screenWidth * 0.06),
                          painter: _TriangleIndicatorPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Continue button - responsive sizing
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, 
                    vertical: verticalSpacing
                  ),
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.065, // Responsive height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.weightScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF4500), // Orange color from screenshot
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

// Triangle painter for the indicator
class _TriangleIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFF7900)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
