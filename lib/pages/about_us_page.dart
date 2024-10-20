import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:readeth/config/app_resources.dart';
import 'package:readeth/models/team_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  AboutUsPage({super.key});

  final Uri _uri = Uri.parse('https://github.com/LeulWeb/readeth');

  List<TeamModel> teamList = [
    TeamModel(
      name: 'Leul Webshet',
      imageUrl: 'https://avatars.githubusercontent.com/u/100644780?v=4',
      idNumber: 'Eitm/ur172096/12',
    ),
    TeamModel(
      name: 'Kaleb Asnake',
      imageUrl: 'https://avatars.githubusercontent.com/u/100644780?v=4',
      idNumber: 'Ugr/171597/12',
    ),
    TeamModel(
      name: 'Mihretu Hiskel',
      imageUrl: 'https://avatars.githubusercontent.com/u/100644780?v=4',
      idNumber: 'Ugr/172030/12',
    ),
    TeamModel(
      name: 'Getachew Degie',
      imageUrl: 'https://avatars.githubusercontent.com/u/110644780?v=4',
      idNumber: 'Ugr/177353/12',
    ),
    TeamModel(
      name: 'Selam Mebratu',
      imageUrl: 'https://avatars.githubusercontent.com/u/110644780?v=4',
      idNumber: 'Ugr/172890/12',
    ),
    TeamModel(
      name: 'Jemal Yesuf',
      imageUrl: 'https://avatars.githubusercontent.com/u/110644780?v=4',
      idNumber: 'Ugr/172530/12',
    ),
    TeamModel(
      name: 'Yohannes Gebreslase',
      imageUrl: 'https://avatars.githubusercontent.com/u/110644780?v=4',
      idNumber: 'Eitm/ur130126/10',
    ),
  ];

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: teamList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(teamList[index].imageUrl),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(teamList[index].name),
                            Text(teamList[index].idNumber),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        tooltip: 'view on github',
        shape: const CircleBorder(),
        onPressed: () {
          _launchInBrowserView(_uri);
        },
        child: Lottie.asset('assets/animations/github.json'),
      ),
    );
  }
}
