#include <sourcemod>



#pragma semicolon 1



new const String:PLUGIN_NAME[] = "Steam ID To Console";

new const String:PLUGIN_VERSION[] = "1.0";



public Plugin:myinfo =

{

	name = PLUGIN_NAME,

	author = "FrostJacked, modified by WhiteWolf",

	description = "Displays Steam ID to console when a client disconnects or name changes.",

	version = PLUGIN_VERSION,

	url = "www.swoobles.com"

}



public OnPluginStart()

{

	HookEvent("player_changename", Event_ChangeName_Post, EventHookMode_Post);

}



public OnClientDisconnect(iClient)

{

	PrintMessageSteamID(iClient);

}



public Event_ChangeName_Post(Handle:hEvent, const String:szName[], bool:bDontBroadcast)

{

	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	new String:ClientNewName[32];
	GetEventString(hEvent, "newname",ClientNewName, sizeof(ClientNewName));
	
	if(!iClient)

		return;

	

	PrintMessageSteamIDToLog(iClient,ClientNewName, true);
}

PrintMessageSteamID(iTarget, bool:bNameChange=false)

{

	decl String:szAuthID[32];

	GetClientAuthString(iTarget, szAuthID, sizeof(szAuthID));

	decl String:szMessage[128];

	

	if(bNameChange)
{
		Format(szMessage, sizeof(szMessage), "%N namechanged. (%s)", iTarget, szAuthID);
}
	else
{
		Format(szMessage, sizeof(szMessage), "%N disconnected. (%s)", iTarget, szAuthID);
	}

	for(new iClient=1; iClient<=MaxClients; iClient++)

	{

		if(!IsClientInGame(iClient))

			continue;

		

		PrintToConsole(iClient, szMessage);

	}

}

PrintMessageSteamIDToLog(iTarget, String:ClientNewName[], bool:bNameChange=false)

{

	decl String:szAuthID[32];

	GetClientAuthString(iTarget, szAuthID, sizeof(szAuthID));

	
	decl String:szMessage[128];

	

	if(bNameChange)
{
		Format(szMessage, sizeof(szMessage), "%N namechanged. (%s)", iTarget, szAuthID);
		LogMessage("%N changed name to %s (%s)", iTarget, ClientNewName, szAuthID);
}
	else
{
		Format(szMessage, sizeof(szMessage), "%N disconnected. (%s)", iTarget, szAuthID);
		LogMessage("%N disconnected. (%s)", iTarget, szAuthID);
	}

	for(new iClient=1; iClient<=MaxClients; iClient++)

	{

		if(!IsClientInGame(iClient))

			continue;

		

		PrintToConsole(iClient, szMessage);

	}

}