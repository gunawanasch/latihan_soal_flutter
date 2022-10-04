import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:latihan_soal_flutter/models/kerjakan_soal_list.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';
import 'package:latihan_soal_flutter/repository/latihan_soal_api.dart';

class KerjakanLatihanSoalPage extends StatefulWidget {
  const KerjakanLatihanSoalPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<KerjakanLatihanSoalPage> createState() =>
      _KerjakanLatihanSoalPageState();
}

class _KerjakanLatihanSoalPageState extends State<KerjakanLatihanSoalPage>
    with SingleTickerProviderStateMixin {
  KerjakanSoalList? soalList;

  getQuestionList() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      soalList = KerjakanSoalList.fromJson(result.data!);
      _controller = TabController(length: soalList!.data!.length, vsync: this);
      setState(() {});
    }
  }

  TabController? _controller;

  @override
  void initState() {
    super.initState();
    getQuestionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan Soal'),
      ),
      //Tombol selanjutnya atau submit
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Selanjutnya')),
          ],
        ),
      ),
      body: soalList == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                //TabBar no soal
                Container(
                  child: TabBar(
                      controller: _controller,
                      tabs: List.generate(
                          soalList!.data!.length,
                          (index) => Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.black),
                              ))),
                ),
                //TabBar view soal dan pilihan jawaban,
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: TabBarView(
                      controller: _controller,
                      children: List.generate(
                        soalList!.data!.length,
                        (index) => SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Soal no ${index + 1}'),
                              if (soalList!.data![index].questionTitle != null)
                                Html(data:soalList!.data![index].questionTitle!),
                              if (soalList!.data![index].questionTitleImg != null)
                                Image.network(
                                    soalList!.data![index].questionTitleImg!),
                              _buildOption('A.', soalList!.data![index].optionA,
                                  soalList!.data![index].optionAImg),
                              _buildOption('B.', soalList!.data![index].optionB,
                                  soalList!.data![index].optionBImg),
                              _buildOption('C.', soalList!.data![index].optionC,
                                  soalList!.data![index].optionCImg),
                              _buildOption('D.', soalList!.data![index].optionD,
                                  soalList!.data![index].optionDImg),
                              _buildOption('E.', soalList!.data![index].optionE,
                                  soalList!.data![index].optionEImg),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Container _buildOption(String option, String? answer, String? answerImg) {
    return Container(
      child: Row(
        children: [
          Text(option),
          if (answer != null) Expanded(child: Html(data:answer)),
          if (answerImg != null) Expanded(child: Image.network(answerImg)),
        ],
      ),
    );
  }
}
