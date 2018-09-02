import "phoenix_html"
import {Socket, Presence} from "phoenix"

// Making the socket connection
let socket = new Socket("/socket", {params: {user: "phoenix"}});
socket.connect();

// Join and open the socket channels
let room = socket.channel("room:lobby");

// Connect to the channel
room.join()
  .receive("ok", resp => {
    console.log("C O N E C T A D O", resp)
    let current_user = document.getElementById("current_user");
    current_user.innerText = resp.category;
    let current_song= document.getElementById("current_song");
    current_song.innerText = resp.song;
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

let renderMessage = (message) => {
  if( message.body === "start"){
    toast( "Play Music!!!" );
    let current_song= document.getElementById("current_song").innerText;
    playSong( current_song );
    playMusicLoader();
  } else if ( message.body === "stop"){
    toast( "S T O P" );
    Howler.volume(0)
    playWaitingLoader();
  } else if( message.body === "play") {
    toast( "P L A Y" );
    Howler.volume(1)
    playMusicLoader();
  } else if ( message.body === "reload"){
    location.reload();
  } else {
    // Play only
    toast( "Play Song "+message.body );
    let user = document.getElementById("current_user").innerText;
    if( user === message.body){ Howler.volume(1); playMusicLoader(); }
  }
}

function playMusicLoader(){
  document.getElementById("music_loader").style = "visibility: visible;";
};

function playWaitingLoader(){
  document.getElementById("music_loader").style = "visibility: hidden;";
};

function playSong( song ) {
  let sound2 = new Howl({
    src: [ song ],
    autoplay: true,
    loop: true,
    volume: 1
  });
}

room.on("message:new:client", message => renderMessage(message))

function toast( message ) {
  var snackbar = document.getElementById("snackbar");
  snackbar.innerText = message;
  snackbar.className = "show";
  setTimeout(function(){ snackbar.className = snackbar.className.replace("show", ""); }, 3000);
}
