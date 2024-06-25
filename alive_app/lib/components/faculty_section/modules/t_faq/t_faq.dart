import 'package:flutter/material.dart';

class TFaq extends StatefulWidget {
  final String token;
  const TFaq({super.key, required this.token});

  @override
  State<TFaq> createState() => _TFaqState();
}

class _TFaqState extends State<TFaq> {
  int? currentPanelIndex;

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
                buildCustomExpansionPanel(
                    'How to take attendance?',
                    'Once joined the sessions attendence will be taken automatically in certain interval of time',
                    1),
                buildCustomExpansionPanel(
                    'How to schedule online classes?',
                    "Add class to your time table using ERP and mark it as <em className='faq-em'>online</em>",
                    2),
              ]),
              buildCustomExpansionPanelList('Exam', [
                buildCustomExpansionPanel(
                    'How to create an exam?',
                    '1.  Click on the "+" at the bottom right corner of the screen in exams page\n'
                        '2.  Fill all the required fields such as exam name, description, topics, exam start and end time, and batches\n'
                        '3.  Click on the "Create" button at the bottom',
                    3),
                buildCustomExpansionPanel(
                    'How to add questions to an exam?',
                    'From a file\n\n'
                        '1.  Click on the Import Question button in exam page\n'
                        '2. Choose a text file in aiken format to import questions\n\n'
                        'From the UI\n\n'
                        '1. Click on the Add Question button in exam page\n'
                        '2. Fill all the required fields\n'
                        '3. Click on the Add button to add new question',
                    4),
                buildCustomExpansionPanel(
                    'Is the question restricted to english language only?',
                    'No. question can be framed in any language in text file or through UI',
                    5),
              ]),
              buildCustomExpansionPanelList('Study Material', [
                buildCustomExpansionPanel(
                    'What are the supported file formats?',
                    '.pdf, .docx, .ppsx, .pptx, .odp',
                    6),
                buildCustomExpansionPanel(
                    'Can files be added after creation of study material?',
                    'Yes',
                    7),
                buildCustomExpansionPanel(
                    'Which students have access to my notes?',
                    'Any student with Alive access will be able to access any study material on Alive',
                    8),
              ]),
              buildCustomExpansionPanelList('Academic Progress', [
                buildCustomExpansionPanel(
                    'Can study materials of other branch are accessible',
                    'Yes',
                    9),
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
