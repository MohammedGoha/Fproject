import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing/config/cfg.dart';
import 'dart:convert';
import '../utils/theme.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  List candidates = [];
  String electionName = 'جاري تحميل الانتخابات...';

  @override
  void initState() {
    super.initState();
    fetchElectionName();
    fetchCandidates();
  }

  Future<void> fetchElectionName() async {
    try {
      final response = await http.get(Uri.parse('$server:5000/elections'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          electionName = data[0]['name'] ?? 'الانتخابات الرئاسية';
        });
        _showSnackbar("✅ تم تحميل اسم الانتخابات بنجاح", successGreen);
      } else {
        throw Exception('Failed to load election name');
      }
    } catch (e) {
      setState(() {
        electionName = '❌ فشل تحميل اسم الانتخابات';
      });
      _showSnackbar("⚠️ خطأ في تحميل اسم الانتخابات", errorRed);
    }
  }

  Future<void> fetchCandidates() async {
    try {
      final response = await http.get(Uri.parse('$server:5000/candidates'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          candidates = data;
        });
        _showSnackbar("✅ تم تحميل المرشحين بنجاح", successGreen);
      } else {
        throw Exception('Failed to load candidates');
      }
    } catch (e) {
      setState(() {
        candidates = [];
      });
      _showSnackbar("⚠️ خطأ في تحميل المرشحين", errorRed);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: arabicFont),
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('التصويت الإلكتروني', style: TextStyle(fontFamily: arabicFont)),
          backgroundColor: nileBlue,
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: desertSand,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        electionName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: pharaohGreen,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: candidates.isEmpty
                        ? Center(child: CircularProgressIndicator(color: gold))
                        : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: candidates.length,
                      itemBuilder: (context, index) {
                        final candidate = candidates[index];
                        return _buildCandidateCard(candidate, context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCandidateCard(Map candidate, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CandidateDetailScreen(candidate: candidate),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: candidate['image'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  candidate['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person, size: 60, color: nileBlue),
                      ),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Icon(Icons.person, size: 60, color: nileBlue),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate['name'] ?? 'غير معروف',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: arabicFont,
                      color: primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'العمر: ${candidate['age']?.toString() ?? 'غير متوفر'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: arabicFont,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CandidateDetailScreen extends StatelessWidget {
  final Map candidate;

  CandidateDetailScreen({required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              candidate['name'] ?? 'تفاصيل المرشح',
              style: TextStyle(fontFamily: arabicFont)),
          backgroundColor: nileBlue,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gold, width: 2),
                ),
                child: candidate['image'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    candidate['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.person, size: 80, color: nileBlue),
                        ),
                  ),
                )
                    : Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.person, size: 80, color: nileBlue),
                ),
              ),
              SizedBox(height: 20),
              Text(
                candidate['name'] ?? 'غير معروف',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: arabicFont,
                  color: pharaohGreen,
                ),
              ),
              SizedBox(height: 10),
              _buildDetailRow('العمر:', candidate['age']?.toString() ?? 'غير متوفر'),
              _buildDetailRow('المؤهل:', candidate['education'] ?? 'غير متوفر'),
              SizedBox(height: 10),
              Text(
                'البرنامج الانتخابي:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: arabicFont,
                  color: pharaohGreen,
                ),
              ),
              SizedBox(height: 5),
              Text(
                candidate['description'] ?? 'لا يوجد وصف متوفر',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: arabicFont,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: secondaryButtonStyle,
                    child: Text('رجوع', style: TextStyle(fontFamily: arabicFont)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'تم التصويت لـ ${candidate['name']}',
                              style: TextStyle(fontFamily: arabicFont)),
                          backgroundColor: successGreen,
                        ),


                      );
                    },
                    style: primaryButtonStyle,
                    child: Text('التصويت الآن', style: TextStyle(fontFamily: arabicFont)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontFamily: arabicFont,
              color: primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontFamily: arabicFont,
                color: primaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}