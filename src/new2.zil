<VERSION ZIP>
<CONSTANT RELEASEID 1>

"Basic mailbox game with working OPEN, CLOSE, and READ"

<CONSTANT GAME-BANNER
"Mailbox Example Game |
(c) 2025 Interactive Fiction Co. All rights reserved. |
Release 1 / Serial Number 250507"
>

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "Mailbox Example" CR>
    <INIT-STATUS-LINE>
    <SETG HERE ,WEST-OF-HOUSE>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>>

<INSERT-FILE "parser"> ; ensure this contains verb/action handling

<ROOM WEST-OF-HOUSE
    (DESC "West of House")
    (IN ROOMS)
    (LDESC "You are standing in an open field west of a white house, with a boarded front door.")
    (FLAGS LIGHTBIT ONBIT)>

<OBJECT MAILBOX
  (LOC WEST-OF-HOUSE)
  (DESC "small mailbox")
  (SYNONYM MAILBOX)
  (ADJECTIVE SMALL)
  (FLAGS CONTAINER OPENABLE)
  (FDESC "There is a small mailbox here.")
  (LDESC "The mailbox is closed.")
  (ACTION MAILBOX-F)>

<OBJECT LEAFLET
  (LOC MAILBOX)
  (DESC "leaflet")
  (SYNONYM LEAFLET PAPER)
  (ADJECTIVE SMALL)
  (FLAGS TAKEABLE READABLE)
  (FDESC "A small leaflet rests inside the mailbox.")
  (ACTION LEAFLET-F)>



<ROUTINE MAILBOX-F ()
  <COND
    ((EQUAL? ,PRSA ,OPEN)
     <COND
       ((IS? ,PRSO OPEN)
        <TELL "It's already open." CR>)
       (T
        <SET ,PRSO ,OPEN>
        <TELL "You open the mailbox." CR>)
     <RETURN T>
    ((EQUAL? ,PRSA ,CLOSE)
     <COND
       ((NOT <IS? ,PRSO OPEN>)
        <TELL "It's already closed." CR>)
       (T
        <CLEAR ,PRSO ,OPEN>
        <TELL "You close the mailbox." CR>)
     <RETURN T>)>>
	 
<ROUTINE LEAFLET-F ()
  <COND
    ((EQUAL? ,PRSA ,READ)
     <TELL "The leaflet says: 'WELCOME TO ZORK!^ZORK is a game of adventure, danger, and low cunning.^In it you will explore some of the most amazing territory ever seen by mortals.^No Computer should be without one!'" CR>
     <RETURN T>)>>
