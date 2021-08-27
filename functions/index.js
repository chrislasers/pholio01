const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
// database tree

exports.sendPushNotification = functions.database.ref('/Users/{uid}/Matched/{id}').onWrite(event => {

    const payload = {
        notification: {
            content_available: 'true',
            title: 'New Match!',
            body: 'Click and See!',
            badge: '1',
            sound: 'default',
        }

    };

    return admin.database().ref('fcmToken').once('value').then(allToken => {
        if (allToken.val()) {
            const token = Object.keys(allToken.val());
            console.log(`token? ${token}`);
            return admin.messaging().sendToDevice(token, payload).then(response => {
                return null;
            });
        }

        return null;
    })
});

/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */
exports.sendFollowersNotification = functions.database.ref('/mess/{uid}/{id}')
    .onWrite(async (change, context) => {
        const id = context.params.id;
        const uid = context.params.uid;
        // If un-follow we exit the function.
        if (!change.after.val()) {
            return console.log('User ', id, 'un-followed user', uid);
        }
        console.log('We have a new follower UID:', id, 'for user:', uid);

        // Get the list of device notification tokens.
        const getDeviceTokensPromise = admin.database()
            .ref(`/Users/${uid}/notificationTokens`).once('value');

        // Get the follower profile.
        //const getFollowerProfilePromise = admin.auth().getUser(followerUid);

        // The snapshot to the user's tokens.
        let tokensSnapshot;

        // The array containing all the user's tokens.
        let tokens;

        const results = await Promise.all([getDeviceTokensPromise]);
        tokensSnapshot = results[0];
        const follower = results[1];

        // Check if there are any device tokens.
        if (!tokensSnapshot.hasChildren()) {
            return console.log('There are no notification tokens to send to.');
        }
        console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
        console.log('Fetched follower profile', follower);

        // Notification details.
        const payload = {
            notification: {
                content_available: 'true',
                title: 'New Message!',
                body: 'Click and See!',
                badge: '1',
                sound: 'default',
                priority: "high",

            }
        };

        // Listing all tokens as an array.
        tokens = Object.keys(tokensSnapshot.val());
        // Send notifications to all tokens.
        const response = await admin.messaging().sendToDevice(tokens, payload);
        // For each message check if there was an error.
        const tokensToRemove = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                console.error('Failure sending notification to', tokens[index], error);
                // Cleanup the tokens who are not registered anymore.
                if (error.code === 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                    tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
                }
            }
        });
        return Promise.all(tokensToRemove);
    });

exports.sendFollowerNotification = functions.database.ref('/followers/{uid}/{id}')
    .onWrite(async (change, context) => {
        const id = context.params.id;
        const uid = context.params.uid;
        // If un-follow we exit the function.
        if (!change.after.val()) {
            return console.log('User ', id, 'un-followed user', uid);
        }
        console.log('We have a new follower UID:', id, 'for user:', uid);

        // Get the list of device notification tokens.
        const getDeviceTokensPromise = admin.database()
            .ref(`/Users/${uid}/notificationTokens`).once('value');

        // Get the follower profile.
        //const getFollowerProfilePromise = admin.auth().getUser(followerUid);

        // The snapshot to the user's tokens.
        let tokensSnapshot;

        // The array containing all the user's tokens.
        let tokens;

        const results = await Promise.all([getDeviceTokensPromise]);
        tokensSnapshot = results[0];
        const follower = results[1];

        // Check if there are any device tokens.
        if (!tokensSnapshot.hasChildren()) {
            return console.log('There are no notification tokens to send to.');
        }
        console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
        console.log('Fetched follower profile', follower);

        // Notification details.
        const payload = {
            notification: {
                content_available: 'true',
                title: 'New Shoot Request!',
                body: 'Click and See!',
                badge: '1',
                sound: 'default',
                priority: "high",

            }
        };

        // Listing all tokens as an array.
        tokens = Object.keys(tokensSnapshot.val());
        // Send notifications to all tokens.
        const response = await admin.messaging().sendToDevice(tokens, payload);
        // For each message check if there was an error.
        const tokensToRemove = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                console.error('Failure sending notification to', tokens[index], error);
                // Cleanup the tokens who are not registered anymore.
                if (error.code === 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                    tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
                }
            }
        });
        return Promise.all(tokensToRemove);
    });


