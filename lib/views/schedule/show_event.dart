import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/user_service.dart';
import 'package:sizer/sizer.dart';

class ShowEvent extends StatefulWidget {
  final Event event;

  const ShowEvent({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<ShowEvent> createState() => _ShowEventState();
}

class _ShowEventState extends State<ShowEvent> {
  late DateTime _selectedDateTime;
  late UserModel? _selectedOrganizer;
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.event.date;
    _loadOrganizer();
  }

  Future<void> _loadOrganizer() async {
    if (widget.event.organizerId != null) {
      UserModel? organizer =
          await UserService.getUserById(widget.event.organizerId!);
      setState(() {
        _selectedOrganizer = organizer;
      });
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SizedBox(height: 40.h,child: const Center(child: CircularProgressIndicator()))
        : Container(
            padding: const EdgeInsets.all(16.0),
            height: 40.h,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Center(
                        child: Text(
                          _selectedDateTime.toString().substring(0, 16),
                          style: const TextStyle(
                            color: ColorPalette.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        widget.event.title,
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.highlight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Description:",
                            style: TextStyle(
                                fontSize: 10.sp, color: ColorPalette.secondary),
                          ),
                          Text(
                            widget.event.description ?? 'No Description',
                            style: TextStyle(
                                fontSize: 16.sp, color: ColorPalette.secondary),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Coach: ",
                            style: TextStyle(
                                fontSize: 16.sp, color: ColorPalette.secondary),
                          ),
                          Text(
                            "${_selectedOrganizer!.firstName} ${_selectedOrganizer!.lastName}",
                            style: TextStyle(
                                fontSize: 16.sp, color: ColorPalette.highlight),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop<bool>(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0)),
                  child: const Text("Close",
                      style:
                          TextStyle(fontSize: 18, color: ColorPalette.primary)),
                ),
              ],
            ),
          );
  }
}
