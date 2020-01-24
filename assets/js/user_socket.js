// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import { Socket } from "phoenix";

const socket = new Socket("/sockets/users", {
  params: { user_token: window.userToken }
});

socket.connect();

export default socket;

// Now that you are connected, you can join channels with a topic:
const userChannel = socket.channel("users:join");
userChannel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

// Now that you are connected, you can join channels with a topic:
const chatLobbyChannel = socket.channel("room:lobby", {
  user_id: window.userId
});
chatLobbyChannel
  .join()
  .receive("ok", resp => {
    console.log("Joined lobby successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

export { chatLobbyChannel, userChannel };
