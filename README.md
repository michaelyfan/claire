# claire

A Flutter rewrite of [Claire](https://github.com/samgamage/claire). WIP.

### TODOs
* finish login flow (handle login errors)
* user registration
* complete our Freemium/Premium business model
* more language support
* improve sentiment analysis
* ability to change age and location preferences
* messages retrieval is currently get-all-messages-then-filter, change to query
* getting users to swipe on is currently get-all-users-then-filter, change to query
* a user's swiped array will become polluted over time
* expand profile pic compatibility beyond .jpg, or convert it before upload somehow
* remove user from list of potential swipes when they're in a conversation
* consider disabling swipe screen outright when user is in a conversation
* test on actual iOS devices
* general error handling
* move many functions (such as entering a conversation after discovering a swipe) to a server, for security
