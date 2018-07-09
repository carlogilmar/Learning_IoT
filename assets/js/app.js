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

