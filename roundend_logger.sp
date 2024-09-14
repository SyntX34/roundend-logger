#include <sourcemod>
#include <sdktools>
#include <multicolors>

public Plugin:myinfo = 
{
    name = "Round End Player Logger",
    author = "+SyntX",
    description = "Logs player info at round end",
    version = "1.0",
    url = "https://steamcommunity.com/id/SyntX34"
};

public void OnPluginStart()
{
    HookEvent("round_end", RoundEndHandler, EventHookMode_Post);
}

public void RoundEndHandler(Event event, const char[] name, bool dontBroadcast)
{
    // Print a more compact header to all clients
    PrintToConsoleAll("#ID   Name                SteamID           Team          Status");

    int maxClients = GetMaxClients();
    for (int i = 1; i <= maxClients; i++)
    {
        if (IsClientConnected(i) && IsClientInGame(i))
        {
            char playerName[64], steamID[32], team[32], status[16];

            // Get player's name
            GetClientName(i, playerName, sizeof(playerName));

            // Get player's SteamID
            GetClientAuthString(i, steamID, sizeof(steamID));

            // Handle cases where the SteamID is missing or "STEAM_ID_PENDING"
            if (steamID[0] == '\0' || StrEqual(steamID, "STEAM_ID_PENDING"))
            {
                strcopy(steamID, sizeof(steamID), "Pending");
            }

            // Get player's team using if-else if
            int playerTeam = GetClientTeam(i);
            if (playerTeam == 2)
            {
                strcopy(team, sizeof(team), "Zombie");
            }
            else if (playerTeam == 3)
            {
                strcopy(team, sizeof(team), "Human");
            }
            else
            {
                strcopy(team, sizeof(team), "Unknown");
            }

            // Determine if player is alive, dead, or spectating
            if (IsPlayerAlive(i))
            {
                strcopy(status, sizeof(status), "Alive");
            }
            else if (GetEntProp(i, Prop_Send, "m_lifeState") == 1)
            {
                strcopy(status, sizeof(status), "Dead");
            }
            else
            {
                strcopy(status, sizeof(status), "Spectator");
            }

            // Print more compact data to all clients
            PrintToConsoleAll("#%-4d %-18s %-16s %-12s %-8s", i, playerName, steamID, team, status);
        }
    }
}
