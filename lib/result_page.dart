import 'package:flutter/material.dart';
import 'package:task_app_calorie/api_service.dart';

class ResultPage extends StatefulWidget {
  final String base64Image;

  ResultPage({required this.base64Image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? responseText;
  Map<String, String> nutritionData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    callApiForData();
  }

  void callApiForData() async {
    String? data = await ApiService.sendImageToAPI(widget.base64Image);
    if (data != null) {
      setState(() {
        responseText = data;

        nutritionData = extractNutritionalInfo(data);
        isLoading = false;
      });
    }
  }

  Map<String, String> extractNutritionalInfo(String text) {
    final Map<String, String> extractedData = {};
    final RegExp regex = RegExp(r"\*\*([\w\s]+)\*\*:\s*~?([\d.]+[a-zA-Z]*)");

    for (final match in regex.allMatches(text)) {
      final key = match.group(1)?.trim() ?? "";
      final value = match.group(2)?.trim() ?? "";
      if (key.isNotEmpty && value.isNotEmpty) {
        extractedData[key] = value;
      }
    }
    return extractedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calorie Info")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: nutritionData.isNotEmpty
                  ? ListView.builder(
                      itemCount: nutritionData.length,
                      itemBuilder: (context, index) {
                        String key = nutritionData.keys.elementAt(index);
                        String value = nutritionData[key]!;
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(key,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(value),
                          ),
                        );
                      },
                    )
                  : Text(
                      responseText ?? "No data available",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
            ),
    );
  }
}
