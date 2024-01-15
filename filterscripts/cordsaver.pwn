#define FILTERSCRIPT

#include <a_samp> // Biblioteca padrão do SA-MP
#include <Pawn.CMD> // Processador de comandos; https://github.com/katursis/Pawn.CMD
#include <filesystem> // Plugin que inclue a função fs_fcreate e outras auxiliares; https://github.com/FreddieCrew/samp-fs

#if defined FILTERSCRIPT

public OnFilterScriptInit() 
{
    print("CordSaver carregado com sucesso!\n");
    return 1;
}

CMD:savep(playerid, params[])
{
    // Cria o handle do arquivo onde as posições serão salvas
    new File:handle;
   
    // Cria as variáveis para armazenar as coordenadas do jogador
    new Float:X, Float:Y, Float:Z, Float:Angle;
    
    // Cria a string para formatar os dados
    new content[128];

    // Se o jogador estiver em um veículo, se sim, armazena informações necessárias do veículo
    if (IsPlayerInAnyVehicle(playerid))
    {
        // Cria a variável para armazenar o ID do veículo do jogador
        new vehicleid;

        // Armazena o ID do veículo do jogador na variável 'vehicleid'
        vehicleid = GetPlayerVehicleID(playerid);

        // Armazena as coordenadas X, Y, Z do veículo nas variáveis
        GetVehiclePos(vehicleid, X, Y, Z);
        
        // Armazena o ângulo/rotação do veículo na variável Angle
        GetVehicleZAngle(vehicleid, Angle);
        
        // Armazena as informações do veículo na string 'content'
        format(content, sizeof(content), "// %s (Em veiculo)\r\nID = %d\r\nX = %f\r\nY = %f\r\nZ = %f\r\nR = %f\r\ninteriorid = %d\r\nvehiclevirtualworld = %d\r\n", params, GetVehicleModel(vehicleid), X, Y, Z, Angle, GetPlayerInterior(playerid), GetVehicleVirtualWorld(vehicleid));
    }
    else 
    {
        // Armazena as coordenadas X, Y, Z do jogador nas variáveis
        GetPlayerPos(playerid, X, Y, Z);

        // Armazena o ângulo/rotação do jogador na variável Angle.
        GetPlayerFacingAngle(playerid, Angle);

        // Armazena as informações na string 'content'
        format(content, sizeof(content), "// %s (Sem veiculo)\r\nX = %f\r\nY = %f\r\nZ = %f\r\nR = %f\r\ninteriorid = %d\r\nvirtualworld = %d\r\nskinid = %d\r\n", params, X, Y, Z, Angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), GetPlayerSkin(playerid));
    }


    // Caso o arquivo 'positions.txt' não exista na pasta scriptfiles, ele é criado
    if (!fs_fexists("scriptfiles/positions.txt")) 
    {
        fs_fcreate("scriptfiles/positions.txt");
    }


    // Tenta abrir o arquivo 'positions.txt' na pasta scriptfiles
    handle = fopen("positions.txt", io_append);

    if (handle) 
    {
        // Escreve o conteúdo da string 'content' no arquivo 'positions.txt'
        fwrite(handle, content);
        // Ao término da operação, fecha o arquivo 'positions.txt'
        fclose(handle);
        SendClientMessage(playerid, -1, "Posição salva! Cheque em: scriptfiles/positions.txt");
    }
    return 1;
}
#endif
// EOF
