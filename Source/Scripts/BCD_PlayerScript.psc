Scriptname BCD_PlayerScript Extends ReferenceAlias

Event OnPlayerLoadGame()
    (GetOwningQuest() as BCD_Script).Init()
EndEvent