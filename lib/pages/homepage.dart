import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:election_exit_poll_620710303/services/api.dart';
import 'package:election_exit_poll_620710303/models/candidate.dart';
import 'package:google_fonts/google_fonts.dart';

class  homePage extends StatefulWidget {
  static const routeName = '/home_page';
  const homePage ({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();

}

class _homePageState extends State<homePage> {
  late Future<List<Candidate>> _candidateFuture;
  Future<void> _election(int candidateNumber) async {
    var elector =
    (await Api().submit('exit_poll', {'candidateNumber': candidateNumber}));
    _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ ${elector.toString()}');
  }

  _handleClickCandidate(int candidate) {
    _election(candidate);
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _candidateFuture = _fetch();
  }

  Future<List<Candidate>> _fetch() async {
    List list = await Api().fetch('exit_poll');
    var candidate = list.map((item) => Candidate.fromJson(item)).toList();
    print("asd "+candidate.toString());
    return candidate;
  }

  Widget _buildCandidateCard(BuildContext context) {
    return FutureBuilder<List<Candidate>>(
      future: _candidateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var candidateList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: candidateList!.length,
            itemBuilder: (BuildContext context, int index) {
              var candidate = candidateList[index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                color: Colors.white.withOpacity(0.5),
                child: InkWell(
                  onTap: () => _handleClickCandidate(candidate.candidateNumber),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${candidate.candidateNumber}',

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${candidate.candidateTitle} ${candidate.candidateFirstName} ${candidate.candidateLastName}',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _candidateFuture = _fetch();
                    });
                  },
                  child: const Text('ลองใหม่'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OutlinedButton(
        onPressed: () {
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.purple,
        ),
        child: Text(
            'ดูผล',
            style: Theme.of(context).textTheme.bodyText2
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  'assets/images/vote_hand.png',
                  width: 70.0,
                  height: 70.0,
                  //fit: BoxFit.cover,
                ),
              ),
              Text(
                  'EXIT POLL',
                  style: Theme.of(context).textTheme.bodyText2
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'เลือกตั้ง อบต.',
                    style: Theme.of(context).textTheme.headline1
                ),
              ),
              Text(
                  'รายชื่อผู้สมัครรับเลือกตั้ง',
                  style: Theme.of(context).textTheme.bodyText2
              ),
              Text(
                  'นายกองค์การบริหารส่วนตำบลเขาพระ',
                  style: Theme.of(context).textTheme.bodyText2
              ),
              Text(
                  'อำเภอเมืองนครนายก จังหวัดนครนายก',
                  style: Theme.of(context).textTheme.bodyText2
              ),
              _buildCandidateCard(context),
            ],
          ),
        ),
      ),
    );
  }

  }



