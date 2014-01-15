
app = angular.module("idlecampus", ["ngResource", "$strap.directives"])
@xmpp = ["$scope","Data",($scope, Data) ->
  group_name = undefined
  group_code = undefined
  $scope.$watch "spin", (newValue, oldValue) ->
  

  $scope.changeEmail = ->
    console.log $scope.email
    $.ajax
      type: "GET"
      url: "/users/checkEmail"
      data:
        email: $scope.email

      success: (data) ->
        console.log parseInt(data)
        $("#emailicon").attr "class", "icon-check"  if parseInt(data) is 0
        $("#emailicon").attr "class", "icon-remove"  if parseInt(data) > 0
        console.log $("#emailicon")

      dataType: ""


  $scope.changeName = ->
    console.log "name"
    console.log $scope.user
    $.ajax
      type: "GET"
      url: "/users/checkName"
      data:
        name: $scope.user

      success: (data) ->
        $("#nameicon").attr "class", "icon-check"  if parseInt(data) is 0
        $("#nameicon").attr "class", "icon-remove"  if parseInt(data) > 0

      dataType: ""


  $scope.connected = ->
    iq = undefined
    # $scope.XMPP.connection.pubsub.createNode $scope.XMPP.connection.jid.split("/")[0] + "/groups", "", (data) ->
#       console.log data

    iq = $iq(type: "get").c("query",
      xmlns: "jabber:iq:roster"
    )
    $scope.XMPP.connection.sendIQ iq, $scope.XMPP.on_roster
    $scope.XMPP.connection.addHandler $scope.XMPP.on_roster_changed, "jabber:iq:roster", "iq", "set"
    $scope.XMPP.connection.addHandler $scope.XMPP.on_message, null, "message", "chat"
    $scope.XMPP.connection.addHandler $scope.XMPP.on_message, null, "message", "headline"

  $scope.spin = ""
  $scope.disconnected = ->
    
    unless localStorage.getItem("sid") is ""
      bootbox.alert "Session Expired...Please login again", ->
        window.location = "/signin"
         
    eraseCookie("remember_token")
    localStorage.clear()
    XMPP.connection = null
    
   
  $scope.XMPP =
    NS_DATA_FORMS: "jabber:x:data"
    NS_PUBSUB: "http://jabber.org/protocol/pubsub"
    NS_PUBSUB_OWNER: "http://jabber.org/protocol/pubsub#owner"
    NS_PUBSUB_ERRORS: "http://jabber.org/protocol/pubsub#errors"
    NS_PUBSUB_NODE_CONFIG: "http://jabber.org/protocol/pubsub#node_config"
    connection: null
    start_time: null
    jid_to_id: (jid) ->
      Strophe.getBareJidFromJid(jid).replace(/@/g, "-").replace /\./g, "-"

    on_roster: (iq) ->
      $(iq).find("item").each ->
        contact = undefined
        jid = undefined
        jid_id = undefined
        name = undefined
        jid = $(this).attr("jid")
        name = $(this).attr("name") or jid
        jid_id = $scope.XMPP.jid_to_id(jid)
        contact = $("<li id='" + jid_id + "'>" + "<div class='roster-contact offline'>" + "<a href=#chat><img class='ui-li-icon  ui-li-thumb' alt='' src=''><div class='roster-name'>" + name + "</div><div class='roster-jid'>" + jid + "</div></a></div></li>")
        $scope.XMPP.insert_contact contact

      $scope.XMPP.connection.addHandler $scope.XMPP.on_presence, null, "presence"
      $scope.XMPP.connection.send $pres()

    pending_subscriber: null
    on_presence: (presence) ->
      contact = undefined
      from = undefined
      jid_id = undefined
      li = undefined
      ptype = undefined
      show = undefined
      ptype = $(presence).attr("type")
      from = $(presence).attr("from")
      jid_id = $scope.XMPP.jid_to_id(from)
      if ptype is "subscribe"
        $scope.XMPP.pending_subscriber = from
        $("#approve-jid").text Strophe.getBareJidFromJid(from)
        $.mobile.changePage "#approve_dialog",
          transition: "slideup"

      else if ptype isnt "error"
        contact = $("li#" + jid_id + " .roster-contact").removeClass("online").removeClass("away").removeClass("offline")
        if ptype is "unavailable"
          contact.addClass "offline"
        else
          show = $(presence).find("show").text()
          if show is "" or show is "chat"
            contact.addClass "online"
            $("li#" + jid_id + " a img").attr "src", "green.jpg"
          else
            contact.addClass "away"
            $("li#" + jid_id + " a img").attr "src", "red.png"
        li = contact.parent().parent().parent()
        li.remove()
        $scope.XMPP.insert_contact li
      jid_id = $scope.XMPP.jid_to_id(from)
      $("#chat-" + jid_id).data "jid", Strophe.getBareJidFromJid(from)
      true

    on_roster_changed: (iq) ->
      console.log "roster changed"
      $(iq).find("item").each ->
        contact = undefined
        jid = undefined
        jid_id = undefined
        name = undefined
        sub = undefined
        sub = $(this).attr("subscription")
        jid = $(this).attr("jid")
        name = $(this).attr("name") or jid
        jid_id = $scope.XMPP.jid_to_id(jid)
        if sub is "remove"
          $("#" + jid_id).remove()
        else
          contact = $("<li id='" + jid_id + "'>" + "<div class=" + ($("#" + jid_id).attr("class") or "roster-contact offline") + ">" + "<a href=#chat><img class='ui-li-icon  ui-li-thumb' alt='' src=''><div class='roster-name'>" + name + "</div><div class='roster-jid'>" + jid + "</div></a></div></li>")
          if $("#" + jid_id).length > 0
            console.log 2
            $("#" + jid_id).replaceWith contact
          else
            console.log "1"
            $scope.XMPP.insert_contact contact

      true

    on_message: (message) ->
      body = undefined
      from = undefined
      mess = undefined
      messagetodisplay = undefined
      type = undefined
      console.log message
      type = $(message).attr("type")
      console.log type
      if type is "chat"
        body = $(message).children("body").text()
        from = ""
        console.log body
        messagetodisplay = from + " : " + body
        mess = "<li style='background-color:#ECEFF5; list-style:none;border:1px solid black;margin:5px'>" + messagetodisplay + "</li>"
        $("ul#posts").append $(mess)
      else if type = "headline"
        if $(message).find("value").text()
          body = $(message).find("value").text()
          from = $(message).find("items").attr("node")
          $scope.data.user = from
          console.log body
          messagetodisplay = body
          $scope.data.groupMessages.push messagetodisplay
          $scope.$digest()
      true

    scroll_chat: (jid_id) ->
      div = undefined
      div = $("#chat-" + jid_id + " .chat-messages").get(0)
      div.scrollTop = div.scrollHeight

    presence_value: (elem) ->
      if elem.hasClass("online")
        return 2
      else
        return 1  if elem.hasClass("away")
      0

    insert_contact: (elem) ->
      contacts = undefined
      inserted = undefined
      jid = undefined
      pres = undefined
      jid = elem.find(".roster-jid").text()
      pres = $scope.XMPP.presence_value(elem.find(".roster-contact"))
      contacts = $("ul#myfriends li")
      if contacts.length > 0
        inserted = false
        contacts.each ->
          cmp_jid = undefined
          cmp_pres = undefined
          cmp_pres = $scope.XMPP.presence_value($(this).find(".roster-contact"))
          cmp_jid = $(this).find(".roster-jid").text()
          if pres > cmp_pres
            $(this).before elem
            inserted = true
            false
          else if pres is cmp_pres
            if jid < cmp_jid
              $(this).before elem
              inserted = true
              false

        $("ul#myfriends").append elem  unless inserted
      else
        $("ul#myfriends").append elem

    callback: (status) ->
      alert connection
      if status is Strophe.Status.REGISTER
        alert 10
        alert connection
        connection.register.fields.username = "juliet"
        alert "100"
        connection.register.fields.password = "R0m30"
        lert "100"
        alert "before"
        connection.register.submit()
        alert "after"
      else if status is Strophe.Status.REGISTERED
        alert 101
        console.log "registered!"
        connection.authenticate()
      else if status is Strophe.Status.CONNECTED
        alert 102
        console.log "logged in!"
      else
        alert "con"
        alert "con" + connection

  $scope.getNodeSubscriptions = (group) ->
    $scope.XMPP.connection.pubsub.getNodeSubscriptions group, (data) ->
      console.log "Subscribers"
      console.log data



  $scope.connect = (user, password) ->
    connection = undefined
    connection = new Strophe.Connection("http://idlecampus.com/http-bind")
    connection.connect user, password, (status) ->
      $scope.XMPP.connection = connection
      console.log status

    connection.xmlInput = (body) ->
      console.log body

    connection.xmlOutput = (body) ->
      console.log "XMPP OUTPUT"
      console.log body
      localStorage.setItem "rid", $(body).attr("rid")
      localStorage.setItem "sid", $(body).attr("sid")

  $scope.getGroupsCreated = ->
    $.get "/groups", (data) ->
      console.log "groups created"
      console.log data
      for d in data
        Data.groupscreated.push d
       

  $scope.checkIfGroupsToCreate =  ->
      if (typeof gon isnt "undefined" and gon isnt null) and (gon.group?)
        grouo_name = gon.group.group_name
        group_code = gon.group.grup_code
        $scope.XMPP.connection.pubsub.publish $scope.XMPP.connection.jid.split("/")[0] + "/groups", group_code, (data) ->
	  
  $scope.register1 = ->
    console.log gon.attacher
    form = $scope.signupform
    connection = new Strophe.Connection("http://idlecampus.com//http-bind")
    sid = localStorage.getItem("sid")
    rid = localStorage.getItem("rid")
    jid = localStorage.getItem("jid")
    console.log "CREDENTIALS"
    console.log sid
    console.log rid
    console.log jid
    console.log connection
    callback = (status) ->
      console.log status
      if status is Strophe.Status.REGISTER
        connection.register.fields.username = user
        connection.register.fields.password = password
        connection.register.submit()
      else if status is Strophe.Status.REGISTERED
        localStorage.setItem "jid", user + "@idlecampus.com"
        $scope.connect user + "@idlecampus.com", password
        $scope.$digest()
      else if status is Strophe.Status.CONNECTED
        console.log "logged in!"
      else

    if (typeof gon isnt "undefined" and gon isnt null) and (gon.register?)
      user = gon.register.name
      email = gon.register.email
      password = gon.register.password
      connection.register.connect "idlecampus.com", callback, 60, 1
    if (typeof gon isnt "undefined" and gon isnt null) and (gon.attacher?)
      user = gon.attacher.user
      password = gon.attacher.password
      localStorage.setItem "jid", user + "@idlecampus.com"
      return $scope.connect(user + "@idlecampus.com", password)
   
    if (typeof jid isnt "undefined" and jid isnt null) and (typeof sid isnt "undefined" and sid isnt null) and (typeof rid isnt "undefined" and rid isnt null) and jid isnt "" and sid isnt "" and rid isnt ""
      console.log connection
      connection.xmlInput = (body) ->
        console.log body

      connection.xmlOutput = (body) ->
        console.log "XMPP OUTPUT"
        console.log body
        localStorage.setItem "rid", $(body).attr("rid")
        localStorage.setItem "sid", $(body).attr("sid")

      connection.attach jid, sid, rid, (status) ->
        console.log status
        if status is Strophe.Status.CONNECTED or status is Strophe.Status.ATTACHED
          $scope.XMPP.connection = connection
          $scope.XMPP.connection.jid = jid
          console.log "attached"
          $scope.connected()
          $scope.getGroupsCreated()
		        $scope.checkIfGroupsToCreate()
        else
          $(document).trigger "disconnected"  if status is Strophe.Status.DISCONNECTED

    $scope.XMPP.connection = connection

  $scope.signout = ->
    
    $scope.XMPP.connection.disconnect()
    localStorage.clear()
    

  $scope.attach = ->
    
   
    conn = new Strophe.Connection(gon.global.xmpp_url)
    conn.xmlInput = (body) ->
      console.log body if gon.global.debug

    conn.xmlOutput = (body) ->
      console.log body if gon.global.debug
      localStorage.setItem "rid", $(body).attr("rid")
      localStorage.setItem "sid", $(body).attr("sid")

    sid = localStorage.getItem("sid")
    rid = localStorage.getItem("rid")
    jid = localStorage.getItem("jid")
   
    if typeof gon.attacher isnt "undefined" and gon.attacher isnt null
      sid = gon.attacher.id
      rid = gon.attacher.rid
      jid = gon.attacher.jid
      group = gon.attacher.group
      localStorage.setItem "jid", jid 
    if jid and sid and rid
      conn.attach jid, sid, rid, (status) ->
        console.log status if gon.global.env != "test"
        if status is Strophe.Status.CONNECTED or status is Strophe.Status.ATTACHED
          $scope.XMPP.connection = conn
          $scope.XMPP.connection.jid = jid
          $scope.connected()
          $scope.XMPP.connection.pubsub.subscribe group, "", ((data) -> 
          ), ((data) ->
            
            
          ), ((data) ->
          ), true if group
        else
          $scope.disconnected()  if status is Strophe.Status.DISCONNECTED]
