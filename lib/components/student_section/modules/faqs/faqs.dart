import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  final String token;
  const FAQ({super.key, required this.token});

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  int? currentPanelIndex;
  String searchQuery = '';

  final List<Map<String, dynamic>> faqSections = [
    {
      'title': 'Online Classes',
      'items': [
        {
          'question': 'How to join a class?',
          'answer':
              'Allow permissions such as camera and microphone in the browser. Go to home/dashboard page and under online classes section, join the scheduled class by clicking on join',
        },
      ],
    },
    {
      'title': 'Exam',
      'items': [
        {
          'question': 'Can exams be taken on mobile devices?',
          'answer': 'Yes. But a device with larger sceen is recommended',
        },
        {
          'question': 'Is fullscreen mandatory while taking the exam?',
          'answer': 'Yes. If fullscreen mode is exited the exam will be ended',
        },
        {
          'question':
              'What happens if window focus is changes during the exam?',
          'answer': 'The exam will be ended',
        },
      ],
    },
    {
      'title': 'Study Material',
      'items': [
        {
          'question': 'Can study materials of other branch are accessible',
          'answer': 'Yes',
        },
        {
          'question': 'Is it possible to dowload entire study material?',
          'answer': 'Yes. In a compressed zip file',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredSections {
    if (searchQuery.isEmpty) {
      return faqSections;
    }
    return faqSections
        .map((section) {
          final filteredItems = section['items']
              .where((item) =>
                  item['question']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  item['answer']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
              .toList();
          return {
            'title': section['title'],
            'items': filteredItems,
          };
        })
        .where((section) => section['items'].isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('assets/faq_bg.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.61), BlendMode.darken)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Text(
                                "View all FAQ'S here",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ...filteredSections.map((section) => buildCustomExpansionPanelList(
                section['title'],
                (section['items'] as List)
                    .asMap()
                    .entries
                    .map((entry) => buildCustomExpansionPanel(
                        entry.value['question'],
                        entry.value['answer'],
                        faqSections.indexOf(section) * 100 + entry.key))
                    .toList())),
          ],
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
