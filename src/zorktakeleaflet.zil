

<OBJECT MAILBOX
  (LOC HERE) ; or wherever you want the mailbox to be
  (DESC "small mailbox")
  (SYNONYM MAILBOX)
  (ADJECTIVE SMALL)
  (FLAGS CONTAINER OPENABLE)
  (CAPACITY 5)
  (ACTION MAILBOX-F)
  (FDESC "There is a small mailbox here.")
  (LDESC "The mailbox is closed.")
  (CONTENTS LEAFLET)>

<OBJECT LEAFLET
  (DESC "leaflet")
  (SYNONYM LEAFLET PAPER)
  (ADJECTIVE SMALL)
  (FLAGS TAKEABLE READABLE)
  (ACTION LEAFLET-F)
  (FDESC "A small leaflet rests inside the mailbox.")>

<ROUTINE MAILBOX-F ()
  <COND
    ((AND ,PRSA ,PRSO)
     <COND
       ((EQUAL? ,PRSA ,OPEN)
        <TELL "You open the mailbox." CR>
        <SETG MAILBOX <PUTP ,MAILBOX ,OPEN? T>>
        T)
       ((EQUAL? ,PRSA ,CLOSE)
        <TELL "You close the mailbox." CR>
        <SETG MAILBOX <PUTP ,MAILBOX ,OPEN? NIL>>
        T)))>

<ROUTINE LEAFLET-F ()
  <COND
    ((EQUAL? ,PRSA ,READ)
     <TELL "Welcome to ZIL! This leaflet introduces you to the world of interactive fiction." CR>
     T))>
