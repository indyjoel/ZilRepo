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
	(WEST TO ROOM-A)
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
         <TELL "The leaflet says: 'WELCOME TO ZORK! CR
		 ZORK is a game of adventure, danger, and low cunning. In it you will explore some of the most CR
		 amazing territory ever seen by mortals. No Computer should be without one! CR>
         <RETURN T>)>>


<OBJECT COAT
    (DESC "coat")
    (SYNONYM COAT JACKET)
    (IN PLAYER)
    (FLAGS TAKEBIT WEARBIT WORNBIT)
    (ACTION COAT-R)>

<ROUTINE COAT-R ()
    <COND (<VERB? EXAMINE> <TELL "Nice clean coat." CR>)>>

<OBJECT BALL
    (DESC "ball")
    (SYNONYM BALL)
    (IN ROOM-A)
    (FLAGS TAKEBIT)
    (ACTION CLOAK-R)>

<ROUTINE CLOAK-R ()
    <COND (<VERB? EXAMINE> <TELL "A nice round ball." CR>)>>
	
<OBJECT BAT
    (DESC "bat")
    (SYNONYM BAT)
    (IN ROOM-A)
    (FLAGS TAKEBIT)
    (ACTION CLOAK-R2)>


<ROUTINE CLOAK-R2 ()
    <COND (<VERB? EXAMINE> <TELL "A nice wooden bat." CR>)>>