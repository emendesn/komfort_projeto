#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTIRACR    บAutor  ณ Cristiam Rossi     บ Data ณ  13/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que "envelopa" a rotina FINA150 - gera็ใo de arq. บฑฑ
ฑฑบ          ณ da comunica็ใo bancแria para remover o CHR(13) - CR do arq.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GLOBAL / KOMFORTHOUSE                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TiraCR()
Local cMsg  := ""
Local nOpc  := 0
Local cFile
Local cConteud
Local cAjust

	cMsg += "Se voc๊ deseja gerar CNAB p/ cheque cust๓dia ้ necessแrio remover o caracter especial"
	cMsg += " de retorno de carro (CR-13), caso contrแrio nใo hแ necessidade."+CRLF+CRLF
	cMsg += "Voc๊ deseja remover os caracteres CR-13?"

	nOpc := Aviso("Remo็ใo de caracter especial",cMsg,{"Sim","Nใo"})

	fina150()	// chamada da rotina de Gera็ใo de arquivos

	if nOpc == 1	// remover o CR - caracter CHR(13)
		pergunte("AFI150",.F.)	// chama perguntas para obter o nome do arquivo gerado
		cFile := alltrim(MV_PAR04)
		
		if empty( cFile )
			return nil
		endif

		if ! file( cFile )
			msgStop("Arquivo ["+cFile+"] nใo encontrado, verifique!","Remo็ใo CR-13")
		else
			cConteud := MemoRead( cFile )
			cAjust := strtran( cConteud, CRLF, chr(10) )
			MemoWrite( strtran(cFile,".","-com_CR")+".bak", cConteud )
			MemoWrite( cFile, cAjust )
			
			if file( cFile )
				msgInfo("Arquivo ["+cFile+"] criado sem o CR-13","Remo็ใo CR-13")
			else
				msgStop("Falha na cria็ใo do arquivo ["+cFile+"], verifique!","Remo็ใo CR-13")
			endif
		endif
	endif
return nil
