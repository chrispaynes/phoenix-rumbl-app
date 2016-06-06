let Player = {
  player: null,

  // connects callback to YouTube's window.onYouTubeIframeAPIReady
  // embeds YouTube's iFrame
  // creates Iframe with YouTube's API when ready
  // creates video playback features
    // gets current time of video
    // seeks out a current time in video
  init(domId, playerId, onReady){
    window.onYouTubeIframeAPIReady = () => {
      this.onIframeReady(domId, playerId, onReady);
    };

    let youtubeScriptTag = document.createElement("script");
    youtubeScriptTag.src = "//www.youtube.com/iframe_api";
    document.head.appendChild(youtubeScriptTag);
  },
  onIframeReady(domId, playerId, onReady){
    this.player = new YT.Player(domId, {
      height: "360",
      width: "420",
      videoId: playerId,
      events: {
        "onReady": (event => onReady(event) ),
        "onStateChange": (event => this.onPlayerStateChange(event) )
      }
    });
  },

  onPlayerStateChange(event) { },
  getCurrentTime() {
    return Math.floor(this.player.getCurrentTime() * 1000);
  },
  seekTo(millsec) {
    return this.player.seekTo(millsec / 1000);
  }
};

export default Player;