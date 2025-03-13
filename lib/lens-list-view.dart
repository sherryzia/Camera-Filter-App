import 'package:camerakit_flutter/lens_model.dart';
import 'package:flutter/material.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';

class LensListView extends StatefulWidget {
  final List<Lens> lensList;

  const LensListView({super.key, required this.lensList});

  @override
  State<LensListView> createState() => _LensListViewState();
}

class _LensListViewState extends State<LensListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Lenses'),
      ),
      body: widget.lensList.isEmpty
          ? const Center(child: Text('No lenses available'))
          : ListView.separated(
              itemCount: widget.lensList.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  final Map<String, dynamic> arguments = {
                    'lensId': widget.lensList[index].id ?? "",
                    'groupId': widget.lensList[index].groupId ?? ""
                  };
                  Navigator.of(context).pop(arguments);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      if (widget.lensList[index].thumbnail != null &&
                          widget.lensList[index].thumbnail!.isNotEmpty)
                        Image.network(
                          widget.lensList[index].thumbnail![0],
                          width: 70,
                          height: 70,
                          errorBuilder: (context, error, stackTrace) => 
                            Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                        ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          widget.lensList[index].name ?? 'Unnamed Lens',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
