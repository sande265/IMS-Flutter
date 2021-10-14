import 'package:flash_chat/Components/IconContent.dart';
import 'package:flash_chat/Components/card.dart';
import 'package:flash_chat/api/Api.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/new_Sale.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> _data = {
    "sales": '',
    "qty": '',
    "total": '',
  };

  var data = [];
  var loading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
    if (data.isNotEmpty) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('HomePage'),
        backgroundColor: Color(0xff111328),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  fetchData();
                },
                child: Tooltip(
                  message: "Refresh Data.",
                  child: Icon(
                    Icons.refresh,
                    size: 26.0,
                  ),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      body: Container(
        color: Color(0xffD8E3E7),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: ReusableCard(
                          onPress: () {},
                          colour: Color(0xff111328),
                          cardChild: IconContent(
                            icon: Icons.attach_money_outlined,
                            text: 'Total Sales',
                            itemValue:
                                _data['total'] != '' ? _data['total'] : '0',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ReusableCard(
                          onPress: () {
                            // fetchData();
                          },
                          colour: Color(0xff111328),
                          cardChild: IconContent(
                            icon: Icons.production_quantity_limits,
                            text: 'Quantity Sold',
                            itemValue: _data['qty'] != '' ? _data['qty'] : '0',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'List of Sold Items.',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              DataTable(
                                decoration: BoxDecoration(
                                  color: kThemeColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'Product Name',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Qty',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                                rows: data.length > 0
                                    ? data
                                        .map((item) => DataRow(cells: [
                                              DataCell(Text(
                                                  '${item['product_name']}')),
                                              DataCell(Text('${item['qty']}')),
                                              DataCell(Text(
                                                  '${item['sale_price']}')),
                                            ]))
                                        .toList()
                                    : [
                                        DataRow(cells: [
                                          DataCell(Text('')),
                                          DataCell(Text('No Data')),
                                          DataCell(Text(''))
                                        ]),
                                      ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Tooltip(
                          message: "Create a New Sale of Item.",
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, NewSalePage.id);
                            },
                            icon: Icon(
                              Icons.money_rounded,
                            ),
                            autofocus: true,
                            label: Text(
                              'New Sale',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void fetchData() async {
    final DateTime now = DateTime.now();
    var currentDate = now.toString().split(" ")[0];
    var response = await Api().getData('/sales?date=$currentDate');
    print(response);
    if (response['message'] != null && response['data'] == null) {
      _showToast(context, response['message'], Colors.red);
      setState(() {
        loading = false;
        _data = {
          "sales": '',
          "qty": '',
          "total": '',
        };
        data = [];
      });
    } else {
      setState(() {
        loading = false;
        _data['total'] = response['total_amount'] != null
            ? response['total_amount'].toString()
            : '';
        _data['qty'] = response['total_qty'] != null
            ? response['total_qty'].toString()
            : '';
        data = response['data'] != null ? response['data'] : {};
      });
      // print(response);
    }
  }

  void _showToast(BuildContext context, message, color) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$message'),
        backgroundColor: color,
        action:
            SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
