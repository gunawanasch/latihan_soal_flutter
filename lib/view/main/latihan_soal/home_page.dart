import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/helpers/preference_helper.dart';
import 'package:latihan_soal_flutter/models/banner_list.dart';
import 'package:latihan_soal_flutter/models/mapel_list.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';
import 'package:latihan_soal_flutter/models/user_by_email.dart';
import 'package:latihan_soal_flutter/providers/latihan_soal_provider.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/mapel_page.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/paket_soal_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapelList? mapelList;
  BannerList? bannerList;
  UserData? dataUser;
  LatihanSoalProvider? latihanSoalProvider;

  getMapel() async {
    latihanSoalProvider = Provider.of<LatihanSoalProvider>(context, listen: false);
    final mapelResult = await latihanSoalProvider!.getMapel();
    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  getBanner() async {
    final bannerResult = await latihanSoalProvider!.getBanner();
    if (bannerResult.status == Status.success) {
      bannerList = BannerList.fromJson(bannerResult.data!);
      setState(() {});
    }
  }

  setupFcm() async {
    final tokenFcm = await FirebaseMessaging.instance.getToken();
    print('tokenfcm: $tokenFcm');

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future getUserData() async {
    dataUser = await PreferenceHelper().getUserData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMapel();
    getBanner();
    setupFcm();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: SafeArea(
        child: ListView(
          children: [
            _buildUserHomeProfile(),
            _buildTopBanner(context),
            _buildHomeListMapel(mapelList),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Terbaru',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  bannerList == null
                      ? Container(
                    height: 70,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : Container(
                    height: 150,
                    child: ListView.builder(
                      itemCount: bannerList!.data!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        final currentBanner = bannerList!.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                            Image.network(currentBanner.eventImage!),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildHomeListMapel(MapelList? list) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 21),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Pilih Pelajaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return MapelPage(mapel: mapelList!);
                  }));
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: R.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          list == null
              ? Container(
            height: 70,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          )
              : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: list.data!.length > 3 ? 3 : list.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final currentMapel = list.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return PaketSoalPage(id: currentMapel.courseId!);
                    }));
                  },
                  child: MapelWidget(
                    title: currentMapel.courseName!,
                    totalPacket: currentMapel.jumlahMateri!,
                    totalDone: currentMapel.jumlahDone!,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Container _buildTopBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        color: R.colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 147,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15,
            ),
            child: Text(
              'Mau kerjain latihan soal apa hari ini?',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              R.assets.imgHome,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildUserHomeProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ' + (dataUser?.userName ?? 'Nama User'),
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Selamat datang',
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            R.assets.imgUser,
            width: 35,
            height: 35,
          ),
        ],
      ),
    );
  }
}

class MapelWidget extends StatelessWidget {
  const MapelWidget({
    Key? key,
    required this.title,
    required this.totalDone,
    required this.totalPacket,
  }) : super(key: key);

  final String title;
  final int? totalDone;
  final int? totalPacket;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 21),
      child: Row(
        children: [
          Container(
            height: 53,
            width: 53,
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: R.colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(R.assets.icAtom),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '$totalDone/$totalPacket Paket latihan soal',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: R.colors.greySubtitleHome,
                  ),
                ),
                SizedBox(height: 5),
                Stack(
                  children: [
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: R.colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: totalDone!,
                          child: Container(
                            height: 5,
                            // width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: R.colors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: totalDone! - totalDone!,
                          child: Container(
                            // height: 5,
                            // width: MediaQuery.of(context).size.width * 0.4,
                            // decoration: BoxDecoration(
                            //   color: R.colors.primary,
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}