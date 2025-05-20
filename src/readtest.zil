"ZORK1 for
	        Zork I: The Great Underground Empire
	(c) Copyright 1983 Infocom, Inc.  All Rights Reserved."
	
<VERSION ZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"Infocom interactive fiction - a fantasy story |
(c) Copyright 1981, 1982, 1983, 1984, 1985 Infocom, Inc.  all rights reserved. |
ZORK is a registered trademark of Infocom, Inc. |
Release 119 / Serial Number 880429"
>

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "ZORK I: The Great Underground Empire" CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,WEST-OF-HOUSE>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser">

<ROOM WEST-OF-HOUSE
    (DESC "West of House")
	(EAST TO FIELD)
    (IN ROOMS)
    (LDESC "You are standing in an open field west of a white house, with a boarded front door.")
    (FLAGS LIGHTBIT ONBIT)>

<ROOM FIELD
	(WEST TO WEST-OF-HOUSE)
    (DESC "Open Field")
    (IN ROOMS)
    (LDESC "It is lovely open green field.")
    (FLAGS LIGHTBIT ONBIT)>

; Mailbox object definition
<OBJECT MAILBOX
    (LOC WEST-OF-HOUSE)
    (SYNONYM MAILBOX BOX)
    (ADJECTIVE SMALL)
    (DESC "small mailbox")
    (FLAGS CONTBIT)
    (CAPACITY 10)
    (ACTION MAILBOX-F)>

<ROUTINE MAILBOX-F ()
    <COND
        ((= ,PRSA ,OPENBIT)
         <TELL "Opening the mailbox reveals a leaflet" CR>
         <COND
             ((<IS? ,PRSO ,READ>)
;              <TELL "Inside it contains:" CR>
              <LIST-OBJECTS ,PRSO ,PRSI>)
         >
         <RETURN T>)		 
    >
>

; Leaflet object definition (inside the mailbox)
<OBJECT LEAFLET
    (LOC MAILBOX)
    (SYNONYM LEAFLET PAPER)
    ;(DESC "leaflet with some writing on it")
    (FLAGS READBIT TAKEABLE)
	(ACTION LEAFLET-F)>
	
	
<ROUTINE LEAFLET-F ()
    <COND
        ((= ,PRSA ,READ)
         <IF (<> <LOC ,PRSO> ,WINNER>
              <MOVE ,PRSO ,WINNER>
              <TELL "(Taken)" CR>)>
         <TELL "The leaflet says: 'Welcome to the Adventure!'" CR>
         <RETURN T>)>>