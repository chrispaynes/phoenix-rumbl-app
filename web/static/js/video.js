import Player from "./player"

let Video = {

  // sets ups the video player
  // pulls video id from video
  init(socket, element){ if(!element) { return }
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
    let vidChannel = socket.channel("videos:" + videoId)
    //TODO join the vidChannel
  }

}
export default Video