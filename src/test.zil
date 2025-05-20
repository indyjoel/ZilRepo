

"MYGAME"
"An example ZIL game loop with game-over handling."

<CONSTANT TRUE T>
<CONSTANT FALSE <>>  ; empty list represents false

<GLOBAL GAME-OVER-FLAG FALSE>  ; a global flag to track if the game should end

<ROUTINE GAME-OVER? ()
  <RETURN <GVAL GAME-OVER-FLAG>>>

<ROUTINE END-GAME ()
  <SETG GAME-OVER-FLAG TRUE>
  <TELL CR "Game over. Thanks for playing!" CR>
  <RETURN>>

<ROUTINE QUIT-COMMAND ()
  <END-GAME>
  <RETURN>>

<SYNTAX QUIT = QUIT-COMMAND>

<ROUTINE GAME-LOOP ()
  ;<READLINE LINE>
  ;<PARSE LINE>
  ;<PERFORM-VALUE>
  <RETURN>>

<ROUTINE GO ()
  <TELL "Welcome to your ZIL game!" CR CR>
  <REPEAT ()
    <COND
      (<NOT <GAME-OVER?>> <GAME-LOOP>)
      (T <RETURN>)>>>
