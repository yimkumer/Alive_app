import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TCreateMaterial extends StatefulWidget {
  const TCreateMaterial({super.key, required String token});

  @override
  State<TCreateMaterial> createState() => _TCreateMaterialState();
}

class _TCreateMaterialState extends State<TCreateMaterial> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            elevation: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.18,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF312F42),
                          Color(0xFF3D3B53),
                          Color(0xFF4A4864),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add new material',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Provide all the required information to create a material',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0XFFFCFCFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First input field Material name
                        const Text("Material name *",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF7B7E8B),
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Eg: New material for DS',
                              hintStyle: const TextStyle(
                                color: Color(0xFF7B7E8B),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B7E8B)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF59B9FE)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        //Second input field Description
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Description *",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF7B7E8B),
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Description goes here...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF7B7E8B),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B7E8B)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF59B9FE)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),

                        //Third input field Material Subject selection
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Material Subject *",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF7B7E8B),
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Eg: New material for DS',
                              hintStyle: const TextStyle(
                                color: Color(0xFF7B7E8B),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B7E8B)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF59B9FE)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                            "If subject not displayed in the dropdown then you already have a material for that subject",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7B7E8B),
                                fontWeight: FontWeight.bold)),

                        //Fourth input field Tags name
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                            "Add Tags (Type tags as comma seperated values)",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF7B7E8B),
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Add new tag',
                              hintStyle: const TextStyle(
                                color: Color(0xFF7B7E8B),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B7E8B)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF59B9FE)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        //IconButton for upload
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                            "Upload Attachments\nSupports: .pdf, .docx, .ppsx, .pptx, .odp\n",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF7B7E8B),
                                fontWeight: FontWeight.bold)),
                        Align(
                          alignment: Alignment.center,
                          child: CustomPaint(
                            painter: DashedRect(
                                color: Colors.grey[800]!,
                                strokeWidth: 2,
                                gap: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.upload_file_outlined,
                                  size: 100,
                                  color: Color.fromARGB(255, 133, 132, 132),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //Bottom Buttons
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Add new material button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF139CFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                " Add New Material",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                            //Cancel button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6A7F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                " Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for dashed border
class DashedRect extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRect(
      {this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    double x = 0, y = 0;
    while (x < size.width) {
      path.moveTo(x, 0);
      path.lineTo(x + gap, 0);
      x += gap * 2;
    }
    while (y < size.height) {
      path.moveTo(size.width, y);
      path.lineTo(size.width, y + gap);
      y += gap * 2;
    }
    x = size.width;
    while (x > 0) {
      path.moveTo(x, size.height);
      path.lineTo(x - gap, size.height);
      x -= gap * 2;
    }
    y = size.height;
    while (y > 0) {
      path.moveTo(0, y);
      path.lineTo(0, y - gap);
      y -= gap * 2;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
