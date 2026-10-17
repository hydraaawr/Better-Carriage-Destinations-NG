Scriptname BCD_Script extends Quest

Import BCD_Utils

Actor Property PlayerRef Auto
MiscObject Property Gold Auto
GlobalVariable Property BCD_Cost Auto
GlobalVariable Property CarriageDistanceMult Auto
GlobalVariable Property FerryDistanceMult Auto
FormList Property BCD_CarriageLocationsList Auto
FormList Property BCD_FerryLocationsList Auto
FormList Property BCD_DangerousLocationLists Auto
FormList Property BCD_DeferredMarkers Auto
FormList Property BCD_DeferredMarkersTargets Auto
Message property BCD_ConfirmMsg Auto
BCD_MCM Property Config Auto
Scene Property BDC_CarriageResponseScene Auto
Scene Property BDC_FerryResponseScene Auto
ReferenceAlias Property Driver Auto
Spell Property BCD_CarryWeightAb Auto
GlobalVariable Property MapReqsDisabled Auto

; temp storage
ObjectReference currentMarker
Actor currentDriver
Bool isFerry
Bool isFree
Int htham_mapIsDisabled ; Helps To Have A Map mod config

Event OnInit()
    Init()
EndEvent

Function Init()
    Config.OnSettingChange("")
    HelpsToHaveAMap()
EndFunction

Function OpenMap(Actor akDriver, Bool abFerryman = False, FormList akWhitelist = None, FormList akBlocklist = None, Bool abIsFree = False)
    currentDriver = akDriver
    isFerry = abFerryman
    isFree = abIsFree

    If MapReqsDisabled
        htham_mapIsDisabled = MapReqsDisabled.GetValueInt()
        MapReqsDisabled.SetValueInt(1)
    EndIf

    RegisterForModEvent("BCD_SetDestination", "SetDestination")

    FormList filterList = akWhitelist
    Bool isWhiteList = True
    If akBlocklist
        filterList = akBlocklist
        isWhiteList = False
    EndIf
    OpenTheMap(filterList, isWhiteList)

    While UI.IsMenuOpen("MapMenu")
        Utility.Wait(0.1)
    EndWhile

    UnregisterForModEvent("BCD_SetDestination")

    If MapReqsDisabled
        MapReqsDisabled.SetValueInt(htham_mapIsDisabled)
    EndIf
EndFunction

Event SetDestination(string eventName, string strArg, float numArg, Form formArg)
    ObjectReference marker = GetMapMarkerByIndex(numArg as Int)
    If ! marker
        Return
    EndIf

    ; log marker ID
    ;  Debug.Trace("Marker: " + PO3_SKSEFunctions.IntToString(marker.GetFormID(), true))
    ;  Return

    marker = CheckDeferredMarker(marker)

    Int cost = 0
    If !isFree
        cost = GetTravelCost(marker)
        If BCD_ConfirmMsg.Show(cost) != 0
            Return
        EndIf
    EndIf

    BCD_Utils.CloseTheMap()

    BCD_Cost.SetValueInt(cost)
    Driver.ForceRefTo(currentDriver)
    If isFerry
        BDC_FerryResponseScene.Start()
    Else
        BDC_CarriageResponseScene.Start()
    EndIf

    If PlayerRef.GetItemCount(Gold) >= cost
        currentMarker = marker
        Utility.Wait(2) ; wait before removing gold, ensure ResponseScene is played correctly
        PlayerRef.RemoveItem(Gold, cost)
        DoTravel()
    EndIf
EndEvent

Function DoTravel()
    PlayerRef.AddSpell(BCD_CarryWeightAb, False) ; extra carryweight since fast travel will fail if overencumbered
    PlayerRef.ForceRemoveRagdollFromWorld()
    If Config.bTimePasses
        Game.FastTravel(currentMarker)
    Else
        PlayerRef.MoveTo(currentMarker.GetLinkedRef())
    EndIf
    PlayerRef.RemoveSpell(BCD_CarryWeightAb)
EndFunction

Int Function GetTravelCost(ObjectReference akDestination)
    Float fDistance = GetDistance(playerref, akDestination) * 0.01
    Float fDistanaceMult = CarriageDistanceMult.value
    If isFerry
        fDistanaceMult = FerryDistanceMult.value
    EndIf

    Float fCostMult = Config.fCostMult
    If IsDangerous(akDestination.GetCurrentLocation())
        fCostMult = Config.fDangerousCostMult
    EndIf

    Int result = (fDistance * fDistanaceMult * fCostMult) as Int
    If result < Config.iMinCost
        result = Config.iMinCost
    ElseIf result > Config.iMaxCost
        result = Config.iMaxCost
    EndIf
    Return result
EndFunction

Bool Function IsDangerous(Form akLocation)
    Return HasAnyKeywordInList(akLocation, BCD_DangerousLocationLists)
EndFunction

; Deferred Marker: locations that should point to somewhere else before they're discovered
; If a MapMarker object is present in BCD_DeferredMarkers, its matching index from BCD_DeferredMarkersTargets is used instead.
ObjectReference Function CheckDeferredMarker(ObjectReference akMarker)
    Int index = BCD_DeferredMarkers.Find(akMarker)
    If index != -1 && ! akMarker.CanFastTravelToMarker()
        Return BCD_DeferredMarkersTargets.GetAt(index) as ObjectReference
    EndIf

    Return akMarker
EndFunction

; @link https://www.nexusmods.com/skyrimspecialedition/mods/37238
Function HelpsToHaveAMap()
    If ! MapReqsDisabled
        MapReqsDisabled = Game.GetFormFromFile(0xD9E, "Helps To Have A Map.esp") as GlobalVariable
    EndIf
EndFunction