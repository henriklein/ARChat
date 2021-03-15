import 'package:arkit_plugin_example/widget_projection.dart';
import 'package:flutter/material.dart';
import 'Custom.dart';
import 'home.dart';

void main() => runApp(MaterialApp(home: MobileApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final samples = [
      Sample(
        "Custom Project",
        "combining multiple events",
        Icons.multiline_chart,
        () => Navigator.of(context)
            .push<void>(MaterialPageRoute(builder: (c) => CustomProject())),
      ),
      Sample(
        'Widget Projection',
        'Flutter widgets in AR',
        Icons.widgets,
        () => Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (c) => WidgetProjectionPage())),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ARKit Demo'),
      ),
      body:
          ListView(children: samples.map((s) => SampleItem(item: s)).toList()),
    );
  }
}

class SampleItem extends StatelessWidget {
  const SampleItem({Key key, this.item}) : super(key: key);
  final Sample item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => item.onTap(),
        child: ListTile(
          leading: Icon(item.icon),
          title: Text(
            item.title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          subtitle: Text(
            item.description,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }
}

class Sample {
  const Sample(this.title, this.description, this.icon, this.onTap);
  final String title;
  final String description;
  final IconData icon;
  final Function onTap;
}
