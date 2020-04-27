#Include 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
//Tel. Contato Kevin 2373-1527

/*
=====================================================================================
Programa.:              KMFIN02B
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            ROTINA PARA EXECUTAR O ENVIO DO ARQUIVO DE CONCILIACAO DE VENDAS PARA O FTP CONCIL, ATRAVES DE AGENDAMENTO.
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
User Function KMFIN02B()

	Local cArqFTP	:= ""	

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
	
	cArqFTP		:= U_KMFINA02(.T.) //A rotina encontra-se no fonte KMFINA02
	
	If !(Empty(cArqFTP))
		
		KMFIN02B01(cArqFTP)
		
	EndIf

	RESET ENVIRONMENT

Return

/*
=====================================================================================
Programa.:              KMFIN02B01
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            ROTINA PARA EXECUTAR O ENVIO DO ARQUIVO DE CONCILIACAO DE VENDAS PARA O FTP CONCIL, ATRAVES DE AGENDAMENTO.
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02B01(cArqFTP)

	Local oFTP	:= MNGFTP():NEW()

	oFTP:cServidor	:= "ftp2.ainstec.com"
	oFTP:cLogin		:= "komforthouse.ftp"
	oFTP:cSenha		:= "#@$FTPCLI"
	oFTP:cArqDest	:= "\SYSTEM\" + cArqFTP	
	oFTP:cPathFTP	:= "/ENTRADA/ESTABELECIMENTOS/" + cArqFTP	

	oFTP:Upload()

RETURN