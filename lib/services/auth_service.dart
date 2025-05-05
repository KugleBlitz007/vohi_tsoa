import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is admin
  Future<bool> isUserAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No user is currently signed in');
        return false;
      }

      print('Checking admin status for user: ${user.uid}');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        print('User document does not exist, creating it now');
        await createUserDocument(user);
        return false;
      }

      final isAdmin = userDoc.data()?['isAdmin'] == true;
      print('User admin status: $isAdmin');
      return isAdmin;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument(User user) async {
    try {
      print('Creating user document for UID: ${user.uid}');
      final userRef = _firestore.collection('users').doc(user.uid);
      
      // Check if document already exists
      final docSnapshot = await userRef.get();
      if (!docSnapshot.exists) {
        final userData = {
          'email': user.email,
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        };
        
        print('Creating new user document with data: $userData');
        await userRef.set(userData);
        print('User document created successfully');
      } else {
        print('User document already exists, updating last login');
        await userRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating/updating user document: $e');
      throw e;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Attempting to sign in user: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        print('User signed in successfully: ${credential.user!.uid}');
        await createUserDocument(credential.user!);
      }
      
      return credential;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Starting registration process for: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        print('User created successfully with UID: ${credential.user!.uid}');
        await createUserDocument(credential.user!);
      }
      
      return credential;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      print('Signing out user');
      await _auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Sign out error: $e');
      throw e;
    }
  }
}
