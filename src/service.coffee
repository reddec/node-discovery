dgram             = require 'dgram'
{EventEmitter}    = require 'events'
METHOD_FORCE_FIND = 'force'
METHOD_ECHO       = 'echo'
METHOD_FIND       = 'find'
INTERVAL          = 2000
MULTICAST_IP      = '239.155.155.150'
MULTICAST_PORT    = 22000
###
* Simple service discovery over UDP multicast
* Emits events with name of catched service description
* Custom event '*' catches all messages (except own or force)
###
class Service  extends EventEmitter
  ###
  * Create new instance of discovery service and
  * join to muticast
  * @param {string} Name of service. Messages from
  * services with same name will not be catched
  * @param {number} Multicast port
  * @param {string} Multicast IP
  * @param {number} Sending interval
  ###
  constructor:(@name, @port=MULTICAST_PORT, @ip=MULTICAST_IP, interval = INTERVAL)->
    @names = {}
    @socket = dgram.createSocket('udp4')
    @socket.bind @port, ()=>
      @socket.addMembership @ip
      console.log "Joined to", @ip, "as", @name
    @socket.on 'message', @on_message
    @timer = setInterval @sendAbout, interval

  ###
  * Listener for incoming UDP messages
  ###
  on_message:(msg, rinfo)=>
    msg = JSON.parse msg.toString()
    ip = rinfo.address
    return if msg.name == @name                             # Self message
    return @sendAbout() if msg.method == METHOD_FORCE_FIND  # Force send myself
    return @sendAbout() if msg.method == METHOD_FIND and msg.query == @name
    @emit msg.name, msg.name, ip, msg.data
    @emit '*', msg.name, ip, msg.data

  ###
  * Add new service (logical) description
  * @param {string} Name of service.
  * @param {object} Serializeable description
  * @return {Service} itself
  ###
  add:(name, data)=>
    @names[name] = data
    return this

  ###
  * Force request descriptions from services
  * @return {Service} itself
  ###
  force:()=>
    msg=
      method: METHOD_FORCE_FIND
      name: @name
    msg = new Buffer(JSON.stringify msg)
    @socket.send msg, 0, msg.length, @port, @ip
    return this

  ###
  * Force request descriptions from service with specified name
  * @param {string} Name of service.
  * @return {Service} itself
  ###
  forceByName:(name)=>
    msg=
      method: METHOD_FIND
      name: @name
      query: name
    msg = new Buffer(JSON.stringify msg)
    @socket.send msg, 0, msg.length, @port, @ip
    return this

  ###
  * Close sockets and remove all listeners
  * @return {Service} itself
  ###
  close:() =>
    @removeAllListeners()
    @socket.close()
    clearInterval @timer
    return this

  ###
  * Send self description to multicast group
  * @return {Service} itself
  ###
  sendAbout:()=>
    msg=
      method: METHOD_ECHO
      name: @name
      data: @names
    msg = new Buffer JSON.stringify(msg)
    @socket.send msg, 0, msg.length, @port, @ip
    return this

module.exports = Service
