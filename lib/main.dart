import 'package:flutter/material.dart';
import 'package:flutter_html_text/HTML_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTML Text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter HTML tags in text widget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          const HTMLText(
              'hihi <b>bold nextline</b> then some other normal text. Followed by more <b>Bold</b> text. Then some <i>Italics</i> text. also some <u>underline</u> text.'),
          const HTMLText('hihi'),
          const HTMLText('<b><i>SOME VERY IMPORTANT TEXT</i></b>'),
          const HTMLText('<i>some italic text</i> followed by <b>some bold text</b>'),
          const HTMLText('<b><u><i>text with all 3 modifieres</i></u></b>.'),
          const HTMLText('<b><u><i>texxt</i> with</u> all</b> 3 modifieres.'),
          const HTMLText(
              'before text and <b>Bold with italics <i>text</i> and</b> x <u>underline <b><i>more</i></b>.</u>'),
          HTMLText(
            'this is a <a href="https://w3schools.com">link</a>............',
            onTap: (text) {
              print('returned $text');
            },
          ),
          HTMLText(
            "this <b>is</b> a <u><a href='xyz'>link</a>....xxx</u>.......xxx.",
            onTap: (xx) {
              print('object $xx');
            },
          ),
        ],
      )),
    );
  }
}
