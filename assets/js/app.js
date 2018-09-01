import "phoenix_html"
import {Socket, Presence} from "phoenix"

// Making the socket connection
let socket = new Socket("/socket", {params: {user: "phoenix"}});
socket.connect();

// Join and open the socket channels
let room = socket.channel("room:lobby");
var song = " Phoenix ";

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
    let current_song= document.getElementById("current_song").innerText;
    playSong( current_song );
  } else if ( message.body === "stop"){
    Howler.volume(0)
  } else if( message.body === "play") {
    Howler.volume(1)
  } else if ( message.body === "reload"){
    location.reload();
  } else {
    // Play only
    let user = document.getElementById("current_user").innerText;
    if( user === message.body){ Howler.volume(1); }
  }
}

function playSong( song ) {
  let sound2 = new Howl({
    src: [ song ],
    autoplay: true,
    loop: true,
    volume: 1
  });
}

room.on("message:new:client", message => renderMessage(message))
