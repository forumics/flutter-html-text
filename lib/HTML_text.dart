import 'dart:math';
import 'dart:ui' as ui;
import 'dart:html';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HTMLText extends StatefulWidget {
  final TextStyle style;
  final String data;
  final String link;
  final Function? onTap;

  const HTMLText(this.data, {super.key, this.style = const TextStyle(), this.link = '', this.onTap});

  @override
  State<HTMLText> createState() => _HTMLText();
}

class _HTMLText extends State<HTMLText> {
  final HtmlElement _htmlElement = ParagraphElement();
  late List<TextSpan> textWidget = [];
  late String data;
  late TextStyle currentStyle = widget.style;

  void printTags(String text, {String isLink = ''}) {
    if (getFirstHTMLTagPos(text) == 0) {
      if (findStartHTMLTag(text) == 0) {
        addHTMLStyleTag(text.substring(0, 3));
        if (text.length > getTagSize(text)) {
          if (text.substring(0, 3) == '<a ') {
            printTags(text.substring(getTagSize(text)), isLink: getHref(text));
          } else {
            printTags(text.substring(getTagSize(text)), isLink: isLink);
          }
        }
      } else {
        removeHTMLStyleTag(text.substring(0, 4));
        if (text.length > 4) {
          printTags(text.substring(4), isLink: '');
        }
      }
    } else {
      if (getFirstHTMLTagPos(text) != -1) {
        printHTMLTags(text.substring(0, getFirstHTMLTagPos(text)), isLink);
        printTags(text.substring(getFirstHTMLTagPos(text)), isLink: isLink);
      } else {
        printHTMLTags(text, isLink);
      }
    }
  }

  void printHTMLTags(String text, String isLink) {
    if (isLink.isNotEmpty) {
      textWidget.add(TextSpan(
          text: text,
          style: currentStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              widget.onTap!(isLink);
            }));
    } else {
      textWidget.add(TextSpan(text: text, style: currentStyle));
    }
  }

  @override
  void initState() {
    super.initState();
    data = widget.data.replaceAll('<br/>', '\n').replaceAll('<br />', '\n').replaceAll('<br>', '\n');
    if (findHTMLTag(data)) {
      printTags(data);
    } else {
      textWidget.add(TextSpan(text: data, style: widget.style));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewType = 'html-text-${widget.data}';

    if (widget.link != '') {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
          viewType,
          (_) => AnchorElement(href: widget.link)
            ..text = widget.data
            ..style.fontSize = '14px'
            ..style.color = '#ff0000'
            ..style.margin = '0px'
            ..style.padding = '0px'
            ..style.height = '0px'
            ..style.width = '0px'
            ..style.overflow = 'hidden'
            ..style.visibility = 'hidden');
    } else {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
          viewType,
          (_) => _htmlElement
            ..text = widget.data
            ..style.top = '0px'
            ..style.left = '0px'
            ..style.fontSize = '14px'
            ..style.color = '#ff0000'
            ..style.margin = '0px'
            ..style.padding = '0px'
            ..style.height = '0px'
            ..style.width = '0px'
            ..style.overflow = 'hidden');
    }

    return Column(children: [
      Text.rich(TextSpan(text: '', children: textWidget)),
      SizedBox.shrink(
          child: IgnorePointer(
        child: HtmlElementView(viewType: viewType),
      )),
    ]);
  }

  int getFirstHTMLTagPos(String text) {
    int start = findStartHTMLTag(text);
    int close = findFirstHTMLCloseTag(text);

    if (start == -1) {
      start = 1000;
    }
    if (close == -1) {
      close = 1000;
    }

    if ([start, close].reduce(min) == 1000) {
      return -1;
    } else {
      return [start, close].reduce(min);
    }
  }

  bool findHTMLTag(String text) {
    if (findStartHTMLTag(text) == -1) {
      return false;
    } else {
      return true;
    }
  }

  int findStartHTMLTag(String text) {
    int bold = findBoldTag(text);
    int italics = findItalicsTag(text);
    int underline = findUnderLineTag(text);
    int ahref = findAHrefTag(text);

    if (bold == -1) {
      bold = 1000;
    }
    if (italics == -1) {
      italics = 1000;
    }
    if (underline == -1) {
      underline = 1000;
    }
    if (ahref == -1) {
      ahref = 1000;
    }

    if ([bold, italics, underline, ahref].reduce(min) == 1000) {
      return -1;
    } else {
      return [bold, italics, underline, ahref].reduce(min);
    }
  }

  int findFirstHTMLCloseTag(String text) {
    int bold = findBoldCloseTag(text);
    int italics = findItalicsCloseTag(text);
    int underline = findUnderLineCloseTag(text);
    int ahref = findAHrefCloseTag(text);

    if (bold == -1) {
      bold = 1000;
    }
    if (italics == -1) {
      italics = 1000;
    }
    if (underline == -1) {
      underline = 1000;
    }
    if (ahref == -1) {
      ahref = 1000;
    }

    if ([bold, italics, underline, ahref].reduce(min) == 1000) {
      return -1;
    } else {
      return [bold, italics, underline, ahref].reduce(min);
    }
  }

  int getTagSize(String text) {
    if (text.substring(0, 3) == '<a ') {
      return text.replaceAll('\'>', '">').indexOf('">') + 2;
    } else {
      return 3;
    }
  }

  int findBoldTag(String text) {
    return text.indexOf('<b>');
  }

  int findBoldCloseTag(String text) {
    return text.indexOf('</b>');
  }

  int findItalicsTag(String text) {
    return text.indexOf('<i>');
  }

  int findItalicsCloseTag(String text) {
    return text.indexOf('</i>');
  }

  int findUnderLineTag(String text) {
    return text.indexOf('<u>');
  }

  int findUnderLineCloseTag(String text) {
    return text.indexOf('</u>');
  }

  int findAHrefTag(String text) {
    return text.indexOf('<a ');
  }

  int findAHrefCloseTag(String text) {
    return text.indexOf('</a>');
  }

  String getHref(String text) {
    text = text.replaceAll('\'>', '">').replaceAll('<a href="', '').replaceAll("<a href='", '');
    return text.substring(0, text.indexOf('">'));
  }

  void addHTMLStyleTag(String tag) {
    switch (tag) {
      case '<b>':
        currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
        break;
      case '<i>':
        currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
        break;
      case '<u>':
        currentStyle = currentStyle.copyWith(decoration: TextDecoration.underline);
        break;
      case '<a ':
        currentStyle = currentStyle.copyWith(color: Colors.blue, decoration: TextDecoration.underline);
        break;
    }
  }

  void removeHTMLStyleTag(String tag) {
    switch (tag) {
      case '</b>':
        if (widget.style.fontWeight == null) {
          currentStyle = currentStyle.copyWith(fontWeight: FontWeight.normal);
        } else {
          currentStyle = currentStyle.copyWith(fontWeight: widget.style.fontWeight);
        }
        break;
      case '</i>':
        if (widget.style.fontStyle == null) {
          currentStyle = currentStyle.copyWith(fontStyle: FontStyle.normal);
        } else {
          currentStyle = currentStyle.copyWith(fontStyle: widget.style.fontStyle);
        }
        break;
      case '</u>':
        currentStyle = currentStyle.copyWith(decoration: widget.style.decoration);
        if (widget.style.fontStyle == null) {
          currentStyle = currentStyle.copyWith(decoration: TextDecoration.none);
        } else {
          currentStyle = currentStyle.copyWith(decoration: widget.style.decoration);
        }
        break;
      case '</a>':
        TextStyle tempStyle = currentStyle;
        currentStyle = widget.style;
        currentStyle = currentStyle.copyWith(fontWeight: tempStyle.fontWeight);
        currentStyle = currentStyle.copyWith(fontStyle: tempStyle.fontStyle);
        break;
    }
  }
}
