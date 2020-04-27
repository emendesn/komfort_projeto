#include 'protheus.ch'
#include 'parmtype.ch'


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TK272HTM º Autor ³ WELLINGTON RAUL P  º Data ³  06/12/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA PARA ALTERAÇÃO WORKFLOW CALL CENTER       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TK272HTM()
	
	Local aArea := getArea()

	Local _cHtml  := ""
	Local _cPedVen := ""
	Local _cFilial:=""

	DbSelectArea('SUC')
	SUC->(DBSetOrder(1))
	SUC->(DBSeek(XFilial('SUC')+ParamIxb[1,1]))
	
	_cPedVen := SUC->UC_01PED
	_cFilial := SUC->UC_01FIL

	_cHtml 	+= "<table border='0' cellpadding='2' cellspacing='5' width='100%'>"
	_cHtml 	+= " <tr>"
	_cHtml 	+= "   <td width='700' bgcolor='DFEFFF' height='26'>"
	_cHtml 	+= "     <p align='center'><font face='Arial' size='4'><b>Pedido de Venda: "+_cPedVen+    "   Filial: "+_cFilial+  " </b></font></p>"
	_cHtml 	+= "   </td>"	
	_cHtml 	+= " </tr>" 
	_cHtml 	+= "</table>"

	if Empty(alltrim(M->UC_OBS))
		cObs := U_SyLeSYP( M->UC_CODOBS, 81 )
		M->UC_OBS := cObs
	endif

	if Empty(alltrim(M->UC_OBS))
		MsgAlert("TK272HTM - Campo observação vazio, acione a equipe de Sistemas !!!")
		Return(.F.)
	endif

	restArea(aArea)
	
Return _cHtml
