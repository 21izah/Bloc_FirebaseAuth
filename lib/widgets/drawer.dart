import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF1C2B21),
                Color(0xFF101A13),
              ],
              center: Alignment.center,
              radius: 1.5,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.only(top: 60),
            children: [
              // Drawer Header with Radial Gradient
              // DrawerHeader(
              //   decoration: BoxDecoration(
              //     gradient: RadialGradient(
              //       colors: [
              //         Colors.teal.shade700,
              //         Colors.teal.shade900,
              //       ],
              //       center: Alignment.center,
              //       radius: 1.2,
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CircleAvatar(
              //         radius: 35,
              //         backgroundColor: Colors.white,
              //         child: Image.asset(
              //           // height: 300,
              //           'lib/assets/user.png',
              //           // 'lib/assets/Animation - 1700336113042.json',
              //         ),
              //       ),
              //       SizedBox(height: 10),
              //       Text(
              //         "Welcome Back!",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Text(
              //         "user@example.com",
              //         style: TextStyle(
              //           color: Colors.white70,
              //           fontSize: 14,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Home Tile
              _buildListTile(
                imagePath: 'lib/assets/home-button.png',
                title: "Home",
                onTap: () => Navigator.pop(context),
              ),

              // Settings ExpansionTile
              _buildExpansionTile(
                imagePath: 'lib/assets/settings.png',
                title: "Settings",
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildListTile02(
                      imagePath: 'lib/assets/user.png',
                      title: "Account",
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildListTile02(
                      imagePath: 'lib/assets/privacy.png',
                      title: "Privacy",
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),

              // About ExpansionTile
              _buildExpansionTile(
                imagePath: 'lib/assets/about.png',
                title: "About",
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildListTile02(
                      imagePath: 'lib/assets/office.png',
                      title: "Company",
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  _buildListTile(
                    imagePath: 'lib/assets/user.png',
                    title: "Team",
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),

              // Logout Tile
              _buildListTile(
                imagePath: 'lib/assets/logout.png',
                title: "Logout",
                color: Colors.redAccent,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom ListTile Widget
  Widget _buildListTile({
    required imagePath,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Image.asset(
        height: 20,
        imagePath,
        // 'lib/assets/Animation - 1700336113042.json',
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  // Custom ListTile Widget
  Widget _buildListTile02({
    required imagePath,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Image.asset(
        height: 20,
        imagePath,
        // 'lib/assets/Animation - 1700336113042.json',
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  // Custom ExpansionTile Widget
  Widget _buildExpansionTile({
    required imagePath,
    required String title,
    required List<Widget> children,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Image.asset(
          height: 20,
          imagePath,
          // 'lib/assets/Animation - 1700336113042.json',
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        children: children,
      ),
    );
  }
}
