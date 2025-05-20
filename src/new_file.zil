<VERSION ZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"New Adventure Game|\nA ZILF learning experience."
>

<INSERT-FILE "parser">


<ROUTINE GO ()
<CRLF> <CRLF>
<TELL "Game started." CR CR>
<INIT-STATUS-LINE>
<V-VERSION> <CRLF>
<SETG HERE ,START-ROOM>
<MOVE ,PLAYER-CHARACTER ,HERE>
;<TELL "Debug: LIGHTBIT is set for START-ROOM." CR>
<V-LOOK>
<MAIN-LOOP>
>

"Objects"

<OBJECT PLAYER-CHARACTER
(DESC "player")
(SYNONYM PLAYER)
(FLAGS PERSONBIT)>

<OBJECT START-ITEM
(DESC "a mysterious item")
(SYNONYM ITEM)
(IN START-ROOM)
(FLAGS TAKEBIT)>

<OBJECT LEAFLET
(DESC "a leaflet")
(SYNONYM leaflet)
(IN START-ROOM)
(FLAGS TAKEBIT)>

"Rooms"

<ROOM START-ROOM
  (DESC "Living Room")
  (LDESC "You are in a cozy living room with a fireplace.")
  (FLAGS LIGHTED)
>


"End of file."
