;----------------------------------------------------------------------
"Swarm Babies Default"
;----------------------------------------------------------------------

<OBJECT MALLORY
    (DESC "Mallory")
    (SYNONYM SAINT MALLORY)
    (IN GENERIC-OBJECTS)>

<OBJECT NICHOLAS
    (DESC "Nicholas")
    (SYNONYM NICHOLAS)
    (IN GENERIC-OBJECTS)>

<OBJECT JANINE
    (DESC "Janine")
    (SYNONYM JANINE)
    (IN GENERIC-OBJECTS)>
	
<OBJECT DEAD-SWARMBABY
    (DESC "dead Swarm Baby")
    (IN LOCAL-GLOBALS)
    (SYNONYM DEAD SWARM BABY SWARMBABY)
    (ADJECTIVE DEAD)
    (ACTION DEAD-SWARMBABY-F)
    (FLAGS PERSONBIT TRYTAKEBIT)>

<ROUTINE DEAD-SWARMBABY-F ()
    <TELL "Swarm Baby is dead." CR>>

<OBJECT SWARMBABY
    (DESC "hideous Swarm Baby")
	(IN CONTAINMENT)
    (SYNONYM SWARM BABY SWARMBABY)
    (ADJECTIVE HIDEOUS UGLY DISGUSTING)
    (FDESC "... introductory text for the Swarm Baby ...")
    (ACTION SWARMBABY-R)
    (FLAGS TRYTAKEBIT PERSONBIT)>

<ROUTINE SWARMBABY-R ()
    <COND (<VERB? EXAMINE> 
			<TELL "Text for examining the Swarm Babies." CR>)
	      
		  (<VERB? ATTACK> 
		  <TELL "Fight scene description, you kill the enemy." CR>
		  <REMOVE ,SWARMBABY>
		  <MOVE ,DEAD-SWARMBABY ,RUBBLE>)
		  
			(<VERB? TELL-ABOUT>
				<COND 
		            			 
                 (<PRSI? ,MALLORY>
                  <TELL "You tell the Swarm Baby about Saint Mallory..." CR>)
				  
				 (<PRSI? ,NICHOLAS>
                  <TELL "You tell the Swarm Baby about Nicholas..." CR>)

				 (<PRSI? ,JANINE>
                  <TELL "You tell the Swarm Baby about Janine..." CR>)>)		  
		  
			(<VERB? ASK-ABOUT>
				<COND 
		            			 
                 (<PRSI? ,MALLORY>
                  <TELL "You ask the Swarm Baby about Saint Mallory..." CR>)
				  
				 (<PRSI? ,NICHOLAS>
                  <TELL "You ask the Swarm Baby about Saint Mallory..." CR>)

				 (<PRSI? ,JANINE>
                  <TELL "You ask the Swarm Baby about Saint Mallory..." CR>)>)>>