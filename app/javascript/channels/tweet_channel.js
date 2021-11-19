// app/javascript/channels/tweet_channel.js
import consumer from "./consumer"

//consumer.subscriptions.create({ channel: "TweetChannel", room: "Best Room" })

consumer.subscriptions.create("TweetChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected to tweet channel...")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("----- start of tweet data received -----------")
    console.log(data)
    console.log("----- end of tweet data received -----------")
  }
});
