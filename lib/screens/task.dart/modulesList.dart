import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ListTileModule extends StatelessWidget {
  final String projectTitle;
  final String moduleTitle;
  final List<String> profileImagePaths;
  final double percentage;
  final String imagePath;
  final List<String> teamMembers;
  final VoidCallback onTap;

  const ListTileModule({
    Key? key,
    required this.projectTitle,
    required this.moduleTitle,
    required this.profileImagePaths,
    required this.percentage,
    required this.imagePath,
    required this.teamMembers,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 40),
                      child: Text(
                        projectTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10),
                      child: Text(
                        moduleTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 150,
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            for (int i = 0; i < teamMembers.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: CircleAvatar(
                                  radius: 15.0,
                                  backgroundImage: AssetImage(
                                    profileImagePaths[i % profileImagePaths.length],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 80,
                      lineHeight: 15.0,
                      percent: percentage / 100,
                      backgroundColor: const Color.fromARGB(255, 238, 225, 225),
                      progressColor: Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Text(
                          'Team Members: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (var member in teamMembers)
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(member.replaceAll('@gmail.com', '')),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}