import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/main.dart';
import 'package:tauker_mobile/providers/profile_provider.dart';

class Avatar extends ConsumerStatefulWidget {
  const Avatar({
    super.key,
  });


  @override
  ConsumerState<Avatar> createState() => _AvatarState();
}

class _AvatarState extends ConsumerState<Avatar> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return profileState.when(

        data:
            (profile) {
          print("avatar url value${profile.avatar_url}");
          return Column(
            children: [
              if (profile.avatar_url == null || profile.avatar_url!.isEmpty)
                Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey,
                  child: const Center(
                    child: Text('No Image'),
                  ),
                )
              else

                Image.network(
                  profile.avatar_url!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _upload,
                child: const Text('Upload'),
              ),
            ],
          );
        },
        error:
            (error, stack) {
          return Center(child: Text(error.toString()));
        },
        loading:
            () {
          return const Center(child: Text('loading'));
        });
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );

    if (imageFile == null) {
      return; // User canceled the picker
    }

    setState(() => _isLoading = true);

    try {
      // Call your Riverpod function to upload the image and create the URL here
      await ref.read(profileNotifierProvider.notifier).editAvatar(imageFile);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated your profile image!'),
          backgroundColor: Colors.green,
        ),
      );
    } on StorageException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } on PostgrestException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unexpected error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

}


