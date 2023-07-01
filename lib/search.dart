import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class FilterOption {
  FilterOption({required this.name, required this.isChecked});
  String name;
  bool isChecked;
}

String formatDateTime(DateTime dateTime) {
  DateFormat dateFormat = DateFormat("yyyy.MM.dd (E) \nhh:mm a");
  String formattedDate = dateFormat.format(dateTime);
  return formattedDate;
}

class SearchPageState extends State<SearchPage> {
  final List<Item> _data = generateItems(1);
  DateTime checkinDate = DateTime.now();

  final List<FilterOption> _filters = [
    FilterOption(name: 'No Kids Zone', isChecked: false),
    FilterOption(name: 'Pet-Friendly', isChecked: false),
    FilterOption(name: 'Free breakfast', isChecked: false),
  ];

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Please Check\nyour choice :)')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.filter_list,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        _filters
                            .where((filter) => filter.isChecked)
                            .map((filter) => filter.name)
                            .toString(),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.date_range,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: <Widget>[
                        Text('In ' + checkinDate.toString()),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDateTime(checkinDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _neverSatisfied();
        },
        label: const Text(
          'Search',
          style: TextStyle(fontSize: 20),
        ),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: Colors.white,
        child: ListView(children: <Widget>[
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _data[index].isExpanded = !isExpanded;
              });
            },
            children: _data.map<ExpansionPanel>((Item item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const ListTile(
                    leading: Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Center(
                      child: Text("select filters"),
                    ),
                  );
                },
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _filters.map((filter) {
                    return Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 130,
                        ),
                        Checkbox(
                          value: filter.isChecked,
                          onChanged: (value) {
                            setState(() {
                              filter.isChecked = value!;
                            });
                          },
                        ),
                        Text(filter.name)
                      ],
                    );
                  }).toList(),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
          const ListTile(
            leading: Text(
              "Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📆 Check-in',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(formattedDate.toString())
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(180, 215, 251, 1.0),
                ),
                child: const Text('Select Date',
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: checkinDate,
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, child) {
                      return Theme(
                        data: ThemeData.dark(),
                        child: child!,
                      );
                    },
                  ).then((date) {
                    setState(() {
                      checkinDate = date!;
                    });
                  });
                },
              )
            ],
          ),
        ]),
      ),
    );
  }
}
