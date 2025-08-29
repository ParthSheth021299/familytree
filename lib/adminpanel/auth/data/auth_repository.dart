import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepository({FirebaseAuth? auth})
    : firebaseAuth = auth ?? FirebaseAuth.instance;

  //Login Method
  // Future<String?> loginAdmin(String email, String password) async {
  //   try {
  //     final userCred = await firebaseAuth.signInWithEmailAndPassword(
  //       email: email.trim(),
  //       password: password.trim(),
  //     );
  //     // if (userCred.user == null) {
  //     //   return "User not found";
  //     // }
  //     print("ADMIN ${userCred.user?.email}");
  //     if (userCred.user?.email == 'admin@gmail.com') {
  //       return null;
  //     } else {
  //       validateUser(userCred.user!);
  //     }

  //     return null; // ✅ no error = success
  //   } on FirebaseAuthException catch (e) {
  //     return e.message ?? "Login failed.";
  //   } catch (e) {
  //     return "Unexpected error: ${e.toString()}";
  //   }
  // }
  Future<String?> loginAdmin(String email, String password) async {
    try {
      final userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCred.user;

      if (user == null) {
        return "User not found.";
      }

      // ✅ ADMIN FLOW
      if (user.email == 'admin@gmail.com') {
        return null;
      }

      // ✅ TEMP USER FLOW
      final docSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (docSnapshot.docs.isEmpty) {
        return "User record not found in database.";
      }

      final userData = docSnapshot.docs.first.data();
      final isActive = userData['isActive'] ?? true;

      if (!isActive) {
        return "Access denied: Your account has been deactivated.";
      }

      // 🕒 Optional time-based session (disabled for now)
      // final createdAt = (userData['createdAt'] as Timestamp?)?.toDate();
      // if (createdAt != null) {
      //   final diff = DateTime.now().difference(createdAt);
      //   if (diff.inMinutes > 15) {
      //     await user.delete();
      //     await FirebaseFirestore.instance
      //         .collection('user')
      //         .doc(docSnapshot.docs.first.id)
      //         .delete();
      //     return "Session expired — please request access again.";
      //   }
      // }

      print("✅ Temp user logged in: ${user.email}");
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed.";
    } catch (e) {
      return "Unexpected error: ${e.toString()}";
    }
  }

  //create temp account
  Future<String?> createTempAccount(String email, String password) async {
    try {
      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      //Checking user
      final user = credentials.user;
      if (user == null) {
        return null;
      }

      //Adding user to the firebase store
      await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
        "email": email,
        "password": password,
        "createdAt": FieldValue.serverTimestamp(),
        "isActive": true,
      });

      return "User Created";
    } on FirebaseAuthException catch (e) {
      // handle Firebase specific errors
      switch (e.code) {
        case "email-already-in-use":
          return "This email is already registered. Please try logging in.";
        case "invalid-email":
          return "The email address is invalid.";
        case "weak-password":
          return "Password is too weak. Please use a stronger one.";
        case "operation-not-allowed":
          return "Email/password accounts are not enabled.";
        default:
          return "Authentication error: ${e.message}";
      }
    } catch (e) {
      debugPrint("Error: $e");
      return "An unexpected error occurred. Please try again.";
    }
  }

  Future<String?> validateUser(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .get();

    if (!doc.exists || doc.data()?['createdAt'] == null) {
      showToast('User is not available');
      return "User is not available";
    }

    // Check if user is active
    final isActive = doc.data()?['isActive'] ?? false;
    if (!isActive) {
      await FirebaseAuth.instance.signOut();
      showToast('Account has been deactivated');
      return "Account has been deactivated";
    }

    // Optional: Session timeout logic (commented out by you)
    final now = DateTime.now();
    final createdAt = (doc.data()?['createdAt'] as Timestamp).toDate();
    final diff = now.difference(createdAt);

    // Uncomment this block if you still want a time-based temp session
    // if (diff.inMinutes > 15) {
    //   await user.delete();
    //   await FirebaseFirestore.instance
    //       .collection('user')
    //       .doc(user.uid)
    //       .delete();
    //   showToast("Session expired — please request new access.");
    //   return "Session expired — please request new access.";
    // }

    return null; // valid user
  }

  //Logout
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
