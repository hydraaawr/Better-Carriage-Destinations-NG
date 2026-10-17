Scriptname BCD_Utils Hidden

ObjectReference Function GetMapMarkerByIndex(Int aiIndex) Global Native

Float Function GetDistance(ObjectReference akFromRef, ObjectReference akToRef) Global Native

Bool Function HasAnyKeywordInList(Form akForm, FormList akList) Global Native

; @param abIsWhitelist
;  - True: map will hide all markers except the ones listed in akFilterList
;  - False: map will hide the markers listed in akFilterList
Function OpenTheMap(FormList akFilterList = None, Bool abIsWhitelist = True) Global Native

Function CloseTheMap() Global Native
