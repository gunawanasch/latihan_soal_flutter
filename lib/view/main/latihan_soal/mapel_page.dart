import 'package:flutter/material.dart';
import 'package:latihan_soal_flutter/models/mapel_list.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/home_page.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/paket_soal_page.dart';

class MapelPage extends StatelessWidget {
  const MapelPage({Key? key, required this.mapel}) : super(key: key);
  static String route = 'mapel_page';

  final MapelList mapel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Mata Pelajaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: ListView.builder(
          itemCount: mapel.data!.length,
          itemBuilder: ((context, index) {
          final currentMapel = mapel.data![index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaketSoalPage(id: currentMapel.courseId!)));
            },
            child: MapelWidget(
              title: currentMapel.courseName!,
              totalPacket: currentMapel.jumlahMateri!,
              totalDone: currentMapel.jumlahDone!,
            ),
          );
        })),
      ),
    );
  }
}
