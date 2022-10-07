import 'package:flutter/material.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';
import 'package:latihan_soal_flutter/models/result_response.dart';
import 'package:latihan_soal_flutter/providers/latihan_soal_provider.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.exerciseId}) : super(key: key);
  final String exerciseId;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ResultResponse? resultData;
  LatihanSoalProvider? latihanSoalProvider;

  getResult() async {
    latihanSoalProvider = Provider.of<LatihanSoalProvider>(context, listen: false);
    final result = await latihanSoalProvider!.getResult(widget.exerciseId);
    if (result.status == Status.success) {
      resultData = ResultResponse.fromJson(result.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: resultData == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                        ),
                        Text(
                          'Tutup',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Selamat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'Kamu telah menyelesaikan Kuiz ini',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 34),
                    Image.asset(
                      R.assets.imgResult,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    SizedBox(height: 35),
                    Text(
                      'Nilai kamu:',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      resultData!.data!.result!.jumlahScore!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 96,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
