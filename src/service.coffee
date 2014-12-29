dgram = require 'dgram'
{EventEmitter} = require 'events'
METHOD_NOTIFY = 'notify'
METHOD_FIND = 'find'
INTERVAL = 2000
MULTICAST_IP = '239.155.155.150'
MULTICAST_PORT = 22000
###
 * Simple service discovery over UDP multicast
 * Emits events with name of catched service description
 * Custom event '*' catches all messages
###
class Listener extends EventEmitter
  ###
  * Create new instance of service finder
  * @param {function(Listener) } Ready callback
  * @param {number} Multicast port
  * @param {string} Multicast IP
  ###
  constructor: (done, @port = MULTICAST_PORT, @ip = MULTICAST_IP) ->
    @socket = dgram.createSocket('udp4')
    @socket.bind @port, () =>
      @socket.addMembership @ip
      done(this) if done
    @socket.on 'message', @on_message

  ###
  * Listener for incoming UDP messages
  ###
  on_message: (msg, rinfo) =>
    msg = JSON.parse msg.toString()
    ip = rinfo.address
    @emit msg.name, msg.name, ip, msg.data
    @emit '*', msg.name, ip, msg.data

  ###
  * Close sockets and remove all listeners
  * @return {Service} itself
  ###
  close: () =>
    @removeAllListeners()
    @socket.close()
    return this



class Description
  ###
  * Create new instance of service description
  * @param {string} Name of service
  * @param {number} Multicast port
  * @param {string} Multicast IP
  * @param {number} Sending interval
  ###
  constructor: (@name, @port = MULTICAST_PORT, @ip = MULTICAST_IP, interval = INTERVAL) ->
    @attrs = {}
    @socket = dgram.createSocket('udp4')
    @timer = setInterval @notify, interval

  ###
  * Add attribute of description
  * @param {string} Name of attribute.
  * @param {object} Serializeable data
  * @return {Service} itself
  ###
  attr: (name, data) =>
    @attrs[name] = data
    return this

  ###
  * Send self description to multicast group
  * @return {Service} itself
  ###
  notify: () =>
    msg =
      method: METHOD_NOTIFY
      name: @name
      data: @attrs
      time: Date.now()
    msg = new Buffer JSON.stringify(msg)
    @socket.send msg, 0, msg.length, @port, @ip
    return this

  ###
  * Close sockets and remove timer
  * @return {Service} itself
  ###
  close: () =>
    @socket.close()
    clearInterval @timer
    return this

module.exports.Listener = Listener
module.exports.Description = Description
