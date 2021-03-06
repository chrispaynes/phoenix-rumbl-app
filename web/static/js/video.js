import Player from "./player"

let Video = {

  // sets ups the video player
  // pulls video id from video
  init(socket, element) {
    if(!element) { return; }

    let playerId = element.getAttribute("data-player-id");
    let videoId = element.getAttribute("data-id");

    socket.connect()

    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket);
    });
  },
  
  // DOM variables
  // vidChannel connects ES6 client with Phoenix VideoChannel
  onReady(videoId, socket){
    let msgContainer = document.getElementById("msg-container");
    let msgInput     = document.getElementById("msg-input");
    let postButton   = document.getElementById("msg-submit");
    // channel object for video topic
    let vidChannel   = socket.channel("videos:" + videoId);

    // handles the click event on the postButton
    // pushes contents of message input to the server
    // clears the message input
    // outputs client side messaging to the client console
    postButton.addEventListener("click", e => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()};
      vidChannel.push("new_annotation", payload)
                      .receive("error", e => console.log(e));
      msgInput.value = "";
    })

    // handles new events sent by the server
    // when users post new annotations, the server broadcasts new events to the client
    // calls render function after receiving annotation
    // adds last_seen_id paramater to avoid fetching and rendering duplicate date
    vidChannel.on("new_annotation", (resp) => {
      vidChannel.params.last_seen_id = resp.id;
      this.renderAnnotation(msgContainer, resp)
    })
    
  msgContainer.addEventListener("click", e => {
    e.preventDefault()
    let seconds = e.target.getAttribute("data-seek") ||
                  e.target.parentNode.getAttribute("data-seek")
    if (!seconds) { return }

    Player.seekTo(seconds)
  })

    // PING TEST CODE
    // vidChannel.on("ping", ({count}) => console.log("PING", count) )
    
    // joins the vidChannel to the client
    // logs the confirmation or error message
    // establishes an id for videos
    vidChannel.join()
      // .receive("ok", resp => console.log("joined the video channel", resp) )
      .receive("ok", resp => {
        let ids = resp.annotations.map(ann => ann.id);
        if(ids.length > 0){
          vidChannel.params.last_seen_id = Math.max(...ids)
        }
        this.scheduleMessages(msgContainer, resp.annotations);
        console.log("joined the video channel", resp)
      })
      .receive("error", reason => console.log("failed to join the video channel", reason) )
  },

  // creates div and child node to contain messages
  // returns the elements to the HTML
  // safely escapes user input before injecting values to page (protects from XSS attacks)
  esc(str){
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  },

  // renders annotations on page
  renderAnnotation(msgContainer, {user, body, at}){
    let template = document.createElement("div");

    // appends username and annotation to msgContainer template
    // scrolls container to current message
    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },

  scheduleMessages(msgContainer, annotations) {
    setTimeout(() => {
      if (Player.initialized) {
        let ctime = Player.getCurrentTime();
        let remaining = this.renderAtTime(annotations, ctime, msgContainer);
        this.scheduleMessages(msgContainer, remaining);
      } else {
        this.scheduleMessages(msgContainer, annotations);
      }
    }, 1000)
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter( ann => {
      if (ann.at > seconds) {
        return true;
      } else {
        this.renderAnnotation(msgContainer, ann);
        return false;
      }
    })
  },

  formatTime(at) {
    let date = new Date(null);
    date.setSeconds(at / 1000);
    return date.toISOString().substr(14, 5);
  }

};
export default Video;