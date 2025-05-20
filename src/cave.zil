<VERSION ZIP>
<CONSTANT RELEASEID 1>

"Main loop"

<CONSTANT GAME-BANNER
"Tenliner Cave Adventure|
A ZILF learning experience in way more than 10 lines.|
Original game by Einar Saukas|
ZIL conversion by jcompton"
>

<INSERT-FILE "parser">

<ROUTINE GO ()
<CRLF> <CRLF>
<TELL "0/0 RUN" CR CR>
<INIT-STATUS-LINE>
<V-VERSION> <CRLF>
<SETG HERE ,CAVE>
<MOVE ,PLAYER ,HERE>
<V-LOOK>
<MAIN-LOOP>
>

"Objects"

<OBJECT SWORD
(DESC "sword")
(SYNONYM SWORD)
(IN CHEST)
(FLAGS TAKEBIT)>

<OBJECT CHEST
(DESC "chest")
(IN PIT)
(SYNONYM CHEST)
(ACTION CHEST-R)
(FLAGS CONTBIT OPENABLEBIT LOCKEDBIT)>

<OBJECT KEY
(DESC "key")
(SYNONYM KEY)
(IN CORPSE)
(FLAGS TAKEBIT)
(ACTION KEY-R)
>

<OBJECT CORPSE
(DESC "corpse")
(IN LAKE)
(SYNONYM CORPSE)
(FLAGS SURFACEBIT CONTBIT OPENBIT)
(DESCFCN CORPSE-DESC-F)>

<OBJECT DRAGON
(DESC "dragon")
(SYNONYM DRAGON)
(IN HALL)
(ACTION DRAGON-R)>

"Rooms. In the original BASIC room descriptions were constant, and minimalist,
so let's replicate that behavior. These do look weird in the status line if
you're an experienced player, but they get the point across."

<ROOM CAVE
(DESC "You are in a cave.")
(IN ROOMS)
(NORTH TO HALL)
(FLAGS LIGHTBIT)>

<ROOM HALL
(DESC "You are in a hall.")
(IN ROOMS)
(SOUTH TO CAVE)
(FLAGS LIGHTBIT)
(EAST TO PIT)>

<ROOM PIT
(DESC "You are in a pit.")
(IN ROOMS)
(WEST TO HALL)
(NORTH TO LAKE)
(FLAGS LIGHTBIT)>

<ROOM LAKE
(DESC "You are in a lake.")
(IN ROOMS)
(SOUTH TO PIT)
(FLAGS LIGHTBIT)>

"Routines. We have to do a few things to make it a game."

"You win by killing the dragon with the sword. If you try killing him without,
he kills you."

<ROUTINE DRAGON-R ()
<COND (<VERB? ATTACK>
<COND (<HELD? ,SWORD>
<SETG SCORE <+ ,SCORE 10>>
<TELL "You won." CR>
<REMOVE ,DRAGON>
<TELL "Your score is " N ,SCORE " of a possible 10, in " N ,MOVES " moves." CR>
<V-QUIT>
<TELL "Too bad." CR> <QUIT> <RFALSE>
)
(ELSE <JIGS-UP "You died.">
<TELL CR>
<V-QUIT>
)
>
) >
>

"The key unlocks the chest, so we'll clear the lockedbit and get out of here."

<ROUTINE CHEST-R ()
<COND (<VERB? OPEN>
<COND (<HELD? ,KEY>
<FCLEAR ,CHEST ,LOCKEDBIT>
<RFALSE>
)
>
)
>
>

"In the original game, you had to LOOK in a room to notice the dragon, chest,
and the corpse and then you had to LOOK CORPSE to see the key and LOOK CHEST
after opening it to notice that it contains a sword. The default behavior of the
ZILF libraries will display all of these objects as part of the room
description. I decided that it was okay to display the dragon, chest, corpse,
and sword, but I wanted the key to stay hidden until the player expressly
examined the corpse, while also allowing it to just be taken blindly, since the
BASIC game allowed that. To accomplish all this, we use a DESCFCN to force the
game to only tell us that there's a corpse, even though it starts with a key
on it."

<ROUTINE CORPSE-DESC-F (ARG)
<COND (<EQUAL? .ARG ,M-OBJDESC?> <RTRUE>)>
<TELL "There is a corpse here." CR>
>

"When we get the key, we know the corpse can hold objects. So, let's stop
hiding objects with that DESCFCN by clearing that property to False <>. Now
the game will describe any objects we put back on the corpse."

<ROUTINE KEY-R ()
<COND (<VERB? TAKE>
<COND (<NOT <EQUAL? <GETP ,CORPSE ,P?DESCFCN> <> > >
<PUTP ,CORPSE ,P?DESCFCN <> >
<RFALSE>
) > ) > >

"And that's all there is to it."
