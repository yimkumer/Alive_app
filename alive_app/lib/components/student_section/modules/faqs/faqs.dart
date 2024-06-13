import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  final String token;
  const FAQ({super.key, required this.token});

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  int? currentPanelIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8.0,
          child: ListView(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
              buildCustomExpansionPanelList('Online Classes', [
                buildCustomExpansionPanel(
                    'How to join a class?',
                    'Allow permissions such as camera and microphone in the browser. Go to home/dashboard page and under online classes section, join the scheduled class by clicking on join',
                    0),
              ]),
              buildCustomExpansionPanelList('Exam', [
                buildCustomExpansionPanel(
                    'Can exams be taken on mobile devices?',
                    'Yes. But a device with larger sceen is recommended',
                    1),
                buildCustomExpansionPanel(
                    'Is fullscreen mandatory while taking the exam?',
                    'Yes. If fullscreen mode is exited the exam will be ended',
                    2),
                buildCustomExpansionPanel(
                    'What happens if window focus is changes during the exam?',
                    'The exam will be ended',
                    3),
              ]),
              buildCustomExpansionPanelList('Study Material', [
                buildCustomExpansionPanel(
                    'Can study materials of other branch are accessible',
                    'Yes',
                    4),
                buildCustomExpansionPanel(
                    'Is it possible to dowload entire study material?',
                    'Yes. In a compressed zip file',
                    5),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomExpansionPanelList(String title, List<Widget> panels) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          Column(children: panels),
        ],
      ),
    );
  }

  Widget buildCustomExpansionPanel(String title, String content, int index) {
    return CustomExpansionPanel(
      title: title,
      content: content,
      isExpanded: currentPanelIndex == index,
      onTap: () {
        setState(() {
          currentPanelIndex = currentPanelIndex == index ? null : index;
        });
      },
    );
  }
}

class CustomExpansionPanel extends StatefulWidget {
  final String title;
  final String content;
  final bool isExpanded;
  final VoidCallback onTap;

  const CustomExpansionPanel({
    required this.title,
    required this.content,
    required this.isExpanded,
    required this.onTap,
    super.key,
  });

  @override
  _CustomExpansionPanelState createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: const Color(0xFFF7F9FD),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(widget.isExpanded ? Icons.remove : Icons.add),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(widget.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: ConstrainedBox(
                constraints: widget.isExpanded
                    ? const BoxConstraints()
                    : const BoxConstraints(maxHeight: 0.0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(widget.content),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
