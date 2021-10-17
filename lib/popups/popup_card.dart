import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ims_flutter/api/api.dart';
import 'package:ims_flutter/constants/constants.dart';
import 'package:ims_flutter/helpers/general_helpers.dart';
import 'package:ims_flutter/theme/app_theme.dart';

class PopupCard extends StatefulWidget {
  static const id = 'popup_card';
  const PopupCard({Key? key}) : super(key: key);

  @override
  _PopupCardState createState() => _PopupCardState();
}

class _PopupCardState extends State<PopupCard> {
  late Map<String, dynamic> _data = {
    "_selectedItem": '',
    "_dropDownValue": '',
    "_salePrice": '',
    "_qty": 1,
  };

  late Timer _timer;
  var value = 0;
  var data = [];
  var loading = true;
  var ctLoading = false;
  final fieldText = TextEditingController();

  void handleSubmit() async {
    if (_data['_selectedItem'] == '') {
      _showToast(context, 'Please Select Product', Colors.red);
      setState(() {
        ctLoading = false;
      });
    } else if (_data['_salePrice'] == '') {
      _showToast(context, 'Please Enter Sale Price.', Colors.red);
      setState(() {
        ctLoading = false;
      });
    } else {
      var data = {};
      data['sale_price'] = _data['_salePrice'];
      data['qty'] = _data['_qty'];
      var response =
          await Api().postData(data, '/sell/${_data['_selectedItem']}');
      print(response);
      if (response != null && response['data'] != null) {
        _showToast(context, response['message'], Colors.green);
        setState(() {
          ctLoading = false;
          _data = {
            "_selectedItem": '',
            "_dropDownValue": '',
            "_salePrice": '',
            "_qty": 1,
          };
          fieldText.clear();
        });
      } else {
        setState(() {
          ctLoading = false;
        });
        var error = response['message']['qty'].toString();
        _showToast(context, getErrorMessage(error), Colors.red);
      }
    }
  }

  void _showToast(BuildContext context, message, color) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$message',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        action: SnackBarAction(
            label: 'X',
            textColor: Colors.white,
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProducts();
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'add',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.background,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'New Sale',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: loading
                        ? const Center(
                            heightFactor: 2.0,
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Product',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: DropdownButton(
                                  hint: _data['_dropDownValue'] == ''
                                      ? Text(
                                          'Select product',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        )
                                      : Text(
                                          _data['_dropDownValue'],
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  isDense: true,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                  focusColor: Colors.lightBlueAccent,
                                  style: const TextStyle(color: Colors.black),
                                  items: data.map(
                                    (item) {
                                      return DropdownMenuItem<String>(
                                        value: item['product_name'],
                                        child: Text(item['product_name']),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    print(val);
                                    var itemId;
                                    data.forEach((item) {
                                      if (item['product_name'] == val) {
                                        itemId = item['id'];
                                      }
                                    });
                                    setState(
                                      () {
                                        _data['_dropDownValue'] =
                                            val.toString();
                                        _data['_selectedItem'] =
                                            itemId.toString();
                                        print(_data);
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Sale Price',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0),
                                child: TextField(
                                  decoration:
                                      kNormalInputFieldDecoration.copyWith(
                                    hintText: 'Enter Sale Price',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  controller: fieldText,
                                  onChanged: (value) {
                                    setState(() {
                                      _data['_salePrice'] = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTapUp: (TapUpDetails details) {
                                      _timer.cancel();
                                    },
                                    onTapCancel: () {
                                      _timer.cancel();
                                    },
                                    onTapDown: (TapDownDetails details) {
                                      _timer = Timer.periodic(
                                          const Duration(milliseconds: 300),
                                          (t) {
                                        if (_data['_qty'] > 1) {
                                          setState(() {
                                            _data['_qty']--;
                                          });
                                        } else {
                                          _showToast(
                                              context,
                                              'Quantity Cannot be lower than 1.',
                                              Colors.red);
                                        }
                                      });
                                    },
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_data['_qty'] > 1) {
                                          setState(() {
                                            _data['_qty']--;
                                          });
                                        } else {
                                          _showToast(
                                              context,
                                              'Quantity Cannot be lower than 1.',
                                              Colors.red);
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(10),
                                        primary: Colors
                                            .white, // <-- Button color
                                        onPrimary:
                                            Colors.red, // <-- Splash color
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _data['_qty'].toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30.0),
                                  ),
                                  GestureDetector(
                                    onTapUp: (TapUpDetails details) {
                                      _timer.cancel();
                                    },
                                    onTapCancel: () {
                                      _timer.cancel();
                                    },
                                    onTapDown: (TapDownDetails details) {
                                      _timer = Timer.periodic(
                                          const Duration(milliseconds: 300),
                                          (t) {
                                        setState(() {
                                          _data['_qty']++;
                                        });
                                      });
                                    },
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _data['_qty']++;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(10),
                                        primary: Colors
                                            .white, // <-- Button color
                                        onPrimary: Colors
                                            .green, // <-- Splash color
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      ctLoading = true;
                                    });
                                    handleSubmit();
                                  },
                                  child: ctLoading
                                      ? const Center(
                                          child:
                                              CircularProgressIndicator(),
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors
                                          .greenAccent, //background color of button
                                      side: const BorderSide(
                                          width: 3,
                                          color: Colors
                                              .lightBlueAccent), //border width and color
                                      elevation: 3, //elevation of button
                                      shape: RoundedRectangleBorder(
                                          //to set border radius to button
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      padding: const EdgeInsets.all(10)),
                                ),
                              )
                            ],
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getProducts() async {
    var response = await Api().getData('/products?limit=1000');
    print(response);
    if (response['data'] != null) {
      data = response['data'];
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }
}
