"Saint Mallory Demo Game"

<VERSION XZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"Saint Mallory Demo|
Original Story by Ruth Bedder|
IF Game Conversion by Adam Sommerfield|
ZIL coding assistance from te ZIL Revivalists">

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "Opening introductory text for Saint Mallory" CR CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,COMMENCE>
	<SETG MODE ,VERBOSE>
	<QUEUE I-MOOD -1>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser">
<INSERT-FILE "verbs_plus">
<INSERT-FILE "swarmbaby">

"Rooms"

<ROOM CONTAINMENT
    (DESC "Containment Room")
    (IN ROOMS)
    (LDESC "If you can read this then you're in serious trouble!")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST SORRY "Can't go that way.")
	(WEST SORRY "Can't go that way.")
    (FLAGS ONBIT LIGHTBIT)>

<ROOM COMMENCE
    (DESC "Starting Scene")
    (IN ROOMS)
    (LDESC "This is the opening scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST TO STREET)
	(WEST SORRY "Can't go that way.")
    (FLAGS ONBIT LIGHTBIT)>

<ROOM STREET
    (DESC "Street Scene")
    (IN ROOMS)
    (LDESC "This is the Street scene for the broken city.  North is the Shop.")
    (NORTH TO SHOP)
    (SOUTH SORRY "Can't go that way.")
    (EAST TO SHARDS)
	(WEST TO COMMENCE)
    (FLAGS ONBIT LIGHTBIT)>

<ROOM SHOP
    (DESC "Inside Shop")
    (IN ROOMS)
    (LDESC "This is an exploratory scene inside the Shop in the broken city.  Exits are South (to the Street).")
    (NORTH SORRY "Can't go that way.")
    (SOUTH TO STREET)
    (EAST SORRY "Can't go that way.")
	(WEST SORRY "Can't go that way.")
    (FLAGS ONBIT LIGHTBIT)>

<ROOM SHARDS
    (DESC "Shards Scene")
    (IN ROOMS)
    (LDESC "This is the shards scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST TO RUBBLE)
	(WEST TO STREET)
    (FLAGS ONBIT LIGHTBIT)>

<OBJECT CRYSTALSHARD
    (DESC "large crystal shard")
    (SYNONYM SHARDS SHARD CRYSTAL GLASS)
    (IN SHARDS)
    (FLAGS TRYTAKEBIT)
    (ACTION CRYSTALSHARD-R)>

<ROUTINE CRYSTALSHARD-R ()
    <COND (<VERB? EXAMINE> <TELL "Really cool scene where you see the worlds suffering..." CR> <MOVE ,SWARMBABY ,RUBBLE>)>>

<ROOM RUBBLE
    (DESC "Rubble Scene")
    (IN ROOMS)
    (LDESC "This is the rubble scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST TO DESCENT)
	(WEST TO SHARDS)
    (FLAGS ONBIT LIGHTBIT)>

<ROOM DESCENT
    (DESC "Descent Scene")
    (IN ROOMS)
    (LDESC "This is the descent scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST TO PIT)
	(WEST TO RUBBLE)
	(DOWN TO PIT)
    (FLAGS ONBIT LIGHTBIT)>

<ROOM PIT
    (DESC "Pit Scene")
    (IN ROOMS)
    (LDESC "This is the pit scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST TO PURPLE)
	(WEST SORRY "Can't go that way.")
    (FLAGS ONBIT LIGHTBIT)>

<ROOM PURPLE
    (DESC "Purple Scene")
    (IN ROOMS)
    (LDESC "This is the non-canon purple scene for the broken city.")
    (NORTH SORRY "Can't go that way.")
    (SOUTH SORRY "Can't go that way.")
    (EAST SORRY "Can't go that way.")
	(WEST SORRY "Can't go that way.")
    (FLAGS ONBIT LIGHTBIT)>

"Mood"

<GLOBAL MOOD-COUNTER <>>

	<ROUTINE I-MOOD ()
	<SETG MOOD-COUNTER <+ ,MOOD-COUNTER 1>>
		<COND
		(<EQUAL? ,MOOD-COUNTER 1>
		<TELL
		"The smell of smoke is in the air..." CR>)
		
		(<EQUAL? ,MOOD-COUNTER 2>
        <COND (<IN? ,PLAYER ,COMMENCE> <TELL "... the sky in the east looks like it's glowing ...">)
        (ELSE <TELL "... the sky in the east looks like it's glowing ..." CR>)>)
		
		(<EQUAL? ,MOOD-COUNTER 3>
        <COND (<IN? ,PLAYER ,COMMENCE> <TELL "... maybe the sun is setting ...">)
        (ELSE <TELL "... maybe the sun is setting ..." CR>)>)					

		(<EQUAL? ,MOOD-COUNTER 4>
        <COND (<IN? ,PLAYER ,COMMENCE> <TELL "... maybe the sky is on fire, that would explain the ash ...">)
        (ELSE <TELL "... maybe the sky is on fire, that would explain the ash ..." CR>)>)	
		
		(<EQUAL? ,MOOD-COUNTER 5>
        <COND (<IN? ,PLAYER ,COMMENCE> <TELL "... fire, that's it, something is on fire ...">)
        (ELSE <TELL "... fire, that's it, something is on fire ..." CR>)>)	
		
		(<EQUAL? ,MOOD-COUNTER 6>
        <COND (<IN? ,PLAYER ,COMMENCE> <TELL "... gotta keep moving ...">)
        (ELSE <TELL "... gotta keep moving ..." CR>)>)>>