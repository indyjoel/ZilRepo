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
    <SETG HERE ,ROOM-A>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser">


<ROOM ROOM-A
    (DESC "Room A")
    (IN ROOMS)
    (LDESC "Description of room that displays first time only, or every time if the game is in Verbose mode.")
    (NORTH TO X)
    (SOUTH TO X)
    (EAST TO X)
    (WEST TO X)
    (FLAGS LIGHTBIT ONBIT)>

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