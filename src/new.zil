"Saint Mallory Demo Game"

<VERSION XZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"Saint Mallory Demo|
Original Story by Ruth Bedder|
IF Game Conversion by Adam Sommerfield|
ZIL coding assistance from the ZIL Revivalists">

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "Opening introductory text for Saint Mallory" CR CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,COMMENCE>
	<SETG MODE ,VERBOSE>
	;<QUEUE I-MOOD -1>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser">
;<INSERT-FILE "verbs_plus">
;<INSERT-FILE "swarmbaby">


<ROOM COMMENCE
    (DESC "Starting Scene")
    (IN ROOMS)
    (LDESC "This is the opening scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
;    (EAST TO STREET)
	(WEST SORRY "Can't go that way.")
    (FLAGS ONBIT LIGHTBIT)>