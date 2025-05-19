import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String getCurUserUid() {
    return _auth.currentUser!.uid;
  }

  // Регистрация Email/Пароль
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();

      final user = _auth.currentUser;

      await _firebaseFirestore.collection('Users').doc(user!.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': displayName,
        'phone': '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Этот email уже зарегистрирован.');
      }
      throw Exception('Ошибка регистрации: ${e.code}');
    } catch (e) {
      throw Exception('Произошла ошибка: $e');
    }
  }

  // Вход Email/Пароль
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseFirestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()});

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Ошибка входа: ${e.code}');
    }
  }

  // Регистрация через Google
  Future<UserCredential?> registerGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Вход в Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Ошибка авторизации. Пользователь = null.');
      }

      final userRef = _firebaseFirestore.collection('Users').doc(user.uid);

      // Используем транзакцию или проверку внутри try-catch для надёжности
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        // Создаём нового пользователя
        await userRef.set({
          'uid': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? 'user',
          'photoUrl': user.photoURL ?? '',
          'phoneNumber': user.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      log('Ошибка при регистрации через Google: $e');
      rethrow; // Пробрасываем ошибку дальше, если нужно
    }
  }

  // Вход через Google (если пользователь уже есть в базе)
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final userDoc =
          await _firebaseFirestore
              .collection('Users')
              .doc(userCredential.user!.uid)
              .get();

      if (!userDoc.exists) {
        throw Exception("Пользователь не найден в базе данных.");
      }

      return userCredential;
    } catch (e) {
      throw Exception('Ошибка входа через Google: $e');
    }
  }

  // // Уведомления — Обновление настроек
  // Future<void> updateNotificationSettings({
  //   required bool vibration,
  //   required bool sendNotification,
  // }) async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     await _firebaseFirestore.collection('Users').doc(user.uid).update({
  //       'notificationSettings': {
  //         'vibration': vibration,
  //         'sendNotification': sendNotification,
  //       },
  //     });
  //   }
  // }

  // // Уведомления — Получение настроек
  // Future<Map<String, dynamic>> getNotificationSettings() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot doc =
  //         await _firebaseFirestore.collection('Users').doc(user.uid).get();

  //     if (doc.exists) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       final notification = data['notificationSettings'] ?? {};
  //       return {
  //         'vibration': notification['vibration'] ?? false,
  //         'sendNotification': notification['sendNotification'] ?? false,
  //       };
  //     }
  //   }
  //   return {'vibration': false, 'sendNotification': false};
  // }

  // выход
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exit_type', 'logout');
    await FirebaseAuth.instance.signOut();
  }

  // удаление
  Future<void> deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exit_type', 'delete');

    final aUser = FirebaseAuth.instance.currentUser;

    if (aUser != null) {
      try {
        await _firebaseFirestore.collection('Users').doc(aUser.uid).delete();
        log('Пользователь удален из бд');
      } catch (e) {
        throw Exception('Ошибка удаление пользователя из бд: $e');
      }

      try {
        await aUser.delete();
        log('Пользователь удален из FirebaseAuth');
      } catch (e) {
        log('Ошибка при удалении из FirebaseAuth: $e');
      }
    }
  }

  // Сброс пароля
  Future<void> resetUserPassword(
    String password,
    String confirmPassword,
  ) async {
    User? user = _auth.currentUser;
    if (user != null && password == confirmPassword) {
      await user.updatePassword(password);
      await _firebaseFirestore.collection('Users').doc(user.uid).update({
        'password': password,
      });
    }
  }

  // обновление профиля
  Future<void> editProfile(String name, String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Проверка, совпадает ли введенная почта с почтой текущего пользователя
        if (user.email != email) {
          throw Exception(
            'Введите корректную почту (она должна совпадать с текущей)',
          );
        }

        // Если почта совпадает, обновляем имя
        if (user.displayName != name) {
          await user.updateDisplayName(name);
        }

        // Обновляем данные в Firestore
        await _firebaseFirestore.collection('Users').doc(user.uid).update({
          'displayName': name,
        });
      } catch (e) {
        throw Exception('Ошибка обновления профиля: $e');
      }
    }
  }

  // Сообщения об ошибках
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'Exception wrong-password':
        return 'Пароль неверный. Попробуйте снова.';
      case 'Exception user-not-found':
        return 'Пользователь с таким email не найден.';
      case 'Exception email-already-in-use':
        return 'Этот email уже зарегистрирован.';
      default:
        return 'Произошла непредвиденная ошибка. Попробуйте позже.';
    }
  }
}
