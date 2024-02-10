import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

/// This example shows the usage of the [StickyGroupedListView] to create an
/// chat-like application where the elements are grouped by days and the
/// messages are shown on the left or right of the screen.
void main() => runApp(const MyApp());

List<Element> _elements = <Element>[

];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat with Peter'),
        ),
        bottomSheet: FloatingActionButton(onPressed: () {
          _elements.insert(0, Element(DateTime.now(), DateTime.now().millisecondsSinceEpoch.toString()));
          setState(() {});
        }),
        bottomNavigationBar: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter a new message here',
          ),
        ),
        body: StickyGroupedListView<Element, DateTime>(
          elements: _elements,
          order: StickyGroupedListOrder.DESC,
          reverse: false,
          groupBy: (Element element) => DateTime(
            element.date.year,
            element.date.month,
            element.date.day,
          ),
          floatingHeader: true,
          groupSeparatorBuilder: _getGroupSeparator,
          itemBuilder: _getItem, onScroll: (ScrollPosition scrollPosition) {  },
        ),
      ),
    );
  }

  Widget _getGroupSeparator(Element element) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat.yMMMd().format(element.date),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItem(BuildContext ctx, Element element) {
    return Align(
      alignment: element.swapped ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        width: 370,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: SizedBox(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: element.swapped
                  ? Text(element.date.millisecondsSinceEpoch.toString())
                  : const Icon(Icons.person),
              title: Text(element.name),
              trailing: element.swapped
                  ? const Icon(Icons.person_outline)
                  : Text(DateFormat.Hm().format(element.date)),
            ),
          ),
        ),
      ),
    );
  }
}

class Element implements Comparable {
  DateTime date;
  String name;
  bool swapped = false;

  Element(this.date, this.name, [this.swapped = false]);

  @override
  int compareTo(other) {
    return date.compareTo(other.date);
  }
}
