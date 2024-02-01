import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/user_model.dart';

class ParticipantPickerWidget extends StatefulWidget {
  final List<UserModel> users;
  final List<UserModel> selectedParticipants;
  final Function(List<UserModel>) onParticipantsSelected;

  const ParticipantPickerWidget({super.key,
    required this.users,
    required this.selectedParticipants,
    required this.onParticipantsSelected,
  });

  @override
  _ParticipantPickerWidgetState createState() =>
      _ParticipantPickerWidgetState();
}

class _ParticipantPickerWidgetState extends State<ParticipantPickerWidget> {
  bool _isSelectAll = false;
  String _filterText = '';
  final int _participantsPerPage = 5;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _isSelectAll = widget.selectedParticipants.length == widget.users.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) {
            setState(() {
              _filterText = value;
              _currentPage = 0;
              _isSelectAll =
                  widget.selectedParticipants.length == widget.users.length;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Search Participants',
            labelStyle: TextStyle(color: ColorPalette.highlight),
          ),
        ),
        const Text("Selected Participants:"),
        CheckboxListTile(
          title: const Text("Select All"),
          value: _isSelectAll,
          onChanged: (bool? value) {
            setState(() {
              _isSelectAll = value ?? false;
              if (_isSelectAll) {
                widget.onParticipantsSelected([...widget.users]);
              } else {
                widget.onParticipantsSelected([]);
              }
            });
          },
        ),
        ..._getPaginatedFilteredParticipants().map(
          (participant) => CheckboxListTile(
            title: Text("${participant.firstName} ${participant.lastName}"),
            value: widget.selectedParticipants.contains(participant),
            onChanged: (bool? value) {
              setState(() {
                if (value != null) {
                  List<UserModel> updatedParticipants = [
                    ...widget.selectedParticipants
                  ]; // Nowa lista z tymi samymi elementami
                  if (value) {
                    updatedParticipants.add(participant);
                  } else {
                    updatedParticipants.removeWhere((p) => p == participant);
                  }
                  widget.onParticipantsSelected(updatedParticipants);
                  _isSelectAll = widget.users
                      .every((user) => updatedParticipants.contains(user));
                }
              });
            },
          ),
        ),
        // Pagination controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentPage > 0
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
            ),
            Text("Page ${_currentPage + 1}"),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _currentPage < _calculateTotalPages() - 1
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  List<UserModel> _getFilteredParticipants() {
    return widget.users.where((user) {
      final fullName = "${user.firstName} ${user.lastName}".toLowerCase();
      final searchQuery = _filterText.toLowerCase();
      return fullName.contains(searchQuery);
    }).toList();
  }

  List<UserModel> _getPaginatedFilteredParticipants() {
    final startIndex = _currentPage * _participantsPerPage;
    return _getFilteredParticipants()
        .skip(startIndex)
        .take(_participantsPerPage)
        .toList();
  }

  int _calculateTotalPages() {
    return ((_getFilteredParticipants().length - 1) / _participantsPerPage)
        .ceil();
  }
}
