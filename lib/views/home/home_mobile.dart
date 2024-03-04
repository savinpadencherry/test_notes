part of home_view;

class _HomeMobile extends StatefulWidget {
  const _HomeMobile();

  @override
  State<_HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<_HomeMobile> with LogMixin {
  List<Note> notes = []; // List to store notes
  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final uuid = const Uuid();
  var rng = Random();
  @override
  void initState() {
    super.initState();
    Provider.of<TestRepository>(context, listen: false).loadNotes();
    setState(() {});
  }

  void editNote(
    Note note,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        warningLog('Id being sent ${note.id}');
        TextEditingController editTitleController =
            TextEditingController(text: note.title);
        TextEditingController editContentController =
            TextEditingController(text: note.content);
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style: const TextStyle(color: Colors.black),
              ),
              TextField(
                controller: editContentController,
                decoration: const InputDecoration(labelText: 'Content'),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the note with edited values
                setState(() {
                  // final existingNote =
                  //     notes.firstWhere((note) => note.id == note.id);
                  // existingNote.title = editTitleController.text;
                  // existingNote.content = editContentController.text;
                  Provider.of<TestRepository>(context, listen: false)
                      .updateNote(
                    Note(
                      title: editTitleController.text,
                      content: editContentController.text,
                      id: note.id,
                    ),
                  );
                  titleController.text = editTitleController.text;
                  contentController.text = editContentController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final notesProvider = Provider.of<TestRepository>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Consumer<TestRepository>(builder: (context, notesProvider, child) {
        warningLog('build method ${notesProvider.notes}');
        return ListView.builder(
          itemCount: notesProvider.notes.length,
          itemBuilder: (context, index) {
            return NoteWidget(
              noteModel: notesProvider.notes[index],
              onDelete: () =>
                  notesProvider.deleteNote(notesProvider.notes[index].id),
              //  () => deleteNote(notesProvider.notes[index].id),
              onEdit: () => editNote(
                notesProvider.notes[index],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black45,
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.black38,
          title: const Text(
            'Add a New Note',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<TestRepository>(context, listen: false).addNote(
                  Note(
                    title: titleController.text,
                    content: contentController.text,
                    id: rng.nextInt(100000),
                  ),
                );
                // addNote(
                //     title: titleController.text,
                //     content: contentController.text);
                titleController.clear();
                contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
