-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################
local lrpositions = {
        ["ba_jail_blackops"] = {
                guntoss_ct = Vector(547, 441, 26),
                guntoss_t = Vector(691, 448, 26),
                s4s_ct = Vector(2007, 1130, -106),
                s4s_t = Vector(1997, 416, -106)
        },
        ["ba_jail_canyondam_v6_fix"] = {
                guntoss_ct = Vector(-3419, 1327, -2302),
                guntoss_t = Vector(-3287, 1304, -2302),
                s4s_ct = Vector(730, 716, -2302),
                s4s_t = Vector(729, -471, -2302)
        },
        ["jb_new_summer_v2"] = {
                guntoss_ct = Vector(955, -355, -590),
                guntoss_t = Vector(954, -441, -590),
                s4s_ct = Vector(205, -279, -580),
                s4s_t = Vector(209, 437, -580)
        },
        ["jb_parabellum_xg_v1-1"] = {
                guntoss_ct = Vector(3316, -4076, 445),
                guntoss_t = Vector(3316, -4076, 445),
                s4s_ct = Vector(3436, -3934, 126),
                s4s_t = Vector(4340, -4059, 126)
        },
        ["ba_jail_electric_vip"] = {
                guntoss_ct = Vector(-1520, 1672, 94),
                guntoss_t = Vector(-1412, 1673, 94),
                s4s_ct = Vector(-1443, 1680, 96),
                s4s_t = Vector(-1443, 2844, 96)
        },
        ["ba_jail_leoben_a1"] = {
                guntoss_ct = Vector(-2692, 2035, 254),
                guntoss_t = Vector(-2697, 2155, 256),
                s4s_ct = Vector(-2788, 2530, 254),
                s4s_t = Vector(-3504, 2537, 254)
        },
        ["jb_vipinthemix_v1_2"] = {
                guntoss_ct = Vector(927, 849, 94),
                guntoss_t = Vector(801, 848, 94),
                s4s_ct = Vector(1979, 3014, -40),
                s4s_t = Vector(786, 3030, -40)
        },
        ["ba_jail_tile_paradice_v_2_sg"] = {
                guntoss_ct = Vector(-1690, 449, -1000),
                guntoss_t = Vector(-1672, 273, -1000),
                s4s_ct = Vector(-1619, -752, -988),
                s4s_t = Vector(-1649, -1424, -988)
        },
        ["ba_jail_campus_2011_final"] = {
                guntoss_ct = Vector(-6534, 4184, 102),
                guntoss_t = Vector(-6528, 3972, 102),
                s4s_ct = Vector(-6547, 4661, 102),
                s4s_t = Vector(-5716, 4661, 102)
        },
        ["jb_space_jail_v1_fix2"] = {
                guntoss_ct = Vector(293, 141, 98),
                guntoss_t = Vector(397, 141, 98),
                s4s_ct = Vector(-982, 1828, -2),
                s4s_t = Vector(-2818, 1826, -1)
        },
        ["ba_jail_sand_v3"] = {
                guntoss_ct = Vector(-1583, 350, 268),
                guntoss_t = Vector(-1576, 153, 268),
                s4s_ct = Vector(1067, 556, 319),
                s4s_t = Vector(2183, 547, 319)
        },
        ["jb_italia_final"] = {
                guntoss_ct = Vector(1280, 313, 160),
                guntoss_t = Vector(1476, 305, 160),
                s4s_ct = Vector(394, -1167, 0),
                s4s_t = Vector(1493, -1168, 0)
        },
        ["ba_jail_islandtorture_nosound"] = {
                guntoss_ct = Vector(250,418,1024),
                guntoss_t = Vector(251,239,1024),
                s4s_ct = Vector(1005,-1649,34),
                s4s_t = Vector(-55,-1647,34)
        },
        ["ba_jail_xtreme_downview_v5"] = {
                guntoss_ct = Vector(547, 441, -6),
                guntoss_t = Vector(691, 448, -6),
                s4s_ct = Vector(2007, 1130, -136),
                s4s_t = Vector(1994, 382, -136)
        },
        ["ba_jail_jeff_v2"] = {
                guntoss_ct = Vector(-739, 328, 233),
                guntoss_t = Vector(-828, 317, 252),
                s4s_ct = Vector(-1159, 3469, 59),
                s4s_t = Vector(-1212, 2561, 61)
        },
        ["ba_jail_fridej_beta3"] = {
                guntoss_ct = Vector(-1658, 79, -734),
                guntoss_t = Vector(-1693, -104, -753),
                s4s_ct = Vector(-1450, -685, -757),
                s4s_t = Vector(-1451, 100, -758)
        }
}



local LR = JB.CLASS_LR();
LR:SetName("Shot For Shot");
LR:SetDescription("Both the prisoner and guard are given a Desert Eagle. They can each take a shot at each other one shot at a time.");
LR:SetStartCallback(function(prisoner,guard)
	if SERVER then
		if type(lrpositions[game.GetMap()]) == "table" then
	            prisoner:SetPos(lrpositions[game.GetMap()].s4s_t)
	            guard:SetPos(lrpositions[game.GetMap()].s4s_ct)
	    end
	end

	JB.Util.iterate{prisoner,guard}:GiveAmmo(1000,"SMG1"):GiveAmmo(1000,"pistol"):Give('weapon_jb_deagle');

    local caldeagle = prisoner:GetWeapon("weapon_jb_deagle")          
    local targdeagle = guard:GetWeapon("weapon_jb_deagle")
    targdeagle:SetNextPrimaryFire(CurTime() + 1000)
    JB.BroadcastNotification(prisoner:Nick() .. "'s turn to shoot")

    function caldeagle:TakePrimaryAmmo()
                self:SetNextPrimaryFire(CurTime() + 1000)
                targdeagle:SetNextPrimaryFire(CurTime() - 1)
                if guard:Alive() then
    				JB.BroadcastNotification(prisoner:Nick() .. "'s turn to shoot")
                end
 	end

            

    function targdeagle:TakePrimaryAmmo()
            targdeagle:SetNextPrimaryFire(CurTime() + 1000)
            caldeagle:SetNextPrimaryFire(CurTime() - 1)
            if prisoner:Alive() then
    				JB.BroadcastNotification(guard:Nick() .. "'s turn to shoot")
            end
    end
    timer.Simple(0.5,function()
                prisoner:SelectWeapon("weapon_jb_deagle")
                guard:SelectWeapon("weapon_jb_deagle")
    end)

end)
LR:SetIcon(Material("icon16/bomb.png"))
LR();