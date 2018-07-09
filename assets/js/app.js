import "phoenix_html"

import {Socket, Presence} from "phoenix"

// Making the socket connection
let user = document.getElementById("user").innerText
let socket = new Socket("/socket", {params: {user: user}})
socket.connect()

// Join and open the socket channels
let room = socket.channel("room:lobby")
room.on("presence_state", state => {
  console.log("==================== > presence")
  console.log(state)
  presences = Presence.syncState(presences, state)
  render(presences)
})
room.on("presence_diff", diff => {
  console.log("==================== > diff")
  console.log(diff)
  presences = Presence.syncDiff( presences, diff)
  render(presences)
})
room.join()
  .receive("ok", resp => { console.log("Joined to Example Channel!!", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

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
  let messageElement = document.createElement("li")
  messageElement.innerHTML = `
    <b> ${message.user} </b>
    <i> ${formatedTimestamp(message.timestamp)}</i>
    <p> ${message.body} </p>
    `
  messageList.appendChild(messageElement)
  messageList.scrollTop = messageList.scrollHeight
}

room.on("message:new", message => renderMessage(message))


