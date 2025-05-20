"Name of Game"

<VERSION ZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"Name of Game | Description of Game | By Your Name Here | 
Year and any other useful info">

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "Opening text, something that sets the scene." CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,WEST-OF-HOUSE>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser">


<ROOM WEST-OF-HOUSE
    (DESC "West of House")
    (IN ROOMS)
    (LDESC "You are standing in an open field west of a white house, with a boarded front door.")
    (SOUTH TO SOUTH-OF-HOUSE)
    (FLAGS LIGHTBIT ONBIT)>

<ROOM SOUTH-OF-HOUSE
    (DESC "South of House")
    (LDESC "You are facing the south side of a white house. There is no door here, and all the windows are boarded.")
    (EAST TO BEHIND-HOUSE)
    (FLAGS LIGHTBIT ONBIT)>

<ROOM BEHIND-HOUSE
    (DESC "Behind House")
    (LDESC "You are behind the white house. A path leads into the forest to the east. In one corner of the house there is a small window which is slightly ajar.")
    
    (FLAGS LIGHTBIT ONBIT)>

<OBJECT COAT
    (DESC "coat")
    (SYNONYM COAT JACKET)
    (IN PLAYER)
    (FLAGS TAKEBIT WEARBIT WORNBIT)
    (ACTION COAT-R)>

<ROUTINE COAT-R ()
    <COND (<VERB? EXAMINE> <TELL "Nice clean coat." CR>)>>

;<OBJECT BALL
    (DESC "ball")
    (SYNONYM BALL)
    (IN WEST-OF-HOUSE)
    (FLAGS TAKEBIT)
    (ACTION CLOAK-R)>

<OBJECT MAILBOX
    (DESC "small mailbox")
    (SYNONYM MAILBOX)
    (IN WEST-OF-HOUSE)
    (FLAGS OPENABLE)
    (ACTION MAILBOX-R)>

<OBJECT LEAFLET
    (DESC "leaflet")
    (SYNONYM LEAFLET)
    (IN MAILBOX)
    (FLAGS TAKEBIT READBIT)
    (ACTION LEAFLET-R)>

<ROUTINE LEAFLET-R ()
    <COND (<VERB? EXAMINE> <TELL "WELCOME TO ZORK!" CR "ZORK is a game of adventure, danger, and low cunning. In it you will explore some of the most amazing territory ever seen by mortals. " CR>)>>

<ROUTINE CLOAK-R ()
    <COND (<VERB? EXAMINE> <TELL "A nice round ball. " CR>)>>

<ROUTINE MAILBOX-R ()
    <COND
        (<VERB? OPEN>
         <TELL "You open the mailbox, revealing a leaflet inside." CR>
         <MOVE ,LEAFLET ,HERE> ; Move the leaflet to the current room
         <RETURN T>)
        (<VERB? EXAMINE>
         <TELL "A small mailbox, slightly weathered." CR>
         <RETURN T>)
        (T <RFALSE>) ; Handles other cases
    >
>