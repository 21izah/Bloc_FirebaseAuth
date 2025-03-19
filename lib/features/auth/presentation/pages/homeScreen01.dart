import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:izahs/widgets/drawer.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHovered = false;
  bool isHovered01 = false;
  bool isHovered02 = false;
  bool isHovered03 = false;
  // State variable to track hover state
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;
    return Scaffold(
      // backgroundColor: Color(0xFF162616), // Dark Green Background
      appBar: isMobile
          ? AppBar(
              backgroundColor: Color(0xFF162616),
              foregroundColor: Colors.white,
            )
          : AppBar(
              backgroundColor: Color(0xFF162616),
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Izah Michael.",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // if (!widget.isMobile)
                    Row(
                      children: [
                        TextButton(
                          onHover: (value) {
                            setState(() {
                              isHovered01 = value; // Update hover state
                            });
                          },
                          onPressed: () {},
                          child: Text(
                            'Service',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isHovered01
                                  ? Colors.deepOrange
                                  : Colors.white, // Change text color on hover
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        TextButton(
                          onHover: (value) {
                            setState(() {
                              isHovered02 = value; // Update hover state
                            });
                          },
                          onPressed: () {},
                          child: Text(
                            'Gallery',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isHovered02
                                  ? Colors.deepOrange
                                  : Colors.white, // Change text color on hover
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        TextButton(
                          onHover: (value) {
                            setState(() {
                              isHovered03 = value; // Update hover state
                            });
                          },
                          onPressed: () {},
                          child: Text(
                            'Contact',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isHovered03
                                  ? Colors.deepOrange
                                  : Colors.white, // Change text color on hover
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Image.asset(
                        //   "lib/assets/nigeria003.png", // Language Icon
                        //   width: 24,
                        // ),
                        SizedBox(width: 5),
                        Text(
                          "English",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [],
            ),

      drawer: isMobile ? MyDrawer() : null,
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1C2B21), // Dark green background color
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
              child: Column(
                children: [
                  // Top Navigation Bar
                  // NavBar(isMobile: isMobile),

                  // Main Content
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Text Section
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isMobile)
                                Container(
                                  // color: Colors.amber,
                                  height: screenSize.height * 0.3,
                                  width: double.infinity,
                                  // color: Colors.amber,
                                  child: Lottie.asset(
                                      'lib/assets/Animation - 1701449557293.json',
                                      fit: BoxFit.contain),
                                ),
                              Text(
                                "HELLO,",
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 32 : 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 0),
                              Text(
                                "I AM Izah Michael".toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 36 : 54,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Flutter developer and (UI/UX) Web designer",
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 16 : 24,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Versatile full-stack Flutter developer with expertise in building end-to-end mobile applications. Proficient in front-end and back-end development, API integration, and database management. Passionate about crafting intuitive UI/UX designs, ensuring seamless user experiences. Innovating to deliver high-performance, scalable solutions",
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 14 : 18,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onHover: (value) {
                                  setState(() {
                                    isHovered = value; // Update hover state
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isHovered
                                      ? Colors.transparent
                                      : Colors
                                          .deepOrange, // Change background color on hover
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: isHovered
                                          ? Colors.deepOrange
                                          : Colors
                                              .transparent, // Change border color on hover
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                child: Text(
                                  "Contact",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isHovered
                                        ? Colors.deepOrange
                                        : Colors
                                            .white, // Change text color on hover
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Image Section
                        if (!isMobile)
                          Expanded(
                            flex: 6,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  // color: Colors.amberAccent,
                                  child: Positioned(
                                    left: screenSize.width * 0.15,
                                    top: screenSize.height * 0.45,
                                    child: Image.asset(
                                      height: 300,
                                      'lib/assets/blur_green_orange.png',
                                      // 'lib/assets/Animation - 1700336113042.json',
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: Colors.amberAccent,
                                  child: Positioned(
                                    left: screenSize.width * 0.13,
                                    top: screenSize.height * 0.005,
                                    child: Lottie.asset(
                                      height: 700,
                                      'lib/assets/Animation - 1701449557293.json',
                                      // 'lib/assets/Animation - 1700336113042.json',
                                    ),
                                  ),
                                ),

                                // Positioned(
                                //   bottom: 50,
                                //   child: Lottie.asset(
                                //     'lib/assets/Animation - 1701448797710.json',
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
