import "phoenix_html"
import {Socket, Presence} from "phoenix"

// Making the socket connection
let socket = new Socket("/socket", {params: {user: "phoenix"}});
socket.connect();

// Join and open the socket channels
let room = socket.channel("room:lobby");
let current_user = " Phoenix ";

// Connect to the channel
room.join()
  .receive("ok", resp => {
    console.log("C O N E C T A D O", resp)
    let sound2 = new Howl({
      src: [ resp.song ],
      autoplay: true,
      loop: true,
      volume: 0.0,
    });
    let current_user = document.getElementById("current_user");
    current_user.innerText = resp.category;
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

room.on("presence_state", state => {
  console.log("==================== > presence")
  console.log(state)
  presences = Presence.syncState(presences, state)
  render(presences)
})
room.on("presence_diff", diff => {
  console.log("==================== > diff")
  console.log(diff)
  room.push("room::sync", "Alguien vino, o alguien se fue")
  presences = Presence.syncDiff( presences, diff)
  render(presences)
})



// Getting the list of users
let presences = {}

let formatedTimestamp = (Ts) => {
  let date = new Date(Ts)
  return date.toLocaleString()
}

let listBy = (user, {metas:metas}) => {
  return {
    user: user,
    onlineAt: formatedTimestamp(metas[0].online_at)
  }
}

let userList = document.getElementById("userList")
let render = (presences) => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(presence => `
      <li>
      <b>${presence.user}</b>
      <br><small>online since ${presence.onlineAt}</small>
      </li>
      `)
    .join("")
}

// Sending messages
let messageInput = document.getElementById("newMessage")
messageInput.addEventListener("keypress", (e) => {
  console.log("Sending message!")
  if(e.keyCode == 13 && messageInput.value != ""){
    room.push("message:new", messageInput.value)
    messageInput.value = ""
  }
})

// Update the message list
let messageList = document.getElementById("messageList")
let renderMessage = (message) => {
  console.log("Llego un nuevo mensaje!!");


  function playSong( song ) {
    let sound2 = new Howl({
      //src: ['http://carlogilmar.me/uno.m4a'],
      src: [ song ],
      autoplay: true,
      loop: true,
      volume: 0.3,
      onend: function() {
        console.log('Finished!');
      } });
  }

  if( message.body === "1"){

   console.log("Prende!!")
   //Howler.volume(1)
    if( user === "uno "){
      console.log(" es el uno")
      playSong( 'http://carlogilmar.me/uno.m4a' )
    } else if( user === "dos "){
      console.log("es el dos")
      playSong( 'http://carlogilmar.me/dos.m4a' )
    } else if( user === "tres "){
      console.log("es el tres")
      playSong( 'http://carlogilmar.me/tres.m4a' )
    }

  } else if ( message.body === "0"){
   console.log("Apaga!!")
   Howler.volume(0)
  } else if ( message.body === "reload"){
    console.log( "reload" )
    location.reload();
  }
  //let sound2 = new Howl({
  //  src: ['http://carlogilmar.me/tres.m4a'],
  //  autoplay: true,
  //  loop: false,
  //  volume: 0.5,
  //  onend: function() {
  //    console.log('Finished!');
  //  } });
  let messageElement = document.createElement("li")
  messageElement.innerHTML = `
    <b> ${message.user} </b>
    <i> ${formatedTimestamp(message.timestamp)}</i>
    <p> ${message.body} </p>
    `
  messageList.appendChild(messageElement)
  messageList.scrollTop = messageList.scrollHeight
}

room.on("message:new:client", message => renderMessage(message))


