import 'package:flutter/material.dart';
class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key , required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();



}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use safe navigation (?.) instead of forcing it with (!)
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Extract the strings safely, providing a fallback if they don't exist
    final String coverImage = arguments?['coverImage'] ?? '';
    final String avatarImage = arguments?['avatar'] ?? '';
    final String fullName = arguments?['fullName'] ?? 'No Name';
    final String username = arguments?['username'] ?? 'No Username';

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: screenWidth, // Changed from 0.5 to full width so it's not cut in half
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- COVER IMAGE ---
            SizedBox(
              height: 200,
              width: double.infinity,
              // FIX: Check if the string is NOT empty before calling Image.network
              child: coverImage.isNotEmpty
                  ? Image.network(
                coverImage,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.image, size: 50), // Fallback if empty
            ),

            const SizedBox(height: 18),

            // --- USER INFO ROW ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns text nicely
                  children: [
                    Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(username, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey)),
                  ],
                ),

                // --- AVATAR IMAGE ---
                SizedBox(
                    height: 80, // FIX: Changed from 200 to 80 so it fits inside the Row
                    width: 80,  // FIX: Changed from double.infinity (which crashes Rows) to 80
                    child: avatarImage.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(40), // Makes the avatar round
                      child: Image.network(
                        avatarImage,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(Icons.person, size: 40)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}