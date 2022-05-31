import 'package:flutter/material.dart';
import 'package:zhsou/entity.dart';
import 'package:zhsou/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class RecordItemWidget extends StatelessWidget {
  final Record record;
  const RecordItemWidget(this.record, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(record.text),
      subtitle: Text('文档编号：${record.id}'),
      trailing: IconButton(
        icon: Icon(Icons.ads_click),
        onPressed: () {},
      ),
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  final SearchResponse searchResponse;
  const SearchResultWidget(this.searchResponse, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '搜索完毕，搜索结果数：${searchResponse.total}，搜索用时：${searchResponse.useTime}'),
        Expanded(
          child: ListView(
            children: searchResponse.records.map(
              (e) {
                return Column(
                  children: [
                    RecordItemWidget(e),
                    const Divider(),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class SearchInputWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final ValueChanged<String>? callback;
  SearchInputWidget({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(hintText: "请输入搜索关键字"),
            controller: controller,
            onSubmitted: (String val) {
              if (callback != null) callback!(val);
            },
          ),
        ),
        IconButton(
          onPressed: () {
            if (callback != null) callback!(controller.text);
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final ValueNotifier<SearchResponse> _valueNotifier =
      ValueNotifier(SearchResponse());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("搜索引擎"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchInputWidget(
              callback: (val) async {
                _valueNotifier.value = await SearcherService().search(val, 1);
              },
            ),
            Expanded(
              child: ValueListenableBuilder<SearchResponse>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return SearchResultWidget(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
