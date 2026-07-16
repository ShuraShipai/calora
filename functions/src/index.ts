import * as admin from 'firebase-admin';
import { HttpsError, onCall } from 'firebase-functions/v2/https';

admin.initializeApp();

const db = admin.firestore();

/**
 * Removes all Firestore data for the caller before their Firebase Auth record.
 * This is deliberately server-side: client document deletion does not delete
 * subcollections and must never be trusted for account erasure.
 */
export const deleteAccount = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign in to delete your account.');

  const userRef = db.collection('users').doc(uid);
  try {
    await db.recursiveDelete(userRef);
    await admin.auth().deleteUser(uid);
  } catch (error) {
    console.error('Account deletion failed', { uid, error });
    throw new HttpsError('internal', 'We could not delete your account. Please try again.');
  }

  return { deleted: true };
});
