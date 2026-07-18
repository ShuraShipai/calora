import * as admin from 'firebase-admin';
import { HttpsError, onCall } from 'firebase-functions/v2/https';

admin.initializeApp();

const db = admin.firestore();

const deletionResult = { deleted: true } as const;

function isUserNotFound(error: unknown): boolean {
  return (
    typeof error === 'object' &&
    error !== null &&
    'code' in error &&
    error.code === 'auth/user-not-found'
  );
}

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
  } catch (error) {
    console.error('Account data deletion failed', { uid, error });
    throw new HttpsError(
      'internal',
      'We could not delete your account data. Please try again.',
    );
  }

  try {
    await admin.auth().deleteUser(uid);
  } catch (error) {
    // A retried or overlapping request may reach this point after a prior
    // request already removed the Auth record. The requested final state is
    // still satisfied, so return the same success contract.
    if (isUserNotFound(error)) return deletionResult;

    console.error('Account Auth deletion failed', { uid, error });
    throw new HttpsError('internal', 'We could not delete your account. Please try again.');
  }

  return deletionResult;
});
