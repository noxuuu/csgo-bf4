/*
*		Plugin: BF4 RankMod
*		Author: n.o.x
*
*		Description
*		-----------
*		This plugin is based on popular BF2 Rank Mod plugin by *pRED (from amxmodx).
*		Modification is characterised by simplicity, uniqueness, easy installation.
*		It is of the few plugins, who survived time try and still have a lot of fans.
*		Plugin encourages players to compete with each other, earn badges, gain achievements, unblock skills, kill and improve statistics.
*		Plugin is based on gaining higher ranks, which are dependent on Exp. Exp we get for killing, winning rounds and others.
*		We can earn in them 100 badges (25 categories, 4 lvls) and 20 achievements, who gives us addons and super skills that makes game easier.
*
*
*		BF4 Globals
*		---------
*		Rank System			- There is the rank system, based on players grades, acquired by experience.
*		Experience 			- Acquire experience by killing enemies, plant bombs and others.. Experience is needed to get highest rank.
*		Badges 				- Allows players to earn badges, who gives them super skills and addons.
*		Achievements		- Allow players to earn achievements.
*		Medals				- Allow players to collect medals for 1/2/3th position in table at the end match.
*		Daily Rewards		- Bonus system for steelworkers (day 1 - exp, day 2 - 2x exp, day 3 - exp and diamond, etc..)
*		Diamods				- Server currency, we can buy special bonuses for them (in shop).
*		Shop				- We can buy there special bonuses (2x exp, badges etc..)
*		Top-Server			- Shows a menu with the top players, SORTED BY experience.
*		Player Info			- Members have a detailed information (rank, weapon frags, kdr, accuracy, medals, badges, etc..)
*		WebDocs				- Plugin is integrated with www site, players can follow their progress there.
*		
*
*		Changelog
*		---------
*		November 15, 2017	- v1.0 - Initial Release
*
*
*/

#include <emitsoundany>
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <scp>

#define LoopClients(%1) for(int %1 = 1; %1 <= MaxClients; %1++)\
if(IsClientInGame(%1))
	
#define LoopRanks(%1) for(int %1 = 1; %1 < sizeof g_iRankTable; %1++)
#define LoopBadges(%1) for(int %1 = 0; %1 < 25; %1++)
#define LoopAchievements(%1) for(int %1 = 0; %1 < 20; %1++)
#define LoopItemCount(%1) for(int %1 = 0; %1 < menu.ItemCount; %1++)
#define LoopModels(%1) for(int %1 = 1; %1 < sizeof sPlayerMdls; %1++)

#define 	PREFIX_NORMAL 				" \x02[BF4]"
#define 	PREFIX_ERROR 				" \x02[\x04#\x02BF4]"

#define		WEBDOCS_URL					"https://bf4.nwxproject.pl/bf4/"
#define		MINE_MDL					"models/cod_angelskill/mine/w_slam.mdl"
#define		PACKAGE_MDL					"models/cod_angelskill/chemik/chemik.mdl"

#define		HUD_OX						0.17 // 0.01 as default
#define		HUD_OY						0.91 // 0.91 as default

#define 	EXP_DAILY					150
//#define		DEBUG

Handle g_hSql;
Handle g_hTimer = INVALID_HANDLE;
Handle g_hTimerExpose = INVALID_HANDLE;

Handle g_ForwardRankUp;
Handle g_ForwardRankDown;

enum Weapon_ID
{
	weapon_none,
	weapon_deagle,
	weapon_elite,
	weapon_fiveseven,
	weapon_glock,
	weapon_p228,
	weapon_usp,
	weapon_ak47,
	weapon_aug,
	weapon_awp,
	weapon_famas,
	weapon_g3sg1,
	weapon_galil,
	weapon_galilar,
	weapon_m249,
	weapon_m3,
	weapon_m4a1,
	weapon_mac10,
	weapon_mp5navy,
	weapon_p90,
	weapon_scout,
	weapon_sg550,
	weapon_sg552,
	weapon_tmp,
	weapon_ump45,
	weapon_xm1014,
	weapon_bizon,
	weapon_mag7,
	weapon_negev,
	weapon_sawedoff,
	weapon_tec9,
	weapon_taser,
	weapon_hkp2000,
	weapon_mp7,
	weapon_mp9,
	weapon_nova,
	weapon_p250,
	weapon_scar17,
	weapon_scar20,
	weapon_sg556,
	weapon_ssg08,
	weapon_knifegg,
	weapon_knife,
	weapon_flashbang,
	weapon_hegrenade,
	weapon_smokegrenade,
	weapon_molotov,
	weapon_decoy,
	weapon_incgrenade,
	weapon_c4
};

enum BadgeID {
	Badge_Knife,
	Badge_Pistol,
	Badge_Rifles,
	Badge_Shotgun,
	Badge_PM,
	Badge_Sniper,
	Badge_MG,
	Badge_Nade,
	Badge_KDR,
	Badge_Global,
	Badge_Insurgent,
	Badge_Pyrotechnic,
	Badge_Medal,
	Badge_Internship,
	Badge_Achievements,
	Badge_Badges,
	Badge_Mine,
	Badge_Universal,
	Badge_Mixed,
	Badge_Time,
	Badge_Healing,
	Badge_Slowmo,
	Badge_Highlight,
	Badge_Deaths,
	Badge_Connections
};

enum AchievementsID {
	Achievement_Nade,
	Achievement_KDR,
	Achievement_Deaths,
	Achievement_Kills,
	Achievement_Bombs,
	Achievement_Diamonds,
	Achievement_Money,
	Achievement_Mktd,
	Achievement_MineKills,
	Achievement_MineDeaths,
	Achievement_Pockets,
	Achievement_Time,
	Achievement_Medals,
	Achievement_AWP,
	Achievement_Heads,
	Achievement_DMG,
	Achievement_Badges,
	Achievement_Invisiblity,
	Achievement_Rounds,
	Achievement_Connections
};

int g_iRank								[MAXPLAYERS+1];
int g_iExp								[MAXPLAYERS+1];
int g_iDiamonds							[MAXPLAYERS+1];

int g_iDrDay							[MAXPLAYERS+1];
int g_iDrLast							[MAXPLAYERS+1];

int g_iFrags							[MAXPLAYERS+1];
int g_iDeaths							[MAXPLAYERS+1];
int g_iHeadshots						[MAXPLAYERS+1];
int g_iTime								[MAXPLAYERS+1];
int g_iConnections						[MAXPLAYERS+1];

int g_iRaisedPackets					[MAXPLAYERS+1];
int g_iBombs							[MAXPLAYERS+1];
int g_iRounds							[MAXPLAYERS+1];
int g_iMoneyTotal						[MAXPLAYERS+1];

float g_fGivenDmg						[MAXPLAYERS+1];
float g_fObtainedDmg					[MAXPLAYERS+1];

int g_iGoldMedals						[MAXPLAYERS+1];
int g_iSilverMedals						[MAXPLAYERS+1];
int g_iBrownMedals						[MAXPLAYERS+1];

int g_iBadgesValue						[MAXPLAYERS+1][25];
bool g_bAchievement						[MAXPLAYERS+1][20];
int g_iKnifeKills						[MAXPLAYERS+1];
int g_iPistolKills 						[MAXPLAYERS+1];
int g_iRifleKills						[MAXPLAYERS+1];
int g_iShotgunKills						[MAXPLAYERS+1];
int g_iSmgKills							[MAXPLAYERS+1];
int g_iAwpKills							[MAXPLAYERS+1];
int g_iMgKills							[MAXPLAYERS+1];
int g_iNadeKills						[MAXPLAYERS+1];
int g_iMineKills						[MAXPLAYERS+1];
int g_iMineDeaths						[MAXPLAYERS+1];
int g_iSuicideKills						[MAXPLAYERS+1];

int g_iRoundKnifeKills					[MAXPLAYERS+1];
int g_iRoundPistolKills 				[MAXPLAYERS+1];
int g_iRoundRifleKills					[MAXPLAYERS+1];
int g_iRoundShotgunKills				[MAXPLAYERS+1];
int g_iRoundSmgKills					[MAXPLAYERS+1];
int g_iRoundAwpKills					[MAXPLAYERS+1];
int g_iRoundMgKills						[MAXPLAYERS+1];

int g_iAllowAWP							[MAXPLAYERS+1];
bool g_bDeagleReplace					[MAXPLAYERS+1];
bool g_bDoubleExp						[MAXPLAYERS+1];
bool g_bCanHeal							[MAXPLAYERS+1];
int	g_iJumps							[MAXPLAYERS+1];
int	g_iLastButtons						[MAXPLAYERS+1];
int	g_iLastFlags						[MAXPLAYERS+1];
int g_iExposed							[MAXPLAYERS+1];
bool g_bMineExists						[MAXPLAYERS+1];
bool g_bHealthPackUsed					[MAXPLAYERS+1];

int g_iRound;
int g_iSpriteBlue;

ConVar sv_footsteps; 

int g_iRankTable[] = // Exp for rank
{
	300,
	1000,
	1600,
	5000,
	10000,
	12000,
	15000,
	18000,
	23000,
	25000,
	27000,
	30000,
	35000,
	40000,
	45000,
	50000,
	55000,
	60000,
	65000,
	70000,
	75000,
	80000
};

char g_sRanksNames[][] =
{
	"Szeregowy",
	"Starszy Szeregowy",
	"Kapral",
	"Starszy Kapral",
	"Plutonowy",
	"Sierżant",
	"Starszy Sierżant",
	"Młodszy Chorąży",
	"Chorąży",
	"Starszy Chorąży",
	"Chorąży Sztabowy",  
	"Podporucznik",
	"Porucznik",
	"Kapitan",
	"Major",
	"Podpułkownik",
	"Pułkownik",  
	"General Brygady",
	"General Dywizji",
	"General Broni", 
	"General",
	"Marszałek Polski"
};

char sPlayerMdls[][] =
{
	"",
	"models/player/ctm_fbi.mdl", 				// 1 -- ct models
	"models/player/ctm_gign.mdl", 				// 2
	"models/player/ctm_gsg9.mdl", 				// 3
	"models/player/ctm_sas.mdl", 				// 4
	"models/player/ctm_st6.mdl", 				// 5
	"models/player/tm_anarchist.mdl", 			// 6 -- t models
	"models/player/tm_phoenix.mdl", 			// 7
	"models/player/tm_pirate.mdl", 				// 8
	"models/player/tm_balkan_variantA.mdl", 	// 9
	"models/player/tm_leet_variantA.mdl", 		// 10
};

char sArms[][] = {
	"models/weapons/t_arms.mdl",
	"models/weapons/ct_arms.mdl"
};

public Plugin myinfo =
{
    name = "[n.o.x] BF4 Core",
    author = "n.o.x",
    description = "BF4 Rank ExpMod [100 Badges][20 Achievements]",
    version = "0.1b",
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] sError, int err_max)
{
	CreateNative("BF4_GetExp", 		Native_GetExp);
	CreateNative("BF4_SetExp", 		Native_SetExp);
	CreateNative("BF4_GiveExp", 	Native_GiveExp);
	return APLRes_Success;
}

public OnPluginStart()
{
	g_ForwardRankUp	= CreateGlobalForward("BF4_RankUp", ET_Ignore, Param_Cell, Param_Cell);
	g_ForwardRankDown = CreateGlobalForward("BF4_RankDown", ET_Ignore, Param_Cell, Param_Cell);
	
	// Player Commands
	RegConsoleCmd(	"autobuy",				CMD_Autobuy);
	RegConsoleCmd(	"sm_bf4",				CMD_Grade,			"Wyświetla główne menu rang.");
	RegConsoleCmd(	"sm_bf4menu",			CMD_Grade,			"Wyświetla główne menu rang.");
	RegConsoleCmd(	"sm_menu",				CMD_Grade,			"Wyświetla główne menu rang.");
	
	RegConsoleCmd(	"sm_odznaki",			CMD_Badges,			"Wyświetla opis odznak.");
	RegConsoleCmd(	"sm_badges",			CMD_Badges,			"Wyświetla opis odznak.");
	
	RegConsoleCmd(	"sm_sklep",				CMD_Shop,			"Otwiera sklep serwerowy.");
	RegConsoleCmd(	"sm_shop",				CMD_Shop,			"Otwiera sklep serwerowy.");
	RegConsoleCmd(	"sm_s",					CMD_Shop,			"Otwiera sklep serwerowy.");
	
	RegConsoleCmd(	"sm_rank",				CMD_Rank,			"Wyświetla informacje o stanie rankingu.");
	RegConsoleCmd(	"sm_rankme",			CMD_RankMe,			"Wyświetla szczegółowe informacje o pozycji gracza.");
	
	RegConsoleCmd(	"sm_top",				CMD_Top,			"Wyświetla topke graczy.");
	RegConsoleCmd(	"sm_best",				CMD_Top,			"Wyświetla topke graczy.");
	
	RegConsoleCmd(	"sm_bronie",			CMD_Weapons,		"Zmienia preferencje broni na start.");
	RegConsoleCmd(	"sm_weapons",			CMD_Weapons,		"Zmienia preferencje broni na start.");
	
	//Bind for skills
	RegConsoleCmd(	"bf4_explode",			CMD_Explode,		"Możliwość wysadzenia w powietrze siebie i ludzi w pobliżu.");
	RegConsoleCmd(	"bf4_mine",				CMD_Mine,			"Pozwala na podłożenie miny.");
	RegConsoleCmd(	"bf4_hp",				CMD_HealthPack,		"Pozwala na uzycie apteczki.");
	
	//Hooks
	HookEvent(		"player_death", 		Event_PlayerDeath);
	HookEvent(		"player_spawn", 		Event_PlayerSpawn);
	HookEvent(		"bomb_exploded",		Event_BombExplode);
	
	HookEvent(		"round_start",			Event_RoundStart);
	HookEvent(		"round_end",			Event_RoundEnd);
	HookEvent(		"cs_win_panel_match", 	Event_WinPanel);
	HookEvent(		"announce_phase_end", 	Event_RestartRound);
	
	// Stealth steps
	sv_footsteps = FindConVar("sv_footsteps"); 
	AddNormalSoundHook(FootstepCheck); 
	
	//MySql shit
	DB_Connect();
	
	// We need to secure plugin reload
	LoopClients(i)
		if(IsClientInGame(i) && !IsFakeClient(i))
			OnClientPutInServer(i);
}

public Action __________________________________________________________(){}
public void OnMapStart()
{
	ServerCommand("sv_disable_immunity_alpha 1");
	g_hTimer = CreateTimer(1.0, Timer_UpdateHud, _, TIMER_REPEAT);
	
	AddFileToDownloadsTable("sound/nox_bf4/award.mp3");
	AddFileToDownloadsTable("sound/nox_bf4/promotion.mp3");
	
	// package
	AddFileToDownloadsTable("models/cod_angelskill/chemik/chemik.dx80.vtx");
	AddFileToDownloadsTable("models/cod_angelskill/chemik/chemik.dx90.vtx");
	AddFileToDownloadsTable("models/cod_angelskill/chemik/chemik.phy");
	AddFileToDownloadsTable("models/cod_angelskill/chemik/chemik.sw.vtx");
	AddFileToDownloadsTable("models/cod_angelskill/chemik/chemik.vvd");
	AddFileToDownloadsTable("models/cod_angelskill/chemik/chemik.mdl");
	
	AddFileToDownloadsTable("materials/cod_angelskill/chemik/generic_med_kit.vmt");
	AddFileToDownloadsTable("materials/cod_angelskill/chemik/generic_med_kit.vtf");
	
	// mine
	AddFileToDownloadsTable("models/cod_angelskill/mine/w_slam.dx80.vtx");
	AddFileToDownloadsTable("models/cod_angelskill/mine/w_slam.dx90.vtx");
	AddFileToDownloadsTable("models/cod_angelskill/mine/w_slam.phy");
	AddFileToDownloadsTable("models/cod_angelskill/mine/w_slam.sw.vtx");
	AddFileToDownloadsTable("models/cod_angelskill/mine/w_slam.vvd");
	AddFileToDownloadsTable("models/cod_angelskill/mine/w_slam.mdl");
	
	AddFileToDownloadsTable("materials/cod_angelskill/mine/v_slam.vmt");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/v_slam.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/v_slam_normal.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newslam.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newslam.vmt");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newlight1.vmt");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newlight1.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newlight2.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newlight2.vmt");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/retexturetrigger.vmt");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/retexturetrigger.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newlense.vtf");
	AddFileToDownloadsTable("materials/cod_angelskill/mine/newlense.vmt");
	
	PrecacheSoundAny("nox_bf4/award.mp3", true);
	PrecacheSoundAny("nox_bf4/promotion.mp3", true);
	
	PrecacheModel(MINE_MDL);
	PrecacheModel(PACKAGE_MDL);
	
	g_iSpriteBlue = PrecacheModel("materials/sprites/blueflare1.vmt");
	
	LoopModels(i)
		PrecacheModel(sPlayerMdls[i]);
	
	g_iRound = 0;
}

public void OnMapEnd()
{
	LoopClients(i)
		DB_SaveInfo(i);
		
	if(g_hTimer != INVALID_HANDLE)
    {
        CloseHandle(g_hTimer);
        g_hTimer = INVALID_HANDLE;
    }
	
	if(g_hTimerExpose != INVALID_HANDLE)
    {
        CloseHandle(g_hTimerExpose);
        g_hTimerExpose = INVALID_HANDLE;
    }
}

public Action _________________________________________________________(){}
public OnClientAuthorized(client, const String:auth[])
{
	DB_LoadInfo(client);
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, SDK_TakeDamage);
	CreateTimer(5.0, Timer_CheckClient, client);
	SendConVarValue(client, sv_footsteps, "0");
}

public void OnClientDisconnect(int client)
{
	DB_SaveInfo(client);
}

public Action ________________________________________________________(){}
public Action DB_Connect()
{
	if(SQL_CheckConfig("nox_bf4"))
	{
		char DBBuffer[512];
		g_hSql = SQL_Connect("nox_bf4", true, DBBuffer, sizeof(DBBuffer));
		if (g_hSql == INVALID_HANDLE)
			LogError("[BF4] Could not connect: %s", DBBuffer);
		else
		{
			SQL_LockDatabase(g_hSql);
			SQL_FastQuery(g_hSql, "CREATE TABLE IF NOT EXISTS bf4_players (auth_data VARCHAR(48) NOT NULL PRIMARY KEY default '',\
																			name VARCHAR(64) NOT NULL default '',\
																			exp INT NOT NULL default 0,\
																			dr_day INT NOT NULL default 0,\
																			dr_last INT NOT NULL default 0,\
																			frags INT NOT NULL default 0,\
																			deaths INT NOT NULL default 0,\
																			heads INT NOT NULL default 0,\
																			bombs INT NOT NULL default 0,\
																			rounds INT NOT NULL default 0,\
																			money_total INT NOT NULL default 0,\
																			given_dmg FLOAT NOT NULL default 0.0,\
																			obtained_dmg FLOAT NOT NULL default 0.0,\
																			rank INT NOT NULL default 0,\
																			diamonds INT NOT NULL default 0,\
																			join_date INT NOT NULL default 0,\
																			last_seen INT NOT NULL default 0,\
																			connections INT NOT NULL default 0,\
																			server_time INT NOT NULL default 0,\
																			allow_awp INT NOT NULL default 1,\
																			allow_deagle INT NOT NULL default 1,\
																			mine_kills INT NOT NULL default 0,\
																			mine_deaths INT NOT NULL default 0,\
																			suicide_kills INT NOT NULL default 0,\
																			raised_packets INT NOT NULL default 0,\
																			knife_kills INT NOT NULL default 0,\
																			pistol_kills INT NOT NULL default 0,\
																			rifle_kills INT NOT NULL default 0,\
																			shotgun_kills INT NOT NULL default 0,\
																			smg_kills INT NOT NULL default 0,\
																			awp_kills INT NOT NULL default 0,\
																			mg_kills INT NOT NULL default 0,\
																			nade_kills INT NOT NULL default 0,\
																			gold_medals INT NOT NULL default 0,\
																			silver_medals INT NOT NULL default 0,\
																			brown_medals INT NOT NULL default 0,\
																			badge_knife INT NOT NULL default 0,\
																			badge_pistol INT NOT NULL default 0,\
																			badge_rifle INT NOT NULL default 0,\
																			badge_shotgun INT NOT NULL default 0,\
																			badge_smg INT NOT NULL default 0,\
																			badge_awp INT NOT NULL default 0,\
																			badge_mg INT NOT NULL default 0,\
																			badge_nade INT NOT NULL default 0,\
																			badge_kdr INT NOT NULL default 0,\
																			badge_global INT NOT NULL default 0,\
																			badge_insurgent INT NOT NULL default 0,\
																			badge_pyrotechnic INT NOT NULL default 0,\
																			badge_medal INT NOT NULL default 0,\
																			badge_internship INT NOT NULL default 0,\
																			badge_achievements INT NOT NULL default 0,\
																			badge_badges INT NOT NULL default 0,\
																			badge_mine INT NOT NULL default 0,\
																			badge_universal INT NOT NULL default 0,\
																			badge_mixed INT NOT NULL default 0,\
																			badge_time INT NOT NULL default 0,\
																			badge_healing INT NOT NULL default 0,\
																			badge_slowmo INT NOT NULL default 0,\
																			badge_highlight INT NOT NULL default 0,\
																			badge_deaths INT NOT NULL default 0,\
																			badge_connections INT NOT NULL default 0,\
																			achievement_nade INT NOT NULL default 0,\
																			achievement_kdr INT NOT NULL default 0,\
																			achievement_deaths INT NOT NULL default 0,\
																			achievement_kills INT NOT NULL default 0,\
																			achievement_bombs INT NOT NULL default 0,\
																			achievement_diamonds INT NOT NULL default 0,\
																			achievement_money INT NOT NULL default 0,\
																			achievement_mktd INT NOT NULL default 0,\
																			achievement_minekills INT NOT NULL default 0,\
																			achievement_minedeaths INT NOT NULL default 0,\
																			achievement_packages INT NOT NULL default 0,\
																			achievement_time INT NOT NULL default 0,\
																			achievement_medals INT NOT NULL default 0,\
																			achievement_awp INT NOT NULL default 0,\
																			achievement_heads INT NOT NULL default 0,\
																			achievement_dmg INT NOT NULL default 0,\
																			achievement_badges INT NOT NULL default 0,\
																			achievement_invisiblity INT NOT NULL default 0,\
																			achievement_rounds INT NOT NULL default 0,\
																			achievement_connections INT NOT NULL default 0)\
																			ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;");
			SQL_UnlockDatabase(g_hSql);
		}
	}
	else
		SetFailState("Nie mozna odnalezc konfiguracji 'nox_bf4' w databases.cfg.");
}

public DB_LoadInfo(int client)
{
	if(g_hSql != INVALID_HANDLE)
	{
		char _authid[64];
		GetClientAuthId(client, AuthId_Steam2, _authid, 63);
		
		char sQuery[1536];
		Format(sQuery, sizeof(sQuery), "SELECT exp, frags, deaths, heads, bombs, rounds, money_total, given_dmg, obtained_dmg, rank, diamonds, server_time, connections, allow_awp, allow_deagle, mine_kills, mine_deaths, suicide_kills, raised_packets, knife_kills, pistol_kills, rifle_kills, shotgun_kills, smg_kills, awp_kills, mg_kills, nade_kills, gold_medals, silver_medals, brown_medals, badge_knife, badge_pistol, badge_rifle, badge_shotgun, badge_smg, badge_awp, badge_mg, badge_nade, badge_kdr, badge_global, badge_insurgent, badge_pyrotechnic, badge_medal, badge_internship, badge_achievements, badge_badges, badge_mine, badge_universal, badge_mixed, badge_time, badge_healing, badge_slowmo, badge_highlight, badge_deaths, badge_connections, achievement_nade, achievement_kdr, achievement_deaths, achievement_kills, achievement_bombs, achievement_diamonds, achievement_money, achievement_mktd, achievement_minekills, achievement_minedeaths, achievement_packages, achievement_time, achievement_medals, achievement_awp, achievement_heads, achievement_dmg, achievement_badges, achievement_invisiblity, achievement_rounds, achievement_connections, dr_day, dr_last FROM bf4_players WHERE auth_data = '%s';", _authid);
		
		#if defined DEBUG
			PrintToServer(sQuery);
		#endif
		
		SQL_LockDatabase(g_hSql);
		Handle hQuery = SQL_Query(g_hSql, sQuery);
		
		if(hQuery == INVALID_HANDLE)
		{
			char blad[255];
			SQL_GetError(g_hSql, blad, sizeof(blad));
			LogError("Nie mozna odszukac z tabeli. (blad: %s)", blad);
			CloseHandle(g_hSql);
		}
		else if(SQL_FetchRow(hQuery))
		{
			g_iExp[client] = SQL_FetchInt(hQuery, 0);
			g_iFrags[client] = SQL_FetchInt(hQuery, 1);
			g_iDeaths[client] = SQL_FetchInt(hQuery, 2);
			g_iHeadshots[client] = SQL_FetchInt(hQuery, 3);
			g_iRounds[client] = SQL_FetchInt(hQuery, 4);
			g_iBombs[client] = SQL_FetchInt(hQuery, 5);
			g_iMoneyTotal[client] = SQL_FetchInt(hQuery, 6);
			g_fGivenDmg[client] = SQL_FetchFloat(hQuery, 7);
			g_fObtainedDmg[client] = SQL_FetchFloat(hQuery, 8);
			g_iRank[client] = SQL_FetchInt(hQuery, 9);
			g_iDiamonds[client] = SQL_FetchInt(hQuery, 10);
			g_iTime[client] = SQL_FetchInt(hQuery, 11);
			g_iConnections[client] = SQL_FetchInt(hQuery, 12)+1;
			g_iAllowAWP[client] = SQL_FetchInt(hQuery, 13);
			g_bDeagleReplace[client] = GetBoolValue(SQL_FetchInt(hQuery, 14));
			
			g_iMineKills[client] = SQL_FetchInt(hQuery, 15);
			g_iMineDeaths[client] = SQL_FetchInt(hQuery, 16);
			g_iSuicideKills[client] = SQL_FetchInt(hQuery, 17);
			g_iRaisedPackets[client] = SQL_FetchInt(hQuery, 18);
			
			g_iKnifeKills[client] = SQL_FetchInt(hQuery, 19);
			g_iPistolKills[client] = SQL_FetchInt(hQuery, 20);
			g_iRifleKills[client] = SQL_FetchInt(hQuery, 21);
			g_iShotgunKills[client] = SQL_FetchInt(hQuery, 22);
			g_iSmgKills[client] = SQL_FetchInt(hQuery, 23);
			g_iAwpKills[client] = SQL_FetchInt(hQuery, 24);
			g_iMgKills[client] = SQL_FetchInt(hQuery, 25);
			g_iNadeKills[client] = SQL_FetchInt(hQuery, 26);
			
			g_iGoldMedals[client] = SQL_FetchInt(hQuery, 27);
			g_iSilverMedals[client] = SQL_FetchInt(hQuery, 28);
			g_iBrownMedals[client] = SQL_FetchInt(hQuery, 29);
			
			LoopBadges(i)
				g_iBadgesValue[client][i] = SQL_FetchInt(hQuery, i+30);
				
			LoopAchievements(i)
				g_bAchievement[client][i] = GetBoolValue(SQL_FetchInt(hQuery, i+55));
			
			g_iDrDay[client] = SQL_FetchInt(hQuery, 75);
			g_iDrLast[client] = SQL_FetchInt(hQuery, 76);
		}
		else
		{
			g_iDrDay[client] 			= 0;
			g_iDrLast[client] 			= 0;
			g_iFrags[client] 			= 0;
			g_iDeaths[client] 			= 0;
			g_iHeadshots[client] 		= 0;
			g_iRank[client] 			= 0;
			g_iTime[client]				= 0;
			g_iDiamonds[client]			= 0;
			g_fGivenDmg[client]			= 0.0;
			g_fObtainedDmg[client]		= 0.0;
			g_bDoubleExp[client]		= false;
			g_iConnections[client]		= 1;
			g_bMineExists[client]		= false;
			g_bHealthPackUsed[client] 	= false;
			g_bCanHeal[client] 			= false;
			
			LoopBadges(i)
				g_iBadgesValue[client][i] = 0;
			
			LoopAchievements(i)
				g_bAchievement[client][i] = false;
				
			g_iAllowAWP[client]	= 1;
			g_bDeagleReplace[client]	= true;
		}
		CloseHandle(hQuery);
		SQL_UnlockDatabase(g_hSql);
	}
}

public DB_SaveInfo(int client)
{
	if(!IsValidClient(client) || IsFakeClient(client))
		return;
	
	char authid[64];
	if(!GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid)))
		return;
	
	char nick[64];
	char EscapedName[64];
	
	GetClientName(client, nick, sizeof(nick));
	SQL_EscapeString(g_hSql, nick, EscapedName, sizeof(nick));
	
	char sQuery[5000];
	Format(sQuery, sizeof(sQuery), "INSERT INTO `bf4_players` (auth_data, name, exp, dr_day, dr_last, frags, deaths, heads, bombs, rounds, money_total, given_dmg, obtained_dmg, rank, diamonds, join_date, last_seen, connections, server_time, allow_awp, allow_deagle, mine_kills, mine_deaths, suicide_kills, raised_packets, knife_kills, pistol_kills, rifle_kills, shotgun_kills, smg_kills, awp_kills, mg_kills, nade_kills, gold_medals, silver_medals, brown_medals, badge_knife, badge_pistol, badge_rifle, badge_shotgun, badge_smg, badge_awp, badge_mg, badge_nade, badge_kdr, badge_global, badge_insurgent, badge_pyrotechnic, badge_medal, badge_internship, badge_achievements, badge_badges, badge_mine, badge_universal, badge_mixed, badge_time, badge_healing, badge_slowmo, badge_highlight, badge_deaths, badge_connections, achievement_nade, achievement_kdr, achievement_deaths, achievement_kills, achievement_bombs, achievement_diamonds, achievement_money, achievement_mktd, achievement_minekills, achievement_minedeaths, achievement_packages, achievement_time, achievement_medals, achievement_awp, achievement_heads, achievement_dmg, achievement_badges, achievement_invisiblity, achievement_rounds, achievement_connections) VALUES ('%s', '%s', %d, %d, %d, %d, %d, %d, %d, %d, %.f, %.f, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)", authid, EscapedName, g_iExp[client], g_iDrDay[client], g_iDrLast[client], g_iFrags[client], g_iDeaths[client], g_iHeadshots[client], g_iBombs[client], g_iRounds[client], g_iMoneyTotal[client], g_fGivenDmg[client], g_fObtainedDmg[client], g_iRank[client], g_iDiamonds[client], GetTime(), GetTime(), g_iConnections[client], g_iTime[client], g_iAllowAWP[client], GetIntValue(g_bDeagleReplace[client]), g_iMineKills[client], g_iMineDeaths[client], g_iSuicideKills[client], g_iRaisedPackets[client], g_iKnifeKills[client], g_iPistolKills[client], g_iRifleKills[client], g_iShotgunKills[client], g_iSmgKills[client], g_iAwpKills[client], g_iMgKills[client], g_iNadeKills[client], g_iGoldMedals[client], g_iSilverMedals[client], g_iBrownMedals[client], g_iBadgesValue[client][0], g_iBadgesValue[client][1], g_iBadgesValue[client][2], g_iBadgesValue[client][3], g_iBadgesValue[client][4], g_iBadgesValue[client][5], g_iBadgesValue[client][6], g_iBadgesValue[client][7], g_iBadgesValue[client][8], g_iBadgesValue[client][9], g_iBadgesValue[client][10], g_iBadgesValue[client][11], g_iBadgesValue[client][12], g_iBadgesValue[client][13], g_iBadgesValue[client][14], g_iBadgesValue[client][15], g_iBadgesValue[client][16], g_iBadgesValue[client][17], g_iBadgesValue[client][18], g_iBadgesValue[client][19], g_iBadgesValue[client][20], g_iBadgesValue[client][21], g_iBadgesValue[client][22], g_iBadgesValue[client][23], g_iBadgesValue[client][24], GetIntValue(g_bAchievement[client][0]), GetIntValue(g_bAchievement[client][1]), GetIntValue(g_bAchievement[client][2]), GetIntValue(g_bAchievement[client][3]), GetIntValue(g_bAchievement[client][4]), GetIntValue(g_bAchievement[client][5]), GetIntValue(g_bAchievement[client][6]), GetIntValue(g_bAchievement[client][7]), GetIntValue(g_bAchievement[client][8]), GetIntValue(g_bAchievement[client][9]), GetIntValue(g_bAchievement[client][10]), GetIntValue(g_bAchievement[client][11]), GetIntValue(g_bAchievement[client][12]), GetIntValue(g_bAchievement[client][13]), GetIntValue(g_bAchievement[client][14]), GetIntValue(g_bAchievement[client][15]), GetIntValue(g_bAchievement[client][16]), GetIntValue(g_bAchievement[client][17]), GetIntValue(g_bAchievement[client][18]), GetIntValue(g_bAchievement[client][19]));
	Format(sQuery, sizeof(sQuery), "%s ON DUPLICATE KEY UPDATE name=VALUES(name), exp=VALUES(exp), dr_day=VALUES(dr_day), dr_last=VALUES(dr_last), frags=VALUES(frags), deaths=VALUES(deaths), heads=VALUES(heads), bombs=VALUES(bombs), rounds=VALUES(rounds), money_total=VALUES(money_total), given_dmg=VALUES(given_dmg), obtained_dmg=VALUES(obtained_dmg), rank=VALUES(rank), diamonds=VALUES(diamonds), last_seen=VALUES(last_seen), connections=VALUES(connections), server_time=VALUES(server_time), allow_awp=VALUES(allow_awp), allow_deagle=VALUES(allow_deagle), mine_kills=VALUES(mine_kills), mine_deaths=VALUES(mine_deaths), suicide_kills=VALUES(suicide_kills), raised_packets=VALUES(raised_packets), knife_kills=VALUES(knife_kills), pistol_kills=VALUES(pistol_kills), rifle_kills=VALUES(rifle_kills), shotgun_kills=VALUES(shotgun_kills), smg_kills=VALUES(smg_kills), awp_kills=VALUES(awp_kills), mg_kills=VALUES(mg_kills), nade_kills=VALUES(nade_kills), gold_medals=VALUES(gold_medals), silver_medals=VALUES(silver_medals), brown_medals=VALUES(brown_medals), badge_knife=VALUES(badge_knife), badge_pistol=VALUES(badge_pistol), badge_rifle=VALUES(badge_rifle), badge_shotgun=VALUES(badge_shotgun), badge_smg=VALUES(badge_smg), badge_awp=VALUES(badge_awp), badge_mg=VALUES(badge_mg), badge_nade=VALUES(badge_nade), badge_kdr=VALUES(badge_kdr), badge_global=VALUES(badge_global), badge_insurgent=VALUES(badge_insurgent), badge_pyrotechnic=VALUES(badge_pyrotechnic), badge_medal=VALUES(badge_medal), badge_internship=VALUES(badge_internship), badge_achievements=VALUES(badge_achievements), badge_badges=VALUES(badge_badges), badge_mine=VALUES(badge_mine), badge_universal=VALUES(badge_universal), badge_mixed=VALUES(badge_mixed), badge_time=VALUES(badge_time), badge_healing=VALUES(badge_healing), badge_slowmo=VALUES(badge_slowmo), badge_highlight=VALUES(badge_highlight), badge_deaths=VALUES(badge_deaths), badge_connections=VALUES(badge_connections), achievement_nade=VALUES(achievement_nade), achievement_kdr=VALUES(achievement_kdr), achievement_deaths=VALUES(achievement_deaths), achievement_kills=VALUES(achievement_kills), achievement_bombs=VALUES(achievement_bombs), achievement_diamonds=VALUES(achievement_diamonds), achievement_money=VALUES(achievement_money), achievement_mktd=VALUES(achievement_mktd), achievement_minekills=VALUES(achievement_minekills), achievement_minedeaths=VALUES(achievement_minedeaths), achievement_packages=VALUES(achievement_packages), achievement_time=VALUES(achievement_time), achievement_medals=VALUES(achievement_medals), achievement_awp=VALUES(achievement_awp), achievement_heads=VALUES(achievement_heads), achievement_dmg=VALUES(achievement_dmg), achievement_badges=VALUES(achievement_badges), achievement_invisiblity=VALUES(achievement_invisiblity), achievement_rounds=VALUES(achievement_rounds), achievement_connections=VALUES(achievement_connections)", sQuery);
	SQL_TQuery(g_hSql, DB_SaveInfoCallback, sQuery);
}

public void DB_RankCallback(Handle owner, Handle hndl, const char[] error, DataPack info_pack)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RANK] Query failed! %s", error);
		return;
	}
	
	info_pack.Reset(); // Get some info !
	int client = info_pack.ReadCell();
	
	if(client == 0 || !IsClientInGame(client))
		return;
	
	char authid[64];
	if(!GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid)))
		return;
	
	delete info_pack;
	
	int iPosition, iCount;
	char sAuth[64];
	
	while(SQL_FetchRow(hndl))
	{
		iCount++;
		SQL_FetchString(hndl, 0, sAuth, sizeof(sAuth));
		if(StrEqual(sAuth, authid))
			iPosition = iCount;
	}
	
	if(iCount == 0)
		PrintToChat(client, "%s \x01Gracz \x04%N \x02[%s] \01jest w rankingu \x041/1 \x01mając \x04%d \x01zabójstw, \x04%d \x01zgonów i \x02KDR \x04%.2f.", PREFIX_NORMAL, client, g_sRanksNames[g_iRank[client]], g_iFrags[client], g_iDeaths[client], float(g_iFrags[client])/float(g_iDeaths[client]));
	else
		PrintToChat(client, "%s \x01Gracz \x04%N \x02[%s] \01jest w rankingu \x04%d/%d \x01mając \x04%d \x01zabójstw, \x04%d \x01zgonów i \x02KDR \x04%.2f.", PREFIX_NORMAL, client, g_sRanksNames[g_iRank[client]], iPosition, iCount, g_iFrags[client], g_iDeaths[client], float(g_iFrags[client])/float(g_iDeaths[client]));
}

public void DB_RankMeCallback(Handle owner, Handle hndl, const char[] error, DataPack info_pack)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RANKME] Query failed! %s", error);
		return;
	}
	
	info_pack.Reset(); // Get some info !
	char authid[64];
	int client = info_pack.ReadCell();
	info_pack.ReadString(authid, sizeof(authid));
	
	if(client == 0 || !IsClientInGame(client))
		return;
	
	delete info_pack;
	
	int iCount, iPosition, iFrags, iRank, iDeaths, iBadges = 0, iAchievements = 0, iGoldMedals, iSilverMedals, iBrownMedals;
	char sAuth[64], sItem[1024];
	
	Menu menu = new	Menu(Rankme_Handler, MENU_ACTIONS_ALL);
	while(SQL_FetchRow(hndl))
	{
		iCount++;
		SQL_FetchString(hndl, 0, sAuth, sizeof(sAuth));
		if(StrEqual(sAuth, authid))
		{
			SQL_FetchString(hndl, 1, sItem, sizeof(sItem)); // nick
			iFrags = SQL_FetchInt(hndl, 2);
			iRank = SQL_FetchInt(hndl, 3);
			iDeaths = SQL_FetchInt(hndl, 4);
			iGoldMedals = SQL_FetchInt(hndl, 5);
			iSilverMedals = SQL_FetchInt(hndl, 6);
			iBrownMedals = SQL_FetchInt(hndl, 7);
			
			LoopBadges(i)
				iBadges += SQL_FetchInt(hndl, i+8);
				
			LoopAchievements(i)
				iAchievements += SQL_FetchInt(hndl, i+33);
				
			iPosition = iCount;
		}
	}
	
	if(iCount == 0)
		menu.AddItem("", "W tej chwili nie można wyświetlić szczegółowych informacji.");
	else
	{
		Format(sItem, sizeof(sItem), "[#BF4] Statystyki gracza %s \n \n", sItem);
		Format(sItem, sizeof(sItem), "%s➫ Rank: %d/%d \n", sItem, iPosition, iCount);
		Format(sItem, sizeof(sItem), "%s➫ Stopień: [%s] \n", sItem, g_sRanksNames[iRank]);
		Format(sItem, sizeof(sItem), "%s➫ Odznaki: [%d/100]\n \n", sItem, iBadges);
		Format(sItem, sizeof(sItem), "%s➫ Osiągnięcia: [%d/20]\n \n", sItem, iAchievements);
		Format(sItem, sizeof(sItem), "%s➫ Zabójstwa: %d\n", sItem, iFrags);
		Format(sItem, sizeof(sItem), "%s➫ Zgony: %d\n", sItem, iDeaths);
		Format(sItem, sizeof(sItem), "%s➫ KDR: %.2f\n \n", sItem, float(iFrags)/float(iDeaths));
		Format(sItem, sizeof(sItem), "%s➫ Złote medale: %d\n", sItem, iGoldMedals);
		Format(sItem, sizeof(sItem), "%s➫ Srebrne medale: %d\n", sItem, iSilverMedals);
		Format(sItem, sizeof(sItem), "%s➫ Brązowe medale: %d\n \n", sItem, iBrownMedals);
		menu.AddItem("", sItem);
		menu.AddItem("next", "Dalej!");
	}
	menu.AddItem("-SID-", authid);
	
	menu.ExitButton = true;
	menu.Display(client, 0);
}

public void DB_RankMe_DetailsCallback(Handle owner, Handle hndl, const char[] error, DataPack info_pack)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RANKME] Query failed! %s", error);
		return;
	}
	
	info_pack.Reset(); // Get some info !
	char authid[64];
	int client = info_pack.ReadCell();
	info_pack.ReadString(authid, sizeof(authid));
	
	if(client == 0 || !IsClientInGame(client))
		return;
	
	delete info_pack;
	
	int iTime, iConnections, iKnifeKills, iPistolKills, iRifleKills, iShotgunKills, iSmgKills, iAwpKills, iMgKills, iNadeKills;
	char sItem[1024], sJoinDate[32];
	
	Menu menu = new	Menu(Rankme_Handler, MENU_ACTIONS_ALL);
	
	if(SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, sItem, sizeof(sItem));
		FormatTime(sJoinDate, sizeof(sJoinDate), "%d/%m/%Y - %H:%M:%S", SQL_FetchInt(hndl, 1));
		iConnections = SQL_FetchInt(hndl, 2);
		iTime = SQL_FetchInt(hndl, 3);
		iKnifeKills = SQL_FetchInt(hndl, 4);
		iPistolKills = SQL_FetchInt(hndl, 5);
		iRifleKills = SQL_FetchInt(hndl, 6);
		iShotgunKills = SQL_FetchInt(hndl, 7);
		iSmgKills = SQL_FetchInt(hndl, 8);
		iAwpKills = SQL_FetchInt(hndl, 9);
		iMgKills = SQL_FetchInt(hndl, 10);
		iNadeKills = SQL_FetchInt(hndl, 11);
	}
	
	Format(sItem, sizeof(sItem), "[#BF4] Statystyki gracza %s \n \n", sItem);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa nożem: %d\n", sItem, iKnifeKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa pistoletami: %d\n", sItem, iPistolKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa bronia szturmowa: %d\n", sItem, iRifleKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa shotgunami: %d\n", sItem, iShotgunKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa z PM: %d\n", sItem, iSmgKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa AWP: %d\n", sItem, iAwpKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa bronią ciężką: %d\n", sItem, iMgKills);
	Format(sItem, sizeof(sItem), "%s➫ Zabójstwa granatami: %d\n \n", sItem, iNadeKills);
	Format(sItem, sizeof(sItem), "%s\n➫ Czas na serwerze: ", sItem);
	
	if(SecondsToDays(iTime) > 0)
		Format(sItem, sizeof(sItem), "%s%d dni ", sItem, SecondsToDays(iTime));
	
	if(SecondsToHours(RestOfDays(iTime)) > 0)
		Format(sItem, sizeof(sItem), "%s%d godzin(y) ", sItem, SecondsToHours(RestOfDays(iTime)));
	
	Format(sItem, sizeof(sItem), "%s%d minut(y)\n", sItem, SecondsToMinutes(RestOfHours(RestOfDays(iTime))));
	Format(sItem, sizeof(sItem), "%s➫ Pierwsze połączenie: %s\n", sItem, sJoinDate);
	Format(sItem, sizeof(sItem), "%s➫ Liczba połączeń: %d \n \n", sItem, iConnections);
	menu.AddItem("", sItem);
	
	menu.AddItem("back", "Wróć!");
	menu.AddItem("-SID-", authid);
	
	menu.ExitButton = true;
	menu.Display(client, 0);
}

public void DB_TopCallback(Handle owner, Handle hndl, const char[] error, DataPack info_pack)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[TOP] Query failed! %s", error);
		return;
	}
	
	info_pack.Reset(); // Get some info !
	int client = info_pack.ReadCell();
	
	if(client == 0 || !IsClientInGame(client))
		return;
	
	delete info_pack;
	
	int i;
	
	Menu menu = new	Menu(TOP_Handler, MENU_ACTIONS_ALL);
	menu.SetTitle("[#TOP] Nick - Ranga - Fragi");
	
	char menu_item[256];
	char sAuth[64];
	
	while(SQL_FetchRow(hndl))
	{
		i++;
		SQL_FetchString(hndl, 0, menu_item, sizeof(menu_item));
		SQL_FetchString(hndl, 3, sAuth, sizeof(sAuth));
		
		Format(menu_item, sizeof(menu_item), "#%d - %s - %s - [%d]", i, menu_item, g_sRanksNames[SQL_FetchInt(hndl, 2)], SQL_FetchInt(hndl, 1));
		menu.AddItem(sAuth, menu_item);
	}
	
	if(i == 0)
		menu.AddItem("no_records", "Wygląda na to, że ranking jest czysty.");
	
	menu.ExitButton = true;
	menu.Display(client, 0);
}

public DB_SaveInfoCallback(Handle owner, Handle query, const char[] error, any data)
{
	if(query == INVALID_HANDLE)
	{
		LogError("[NOX-RANKS] Failed to save client info (error: %s)", error);
		return;
	}
}

public Action _______________________________________________________(){}
public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	float fOrigin[3];
	float iOrigin[3];
	
	char sWeapon[32];
	GetClientWeapon(client, sWeapon, 32);
	if(g_iBadgesValue[client][Badge_Healing] == 4 && StrEqual(sWeapon, "weapon_knife"))
	{
		int target = GetClientAimTarget(client);
		GetClientEyePosition(client, fOrigin);
		if(IsValidClient(target) && IsPlayerAlive(target))
		{
			if(GetClientTeam(client) == GetClientTeam(target))
			{
				GetClientEyePosition(target, iOrigin);
				if(GetClientButtons(client) & IN_USE && GetVectorDistance(fOrigin, iOrigin) <= 200.0 && g_bCanHeal[client]) 
				{
					int Health = GetEntData(target, FindDataMapInfo(target, "m_iHealth"), 4);
					int MaxHealth = GetEntData(target, FindDataMapInfo(target, "m_iMaxHealth"), 4);
					int iMedic = g_iBadgesValue[client][Badge_Healing]*10;
					
					if(g_iBadgesValue[client][Badge_Healing] == 1)
						iMedic += 5;
					
					if(Health < MaxHealth)
					{
						if((Health + iMedic) > MaxHealth)
							iMedic = MaxHealth;
						else
							iMedic += Health;		
						SetEntData(target, FindDataMapInfo(target, "m_iHealth"), iMedic, 4, true);
					}
					
					PrintToChat(target, "%s \x04Zostałeś uleczony przez \x02%N\x04!", PREFIX_NORMAL, client);
					PrintToChat(client, "%s \x04Uleczyłeś \x02%N\x04!", PREFIX_NORMAL, target);
					g_bCanHeal[client] = false;
				}
			}
		}
	}
	
	if(g_iBadgesValue[client][Badge_Universal] == 4 && StrEqual(sWeapon, "weapon_knife"))
	{
		int fCurFlags = GetEntityFlags(client);
		int fCurButtons = GetClientButtons(client);
		
		if (g_iLastFlags[client] & FL_ONGROUND)
		{
			if (!(fCurFlags & FL_ONGROUND) && !(g_iLastButtons[client] & IN_JUMP) && fCurButtons & IN_JUMP)
				g_iJumps[client]++;
		}
		else if (fCurFlags & FL_ONGROUND)
			g_iJumps[client] = 0;
		else if (!(g_iLastButtons[client] & IN_JUMP) && fCurButtons & IN_JUMP)
			if (1 <= g_iJumps[client] <= 1)
			{
				g_iJumps[client]++;
				float fVel[3];
				GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVel);
				fVel[2] = 300.0; 
				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fVel);
			}
			
		g_iLastFlags[client]	= fCurFlags;
		g_iLastButtons[client]	= fCurButtons;
	}	
}

public Action FootstepCheck(clients[64], &numClients, char sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags)
{
	if(!IsValidClient(entity) || IsFakeClient(entity))
		return Plugin_Continue;

	if((StrContains(sample, "physics") != -1 || StrContains(sample, "footsteps") != -1) && StrContains(sample, "suit") == -1)
	{
		if(g_iBadgesValue[entity][Badge_Universal] <= 3)
			EmitSoundToAll(sample, entity);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public Action SDK_TakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
	if(!IsValidClient(attacker))
		return Plugin_Continue;
	
	if(attacker == victim)
		return Plugin_Continue;
	
	if(GetClientTeam(attacker) == GetClientTeam(victim))
		return Plugin_Continue;
	
	bool bAward = false;
	
	char sWeapon[32];
	GetEdictClassname(GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"), sWeapon, sizeof(sWeapon));
	
	char sInflictor[32];
	GetEdictClassname(inflictor, sInflictor, sizeof(sInflictor));
	
	g_fGivenDmg[attacker] += damage;
	g_fObtainedDmg[victim] += damage;
	
	// ============== Badge_Pyrotechnic ==============
	switch(g_iBadgesValue[attacker][Badge_Pyrotechnic])
	{	
		case 0:
		{
			if(g_fGivenDmg[attacker] >= 100000.0)
			{
				g_iBadgesValue[attacker][Badge_Pyrotechnic] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_fGivenDmg[attacker] >= 200000.0)
			{
				g_iBadgesValue[attacker][Badge_Pyrotechnic] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_fGivenDmg[attacker] >= 300000.0)
			{
				g_iBadgesValue[attacker][Badge_Pyrotechnic] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_fGivenDmg[attacker] >= 500000.0)
			{
				g_iBadgesValue[attacker][Badge_Pyrotechnic] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(attacker, " ==============================================");
		PrintToChat(attacker, " %s \x06Zdobyłeś odznakę za \x03Walkę Pirotechnika\x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[attacker][Badge_Pyrotechnic]);
		PrintToChat(attacker, " ==============================================");
		
		EmitSoundToClientAny(attacker, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Badge_Insurgent ==============
	switch(g_iBadgesValue[victim][Badge_Insurgent])
	{	
		case 0:
		{
			if(g_fObtainedDmg[victim] >= 50000.0)
			{
				g_iBadgesValue[victim][Badge_Insurgent] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_fObtainedDmg[victim] >= 100000.0)
			{
				g_iBadgesValue[victim][Badge_Insurgent] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_fObtainedDmg[victim] >= 150000.0)
			{
				g_iBadgesValue[victim][Badge_Insurgent] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_fObtainedDmg[victim] >= 200000.0)
			{
				g_iBadgesValue[victim][Badge_Insurgent] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(victim, " ==============================================");
		PrintToChat(victim, " %s \x06Zdobyłeś odznakę za \x03Walkę Powstańca\x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[victim][Badge_Insurgent]);
		PrintToChat(victim, " ==============================================");
		
		EmitSoundToClientAny(victim, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	if(!g_bAchievement[attacker][Achievement_DMG] && g_fGivenDmg[attacker] >= 75000.0)
	{
		PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Chodzacy Magazynier \x04!", PREFIX_NORMAL, attacker);
		g_bAchievement[attacker][Achievement_DMG] = true;
	}
	
	// dmg and others
	if(StrEqual(sWeapon, "weapon_knife"))
	{
		int Health = GetEntData(attacker, FindDataMapInfo(attacker, "m_iHealth"), 4);
		int MaxHealth = GetEntData(attacker, FindDataMapInfo(attacker, "m_iMaxHealth"), 4);
		int iMedic = 0;
		
		if(g_iBadgesValue[attacker][Badge_Knife] == 1)
			iMedic = RoundToZero(damage * 0.2);
		else if(g_iBadgesValue[attacker][Badge_Knife] == 2)                                      
			iMedic = RoundToZero(damage * 0.4);
		else if(g_iBadgesValue[attacker][Badge_Knife] == 3)                                      
			iMedic = RoundToZero(damage * 0.6);
		else if(g_iBadgesValue[attacker][Badge_Knife] == 4)                                      
			iMedic = RoundToZero(damage * 0.8);
		
		if(Health < MaxHealth)
		{
			if((Health + iMedic) > MaxHealth)
				iMedic = MaxHealth;
			else
				iMedic += Health;		
			SetEntData(attacker, FindDataMapInfo(attacker, "m_iHealth"), iMedic, 4, true);
		}
	}
	else if(StrEqual(sWeapon, "weapon_awp"))
	{
		if(g_iBadgesValue[attacker][Badge_Sniper] == 1)
			damage*=1.1;
		else if(g_iBadgesValue[attacker][Badge_MG] == 2)
			damage*=1.2;
		else if(g_iBadgesValue[attacker][Badge_MG] == 3)
			damage*=1.3;
		else if(g_iBadgesValue[attacker][Badge_MG] == 4)
			damage*=1.4;
	}
	else if(StrContains(sWeapon, "mp7") != -1 || StrContains(sWeapon, "mp9") != -1
			|| StrContains(sWeapon, "p90") != -1 || StrContains(sWeapon, "bizon") != -1
			|| StrContains(sWeapon, "ump45") != -1 || StrContains(sWeapon, "mac10") != -1)
	{
		if(g_iBadgesValue[attacker][Badge_Slowmo])
		{
			int iChance;
			switch(g_iBadgesValue[attacker][Badge_Slowmo])
			{
				case 1: iChance = 17;
				case 2: iChance = 20
				case 3: iChance = 25;
				case 4: iChance = 33;
			}
			
			if(ChancePicked(iChance))
				FreezePlayer(victim);
		}
	}
	else if(StrContains(sWeapon, "sawedoff") != -1 || StrContains(sWeapon, "xm1014") != -1
				|| StrContains(sWeapon, "mag7") != -1 || StrContains(sWeapon, "nova") != -1)
	{
		if(g_iBadgesValue[attacker][Badge_Highlight])
		{
			int iChance;
			switch(g_iBadgesValue[attacker][Badge_Highlight])
			{
				case 1: iChance = 17;
				case 2: iChance = 20
				case 3: iChance = 25;
				case 4: iChance = 33;
			}
			
			if(ChancePicked(iChance))
				ExposePlayer(victim);
		}
	}
	
	if(g_iBadgesValue[attacker][Badge_MG] >= 1)
	{
		damage *= 1.0+(g_iBadgesValue[attacker][Badge_MG]*0.04);
	}
	
	if(StrContains(sInflictor, "he") != -1)
	{
		damage *= 1.0+(g_iBadgesValue[attacker][Badge_Nade]*0.1);
	}
	
	if(g_iBadgesValue[victim][Badge_Medal] >= 1)
	{
		damage *= 1.0 - (g_iBadgesValue[attacker][victim]*0.04);
	}
	
	return Plugin_Changed;
}

public Action SDK_OnMineTouch(int ent, int victim)
{
	if(!IsValidEntity(ent))
		return;
	
	if(GetEntProp(victim, Prop_Data, "m_nSolidType") && !(GetEntProp(victim, Prop_Data, "m_usSolidFlags") & 0x0004))
	{
		int client = GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity");
		if(IsValidClient(client))
		{
			if(IsValidClient(victim) && GetClientTeam(client) != GetClientTeam(victim))
			{
				float forigin[3];
				float iorigin[3];
				GetEntPropVector(ent, Prop_Send, "m_vecOrigin", forigin);

				LoopClients(i)
				{
					if(GetClientTeam(i) == GetClientTeam(client))
						continue;

					GetClientEyePosition(i, iorigin);
					if(GetVectorDistance(forigin, iorigin) <= 250.0)
						SDKHooks_TakeDamage(i, client, client, float(g_iBadgesValue[client][Badge_Pyrotechnic]*20), DMG_GENERIC);
					
					if((g_iBadgesValue[client][Badge_Pyrotechnic]*20) > GetClientHealth(i))
					{
						bool bAward = false;
						
						g_iMineKills[client]++;
						g_iMineDeaths[i]++;
						
						// ============== Badge_Mine ==============
						switch(g_iBadgesValue[client][Badge_Mine])
						{	
							case 0:
							{
								if(g_iMineKills[client] >= 50)
								{
									g_iBadgesValue[client][Badge_Mine] = 1;
									bAward = true;
								}
							}
							
							case 1:
							{
								if(g_iMineKills[client] >= 100)
								{
									g_iBadgesValue[client][Badge_Mine] = 2;
									bAward = true;
								}
							}
							
							case 2:
							{
								if(g_iMineKills[client] >= 150)
								{
									g_iBadgesValue[client][Badge_Mine] = 3;
									bAward = true;
								}
							}
							
							case 3:
							{
								if(g_iMineKills[client] >= 200)
								{
									g_iBadgesValue[client][Badge_Mine] = 4;
									bAward = true;
								}
							}
						}
						
						if(bAward)
						{
							PrintToChat(client, " ==============================================");
							PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę minami \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Mine]);
							PrintToChat(client, " ==============================================");
							
							EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
						}
						
						if(!g_bAchievement[client][Achievement_MineKills] && g_iMineKills[client] >= 100)
						{
							PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Saper \x04!", PREFIX_NORMAL, client);
							g_bAchievement[client][Achievement_MineKills] = true;
						}
						
						if(!g_bAchievement[i][Achievement_MineDeaths] && g_iMineDeaths[i] >= 200)
						{
							PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Nieudacznik \x04!", PREFIX_NORMAL, i);
							g_bAchievement[i][Achievement_MineDeaths] = true;
						}
					}
				}

				EmitSoundToAll("weapons/hegrenade/explode5.wav", ent, 1, 90);
				TE_SetupExplosion(forigin, g_iSpriteBlue, 10.0, 1, 0, 100, 100);
				TE_SendToAll();

				AcceptEntityInput(ent, "Kill");
				SDKUnhook(ent, SDKHook_StartTouchPost, SDK_OnMineTouch);
			}
		}
		else
		{
			AcceptEntityInput(ent, "Kill");
			SDKUnhook(ent, SDKHook_StartTouchPost, SDK_OnMineTouch);
		}
	}
}

public Action SDK_OnPackageTouch(int ent, int other)
{
	if(!IsValidEntity(ent))
		return;
	
	if(GetEntProp(other, Prop_Data, "m_nSolidType") && !(GetEntProp(other, Prop_Data, "m_usSolidFlags") & 0x0004))
	{
		int client = GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity");
		if(IsValidClient(client))
		{
			if(client == other)
			{
				bool bAward = false;
				g_iRaisedPackets[client]++;
				
				switch(GetRandomInt(0, 2))
				{
					case 0: { // hp
						int Health = GetEntData(client, FindDataMapInfo(client, "m_iHealth"), 4);
						int MaxHealth = GetEntData(client, FindDataMapInfo(client, "m_iMaxHealth"), 4);
						int iMedic = GetRandomInt(5, 15);
						
						PrintToChat(client, " %s \x06Znalazłeś \x04%d hp\x06!", PREFIX_NORMAL, iMedic);
						
						if(Health < MaxHealth)
						{
							if((Health + iMedic) > MaxHealth)
								iMedic = MaxHealth;
							else
								iMedic += Health;		
							SetEntData(client, FindDataMapInfo(client, "m_iHealth"), iMedic, 4, true);
						}
					}
					case 1: { // grenade
						switch(GetRandomInt(0,3))
						{
							case 0:{
								if(CanGiveGrenade(client, weapon_hegrenade))
								{
									GivePlayerItem(client, "weapon_hegrenade");
									PrintToChat(client, " %s \x06Znalazłeś \x04Granat zaczepny\x06!", PREFIX_NORMAL);
								}
							}
							case 1:{
								if(CanGiveGrenade(client, weapon_smokegrenade))
								{
									GivePlayerItem(client, "weapon_smokegrenade");
									PrintToChat(client, " %s \x06Znalazłeś \x04Smoke\x06!", PREFIX_NORMAL);
								}
							}
							case 2:{
								if(CanGiveGrenade(client, weapon_flashbang))
								{
									GivePlayerItem(client, "weapon_flashbang");
									PrintToChat(client, " %s \x06Znalazłeś \x04Flesh'a\x06!", PREFIX_NORMAL);
								}
							}
							case 3:{
								if(CanGiveGrenade(client, weapon_molotov))
								{
									GivePlayerItem(client, "weapon_molotov");
									PrintToChat(client, " %s \x06Znalazłeś \x04Molotova\x06!", PREFIX_NORMAL);
								}
							}
						}
					}
					case 2: { // armor
						int iArmor = GetRandomInt(5, 15);
						SetEntProp(client, Prop_Send, "m_ArmorValue", GetEntProp(client, Prop_Send, "m_ArmorValue") + iArmor);
						PrintToChat(client, " %s \x06Znalazłeś \x04%d pancerza\x06!", PREFIX_NORMAL, iArmor);
					}
				}
				
				
				// ============== Badge_Healing ==============
				switch(g_iBadgesValue[client][Badge_Healing])
				{	
					case 0:
					{
						if(g_iRaisedPackets[client] >= 250)
						{
							g_iBadgesValue[client][Badge_Healing] = 1;
							bAward = true;
						}
					}
					
					case 1:
					{
						if(g_iRaisedPackets[client] >= 500)
						{
							g_iBadgesValue[client][Badge_Healing] = 2;
							bAward = true;
						}
					}
					
					case 2:
					{
						if(g_iRaisedPackets[client] >= 750)
						{
							g_iBadgesValue[client][Badge_Healing] = 3;
							bAward = true;
						}
					}
					
					case 3:
					{
						if(g_iRaisedPackets[client] >= 1000)
						{
							g_iBadgesValue[client][Badge_Healing] = 4;
							bAward = true;
						}
					}
				}
				
				if(bAward)
				{
					PrintToChat(client, " ==============================================");
					PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na Zbieranie \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Healing]);
					PrintToChat(client, " ==============================================");
					
					EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
				}
				
				if(!g_bAchievement[client][Achievement_Pockets] && g_iRaisedPackets[client] >= 500)
				{
					PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Padlinożerca \x04!", PREFIX_NORMAL, client);
					g_bAchievement[client][Achievement_Pockets] = true;
				}
				
				AcceptEntityInput(ent, "Kill");
				SDKUnhook(ent, SDKHook_StartTouchPost, SDK_OnPackageTouch);
			}
		}
		else
		{
			AcceptEntityInput(ent, "Kill");
			SDKUnhook(ent, SDKHook_StartTouchPost, SDK_OnPackageTouch);
		}
	}
}

public void Event_WinPanel(Handle event, const char[] Player_Name, bool dontBroadcast)
{
	int BestFrags[3] = {0,0,0}; // 0 - 1 miejsce / 1 - 2 miejsce / 2 - 3 miejsce
	int BestID[3] = {0,0,0}; 	// 0 - 1 miejsce / 1 - 2 miejsce / 2 - 3 miejsce
	
	LoopClients(i)
	{
		int frags = GetClientFrags(i);
		if(frags > BestFrags[0])// 1 pos
		{
			BestFrags[2] = BestFrags[1];
			BestID[2] 	 = BestID[1];
			BestFrags[1] = BestFrags[0];
			BestID[1]	 = BestID[0];
			BestFrags[0] = frags;
			BestID[0]	 = i;
		}
		else if(frags >= BestFrags[1])// 2 pos
		{
			BestFrags[2] = BestFrags[1];
			BestID[2]	 = BestID[1];
			BestFrags[1] = frags;
			BestID[1]	 = i;
		}
		else if(frags >= BestFrags[2])// 3 pos
		{
			BestFrags[2] = frags;
			BestID[2]	 = i;
		}
	}
	
	if(BestID[0] > 0 && BestFrags[0] > 0)
	{
		g_iGoldMedals[BestID[0]]++;
		GiveExp(BestID[0], 30);
		DB_SaveInfo(BestID[0]);
		PrintToChatAll(" %s \x04Najlepsi gracze mapy:", PREFIX_NORMAL);
		PrintToChatAll(" %s \x04#1 - \x10Złoty Medal\x04 - \x0C%N \x04- \x0E%d \x04- \x06%d", PREFIX_NORMAL, BestID[0], BestFrags[0], 30);
	}
	if(BestID[1] > 0 && BestFrags[1] > 0)
	{
		g_iSilverMedals[BestID[1]]++;
		GiveExp(BestID[1], 20);
		DB_SaveInfo(BestID[1]);
		PrintToChatAll(" %s \x04#2 - \x0DSrebrny Medal\x04 - \x0C%N \x04- \x0E%d \x04- \x06%d", PREFIX_NORMAL, BestID[1], BestFrags[1], 20);
	}
	if(BestID[2] > 0 && BestFrags[2] > 0) 
	{
		g_iBrownMedals[BestID[2]]++;                           
		GiveExp(BestID[2], 10);
		DB_SaveInfo(BestID[2]);
		PrintToChatAll(" %s \x04#3 - \x09Brązowy Medal\x04 - \x0C%N \x04- \x0E%d \x04- \x06%d", PREFIX_NORMAL, BestID[2], BestFrags[2], 10);
	}
	
	LoopClients(i)
	{
		if(!g_bAchievement[i][Achievement_Medals] && g_iBrownMedals[i]+g_iSilverMedals[i]+g_iGoldMedals[i] >= 100)
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Wzorowa Slużba \x04!", PREFIX_NORMAL, i);
			g_bAchievement[i][Achievement_Medals] = true;
		}
	}
	g_iRound = 0;
}

public void Event_RestartRound(Handle event, const char[] Player_Name, bool dontBroadcast)
{
	g_iRound = 0;
}

public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	LoopClients(i)
		SetEntProp(i, Prop_Send, "m_iAccount", GetEntProp(i, Prop_Send, "m_iAccount")+g_iBadgesValue[i][Badge_Pistol]*200);
}

public Action Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	int winner = GetEventInt(event, "winner");
	LoopClients(i)
	{
		if(GetClientTeam(i) == winner)
			g_iMoneyTotal[i] += 3500;
		else
			g_iMoneyTotal[i] += 2000;
			
		if(IsPlayerAlive(i))
		{
			g_iRounds[i]++;
			if(!g_bAchievement[i][Achievement_Rounds] && g_iRounds[i] >= 2500)
			{
				PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Niezniszczalny\x04!", PREFIX_NORMAL, i);
				g_bAchievement[i][Achievement_Rounds] = true;
			}
		}
		
		g_iRoundKnifeKills[i] = 0;
		g_iRoundPistolKills[i] = 0;
		g_iRoundAwpKills[i] = 0;
		g_iRoundMgKills[i] = 0;
		g_iRoundRifleKills[i] = 0;
		g_iRoundShotgunKills[i] = 0;
		g_iRoundSmgKills[i] = 0;
		g_bMineExists[i] = false;
		g_bHealthPackUsed[i] = false;
		
		DB_SaveInfo(i);
	}
	g_iRound++;
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	bool bHead = GetEventBool(event, "headshot");
	bool bDrop = false;
	
	if(!attacker)
		return;

	if(attacker == victim)
		return;
	
	if(!IsValidClient(attacker))
		return;
	
	if(GameRules_GetProp("m_bWarmupPeriod") != 1)
	{
		if(g_iBadgesValue[attacker][Badge_Mixed] == 1)
		{
			if(!GetRandomInt(0,3))
				bDrop = true;
		}
		else if(g_iBadgesValue[attacker][Badge_Mixed] == 2)
		{
			if(!GetRandomInt(0,2))
				bDrop = true;
		}
		else if(g_iBadgesValue[attacker][Badge_Mixed] == 3)
		{
			if(!GetRandomInt(0,1))
				bDrop = true;
		}
		else if(g_iBadgesValue[attacker][Badge_Mixed] == 4)
			bDrop = true;
	
		if(bDrop)
		{
			int ent = CreateEntityByName("hegrenade_projectile");
			if(ent != -1)
			{
				float iorigin[3];
				float iangles[3];
				float ivector[3];
				
				float forigin[3];
				GetClientEyePosition(victim, forigin);
			
				float fangles[3];
				GetClientEyeAngles(victim, fangles);
			
				TR_TraceRayFilter(forigin, fangles, MASK_SOLID, RayType_Infinite, TraceRayFilter, ent);
				TR_GetEndPosition(iorigin);
				
				DispatchSpawn(ent);
				ActivateEntity(ent);
				
				SetEntityModel(ent, PACKAGE_MDL);
				SetEntityMoveType(ent, MOVETYPE_STEP);
				
				MakeVectorFromPoints(forigin, iorigin, ivector);
				NormalizeVector(ivector, ivector);
				ScaleVector(ivector, 1000.0);
				GetVectorAngles(ivector, iangles);
				TeleportEntity(ent, forigin, NULL_VECTOR, NULL_VECTOR);
				
				SetEntProp(ent, Prop_Send, "m_usSolidFlags", 12);
				SetEntProp(ent, Prop_Data, "m_nSolidType", 6);
				SetEntProp(ent, Prop_Send, "m_CollisionGroup", 1);
				SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", attacker);
				
				SDKHook(ent, SDKHook_StartTouchPost, SDK_OnPackageTouch);
			}
		}
		
		g_iFrags[attacker]++;
		g_iDeaths[victim]++;
		
		if(bHead)
			g_iHeadshots[attacker]++;
		
		GiveExp(attacker, 10);
		
		char sWeapon[32];
		//GetEntPropString(GetEntPropEnt(attacker, Prop_Data, "m_hActiveWeapon"), Prop_Data, "m_iClassname", sWeapon, sizeof(sWeapon));
		GetEventString(event, "weapon", sWeapon, sizeof(sWeapon));
		
		if(StrContains(sWeapon, "hegrenade") != -1)
		{
			g_iNadeKills[attacker]++;
			g_iMoneyTotal[attacker] += 300;
		}
		else if(StrContains(sWeapon, "knife") != -1 || StrContains(sWeapon, "bayonet") != -1)
		{
			g_iMoneyTotal[attacker] += 1500;
			g_iKnifeKills[attacker]++;
			g_iRoundKnifeKills[attacker]++;
		}
		else if(StrContains(sWeapon, "glock") != -1 || StrContains(sWeapon, "usp_silencer") != -1
				|| StrContains(sWeapon, "deagle") != -1 || StrContains(sWeapon, "tec9") != -1
				|| StrContains(sWeapon, "p250") != -1 || StrContains(sWeapon, "hkp2000") != -1
				|| StrContains(sWeapon, "fiveseven") != -1 || StrContains(sWeapon, "elite") != -1
				|| StrContains(sWeapon, "cz75a") != -1 || StrContains(sWeapon, "revolver") != -1)
		{
			g_iMoneyTotal[attacker] += 300;
			g_iPistolKills[attacker]++;
			g_iRoundPistolKills[attacker]++;
		}
		else if(StrContains(sWeapon, "awp") != -1)
		{
			g_iMoneyTotal[attacker] += 100;
			g_iAwpKills[attacker]++;
			g_iRoundAwpKills[attacker]++;
		}
		else if(StrContains(sWeapon, "negev") != -1 || StrContains(sWeapon, "m249") != -1)
		{
			g_iMoneyTotal[attacker] += 300;
			g_iMgKills[attacker]++;
			g_iRoundMgKills[attacker]++;
		}
		else if(StrContains(sWeapon, "m4a1") != -1 || StrContains(sWeapon, "ak47") != -1
				|| StrContains(sWeapon, "sg556") != -1 || StrContains(sWeapon, "aug") != -1
				|| StrContains(sWeapon, "galilar") != -1 || StrContains(sWeapon, "famas") != -1)
		{
			g_iMoneyTotal[attacker] += 300;
			g_iRifleKills[attacker]++;
			g_iRoundRifleKills[attacker]++;
		}
		else if(StrContains(sWeapon, "sawedoff") != -1 || StrContains(sWeapon, "xm1014") != -1
				|| StrContains(sWeapon, "mag7") != -1 || StrContains(sWeapon, "nova") != -1)
		{
			g_iMoneyTotal[attacker] += 900;
			g_iShotgunKills[attacker]++;
			g_iRoundShotgunKills[attacker]++;
		}
		else if(StrContains(sWeapon, "mp7") != -1 || StrContains(sWeapon, "mp9") != -1
				|| StrContains(sWeapon, "p90") != -1 || StrContains(sWeapon, "bizon") != -1
				|| StrContains(sWeapon, "ump45") != -1 || StrContains(sWeapon, "mac10") != -1)
		{
			g_iMoneyTotal[attacker] += 600;
			g_iSmgKills[attacker]++;
			g_iRoundSmgKills[attacker]++;
		}
		
		CheckBadges(attacker);
		
		// Check for Achievements
		if(!g_bAchievement[attacker][Achievement_Nade] && g_iNadeKills[attacker] >= 250) // 250 nade kills
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Gorąca sprawa \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_Nade] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_AWP] && g_iAwpKills[attacker] >= 500) // 500 awp kills
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Cicha Przemoc \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_AWP] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_Kills] && g_iFrags[attacker] >= 10000) // 10000 FRAGS
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Szybki i Zabójczy \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_Kills] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_Deaths] && g_iDeaths[attacker] >= 2500) // 2500 FRAGS
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Najwyższa Ofiara \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_Deaths] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_Mktd] && (g_iFrags[attacker] - g_iDeaths[attacker]) >= 10000) // 10000 mktd
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Królewska gra \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_Mktd] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_KDR] && (float(g_iFrags[attacker])/float(g_iDeaths[attacker])) >= 3.0) // kdr 3.0
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Polowanie \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_KDR] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_Heads] && g_iHeadshots[attacker] >= 5000) // 5000 hs
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Celne Strzały \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_Heads] = true;
		}
		
		if(!g_bAchievement[attacker][Achievement_Heads] && g_iHeadshots[attacker] >= 5000) // 5000 hs
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Celne Strzały \x04!", PREFIX_NORMAL, attacker);
			g_bAchievement[attacker][Achievement_Heads] = true;
		}
		
		if(g_iBadgesValue[victim][Badge_Internship])
		{
			if(ChancePicked(g_iBadgesValue[victim][Badge_Internship]*4))
				CreateTimer(0.01, Timer_Respawn, victim, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action Event_PlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(!IsValidClient(client))
		return;
	
	if(GameRules_GetProp("m_bWarmupPeriod") != 1)
		CreateTimer(0.1, Timer_Spawn, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Event_BombExplode(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(!IsValidClient(client))
		return;
	
	g_iBombs[client]++;
	if(!g_bAchievement[client][Achievement_Bombs] && g_iBombs[client] >= 50)
	{
		PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Aż do Klikniecia\x04!", PREFIX_NORMAL, client);
		g_bAchievement[client][Achievement_Bombs] = true;
	}
}

public Action ______________________________________________________(){}
public Action OnChatMessage(int &author, Handle recipients, char[] name, char[] message)
{
	if(IsValidClient(author))
	{
		int MaxMessageLength = MAXLENGTH_MESSAGE - strlen(name) - 5;
		Format(name, MaxMessageLength, "%s \x06[%s]", name, g_sRanksNames[g_iRank[author]]);
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public Action CMD_Autobuy(int client, int args)
{
	CMD_Grade(client, 0);
}

public Action CMD_Grade(int client, int args)
{
	char sTitle[128];
	int iBadges = 0;
	float fPercent = (float(g_iExp[client])/float(g_iRankTable[g_iRank[client]]))*100.0;
	
	LoopBadges(i)
		iBadges += g_iBadgesValue[client][i];
	
	if(g_iRank[client] == sizeof(g_iRankTable)-1)
		Format(sTitle, sizeof(sTitle), "BF4 Rank by n.o.x\n \n* Osiagnales maksymalny stopień.\n* Ranga: [%s]\n* Odznaki: [%d/100]\n \n", g_sRanksNames[g_iRank[client]], iBadges);
	else
		Format(sTitle, sizeof(sTitle), "BF4 Rank by n.o.x\n \n* Ranga: [%s] \n* Postęp: %d/%d [%0.f%s]\n* Odznaki: [%d/100]\n \n", g_sRanksNames[g_iRank[client]], g_iExp[client], g_iRankTable[g_iRank[client]], fPercent, "%%", iBadges);
	
	Menu menu = new Menu(MainMenu_Handler, MENU_ACTIONS_ALL);
	menu.SetTitle(sTitle);
	menu.AddItem("Item_1", "➫ Twoje odznaki");
	menu.AddItem("Item_2", "➫ Twoje osiągnięcia");
	menu.AddItem("Item_3", "➫ Twoje statystyki");
	menu.AddItem("Item_4", "➫ Ranking serwera");
	menu.ExitButton = true;
	menu.Display(client, 300);
	return Plugin_Handled;
}

public Action CMD_Badges(int client, int args)
{
	char sLink[256];
	GetClientAuthId(client, AuthId_Steam2, sLink, sizeof(sLink));
	Format(sLink, sizeof(sLink), "http://noxsp.pl/popups.php?web=%sbadges.php?auth_id=%s", WEBDOCS_URL, sLink);
	ShowMotd(client, "badges_desc", sLink);
	#if defined DEBUG
		PrintToServer(sLink);
	#endif
	return Plugin_Handled;
}

public Action CMD_Shop(int client, int args)
{
	CreateMenu_Shop(client);
	return Plugin_Handled;
}

public Action CMD_Rank(int client, int args)
{
	char query[256];
	
	DataPack info_pack = new DataPack();
	info_pack.WriteCell(client); // client
	
	Format(query,sizeof(query), "SELECT auth_data FROM bf4_players WHERE exp > 0 ORDER BY exp DESC");
	SQL_TQuery(g_hSql, DB_RankCallback, query, info_pack);
	return Plugin_Handled;
}

public Action CMD_RankMe(int client, int args)
{
	char authid[64];
	GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
	CreateMenu_ClientStats(client, authid);
	return Plugin_Handled;
}

public Action CMD_Weapons(int client, int args)
{
	char sItem[32];
	Menu menu = new Menu(WeaponsMenu_Handler, MENU_ACTIONS_ALL);
	menu.SetTitle("BF4 :: Preferencje broni");
	switch(g_iAllowAWP[client])
	{
		case 0: Format(sItem, sizeof(sItem), "➫ AWP [OFF]");
		case 1: Format(sItem, sizeof(sItem), "➫ AWP [ON - Jeśli brak]");
		case 2: Format(sItem, sizeof(sItem), "➫ AWP [ON - Podmiana]");
	}
	menu.AddItem("Item_1", sItem);
	if(g_bDeagleReplace[client])
		Format(sItem, sizeof(sItem), "➫ Deagle [ON - Podmiana]");
	else
		Format(sItem, sizeof(sItem), "➫ Deagle [OFF]");
	menu.AddItem("Item_2", sItem);
	menu.ExitButton = true;
	menu.Display(client, 300);
	return Plugin_Handled;
}

public Action CMD_Top(int client, int args)
{
	char query[256];
	
	DataPack info_pack = new DataPack();
	info_pack.WriteCell(client); // client
	
	Format(query,sizeof(query), "SELECT name, frags, rank, auth_data FROM bf4_players WHERE exp > 0 ORDER BY exp DESC");
	SQL_TQuery(g_hSql, DB_TopCallback, query, info_pack);
	return Plugin_Handled;
}

public Action CMD_Explode(int client, int args)
{
	if(!g_iBadgesValue[client][Badge_Badges])
	{
		PrintToChat	(client, "%s \x06Nie możesz się wysadzić, nie posiadasz odznaki za odznaczenia.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	else if(!IsPlayerAlive(client))
	{
		PrintToChat	(client, "%s \x06Nie możesz się wysadzić będąc martwym.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	
	float fDistance = (g_iBadgesValue[client][Badge_Badges]*50.0) + 50.0;
	float fOrigin[3], iOrigin[3];
	GetClientEyePosition(client, fOrigin);
	
	LoopClients(i)
	{
		if(GetClientTeam(client) == GetClientTeam(i))
			continue;
	
		GetClientEyePosition(i, iOrigin);
		
		if(GetVectorDistance(fOrigin, iOrigin) <= fDistance)
			SDKHooks_TakeDamage(i, client, client, 150.0);
	}
	
	SDKHooks_TakeDamage(client, client, client, 300.0);
	
	TE_SetupExplosion(fOrigin, g_iSpriteBlue, 10.0, 1, 0, 300, 300);
	TE_SendToAll();
	return Plugin_Handled;
}

public Action CMD_Mine(int client, int args)
{
	if(!g_iBadgesValue[client][Badge_Pyrotechnic])
	{
		PrintToChat(client, "%s \x06Nie możesz podłożyć miny, nie posiadasz odznaki piromana.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	else if(!IsPlayerAlive(client))
	{
		PrintToChat(client, "%s \x06Nie możesz podłożyć miny będąc martwym.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	else if(g_bMineExists[client])
	{
		PrintToChat(client, "%s \x06Nie możesz podłożyć więcej min.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	
	int ent = CreateEntityByName("hegrenade_projectile");
	if(ent != -1)
	{
		float iorigin[3];
		float iangles[3];
		float ivector[3];
		
		float forigin[3];
		GetClientEyePosition(client, forigin);
	
		float fangles[3];
		GetClientEyeAngles(client, fangles);
	
		TR_TraceRayFilter(forigin, fangles, MASK_SOLID, RayType_Infinite, TraceRayFilter, ent);
		TR_GetEndPosition(iorigin);
		
		DispatchSpawn(ent);
		ActivateEntity(ent);
		
		SetEntityModel(ent, MINE_MDL);
		SetEntityMoveType(ent, MOVETYPE_STEP);
		
		MakeVectorFromPoints(forigin, iorigin, ivector);
		NormalizeVector(ivector, ivector);
		ScaleVector(ivector, 1000.0);
		GetVectorAngles(ivector, iangles);
		TeleportEntity(ent, forigin, NULL_VECTOR, NULL_VECTOR);
		
		SetEntProp(ent, Prop_Send, "m_usSolidFlags", 12);
		SetEntProp(ent, Prop_Data, "m_nSolidType", 6);
		SetEntProp(ent, Prop_Send, "m_CollisionGroup", 1);
		SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", client);
		
		SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
		if(g_iBadgesValue[client][Badge_Mine] == 1)
			SetEntityRenderColor(ent, 255, 255, 255, 89);
		else if(g_iBadgesValue[client][Badge_Mine] == 2)
			SetEntityRenderColor(ent, 255, 255, 255, 76);
		else if(g_iBadgesValue[client][Badge_Mine] == 3)
			SetEntityRenderColor(ent, 255, 255, 255, 63);
		else if(g_iBadgesValue[client][Badge_Mine] == 4)
			SetEntityRenderColor(ent, 255, 255, 255, 51);
		else
			SetEntityRenderColor(ent, 255, 255, 255, 255);
		
		SDKHook(ent, SDKHook_StartTouchPost, SDK_OnMineTouch);
		g_bMineExists[client] = true;
	}
	
	return Plugin_Handled;
}

public Action CMD_HealthPack(int client, int args)
{
	if(!g_iBadgesValue[client][Badge_Insurgent])
	{
		PrintToChat(client, "%s \x06Nie możesz użyć apteczki, nie posiadasz odznaki powstańca.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	else if(!IsPlayerAlive(client))
	{
		PrintToChat(client, "%s \x06Nie możesz użyć apteczki będąc martwym.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	else if(g_bHealthPackUsed[client])
	{
		PrintToChat(client, "%s \x06Nie możesz użyć apteczki więcej razy.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	
	int Health = GetEntData(client, FindDataMapInfo(client, "m_iHealth"), 4);
	int MaxHealth = GetEntData(client, FindDataMapInfo(client, "m_iMaxHealth"), 4);
	int iMedic = g_iBadgesValue[client][Badge_Insurgent]*15; 
	
	if(Health < MaxHealth)
	{
		if((Health + iMedic) > MaxHealth)
			iMedic = MaxHealth;
		else
			iMedic += Health;	
		
		g_bHealthPackUsed[client] = true;
		PrintToChat(client, "%s \x04Uleczyłeś się.", PREFIX_NORMAL);
		SetEntData(client, FindDataMapInfo(client, "m_iHealth"), iMedic, 4, true);
	}
	else
	{
		PrintToChat(client, "%s \x06Masz pełne hp.", PREFIX_ERROR);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action _____________________________________________________(){}
public void CreateMenu_Shop(int client)
{
	Menu menu = new Menu(ShopMenu_Handler, MENU_ACTIONS_ALL);
	menu.SetTitle("BF4 Shop by n.o.x :: Aktualnie masz [%d Diamentów]\n \n", g_iDiamonds[client]);
	
	menu.AddItem("Item_1", "Losowy Exp [50-250] - [15 Diamentów]");
	menu.AddItem("Item_2", "Podwójny Exp [Na mape] - [100 Diamentów]");
	menu.AddItem("Item_3", "Losowa odznaka [I Stopnia] - [1000 Diamentów]");
	menu.AddItem("Item_4", "Losowa odznaka [II Stopnia] - [2000 Diamentów]");
	menu.AddItem("Item_5", "Losowa odznaka [III Stopnia] - [3000 Diamentów]");
	menu.AddItem("Item_6", "Losowa odznaka [IV Stopnia] - [4000 Diamentów]");
	
	menu.ExitButton = true;
	menu.Display(client, 300);
}

public void CreateMenu_ClientStats(int client, const char[] sAuth)
{
	char sQuery[1024];
	
	DataPack info_pack = new DataPack();
	info_pack.WriteCell(client);
	info_pack.WriteString(sAuth);
	
	Format(sQuery,sizeof(sQuery), "SELECT auth_data, name, frags, rank, deaths, gold_medals, silver_medals, brown_medals, badge_knife, badge_pistol, badge_rifle, badge_shotgun, badge_smg, badge_awp, badge_mg, badge_nade, badge_kdr, badge_global, badge_insurgent, badge_pyrotechnic, badge_medal, badge_internship, badge_achievements, badge_badges, badge_mine, badge_universal, badge_mixed, badge_time, badge_healing, badge_slowmo, badge_highlight, badge_deaths, badge_connections, achievement_nade, achievement_kdr, achievement_deaths, achievement_kills, achievement_bombs, achievement_diamonds, achievement_money, achievement_mktd, achievement_minekills, achievement_minedeaths, achievement_packages, achievement_time, achievement_medals, achievement_awp, achievement_heads, achievement_dmg, achievement_badges, achievement_invisiblity, achievement_rounds, achievement_connections FROM bf4_players WHERE exp > 0 ORDER BY exp DESC");
	PrintToServer(sQuery);
	SQL_TQuery(g_hSql, DB_RankMeCallback, sQuery, info_pack);
}

public void CreateMenu_DetailedStats(int client, const char[] sAuth)
{
	char query[256];
	
	DataPack info_pack = new DataPack();
	info_pack.WriteCell(client);
	info_pack.WriteString(sAuth);
	
	Format(query,sizeof(query), "SELECT name, join_date, connections, server_time, knife_kills, pistol_kills, rifle_kills, shotgun_kills, smg_kills, awp_kills, mg_kills, nade_kills FROM bf4_players WHERE auth_data = '%s'", sAuth);
	PrintToServer(query);
	SQL_TQuery(g_hSql, DB_RankMe_DetailsCallback, query, info_pack);
}

public Action ____________________________________________________(){}
public int MainMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char Item[32];
			menu.GetItem(param2, Item, sizeof(Item));
			
			if(StrEqual(Item, "Item_1"))
			{
				char sLink[256];
				GetClientAuthId(param1, AuthId_Steam2, sLink, sizeof(sLink));
				Format(sLink, sizeof(sLink), "http://noxsp.pl/popups.php?web=%sbadges.php?auth_id=%s", WEBDOCS_URL, sLink);
				ShowMotd(param1, "badges_desc", sLink);
			}
			else if(StrEqual(Item, "Item_2"))
			{
				char sLink[256];
				GetClientAuthId(param1, AuthId_Steam2, sLink, sizeof(sLink));
				Format(sLink, sizeof(sLink), "http://noxsp.pl/popups.php?web=%sachievements.php?auth_id=%s", WEBDOCS_URL, sLink);
				ShowMotd(param1, "achievements_desc", sLink);
			}
			else if(StrEqual(Item, "Item_3"))
			{
				char authid[64];
				GetClientAuthId(param1, AuthId_Steam2, authid, sizeof(authid));
				CreateMenu_ClientStats(param1, authid);
			}
			else if(StrEqual(Item, "Item_4"))
				CMD_Top(param1, 0);
		}
		case MenuAction_End: delete menu;
		case MenuAction_Cancel:
		{
			if(param2 == MenuCancel_ExitBack)
				CMD_Rank(param1, 0);
		}
		case MenuAction_DrawItem:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			if(StrEqual(info, "ITEMDRAW_DISABLED"))
				return ITEMDRAW_DISABLED;
		}
	}
	return 0;
}

public int ShopMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char Item[32];
			menu.GetItem(param2, Item, sizeof(Item));
			
			if(StrEqual(Item, "Item_1"))
			{
				if(g_iDiamonds[param1] >= 10)
				{
					int iExp = GetRandomInt(50, 250);
					g_iDiamonds[param1] -= 15;
					PrintToChat(param1, "%s \x04Kupiłeś \x02%d \x04exp'a!", PREFIX_NORMAL, iExp);
					GiveExp(param1, iExp);
				}
				else
					PrintToChat(param1, "%s \x06Nie posiadasz wystarczającej ilości diamentów!", PREFIX_ERROR);
			}
			else if(StrEqual(Item, "Item_2"))
			{
				if(g_iDiamonds[param1] >= 100)
				{
					g_iDiamonds[param1] -= 100;
					PrintToChat(param1, "%s \x04Kupiłeś \x02Double Exp \x04do końca mapy!", PREFIX_NORMAL);
					g_bDoubleExp[param1] = true;
				}
				else
					PrintToChat(param1, "%s \x06Nie posiadasz wystarczającej ilości diamentów!", PREFIX_ERROR);
			}
			else if(StrEqual(Item, "Item_3"))
			{
				if(g_iDiamonds[param1] >= 1000)
				{
					int iBadge = GiveRandomBadge(param1, 1);
					if(iBadge != -1)
					{
						g_iDiamonds[param1] -= 1000;
						PrintToChat(param1, "%s \x04Kupiłeś odznakę \x02%s \x04!", PREFIX_NORMAL, g_sRanksNames[iBadge]);
					}
					else
						PrintToChat(param1, "%s \x06Nie możesz kupić odznaki na tym poziomie.", PREFIX_ERROR);
				}
				else
					PrintToChat(param1, "%s \x06Nie posiadasz wystarczającej ilości diamentów!", PREFIX_ERROR);
			}
			else if(StrEqual(Item, "Item_4"))
			{
				if(g_iDiamonds[param1] >= 2000)
				{
					int iBadge = GiveRandomBadge(param1, 2);
					if(iBadge != -1)
					{
						g_iDiamonds[param1] -= 2000;
						PrintToChat(param1, "%s \x04Kupiłeś odznakę \x02%s \x04!", PREFIX_NORMAL, g_sRanksNames[iBadge]);
					}
					else
						PrintToChat(param1, "%s \x06Nie możesz kupić odznaki na tym poziomie.", PREFIX_ERROR);
				}
				else
					PrintToChat(param1, "%s \x06Nie posiadasz wystarczającej ilości diamentów!", PREFIX_ERROR);
			}
			else if(StrEqual(Item, "Item_5"))
			{
				if(g_iDiamonds[param1] >= 3000)
				{
					int iBadge = GiveRandomBadge(param1, 3);
					if(iBadge != -1)
					{
						g_iDiamonds[param1] -= 3000;
						PrintToChat(param1, "%s \x04Kupiłeś odznakę \x02%s\x04!", PREFIX_NORMAL, g_sRanksNames[iBadge]);
					}
					else
						PrintToChat(param1, "%s \x06Nie możesz kupić odznaki na tym poziomie.", PREFIX_ERROR);
				}
				else
					PrintToChat(param1, "%s \x06Nie posiadasz wystarczającej ilości diamentów!", PREFIX_ERROR);
			}
			else if(StrEqual(Item, "Item_6"))
			{
				if(g_iDiamonds[param1] >= 4000)
				{
					int iBadge = GiveRandomBadge(param1, 4);
					if(iBadge != -1)
					{
						g_iDiamonds[param1] -= 4000;
						PrintToChat(param1, "%s \x04Kupiłeś odznakę \x02%s\x04!", PREFIX_NORMAL, g_sRanksNames[iBadge]);
					}
					else
						PrintToChat(param1, "%s \x06Nie możesz kupić odznaki na tym poziomie.", PREFIX_ERROR);
				}
				else
					PrintToChat(param1, "%s \x06Nie posiadasz wystarczającej ilości diamentów!", PREFIX_ERROR);
			}
		}
		case MenuAction_End: delete menu;
		case MenuAction_DrawItem:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			if(StrEqual(info, "-SID-"))
				return ITEMDRAW_IGNORE; 
		}
	}
	return 0;
}

public int Rankme_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	char Info[64], Dane[64];
	char sAuth[64];
	LoopItemCount(i)
	{
		menu.GetItem(i, Info, sizeof(Info), _, Dane, sizeof(Dane));
		if(StrEqual(Info, "-SID-"))
			sAuth = Dane;
	}
	switch(action)
	{
		case MenuAction_Select:
		{
			char Item[32];
			menu.GetItem(param2, Item, sizeof(Item));
			if(StrEqual(Item, "next"))
				CreateMenu_DetailedStats(param1, sAuth);
			else if(StrEqual(Item, "back"))
				CreateMenu_ClientStats(param1, sAuth);
		}
		case MenuAction_End: delete menu;
		case MenuAction_DrawItem:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			if(StrEqual(info, "-SID-"))
				return ITEMDRAW_IGNORE; 
		}
	}
	return 0;
}

public int TOP_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32];
			menu.GetItem(param2, sItem, sizeof(sItem));
			
			CreateMenu_ClientStats(param1, sItem);
		}
		case MenuAction_End: delete menu;
	}
	return 0;
}

public int WeaponsMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32];
			menu.GetItem(param2, sItem, sizeof(sItem));
			
			if(StrEqual(sItem, "Item_1")) // awp
			{
				char sType[32];
				if(g_iAllowAWP[param1] < 2)
					g_iAllowAWP[param1]++;
				else
					g_iAllowAWP[param1] = 0;
				
				switch(g_iAllowAWP[param1]) // show info
				{
					case 0: Format(sType, sizeof(sType), "Wyłączono \x06dostawanie");
					case 1: Format(sType, sizeof(sType), "Włączono \x06dostawanie");
					case 2: Format(sType, sizeof(sType), "Włączono \x06podmiane");
				}
				PrintToChat(param1, " %s \x03%s AWP na początku rundy !", PREFIX_NORMAL, sType);
			}
			else if(StrEqual(sItem, "Item_2")) // deagle
			{
				g_bDeagleReplace[param1] = !g_bDeagleReplace[param1];
				PrintToChat(param1, " %s \x03%s \x06podmiane Deagle na początku rundy !", PREFIX_NORMAL, g_bDeagleReplace?"Włączono":"Wyłączono");
			}
			CMD_Weapons(param1, 0);
		}
		case MenuAction_End: delete menu;
	}
	return 0;
}

public Action ___________________________________________________(){}
public Action Timer_UpdateHud(Handle timer, any client)
{
	char sText[128];
	
	SetHudTextParams(HUD_OX, HUD_OY, 1.0 + 0.1, 149, 95, 32, 255, 2, 0.0, 0.0, 0.0);
	
	LoopClients(i)
	{
		int iBadges = 0, iAchievements = 0;
		float fPercent = (float(g_iExp[i])/float(g_iRankTable[g_iRank[i]]))*100.0;
		
		// We need to count player time
		g_iTime[i]++;
		
		if(!g_bAchievement[i][Achievement_Time] && g_iTime[i] >= 15000*60)
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Wielki Gong \x04!", PREFIX_NORMAL, i);
			g_bAchievement[i][Achievement_Time] = true;
		}
		
		LoopBadges(j)
			iBadges += g_iBadgesValue[i][j];
		
		LoopAchievements(j)
			iAchievements += GetIntValue(g_bAchievement[i][j]);
			
		Format(sText, sizeof(sText), "[BF4] %s [%0.f%s] | Odznaki: [%d/100] | Osiągnięcia: [%d/20]", g_sRanksNames[g_iRank[i]], fPercent, "%%", iBadges, iAchievements);
		ShowHudText(i, -1, sText);
	}
}

public Action Timer_ChangeRender(Handle timer, any client)
{
	if(IsValidClient(client))
	{
		if(IsPlayerAlive(client))
		{
			if(g_iExposed[client] > 0)
			{
				int r = GetRandomInt(1, 255);
				int g = GetRandomInt(1, 255);
				int b = GetRandomInt(1, 255);
				
				SetEntityRenderMode(client, RENDER_TRANSCOLOR);
				SetEntityRenderColor(client, r, g, b, 255);
				g_iExposed[client]--;
			}
			else
			{
				GiveBaseInvisiblity(client);
				return Plugin_Stop;
			}
		}
		else
			return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_CheckClient(Handle timer, any client)
{
	if(IsValidClient(client) && GetClientTeam(client) > 0)
	{
		if(!g_bAchievement[client][Achievement_Connections] && g_iConnections[client] >= 200) // 5000 hs
		{
			PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Bywalec \x04!", PREFIX_NORMAL, client);
			g_bAchievement[client][Achievement_Connections] = true;
		}
		
		bool bAward = false;
	
		switch(g_iBadgesValue[client][Badge_Connections])
		{	
			case 0:
			{
				if(g_iConnections[client] == 75)
				{
					g_iBadgesValue[client][Badge_Connections] = 1;
					bAward = true;
				}
			}
			
			case 1:
			{
				if(g_iConnections[client] == 150)
				{
					g_iBadgesValue[client][Badge_Connections] = 2;
					bAward = true;
				}
			}
			
			case 2:
			{
				if(g_iConnections[client] >= 225)
				{
					g_iBadgesValue[client][Badge_Connections] = 3;
					bAward = true;
				}
			}
			
			case 3:
			{
				if(g_iConnections[client] >= 300)
				{
					g_iBadgesValue[client][Badge_Connections] = 4;
					bAward = true;
				}
			}
		}
		
		if(bAward)
		{
			PrintToChat(client, " ==============================================");
			PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Połaczenia\x06, stopień \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Connections]);
			PrintToChat(client, " ==============================================");
			
			EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
			bAward = false;
		}
		
		if(GetTime() > g_iDrLast[client]+86400)
		{
			// Give bonus
			if(g_iDrDay[client] != 4)
				GiveExp(client, EXP_DAILY*(g_iDrDay[client]+1)); // first day
			else
				GiveDiamonds(client, 15); //5th day
			
			// Some info
			char sLink[128];
			Format(sLink, sizeof(sLink), "http://noxsp.pl/popups.php?web=%sdailyrewards.php?day=%d", WEBDOCS_URL, g_iDrDay[client]+1);
			ShowMotd(client, "dr_motd", sLink);
			PrintToChat(client, "%s \x04Zdobyłeś \x02%d \x04%s za pobyt na serwerze, wróć jutro po \x02większy bonus\x04!", PREFIX_NORMAL, g_iDrDay[client] == 4?15:150*(g_iDrDay[client]+1), g_iDrDay[client] == 4?"diamentów":"exp");
			
			// Set next daily
			if(g_iDrDay[client] == 4) // if this day will be 7th -- back to start!
				g_iDrDay[client] = 0;
			else 
				g_iDrDay[client]++;
			
			g_iDrLast[client] = GetTime();
			DB_SaveInfo(client);
		}
	}
	else
		CreateTimer(2.0, Timer_CheckClient, client);
}

public Action Timer_ShowMotd(Handle timer, DataPack info_pack)
{
	info_pack.Reset(); // Get some info !
	int client = info_pack.ReadCell();
	if(IsValidClient(client))
	{
		char sInfo[32]; info_pack.ReadString(sInfo, sizeof(sInfo));
		char sLink[256]; info_pack.ReadString(sLink, sizeof(sLink));
		ShowMOTDPanel(client, sInfo, sLink, MOTDPANEL_TYPE_URL);
	}
}

public Action Timer_UnFreezePlayer(Handle timer, any client)
{
	float fSpeed = 1.0;
	if(g_iBadgesValue[client][Badge_PM] == 1)
		fSpeed = 1.05;
	else if(g_iBadgesValue[client][Badge_PM] == 2)
		fSpeed = 1.1;
	else if(g_iBadgesValue[client][Badge_PM] == 3)
		fSpeed = 1.15;
	else if(g_iBadgesValue[client][Badge_PM] == 4)
		fSpeed = 1.2;
	
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", fSpeed);
	
	GiveBaseInvisiblity(client);
}

public Action Timer_Spawn(Handle timer, any client)
{
	float fSpeed = 1.0;
	int iHealth = g_iBadgesValue[client][Badge_Universal] >= 1?105:100 + (g_iBadgesValue[client][Badge_Rifles]*10);
	int h_mPrimary = GetPlayerWeaponSlot(client, 0);
	int h_mSecondary = GetPlayerWeaponSlot(client, 1); // pistol
	
	// hp [Rifle Badge]
	SetEntData(client, FindDataMapInfo(client, "m_iMaxHealth"), iHealth , 4, true);
	SetEntData(client, FindDataMapInfo(client, "m_iHealth"), iHealth, 4, true);
	
	// speed [PM Badge]
	if(g_iBadgesValue[client][Badge_PM] == 1)
		fSpeed = 1.05;
	else if(g_iBadgesValue[client][Badge_PM] == 2)
		fSpeed = 1.1;
	else if(g_iBadgesValue[client][Badge_PM] == 3)
		fSpeed = 1.15;
	else if(g_iBadgesValue[client][Badge_PM] == 4)
		fSpeed = 1.2;
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", fSpeed);
	
	// AWP [Sniper Badge]
	if(g_iRound > 2 && g_iAllowAWP[client] && (!IsValidEntity(h_mPrimary) || g_iAllowAWP[client] == 2))
	{
		if(g_iBadgesValue[client][Badge_Sniper] == 1)
		{
			if(!GetRandomInt(0,3))
			{
				StripWeapon(client, h_mPrimary);
				GivePlayerItem(client, "weapon_awp");
			}
		}
		else if(g_iBadgesValue[client][Badge_Sniper] == 2)
		{
			if(!GetRandomInt(0,2))
			{
				StripWeapon(client, h_mPrimary);
				GivePlayerItem(client, "weapon_awp");
			}
		}
		else if(g_iBadgesValue[client][Badge_Sniper] == 3)
		{
			if(!GetRandomInt(0,1))
			{
				StripWeapon(client, h_mPrimary);
				GivePlayerItem(client, "weapon_awp");
			}
		}
		else if(g_iBadgesValue[client][Badge_Sniper] == 4)
		{
			StripWeapon(client, h_mPrimary);
			GivePlayerItem(client, "weapon_awp");
		}
	}
	
	// Deagle Replace
	if(g_bDeagleReplace[client])
	{
		if(g_iBadgesValue[client][Badge_Achievements] == 1)
		{
			if(!GetRandomInt(0,3))
			{
				StripWeapon(client, h_mSecondary);
				GivePlayerItem(client, "weapon_deagle");
			}
		}
		else if(g_iBadgesValue[client][Badge_Achievements] == 2)
		{
			if(!GetRandomInt(0,2))
			{
				StripWeapon(client, h_mSecondary);
				GivePlayerItem(client, "weapon_deagle");
			}
		}
		else if(g_iBadgesValue[client][Badge_Achievements] == 3)
		{
			if(!GetRandomInt(0,1))
			{
				StripWeapon(client, h_mSecondary);
				GivePlayerItem(client, "weapon_deagle");
			}
		}
		else if(g_iBadgesValue[client][Badge_Achievements] == 4)
		{
			StripWeapon(client, h_mSecondary);
			GivePlayerItem(client, "weapon_deagle");
		}
	}
	
	// Grenade [Nade Badge]
	if(CanGiveGrenade(client, weapon_hegrenade))
	{
		if(g_iBadgesValue[client][Badge_Nade] == 1)
		{
			if(!GetRandomInt(0,3))
				GivePlayerItem(client, "weapon_hegrenade");
		}
		else if(g_iBadgesValue[client][Badge_Nade] == 2)
		{
			if(!GetRandomInt(0,2))
				GivePlayerItem(client, "weapon_hegrenade");
		}
		else if(g_iBadgesValue[client][Badge_Nade] == 3)
		{
			if(!GetRandomInt(0,1))
				GivePlayerItem(client, "weapon_hegrenade");
		}
		else if(g_iBadgesValue[client][Badge_Nade] == 4)
			GivePlayerItem(client, "weapon_hegrenade");
		
		if(g_iBadgesValue[client][Badge_Badges] == 2)
			GivePlayerItem(client, "weapon_flashbang");
	}
	
	// Invisiblity
	GiveBaseInvisiblity(client);
	
	// Helmet
	if(g_iBadgesValue[client][Badge_Deaths])
	{
		int iChance;
		switch(g_iBadgesValue[client][Badge_Deaths])
		{
			case 1: iChance = 17;
			case 2: iChance = 20
			case 3: iChance = 25;
			case 4: iChance = 33;
		}
		
		if(ChancePicked(iChance))
			SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);
	}
	
	if(g_iBadgesValue[client][Badge_Connections])
	{
		int iChance;
		switch(g_iBadgesValue[client][Badge_Connections])
		{
			case 1: iChance = 17;
			case 2: iChance = 20
			case 3: iChance = 25;
			case 4: iChance = 33;
		}
		
		if(ChancePicked(iChance))
		{
			if(GetClientTeam(client) == CS_TEAM_CT)
				SetEntityModel(client, sPlayerMdls[GetRandomInt(6, 10)]);
			else if(GetClientTeam(client) == CS_TEAM_T)
				SetEntityModel(client, sPlayerMdls[GetRandomInt(1, 5)]);
		}
	}
	
	// prevent invisible arms
	SetEntPropString(client, Prop_Send, "m_szArmsModel", "");
	SetEntPropString(client, Prop_Send, "m_szArmsModel", sArms[GetClientTeam(client) == CS_TEAM_T?0:1]);
}

public Action Timer_Respawn(Handle timer, any client)
{
	if(IsValidClient(client))
	{
		CS_RespawnPlayer(client);
		PrintToChat	(client, "%s \x06Odrodziłeś się.", PREFIX_NORMAL);
	}
}

public Action _________________________________________________(){}
public Native_GetExp(Handle plugin, int numParams)
{
	return g_iExp[GetNativeCell(1)];
}

public Native_SetExp(Handle plugin, int numParams)
{
	g_iExp[GetNativeCell(1)] == GetNativeCell(2);
	CheckRank(GetNativeCell(1));
}

public Native_GiveExp(Handle plugin, int numParams)
{
	GiveExp(GetNativeCell(1), GetNativeCell(2));
}

public Action ________________________________________________(){}
void CheckRank(int client)
{	
	bool bLvlUP = false;
	bool bLvlDown = false;
	
	if(!IsClientConnected(client))
		return;
	
	while(g_iExp[client] >= g_iRankTable[g_iRank[client]] && g_iRank[client] < sizeof(g_iRankTable)-1) // Promotion
	{
		g_iRank[client]++;
		bLvlUP = true;
	}
	
	if(g_iRank[client] > 0)
	{
		while(g_iExp[client] < g_iRankTable[g_iRank[client]-1]) // Spadek
		{
			g_iRank[client]--;
			bLvlDown = true;
		}
	}
	
	if(bLvlUP)
	{
		PrintToChat(client, " ==============================================");
		if(g_iRank[client] == sizeof(g_iRankTable)-1)
			PrintToChat(client, " %s \x07Osiagnales maksymalny stopień. Twoja ranga to : %s.", PREFIX_NORMAL, g_sRanksNames[g_iRank[client]]);
		else
			PrintToChat(client, " %s \x06Awansowales do rangi \x03%s\x06 !", PREFIX_NORMAL, g_sRanksNames[g_iRank[client]]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/promotion.mp3"); // Emit Sound
		
		Call_StartForward(g_ForwardRankUp);
		Call_PushCell(client);
		Call_PushCell(g_iRank[client]);
		Call_Finish();
	}
	
	if(bLvlDown)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Spadłeś do rangi \x03%s", PREFIX_NORMAL, g_sRanksNames[g_iRank[client]]);
		PrintToChat(client, " ==============================================");
		
		Call_StartForward(g_ForwardRankDown);
		Call_PushCell(client);
		Call_PushCell(g_iRank[client]);
		Call_Finish();
	}
}

void CheckBadges(int client)
{
	bool bAward = false;
	float fKDR = float(g_iFrags[client])/float(g_iDeaths[client]);
	int iBadges = 0, iAchievements = 0, iMedals = g_iBrownMedals[client]+g_iSilverMedals[client]+g_iGoldMedals[client];
	
	LoopBadges(i)
		iBadges += g_iBadgesValue[client][i];
		
	LoopAchievements(i)
		iAchievements += GetIntValue(g_bAchievement[client][i]);
	
	// ============== Badge_KDR ==============
	switch(g_iBadgesValue[client][Badge_KDR])
	{	
		case 0:
		{
			if(g_iFrags[client] >= 500 && fKDR >= 1.25)
			{
				g_iBadgesValue[client][Badge_KDR] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iFrags[client] >= 1000 && fKDR >= 1.5)
			{
				g_iBadgesValue[client][Badge_KDR] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iFrags[client] >= 1500 && fKDR >= 1.75)
			{
				g_iBadgesValue[client][Badge_KDR] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iFrags[client] >= 2000 && fKDR >= 2.0)
			{
				g_iBadgesValue[client][Badge_KDR] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na KDR \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_KDR]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Badge_Global ==============
	switch(g_iBadgesValue[client][Badge_Global])
	{	
		case 0:
		{
			if(g_iFrags[client] >= 500)
			{
				g_iBadgesValue[client][Badge_Global] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iFrags[client] >= 1000)
			{
				g_iBadgesValue[client][Badge_Global] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iFrags[client] >= 1500)
			{
				g_iBadgesValue[client][Badge_Global] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iFrags[client] >= 2000)
			{
				g_iBadgesValue[client][Badge_Global] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę Ogólną \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Global]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Mixed Badge ==============
	switch(g_iBadgesValue[client][Badge_Mixed])
	{	
		case 0:
		{
			if(g_iFrags[client] >= 1000 && g_iRoundMgKills[client] >= 1)
			{
				g_iBadgesValue[client][Badge_Mixed] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iFrags[client] >= 2000 && g_iRoundSmgKills[client] >= 1)
			{
				g_iBadgesValue[client][Badge_Mixed] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iFrags[client] >= 3000 && g_iRoundShotgunKills[client] >= 1)
			{
				g_iBadgesValue[client][Badge_Mixed] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iFrags[client] >= 4000 && g_iRoundKnifeKills[client] >= 1)
			{
				g_iBadgesValue[client][Badge_Mixed] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę Mieszaną \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Mixed]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Time Badge ==============
	switch(g_iBadgesValue[client][Badge_Time])
	{	
		case 0:
		{
			if(g_iFrags[client] >= 2500 && g_iTime[client] >= 2500*60)
			{
				g_iBadgesValue[client][Badge_Time] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iFrags[client] >= 5000 && g_iTime[client] >= 5000*60)
			{
				g_iBadgesValue[client][Badge_Time] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iFrags[client] >= 7500 && g_iTime[client] >= 7500*60)
			{
				g_iBadgesValue[client][Badge_Time] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iFrags[client] >= 10000 && g_iTime[client] >= 10000*60)
			{
				g_iBadgesValue[client][Badge_Time] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na Czas \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Time]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Badge_Internship ==============
	switch(g_iBadgesValue[client][Badge_Internship])
	{	
		case 0:
		{
			if(g_iTime[client] >= 7200*60)
			{
				g_iBadgesValue[client][Badge_Internship] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iTime[client] >= 14400*60)
			{
				g_iBadgesValue[client][Badge_Internship] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iTime[client] >= 21600*60)
			{
				g_iBadgesValue[client][Badge_Internship] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iTime[client] >= 28800*60)
			{
				g_iBadgesValue[client][Badge_Internship] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na Staż \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Internship]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Deaths Badge ==============
	switch(g_iBadgesValue[client][Badge_Deaths])
	{	
		case 0:
		{
			if(g_iDeaths[client] >= 250)
			{
				g_iBadgesValue[client][Badge_Deaths] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iDeaths[client] >= 500)
			{
				g_iBadgesValue[client][Badge_Deaths] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iDeaths[client] >= 750)
			{
				g_iBadgesValue[client][Badge_Deaths] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iDeaths[client] >= 1000)
			{
				g_iBadgesValue[client][Badge_Deaths] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03zgony \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Deaths]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Knife Badge ==============
	switch(g_iBadgesValue[client][Badge_Knife])
	{	
		case 0:
		{
			if(g_iKnifeKills[client] >= 50 && g_iRoundKnifeKills[client] >= 1)
			{
				g_iBadgesValue[client][Badge_Knife] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iKnifeKills[client] >= 100 && g_iRoundKnifeKills[client] >= 2)
			{
				g_iBadgesValue[client][Badge_Knife] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iKnifeKills[client] >= 150 && g_iRoundKnifeKills[client] >= 3)
			{
				g_iBadgesValue[client][Badge_Knife] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iKnifeKills[client] >= 200 && g_iRoundKnifeKills[client] >= 3)
			{
				g_iBadgesValue[client][Badge_Knife] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę nożem \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Knife]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Pistol Badge ==============
	switch(g_iBadgesValue[client][Badge_Pistol])
	{	
		case 0:
		{
			if(g_iPistolKills[client] >= 50 && g_iRoundPistolKills[client] >= 2)
			{
				g_iBadgesValue[client][Badge_Pistol] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iPistolKills[client] >= 100 && g_iRoundPistolKills[client] >= 3)
			{
				g_iBadgesValue[client][Badge_Pistol] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iPistolKills[client] >= 200 && g_iRoundPistolKills[client] >= 4)
			{
				g_iBadgesValue[client][Badge_Pistol] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iPistolKills[client] >= 300 && g_iRoundPistolKills[client] >= 4)
			{
				g_iBadgesValue[client][Badge_Pistol] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę pistoletami \x06 na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Pistol]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Rifles Badge ==============
	switch(g_iBadgesValue[client][Badge_Rifles])
	{	
		case 0:
		{
			if(g_iRifleKills[client] >= 1000 && g_iRoundRifleKills[client] >= 3)
			{
				g_iBadgesValue[client][Badge_Rifles] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iRifleKills[client] >= 2000 && g_iRoundRifleKills[client] >= 4)
			{
				g_iBadgesValue[client][Badge_Rifles] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iRifleKills[client] >= 3000 && g_iRoundRifleKills[client] >= 5)
			{
				g_iBadgesValue[client][Badge_Rifles] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iRifleKills[client] >= 5000 && g_iRoundRifleKills[client] >= 5)
			{
				g_iBadgesValue[client][Badge_Rifles] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę bronią szturmową \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Rifles]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Shothun Badge ==============
	switch(g_iBadgesValue[client][Badge_Shotgun])
	{	
		case 0:
		{
			if(g_iShotgunKills[client] >= 50 && g_iRoundShotgunKills[client] >= 2) // 3 kills in one round
			{
				g_iBadgesValue[client][Badge_Shotgun] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iShotgunKills[client] >= 100 && g_iRoundShotgunKills[client] >= 3) // 100 shotgun kills
			{
				g_iBadgesValue[client][Badge_Shotgun] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iShotgunKills[client] >= 200 && g_iRoundShotgunKills[client] >= 4) // 200 frags, 4 frags in one round
			{
				g_iBadgesValue[client][Badge_Shotgun] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iShotgunKills[client] >= 300 && g_iRoundShotgunKills[client] >= 4) // 300 frags, 4 frags in one round
			{
				g_iBadgesValue[client][Badge_Shotgun] = 4;
				
				PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Incognito \x04!", PREFIX_NORMAL, client);
				g_bAchievement[client][Achievement_Invisiblity] = true;
				
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę shotgunami \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Shotgun]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== PM Badge ==============
	switch(g_iBadgesValue[client][Badge_PM])
	{	
		case 0:
		{
			if(g_iSmgKills[client] >= 50 && g_iRoundSmgKills[client] >= 2) // 2 kills in one round
			{
				g_iBadgesValue[client][Badge_PM] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iSmgKills[client] >= 100 && g_iRoundSmgKills[client] >= 3) // 100 pm kills
			{
				g_iBadgesValue[client][Badge_PM] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iSmgKills[client] >= 200 && g_iRoundSmgKills[client] >= 4) // 200 frags, 4 frags and 1 heads in one round
			{
				g_iBadgesValue[client][Badge_PM] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iSmgKills[client] >= 300 && g_iRoundSmgKills[client] >= 4) // 300 frags, 4 frags and 1 heads in one round
			{
				g_iBadgesValue[client][Badge_PM] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę PM \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_PM]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Sniper Badge ==============
	switch(g_iBadgesValue[client][Badge_Sniper])
	{	
		case 0:
		{
			if(g_iAwpKills[client] >= 50 && g_iRoundAwpKills[client] >= 2) // 50 awp frags, 2 kills in one round
			{
				g_iBadgesValue[client][Badge_Sniper] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iAwpKills[client] >= 100 && g_iRoundAwpKills[client] >= 3) // 100 awp kills, 3 frags 
			{
				g_iBadgesValue[client][Badge_Sniper] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iAwpKills[client] >= 200 && g_iRoundAwpKills[client] >= 4) // 200 frags, 4 frags 
			{
				g_iBadgesValue[client][Badge_Sniper] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iAwpKills[client] >= 300 && g_iRoundAwpKills[client] >= 4) // 300 frags, 4 frags
			{
				g_iBadgesValue[client][Badge_Sniper] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę AWP \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Sniper]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== MG Badge ==============
	switch(g_iBadgesValue[client][Badge_MG])
	{	
		case 0:
		{
			if(g_iMgKills[client] >= 50 && g_iRoundMgKills[client] >= 2) // 2 kills in one round
			{
				g_iBadgesValue[client][Badge_MG] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iMgKills[client] >= 100 && g_iRoundMgKills[client] >= 3) // 100 mg kills
			{
				g_iBadgesValue[client][Badge_MG] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iMgKills[client] >= 200 && g_iRoundMgKills[client] >= 4) // 200 frags, 4 frags and 1 heads in one round
			{
				g_iBadgesValue[client][Badge_MG] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iMgKills[client] >= 300 && g_iRoundMgKills[client] >= 4) // 300 frags, 6 frags and 3 heads in one round
			{
				g_iBadgesValue[client][Badge_MG] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę bronia wsparcia \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_MG]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Nade Badge ==============
	switch(g_iBadgesValue[client][Badge_Nade])
	{	
		case 0:
		{
			if(g_iNadeKills[client] >= 50) // 50 kills
			{
				g_iBadgesValue[client][Badge_Nade] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iNadeKills[client] >= 100) // 100 kills
			{
				g_iBadgesValue[client][Badge_Nade] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iNadeKills[client] >= 150) // 150 kills
			{
				g_iBadgesValue[client][Badge_Nade] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iNadeKills[client] >= 200) // 200 kills
			{
				g_iBadgesValue[client][Badge_Nade] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę bronia wsparcia \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Nade]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Highlight Badge ==============
	switch(g_iBadgesValue[client][Badge_Highlight])
	{	
		case 0:
		{
			if(g_iShotgunKills[client] >= 150 && g_iBadgesValue[client][Badge_Shotgun] >= 1) // 100 kills, 1 kill in round, Badge_Shotgun lvl 1
			{
				g_iBadgesValue[client][Badge_Highlight] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iShotgunKills[client] >= 300 && g_iRoundShotgunKills[client] >= 2 && g_iBadgesValue[client][Badge_Shotgun] >= 2) // 100 kills, 2 frags in round, Badge_Shotgun lvl 2
			{
				g_iBadgesValue[client][Badge_Highlight] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iShotgunKills[client] >= 450 && g_iRoundShotgunKills[client] >= 2 && g_iBadgesValue[client][Badge_Shotgun] >= 3) // 200 kills, 2 frags in round, Badge_Shotgun lvl 3
			{
				g_iBadgesValue[client][Badge_Highlight] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iShotgunKills[client] >= 600 && g_iRoundShotgunKills[client] >= 3 && g_iBadgesValue[client][Badge_Shotgun] >= 4) // 300 kills, 3 frags in round, Badge_Shotgun lvl 4
			{
				g_iBadgesValue[client][Badge_Highlight] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę na podświetlenia \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Highlight]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== SlowMo Badge ==============
	switch(g_iBadgesValue[client][Badge_Slowmo])
	{	
		case 0:
		{
			if(g_iSmgKills[client] >= 150 && g_iBadgesValue[client][Badge_PM] >= 1) // 100 kills, 1 kill in round, Badge_PM lvl 1
			{
				g_iBadgesValue[client][Badge_Slowmo] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iSmgKills[client] >= 300 && g_iRoundSmgKills[client] >= 2 && g_iBadgesValue[client][Badge_PM] >= 2) // 100 kills, 2 frags in round, Badge_PM lvl 2
			{
				g_iBadgesValue[client][Badge_Slowmo] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iSmgKills[client] >= 450 && g_iRoundSmgKills[client] >= 2 && g_iBadgesValue[client][Badge_PM] >= 3) // 200 kills, 2 frags in round, Badge_PM lvl 3
			{
				g_iBadgesValue[client][Badge_Slowmo] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iSmgKills[client] >= 600 && g_iRoundSmgKills[client] >= 3 && g_iBadgesValue[client][Badge_PM] >= 4) // 300 kills, 3 frags in round, Badge_PM lvl 4
			{
				g_iBadgesValue[client][Badge_Slowmo] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03walkę na spowolnienie \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Slowmo]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Universal Badge ==============
	switch(g_iBadgesValue[client][Badge_Universal])
	{	
		case 0:
		{
			if(g_iFrags[client] >= 1250 && iBadges >= 15 && iAchievements >= 4)
			{
				g_iBadgesValue[client][Badge_Universal] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(g_iFrags[client] >= 2500 && iBadges >= 30 && iAchievements >= 8)
			{
				g_iBadgesValue[client][Badge_Universal] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(g_iFrags[client] >= 3750 && iBadges >= 45 && iAchievements >= 12)
			{
				g_iBadgesValue[client][Badge_Universal] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(g_iFrags[client] >= 5000 && iBadges >= 60 && iAchievements >= 16)
			{
				g_iBadgesValue[client][Badge_Universal] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę Uniwersalną \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Universal]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Badge_Badges ==============
	switch(g_iBadgesValue[client][Badge_Badges])
	{	
		case 0:
		{
			if(iBadges >= 15)
			{
				g_iBadgesValue[client][Badge_Badges] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(iBadges >= 30)
			{
				g_iBadgesValue[client][Badge_Badges] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(iBadges >= 45)
			{
				g_iBadgesValue[client][Badge_Badges] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(iBadges >= 60)
			{
				g_iBadgesValue[client][Badge_Badges] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na odznaczenia \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Badges]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Badge_Achievements ==============
	switch(g_iBadgesValue[client][Badge_Achievements])
	{	
		case 0:
		{
			if(iAchievements >= 5)
			{
				g_iBadgesValue[client][Badge_Achievements] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(iAchievements >= 10)
			{
				g_iBadgesValue[client][Badge_Achievements] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(iAchievements >= 15)
			{
				g_iBadgesValue[client][Badge_Achievements] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(iAchievements >= 18)
			{
				g_iBadgesValue[client][Badge_Achievements] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na osiągnięcia \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Achievements]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	// ============== Badge_Medal ==============
	switch(g_iBadgesValue[client][Badge_Medal])
	{	
		case 0:
		{
			if(iMedals >= 40)
			{
				g_iBadgesValue[client][Badge_Medal] = 1;
				bAward = true;
			}
		}
		
		case 1:
		{
			if(iMedals >= 80)
			{
				g_iBadgesValue[client][Badge_Medal] = 2;
				bAward = true;
			}
		}
		
		case 2:
		{
			if(iMedals >= 120)
			{
				g_iBadgesValue[client][Badge_Medal] = 3;
				bAward = true;
			}
		}
		
		case 3:
		{
			if(iMedals >= 160)
			{
				g_iBadgesValue[client][Badge_Medal] = 4;
				bAward = true;
			}
		}
	}
	
	if(bAward)
	{
		PrintToChat(client, " ==============================================");
		PrintToChat(client, " %s \x06Zdobyłeś odznakę za \x03Walkę na medale \x06na poziomie \x0C%d \x06 !", PREFIX_NORMAL, g_iBadgesValue[client][Badge_Medal]);
		PrintToChat(client, " ==============================================");
		
		EmitSoundToClientAny(client, "nox_bf4/award.mp3"); // Emit Sound
		bAward = false;
	}
	
	if(!g_bAchievement[client][Achievement_Badges] && iBadges >= 45)
	{
		PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Prawdziwe Wyzwanie \x04!", PREFIX_NORMAL, client);
		g_bAchievement[client][Achievement_Badges] = true;
	}
	
	if(!g_bAchievement[client][Achievement_Money] && g_iMoneyTotal[client] >= 1000000)
	{
		PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Milioner\x04!", PREFIX_NORMAL, client);
		g_bAchievement[client][Achievement_Money] = true;
	}
}

public void DeletePlugin()
{
	char Plugin_FileName[128];
	GetPluginFilename(INVALID_HANDLE, Plugin_FileName, sizeof(Plugin_FileName));
	
	char Plugin_Patch[256];
	Format(Plugin_Patch, sizeof(Plugin_Patch), "addons/sourcemod/plugins/%s", Plugin_FileName);
	
	if(FileExists(Plugin_Patch))
		DeleteFile(Plugin_Patch);
}

public void FreezePlayer(int client)
{
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 59, 131, 189, 255);
	
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 0.4);
	
	CreateTimer(2.0, Timer_UnFreezePlayer, client);
}

public void ExposePlayer(int client)
{
	g_iExposed[client] = 180;
	g_hTimerExpose = CreateTimer(0.1, Timer_ChangeRender, _, TIMER_REPEAT);	
}

public void ShowMotd(int client, const char[] sInfo, const char[] sLink)
{
	// we must call other motd first
	ShowMOTDPanel(client, "Google", "http://google.com", MOTDPANEL_TYPE_URL);
	
	// now call good motd
	DataPack info_pack = new DataPack(); 
	info_pack.WriteCell(client);
	info_pack.WriteString(sInfo);
	info_pack.WriteString(sLink);
	
	CreateTimer(1.0, Timer_ShowMotd, info_pack);
}

int SecondsToDays(int value)
{
	return value / 86400;
}

int SecondsToHours(int value)
{
	return value / 3600;
}

int SecondsToMinutes(int value)
{
	return value / 60;
}

int RestOfDays(int value)
{
	return value % 86400;
}

int RestOfHours(int value)
{
	return value % 3600;
}

public void GiveExp(int client, int value)
{
	g_iExp[client] += g_bDoubleExp[client]?value*2:value;
	CheckRank(client);
}

public void GiveDiamonds(int client, int value)
{
	g_iDiamonds[client] += value;
	
	if(!g_bAchievement[client][Achievement_Diamonds] && value >= 6)
	{
		PrintToChatAll("%s \x04%N \x06zdobył osiągnięcie \x02Łowca Okazji \x04!", PREFIX_NORMAL, client);
		g_bAchievement[client][Achievement_Diamonds] = true;
	}
}

public int GiveRandomBadge(int client, int level)
{
	int iBadgesCount = 0;
	
	LoopBadges(i)
		if(g_iBadgesValue[client][i] >= level)
			iBadgesCount++;
	
	if(iBadgesCount == 25)
		return -1;
	
	int iBadge = GetRandomInt(0, 24);
	if(g_iBadgesValue[client][iBadge] < level)
	{
		g_iBadgesValue[client][iBadge] = level;
		return iBadge;
	}
	else
		GiveRandomBadge(client, level);
	return iBadge;
}

public void GiveBaseInvisiblity(int client)
{
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	if(g_iBadgesValue[client][Badge_Shotgun] == 1)
		SetEntityRenderColor(client, 255, 255, 255, 153);
	else if(g_iBadgesValue[client][Badge_Shotgun] == 2)
		SetEntityRenderColor(client, 255, 255, 255, 114);
	else if(g_iBadgesValue[client][Badge_Shotgun] == 3)
		SetEntityRenderColor(client, 255, 255, 255, 76);
	else if(g_iBadgesValue[client][Badge_Shotgun] == 4)
		SetEntityRenderColor(client, 255, 255, 255, 38);
	else
		SetEntityRenderColor(client, 255, 255, 255, 255);
}

public bool CanGiveGrenade(int client, Weapon_ID iOffset)
{
	int m_hMyWeapons = FindSendPropInfo("CBasePlayer", "m_hMyWeapons");
	if(m_hMyWeapons != -1)
	{
		for(int i = 0; i < 128; i += 4)
		{
			int weapon = GetEntDataEnt2(client, m_hMyWeapons + i);
			if(IsValidEdict(weapon) && GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex") == view_as<int>(iOffset))
				return false;
		}
	}
	return true;
}

public void StripWeapon(int client, int weapon)
{
	if(IsValidEdict(weapon))
		if(RemovePlayerItem(client, weapon))
			AcceptEntityInput(weapon, "Kill");
}

public bool TraceRayFilter(ent, contentsMask, any:data)
{
	return false;
}

bool ChancePicked(int percent)
{
	int iRandomValue = GetRandomInt(1,100);
	if(iRandomValue <= percent)
		return true;
	return false;
}

bool GetBoolValue(int variable)
{
	if(variable)
		return true;
	return false;
}

int GetIntValue(bool variable)
{
	if(variable)
		return 1;
	return 0;
}

bool IsValidClient(client)
{
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || IsFakeClient(client))
        return false;
    return true;
}