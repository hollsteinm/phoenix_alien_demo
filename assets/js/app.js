// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import { chatLobbyChannel } from "./user_socket";

class AlienDemoApp {
  static init() {
    const userId = window.userId;

    const $input = $("#chat-input");

    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        //enter key
        chatLobbyChannel.push("message:new", {
          user_id: userId,
          content: $input.val()
        });
        $input.val("");
      }
    });

    const $messageContainer = $("#chat-output");

    chatLobbyChannel.on("message:new", ({ user_id, content }) => {
      const sanUserId = this.sanitize(user_id);
      const sanContent = this.sanitize(content);

      const userStyledText = user_id === userId ?
        `<i>${sanUserId}:</i>` :
        `<b>${sanUserId}:</b>`

      $messageContainer.append(
        `<br>${userStyledText}<span>&nbsp;${sanContent}<span>`
      );
      $messageContainer.scrollTop(0, $messageContainer.scrollHeight);
    });

    chatLobbyChannel.on("user:entered", ({ user_id }) => {
      const sanUserId = this.sanitize(user_id);
      $messageContainer.append(`<br/><i>${sanUserId} entered</i>`);
    });
  }

  static sanitize(html) {
    return $("<span/>")
      .text(html)
      .html();
  }
}

$(() => AlienDemoApp.init());

export default AlienDemoApp;
