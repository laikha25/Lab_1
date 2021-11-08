import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const CurrencyPage());

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 3,
              child: Image.asset(
                'assets/images/currency_logo.png',
                scale: 1,
              )),
          const Flexible(flex: 7, child: CurrencyConvForm())
        ],
      ),
    );
  }
}

class CurrencyConvForm extends StatefulWidget {
  const CurrencyConvForm({Key? key}) : super(key: key);

  @override
  _CurrencyConvFormState createState() => _CurrencyConvFormState();
}

class _CurrencyConvFormState extends State<CurrencyConvForm> {
  var curValueFrom = 0.0,
      curValueTo = 0.0,
      convertVal = 0.0,
      inputValue = 0.0,
      inputValue2 = "",
      convertValFinal = 0.0,
      desc = 0.0,
      valEmpty = "",
      symbol = "";
  final _formKey = GlobalKey<FormState>();

  TextEditingController valueEditingController = TextEditingController();
  String selectFrom = "MYR", selectTo = "MYR";
  List<String> curList = ["MYR", "SGD", "JPY", "USD", "KRW", "CNY"];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Value cannot be empty';
                    }
                  },
                  controller: valueEditingController,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                      hintText: "Enter value to convert",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                const Text(""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                      itemHeight: 60,
                      value: selectFrom,
                      onChanged: (newValue) {
                        setState(() {
                          selectFrom = newValue.toString();
                        });
                      },
                      items: curList.map((selectCur) {
                        return DropdownMenuItem(
                          child: Text(
                            selectCur,
                          ),
                          value: selectCur,
                        );
                      }).toList(),
                    ),
                    const Text(
                      "To",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      itemHeight: 60,
                      value: selectTo,
                      onChanged: (newValue) {
                        setState(() {
                          selectTo = newValue.toString();
                        });
                      },
                      items: curList.map((selectCur) {
                        return DropdownMenuItem(
                          child: Text(
                            selectCur,
                          ),
                          value: selectCur,
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const Text(""),
                ElevatedButton(
                  onPressed: _loadCurrency,
                  child: const Text('Convert'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(130, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textStyle: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      const Text(
                        "Result",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15.0),
                      Text(desc.toStringAsFixed(2) + " $symbol",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadCurrency() async {
    if (!_formKey.currentState!.validate()) {}

    if (valueEditingController.text.isNotEmpty) {
      var apiid = "28c4e8f0-3d02-11ec-b5e2-555da3d26e56";
      var url =
          Uri.parse('https://freecurrencyapi.net/api/v2/latest?apikey=$apiid');
      var response = await http.get(url);
      var rescode = response.statusCode;

      inputValue = double.parse(valueEditingController.text);
      if (rescode == 200) {
        //200 indicate the query is success
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);

        setState(() {
          if (selectFrom == "MYR" ||
              selectFrom == "SGD" ||
              selectFrom == "JPY" ||
              selectFrom == "KRW" ||
              selectFrom == "CNY") {
            if (selectFrom == "MYR") {
              curValueFrom = parsedJson['data']['MYR'];
            } else if (selectFrom == "SGD") {
              curValueFrom = parsedJson['data']['SGD'];
            } else if (selectFrom == "JPY") {
              curValueFrom = parsedJson['data']['JPY'];
            } else if (selectFrom == "KRW") {
              curValueFrom = parsedJson['data']['KRW'];
            } else if (selectFrom == "CNY") {
              curValueFrom = parsedJson['data']['CNY'];
            }
            convertVal = inputValue / curValueFrom;

            if (selectTo == "MYR" ||
                selectTo == "SGD" ||
                selectTo == "JPY" ||
                selectTo == "KRW" ||
                selectTo == "CNY") {
              if (selectTo == "MYR") {
                curValueTo = parsedJson['data']['MYR'];
                symbol = "Ringgit";
              } else if (selectTo == "SGD") {
                curValueTo = parsedJson['data']['SGD'];
                symbol = "Dollar";
              } else if (selectTo == "JPY") {
                curValueTo = parsedJson['data']['JPY'];
                symbol = "Yen";
              } else if (selectTo == "KRW") {
                curValueTo = parsedJson['data']['KRW'];
                symbol = "Won";
              } else if (selectTo == "CNY") {
                curValueTo = parsedJson['data']['CNY'];
                symbol = "Yuan";
              }
              convertValFinal = convertVal * curValueTo;
              desc = convertValFinal;
            }
            if (selectTo == "USD") {
              symbol = "Dollar";
              convertValFinal = inputValue / curValueFrom;
              desc = convertValFinal;
            }
          }

          if (selectFrom == "USD") {
            if (selectTo == "MYR") {
              curValueTo = parsedJson['data']['MYR'];
              symbol = "Ringgit";
            } else if (selectTo == "SGD") {
              curValueTo = parsedJson['data']['SGD'];
              symbol = "Dollar";
            } else if (selectTo == "JPY") {
              curValueTo = parsedJson['data']['JPY'];
              symbol = "Yen";
            } else if (selectTo == "KRW") {
              curValueTo = parsedJson['data']['KRW'];
              symbol = "Won";
            } else if (selectTo == "CNY") {
              curValueTo = parsedJson['data']['CNY'];
              symbol = "Yuan";
            }
            convertValFinal = inputValue * curValueTo;
            desc = convertValFinal;
          }
        });
      }
    }
  }
}
