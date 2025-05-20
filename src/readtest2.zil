"ZORK1 for
	        Zork I: The Great Underground Empire
	(c) Copyright 1983 Infocom, Inc.  All Rights Reserved."
	
<VERSION ZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"READ TEST"
>

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "ZORK I: The Great Underground Empire" CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,FRONT-YARD>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser">

<ROOM FRONT-YARD
    (DESC "Reading Test")
    (IN ROOMS)
    (LDESC "You are standing near a mailbox.")
    (FLAGS LIGHTBIT ONBIT)>
	
; Mailbox object definition
<OBJECT MAILBOX
    (LOC FRONT-YARD)
    (SYNONYM MAILBOX BOX)
    (ADJECTIVE SMALL)
    (DESC "small mailbox")
    (FLAGS CONTBIT)
    (CAPACITY 10)
    (ACTION MAILBOX-F)>

; Leaflet object definition (inside the mailbox)
<OBJECT LEAFLET
    (LOC MAILBOX)
    (SYNONYM LEAFLET PAPER)
    (DESC "leaflet with some writing on it")
    (FLAGS READBIT)
	(ACTION LEAFLET-F)>
	
<ROUTINE MAILBOX-F ()
    <COND
        ((= ,PRSA ,OPENBIT)
         <TELL "Opening the mailbox reveals a leaflet" CR>
         <COND
             ((<IS? ,PRSO ,READ>)
              <TELL "Inside it contains:" CR>
              <LIST-OBJECTS ,PRSO ,PRSI>)
         >
         <RETURN T>)		 
    >
>
	
	<ROUTINE LEAFLET-F ()
    <COND
        ((= ,PRSA ,READ)
         <TELL "The leaflet says: 'Welcome to the Adventure!'" CR>
         <RETURN T>)>>