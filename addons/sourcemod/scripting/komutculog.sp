#include <sourcemod>
#include <warden>
#include <steamworks>
#include <discord>

#pragma semicolon 1
#pragma newdecls required

Handle sure_timer = null;
int Komutcu = -1, sure = -1;

ConVar webhook = null;

public Plugin myinfo = 
{
	name = "Discord Komutçu Bildirme", 
	author = "EnesEmre", 
	description = "Komuta geçen biri olduğunda discorda aktarır.", 
	version = "1.2", 
	url = "EnesEmre#2977"
};

public void OnPluginStart()
{
	AddCommandListener(Control_ExitWarden, "sm_uw");
	AddCommandListener(Control_ExitWarden, "sm_unwarden");
	AddCommandListener(Control_ExitWarden, "sm_uc");
	AddCommandListener(Control_ExitWarden, "sm_uncommander");
	
	webhook = CreateConVar("sm_komutcu_log_webhook", "Webhook Giriniz", "Komutçu Log'un Gönderileceği Kanal Webhook'u");
	AutoExecConfig(true, "Discord-Komutcu-log", "EnesEmre");
}


{
	int pic[4];
	SteamWorks_GetPublicIP(pic);
	char name[MAX_NAME_LENGTH], authid[128], mesaj[512], sIP[32], Api[256];
	GetClientName(Komutcu, name, sizeof(name));
	GetClientAuthId(Komutcu, AuthId_Steam2, authid, sizeof(authid));
	Format(sIP, sizeof(sIP), "steam://connect/%d.%d.%d.%d", pic[0], pic[1], pic[2], pic[3]);
	Format(mesaj, sizeof(mesaj), "%d Dakika", sure);
	GetConVarString(webhook, Api, sizeof(Api));
	
	DiscordWebHook hook = new DiscordWebHook(Api);
	hook.SlackMode = true;
	
	MessageEmbed Embed = new MessageEmbed();
	
	Embed.SetTitle("Komutçu Komuttan Ayrıldı");
	Embed.SetColor("#ff0000");
	Embed.AddField(":star: Komutçu İsmi", name, true);
	Embed.AddField(":man_police_officer: Komutçu Steam ID", authid, true);
	Embed.AddField("Komut Verdiği Süre", mesaj, true);
	Embed.AddField("Tıkla Bağlan", sIP, true);
	
	hook.Embed(Embed);
	
	hook.Send();
	delete hook;
	
	Komutcu = -1;
	if (sure_timer != null)
	{
		delete sure_timer;
		sure_timer = null;
	}
}

public Action Control_ExitWarden(int client, const char[] command, int argc)
{
	if (warden_iswarden(client))
	{
		int pic[4];
		SteamWorks_GetPublicIP(pic);
		char name[MAX_NAME_LENGTH], authid[128], mesaj[512], sIP[32], Api[256];
		GetClientName(Komutcu, name, sizeof(name));
		GetClientAuthId(Komutcu, AuthId_Steam2, authid, sizeof(authid));
		Format(sIP, sizeof(sIP), "steam://connect/%d.%d.%d.%d", pic[0], pic[1], pic[2], pic[3]);
		Format(mesaj, sizeof(mesaj), "%d Dakika", sure);
		GetConVarString(webhook, Api, sizeof(Api));
	
		DiscordWebHook hook = new DiscordWebHook(Api);
		hook.SlackMode = true;
	
		hook.SetUsername("Komutçu Log");
		MessageEmbed Embed = new MessageEmbed();
		
		Embed.SetTitle("Komutçu Komuttan Ayrıldı");
		Embed.SetColor("#ff0000");
		Embed.AddField(":star: Komutçu İsmi", name, true);
		Embed.AddField(":man_police_officer: Komutçu Steam ID", authid, true);
		Embed.AddField("Komut Verdiği Süre", mesaj, true);
		Embed.AddField("Tıkla Bağlan", sIP, true);
	
		hook.Embed(Embed);
	
		hook.Send();
		delete hook;
	
		Komutcu = -1;
		if (sure_timer != null)
		{
			delete sure_timer;
			sure_timer = null;
		}
	}
}

public void warden_OnWardenCreated(int client)
{
	Komutcu = client;
	int pic[4];
	SteamWorks_GetPublicIP(pic);
	char name[MAX_NAME_LENGTH], authid[128], sIP[32], Api[512];
	GetClientName(Komutcu, name, sizeof(name));
	GetClientAuthId(Komutcu, AuthId_Steam2, authid, sizeof(authid));
	Format(sIP, sizeof(sIP), "steam://connect/%d.%d.%d.%d", pic[0], pic[1], pic[2], pic[3]);
	GetConVarString(webhook, Api, sizeof(Api));
	
	DiscordWebHook hook = new DiscordWebHook(Api);
	hook.SlackMode = true;
	
	hook.SetUsername("Komutçu Log");
	MessageEmbed Embed = new MessageEmbed();
	
	Embed.SetTitle("Yeni Birisi Komuta Geçti");
	Embed.SetColor("#008000");
	Embed.AddField(":star: Komutçu İsmi", name, true);
	Embed.AddField(":man_police_officer: Komutçu Steam ID", authid, true);
	Embed.AddField("Tıkla Bağlan", sIP, true);
	
	hook.Embed(Embed);
	
	hook.Send();
	delete hook;
	
	if (sure != 0)
		sure = 0;
	if (sure_timer != null)
		delete sure_timer;
	sure_timer = CreateTimer(60.0, Surearttir, _, TIMER_REPEAT);
}

public void warden_OnWardenRemoved(int client)
{
	int pic[4];
	SteamWorks_GetPublicIP(pic);
	char name[MAX_NAME_LENGTH], authid[128], mesaj[512], sIP[32], Api[512];
	GetClientName(Komutcu, name, sizeof(name));
	GetClientAuthId(Komutcu, AuthId_Steam2, authid, sizeof(authid));
	Format(sIP, sizeof(sIP), "steam://connect/%d.%d.%d.%d", pic[0], pic[1], pic[2], pic[3]);
	Format(mesaj, sizeof(mesaj), "%d Dakika", sure);
	GetConVarString(webhook, Api, sizeof(Api));
	
	DiscordWebHook hook = new DiscordWebHook(Api);
	hook.SlackMode = true;
	
	hook.SetUsername("Komutçu Log");
	MessageEmbed Embed = new MessageEmbed();
	
	Embed.SetTitle("Komutçu Komuttan Ayrıldı");
	Embed.SetColor("#ff0000");
	Embed.AddField(":star: Komutçu İsmi", name, true);
	Embed.AddField(":man_police_officer: Komutçu Steam ID", authid, true);
	Embed.AddField("Komut Verdiği Süre", mesaj, true);
	Embed.AddField("Tıkla Bağlan", sIP, true);
	
	hook.Embed(Embed);
	
	hook.Send();
	delete hook;
	
	Komutcu = -1;
	if (sure_timer != null)
	{
		delete sure_timer;
		sure_timer = null;
	}
}

public Action Surearttir(Handle timer, any data)
{
	sure++;
}