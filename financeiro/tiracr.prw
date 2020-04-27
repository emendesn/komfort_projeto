#include "totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TIRACR    �Autor  � Cristiam Rossi     � Data �  13/07/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa que "envelopa" a rotina FINA150 - gera��o de arq. ���
���          � da comunica��o banc�ria para remover o CHR(13) - CR do arq.���
�������������������������������������������������������������������������͹��
���Uso       � GLOBAL / KOMFORTHOUSE                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TiraCR()
Local cMsg  := ""
Local nOpc  := 0
Local cFile
Local cConteud
Local cAjust

	cMsg += "Se voc� deseja gerar CNAB p/ cheque cust�dia � necess�rio remover o caracter especial"
	cMsg += " de retorno de carro (CR-13), caso contr�rio n�o h� necessidade."+CRLF+CRLF
	cMsg += "Voc� deseja remover os caracteres CR-13?"

	nOpc := Aviso("Remo��o de caracter especial",cMsg,{"Sim","N�o"})

	fina150()	// chamada da rotina de Gera��o de arquivos

	if nOpc == 1	// remover o CR - caracter CHR(13)
		pergunte("AFI150",.F.)	// chama perguntas para obter o nome do arquivo gerado
		cFile := alltrim(MV_PAR04)
		
		if empty( cFile )
			return nil
		endif

		if ! file( cFile )
			msgStop("Arquivo ["+cFile+"] n�o encontrado, verifique!","Remo��o CR-13")
		else
			cConteud := MemoRead( cFile )
			cAjust := strtran( cConteud, CRLF, chr(10) )
			MemoWrite( strtran(cFile,".","-com_CR")+".bak", cConteud )
			MemoWrite( cFile, cAjust )
			
			if file( cFile )
				msgInfo("Arquivo ["+cFile+"] criado sem o CR-13","Remo��o CR-13")
			else
				msgStop("Falha na cria��o do arquivo ["+cFile+"], verifique!","Remo��o CR-13")
			endif
		endif
	endif
return nil
