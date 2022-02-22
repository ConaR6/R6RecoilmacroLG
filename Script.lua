-- /////////// Recoil Control Settings  /////////
 
-- //// SMG == GUNS WITH LOW RECOIL AND WILL RAPID FIRE FAST 
-- //// AR == GUNS WITH HIGH RECOIL AND WILL RAPID FIRE SLOW
 
-- //// Recoil is handled via # of pixels moved (SMGRecoilMouseMoveAmount), 
-- //// and a delay between each time this movement happens (SMGRapidFireDelayBetweenShots)
 
-- //// Recoil is enabled by Numlock, and can be changed in control settings, Button 4 on your mouse is rapid fire. It's primed by right click.
 
-- //// CHANGE THE BELOW INFO -- 
-- //// WHEN {SMGorARtoggle/Scrolllock by default} IS ON,    IT IS USING SMG SETTINGS
-- //// WHEN {SMGorARtoggle/Scrolllock by default} IS OFF,   IT IS USING AR SETTINGS
 
-- //////////////////////////////////////// RECOIL COMPENSATION SETTINGS -- ////////////////////////////////////////////////
 
 
SMGRecoilMouseMoveAmount    = 8  --           // distance the mousewill move down for recoil compensation NO decimals
ARRecoilMouseMoveAmount     = 10 --           // MORE == Pulls Mouse down more. 1 mousemove==100 DelaySleep
 
SMGMouseMoveDelaySleep      = 8  --           // Delay in miliseconds between each time RecoilMouseMoveAmount
ARMouseMoveDelaySleep       = 8  --           //  More==less mouse pull down, 1 mousemove==100 DelaySleep
 
HorizontalRecoilModifier    = 0  --           // -1 pulls the mouse to the left slightly when firing for compensation
--                                            // If your recoil moves right, try 1. 0==dont move left or right
 
-- //////////////////////////////////////// RAPID FIRE SETTINGS -- ////////////////////////////////////////////////
 
SMGRapidFireDelayBetweenShots   = 80 --      // Delay in (roughly) miliseconds 
ARRapidFireDelayBetweenShots    = 110 --     // between each time SMG/AR/RecoilMouseMoveAmount moves your mouse  
 
SMGRapidFireRecoilCompensation  = 16 --      // In between each rapid fire shot, it will pull the mouse down
ARRapidFireRecoilCompensation   = 9 --       // More == Pulling the Mouse down more between shots
 
RapidFireMousePressDurationSMG  = 9 --       // How long is left click held for rapid fire
RapidFireMousePressDurationAR   = 9 --       //  in milliseconds. 1 == 1 tap
 
-- ///////////////////////////////////////////////////////////////////////////////////////////////////// 
-- //////////////////////////////////////// CONTROLS -- ////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////// 
 
-- //// Options for binding include "scrolllock" "capslock" and "numlock" 
 
LockKey = "numlock"             --    // (TURNS ENTIRE SCRIPT ON/OFF) 
--                                    // Options for binding include "scrolllock" "capslock" and "numlock" 
 
SMGorARtoggle = "scrolllock"    --    // alternates between ARs and SMGs 
--                                    //  (or lots of recoil or not a lot of  recoil)
 
RapidFireButton = 5 --       https://i.imgur.com/WinEVPi.png list of logitech mouse keys. 
--                           I have a G602/g604 with 11 keys. First thumb button == 4 and goes up to 10
 
-- //////////////////////////////////////// ONLY LUA CODERS TOUCH BELOW -- ////////////////////////////////////////////////
 
RapidFireSleepMin = 0
RapidFireSleepMax = 0
MouseMove = 0
NRMin = 0
NRMax = 0
Countx = 0
CountY = 0
 
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////// ONLY LUA CODERS TOUCH BELOW -- ////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////// THIS SECTION IS (SMGorARtoggle){IF SCROLLOCK IS on}  ///////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 
function CheckForSMGorAR()
    if IsKeyLockOn(SMGorARtoggle) then
 
        NoRecoilMouseMoveVert = SMGRecoilMouseMoveAmount -- How Much recoil handling for automatic guns. More==pulldown mouse more
        if (SMGRapidFireDelayBetweenShots > 7) then
            RapidFireSleepMin = SMGRapidFireDelayBetweenShots - 7
            RapidFireSleepMax = SMGRapidFireDelayBetweenShots + 7
        else
            RapidFireSleepMin = SMGRapidFireDelayBetweenShots - SMGRapidFireDelayBetweenShots + 5
            RapidFireSleepMax = SMGRapidFireDelayBetweenShots + 10
        end
        MouseMove = SMGRapidFireRecoilCompensation
        SleepNoRecoilMin = SMGMouseMoveDelaySleep - 1
        SleepNoRecoilMax = SMGMouseMoveDelaySleep + 1
        -- // this if else is creating a range of numbers to work from for random generators
        if (RapidFireMousePressDurationSMG > 1) then
            PressSpeedMin = RapidFireMousePressDurationSMG - 1
            PressSpeedMax = RapidFireMousePressDurationSMG + 1
        else
            PressSpeedMin = RapidFireMousePressDurationSMG
            PressSpeedMax = RapidFireMousePressDurationSMG + 1
        end
        -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        -- /////////////////////// THIS IS FOR ARs OR HighRecoil GUNS. {IF SCROLLOCK IS OFF} ///////////////////////
        -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    else
        NoRecoilMouseMoveVert = ARRecoilMouseMoveAmount
 
        SleepNoRecoilMin = ARMouseMoveDelaySleep - 1
        SleepNoRecoilMax = ARMouseMoveDelaySleep + 1
        if (ARRapidFireDelayBetweenShots > 10) then
            RapidFireSleepMin = ARRapidFireDelayBetweenShots - 5
            RapidFireSleepMax = ARRapidFireDelayBetweenShots + 5
        else
            RapidFireSleepMin = ARRapidFireDelayBetweenShots - ARRapidFireDelayBetweenShots + 5
            RapidFireSleepMax = ARRapidFireDelayBetweenShots + 5
        end
        MouseMove = ARRapidFireRecoilCompensation
        if (RapidFireMousePressDurationAR > 1) then
            PressSpeedMin = RapidFireMousePressDurationAR - 1
            PressSpeedMax = RapidFireMousePressDurationAR + 1
        else
            PressSpeedMin = RapidFireMousePressDurationAR
            PressSpeedMax = RapidFireMousePressDurationAR + 1
        end
    end
end
LC = 1 -- Change this   // 1 = Left Click, 2= Middle Mouse, 3= Right Click
RC = 3 -- Change this   // LC = Fire button, RC = Aim Button
 
-- 
function Resetter()
    Countx = 0
end
 
-- //////////////////////////////////////////////////////////////
 
function RapidFire()
    repeat
        PressMouseButton(LC)
        Sleep(math.random(PressSpeedMin, PressSpeedMax))
        ReleaseMouseButton(LC)
        Sleep(math.random(2, 4))
        MoveMouseRelative(0, MouseMove)
        Sleep(math.random(RapidFireSleepMin, RapidFireSleepMax))
    until not IsMouseButtonPressed(RC)
end
 
-- //////////////////////////////////////////////////////////////
 
function NoRecoil()
    repeat
        MoveMouseRelative(HorizontalRecoilModifier, NoRecoilMouseMoveVert)
        Sleep(math.random(SleepNoRecoilMin, SleepNoRecoilMax))
    until not IsMouseButtonPressed(LC)
end
 
-- //////////////////////////////////////////////////////////////
 
function OnEvent(event, arg)
    EnablePrimaryMouseButtonEvents(true);
    if (event == "MOUSE_BUTTON_PRESSED" and arg == LC) then
        Sleep(25)
        if IsMouseButtonPressed(RC) then
            if IsKeyLockOn(LockKey) then
                CheckForSMGorAR()
                NoRecoil()
                Resetter()
            end
        else
            while IsMouseButtonPressed(LC) do
                Sleep(15)
                if IsMouseButtonPressed(RC) then
                    CheckForSMGorAR()
                    NoRecoil()
                    Resetter()
                end
            end
        end
    end
 
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 4) then
        Sleep(25)
        if IsMouseButtonPressed(RC) then
            CheckForSMGorAR()
            RapidFire()
            Resetter()
        else
            Sleep(25)
            if IsMouseButtonPressed(RC) then
                CheckForSMGorAR()
                RapidFire()
                Resetter()
            end
        end
    end
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then
        repeat
            if IsMouseButtonPressed(1) then
                CheckForSMGorAR()
                NoRecoil()
                Resetter()
            elseif IsMouseButtonPressed(4) then
                CheckForSMGorAR()
                RapidFire()
                Resetter()
            else
                Sleep(15)
            end
        until not IsMouseButtonPressed(3)
 
    end
end
