;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname BCD_DialogScript Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Bool isFree = False
If NoPaymentFaction && akSpeaker.IsInFaction(NoPaymentFaction)
    isFree = True
EndIf
QuestScript.OpenMap(akSpeaker, IsFerry, WhiteList, BlockList, isFree)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

BCD_Script Property QuestScript Auto
FormList Property BlockList Auto
{List of MapMarkers where travel is not possible.}
FormList Property WhiteList Auto
{If specified, travel is possible only to MapMarkers specified in this list.}
Bool Property IsFerry Auto
Faction Property NoPaymentFaction Auto
{Drivers in this faction will not charge the player.}