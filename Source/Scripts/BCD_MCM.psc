Scriptname BCD_MCM Extends MCM_ConfigBase

; ref
GlobalVariable Property BCD_AllowCleared Auto
GlobalVariable Property BCD_OnlyDiscovered Auto
GlobalVariable Property BCD_OnlySettlement Auto

; properties
Float Property fCostMult Auto
Float Property fDangerousCostMult Auto
Int Property iMinCost Auto
Int Property iMaxCost Auto
Bool Property bTimePasses Auto

Event OnSettingChange(string a_ID)
    fCostMult = GetModsettingFloat("fCostMult:Main")
    fDangerousCostMult = GetModsettingFloat("fDangerousCostMult:Main")
    iMinCost = GetModsettingInt("iMinCost:Main")
    iMaxCost = GetModsettingInt("iMaxCost:Main")
    bTimePasses = GetModsettingBool("bTimePasses:Main")

    BCD_OnlySettlement.value = GetModsettingBool("bOnlySettlement:Main") as Float
    BCD_OnlyDiscovered.value = GetModsettingBool("bOnlyDiscovered:Main") as Float
    BCD_AllowCleared.value = GetModsettingBool("bAllowCleared:Main") as Float
EndEvent