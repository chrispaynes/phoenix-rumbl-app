import Player from "./player"

let Video = {

  // sets ups the video player
  // pulls video id from video
  init(socket, element){ if(!element) { return; }
    let playerId = element.getAttribute("data-player-id")
    let videoId = element.getAttribute("data-id")
    socket.connect()
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
},
  
  // DOM variables
  // vidChannel connects ES6 client with Phoenix VideoChannel
  onReady(videoId, socket){
    let msgContainer = document.getElementById("msg-container")
    let msgInput = document.getElementById("msg-input")
    let postButton = document.getElementById("msg-submit")
    // channel object for video topic
    let vidChannel = socket.channel("videos:" + videoId)

    // handles the click event on the postButton
    // pushes contents of message input to the server
    // clears the message input
    // outputs client side messaging to the client console
    postButton.addEventListener("click", e => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()}
      vidChannel.push("new_annotation", payload)
                .receive("error", e => console.log(e) )
      msgInput.value = ""
    })

    // handles new events sent by the server
    // when users post new annotations, the server broadcasts new events to the client
    // calls render function after receiving annotation
    vidChannel.on("new_annotation", (resp) => {
      this.renderAnnotation(msgContainer, resp)
    })


    // PING TEST CODE
    // vidChannel.on("ping", ({count}) => console.log("PING", count) )
    
    // joins the vidChannel to the client
    // logs the confirmation or error message
    vidChannel.join()
      .receive("ok", resp => console.log("joined the video channel", resp) )
      .receive("error", reason => console.log("failed to join the video channel", reason) )
  },

  // creates div and child node to contain messages
  // returns the elements to the HTML
  // safely escapes user input before injecting values to page (protects from XSS attacks)
  esc(str){
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  // renders annotations on page
  renderAnnotation(msgContainer, {user, body, at}){
    let template = document.createElement("div")

    // appends username and annotation to msgContainer template
    // scrolls container to current message
    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)} </b>: ${this.esc(body)}
    </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  }

}
export default Video