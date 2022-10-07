import 'package:flutter/material.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';
import 'package:latihan_soal_flutter/models/paket_soal_list.dart';
import 'package:latihan_soal_flutter/providers/latihan_soal_provider.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/kerjakan_latihan_soal_page.dart';
import 'package:provider/provider.dart';

class PaketSoalPage extends StatefulWidget {
  const PaketSoalPage({Key? key, required this.id}) : super(key: key);
  static String route = 'paket_soal_page';
  final String id;

  @override
  State<PaketSoalPage> createState() => _PaketSoalPageState();
}

class _PaketSoalPageState extends State<PaketSoalPage> {
  PaketSoalList? paketSoalList;
  LatihanSoalProvider? latihanSoalProvider;

  getPaketSoal() async {
    latihanSoalProvider = Provider.of<LatihanSoalProvider>(context, listen: false);
    final paketSoalResult = await latihanSoalProvider!.getPaketSoal(widget.id);
    if (paketSoalResult.status == Status.success) {
      paketSoalList = PaketSoalList.fromJson(paketSoalResult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPaketSoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      appBar: AppBar(
        title: Text('Paket Soal'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Paket Soal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: paketSoalList == null
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : SingleChildScrollView(
                child: Wrap(
                  children:
                  List.generate(paketSoalList!.data!.length, (index) {
                    final currentPaketSoal = paketSoalList!.data![index];
                    return Container(
                      padding: EdgeInsets.all(3),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: PaketSoalWidget(data: currentPaketSoal),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaketSoalWidget extends StatelessWidget {
  const PaketSoalWidget({
    Key? key,
    required this.data,
  }) : super(key: key);
  final PaketSoalData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                KerjakanLatihanSoalPage(id: data.exerciseId!)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(0.2),
              ),
              padding: EdgeInsets.all(12),
              child: Image.asset(
                R.assets.icNote,
                width: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              data.exerciseTitle!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${data.jumlahDone}/${data.jumlahSoal} Paket Soal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: R.colors.greySubtitleHome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}