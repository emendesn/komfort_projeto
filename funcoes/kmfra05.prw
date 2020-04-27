#Include "Protheus.Ch"
#Include "topconn.Ch"
#Include 'TbiConn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA05   บAutor  ณRafael Cruz                ณ  11/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que efetua a atualiza็ใo do campo pend๊ncia         บฑฑ
ฑฑบ          ณ financeira do cadastro do cliente.						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ komfort          										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMFRA05()

Local lGrpCrd := IIF(__cUserID $ SuperGetMv("KH_KMFRA05",.F.,"000000"),.T.,.F.)

If !lGrpCrd
	Msgstop("Seu usuแrio nใo possui acesso p/ realizar esta opera็ใo.","Acesso Negado")
	Return
EndIf 

//#RVC20180912.bo
/*If A1_01PEDFI <> "1"
	Msgstop("O Cliente " + SA1->A1_COD + "/" + SA1->A1_LOJA + " nใo possui pend๊ncia financeira.","Pend๊ncia Financeira")
	Return
EndIF*/
//#RVC20180912.eo

//#RVC20180912.bn
If A1_MSBLQL == "1"
	Msgstop("O Cliente " + SA1->A1_COD + "/" + SA1->A1_LOJA + " estแ bloqueado.","A1_MSBLQL")
	Return
EndIF
//#RVC20180912.en

If Aviso("Pend๊ncia Financeira","Confirma a atualiza็ใo do Cliente n.ฐ " + SA1->A1_COD +"/" + SA1->A1_LOJA + " ?",{"Sim","Nใo"},1) == 1
	If A1_01PEDFI <> "1"
		RecLock("SA1",.F.)
			A1_01PEDFI := "1"
		SA1->(MsUnLock())
		MsgInfo("Registro atualizado com sucesso!","T้rmino")
	Else
		RecLock("SA1",.F.)
			A1_01PEDFI := "2"
		SA1->(MsUnLock())
		MsgInfo("Registro atualizado com sucesso!","T้rmino")	
	EndIf
EndIf

Return