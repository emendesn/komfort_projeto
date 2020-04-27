#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT500GRNCC� Autor � AP6 IDE            � Data �  18/07/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica a necessidade da geracao de uma NCC para o cliente���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT500GRNCC()

Local aArea := GetArea()

ValAtTMK(SC6->C6_NUM)

RestArea(aArea)

Return(.T.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValAtTMK  �Autor  �Vendas CRM          � Data �  09/22/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se todos os itens dos pedido foram eliminados por  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValAtTMK(cPedido)

Local aAreaSC6 	:= SC6->(GetArea())
Local nY		:= 0
Local aRegSC6  	:= {}


SC6->(dbSetOrder(1))
If SC6->(dbSeek(xFilial("SC6")+cPedido))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+cPedido
		If Alltrim(SC6->C6_BLQ)=="R"
			AAdd( aRegSC6 , { xFilial("SC6") , cPedido , 4 , SC6->C6_ITEM , SC6->C6_PRODUTO , LEFT(SC6->C6_NUMTMK,Len(cFilAnt)) , Alltrim(SC6->C6_NUMTMK) })
		Endif
		SC6->(DbSkip())
	End
EndIf

If Len(aRegSC6) > 0
	For nY := 1 To Len(aRegSC6)
		TkAtuTlv( aRegSC6[nY,1] , aRegSC6[nY,2] , aRegSC6[nY,3] , aRegSC6[nY,4] , aRegSC6[nY,5] , aRegSC6[nY,6] , aRegSC6[nY,7] )
	Next
Endif

RestArea(aAreaSC6)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TkAtuTlv  �Autor  �Vendas Clientes     � Data �  24/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de integracao entre Televendas e Faturamento, utili- ���
���          �zada basicamente para manter os dados do orcamento televen- ���
���          �das de acordo com a posicao do pedido de venda associado.   ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Numero do pedido de vendas                          ���
���          �ExpN2 - Status do atendimento (1-Atend;2-Liberado;3-Nf)     ���
�������������������������������������������������������������������������͹��
���Uso       �CALL CENTER/FATURAMENTO                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TkAtuTlv(cFilPed,cPedido,nStatus,cItem,cProduto,cFilOrc,cOrcamento)

Local aArea		:= GetArea()				// Salva os dados de posicionamento do alias atual
Local aAreaSUA	:= SUA->(GetAreA())		// Salva os dados de posicionamento do SUA
Local cStatus	:= ""						// Status a ser gravado no orcamento Televendas
Local nCont		:= 0
Local nCancel	:= 0
Local cFilAtu 	:= GetMv("MV_SYLOCDP",,"100001")
Local cAlias 	:= GetNextAlias()
Local cDirImp	:= "\SIGAFAT_"+cFilAnt+"\"
Local cARQLOG	:= cDirImp+"RESIDUO_"+cFilAnt+"_"+cPedido+cItem+".LOG"

MakeDir(cDirImp)

LjWriteLog( cARQLOG, Replicate('-',80) )
LjWriteLog( cARQLOG, "INICIADO ROTINA DE ELIMINACAO DE PEDIDO MT500GRNCC() - DATA/HORA: "+DToC(Date())+" AS "+Time() )

LjWriteLog( cARQLOG, "1.00 - FILIAL DO PEDIDO			: "+cFilPed )
LjWriteLog( cARQLOG, "1.01 - PEDIDO DE VENDA			: "+cPedido )
LjWriteLog( cARQLOG, "1.02 - ITEM DO PEDIDO DE VENDA		: "+cItem )
LjWriteLog( cARQLOG, "1.03 - PRODUTO DO PEDIDO			: "+cProduto )
LjWriteLog( cARQLOG, "1.04 - FILIAL DO ATENDIMENTO		: "+cFilOrc )
LjWriteLog( cARQLOG, "1.05 - ATENDIMENTO				: "+cOrcamento )

LjWriteLog( cARQLOG, CRLF )

//���������������������������������������������������Ŀ
//�Analisa qual o status a ser gravado de acordo com o�
//�parametro nStatus recebido na chamada da funcao    �
//�����������������������������������������������������
If nStatus == 4   // Por eliminacao de residuo, utiliza o status cancelado
	cStatus	:= "CAN"	// NF cancelada
Endif

//���������������������������������������������Ŀ
//�Atualiza os itens do orcamento do Televendas �
//�����������������������������������������������
DbSelectArea("SUA")
DbSetOrder(1)
If DbSeek(cOrcamento)
	LjWriteLog( cARQLOG, "2.00 - ENTROU NO ATENDIMENTO: "+cOrcamento )
	
	cQuery := " SELECT SUB.R_E_C_N_O_ SUBREC FROM "+RetSqlName("SUB")+" SUB WHERE UB_FILIAL='"+cFilOrc+"' AND UB_XFILPED = '"+cFilPed+"' AND UB_NUMPV='"+cPedido+"' AND UB_ITEMPV='"+cItem+"' AND SUB.D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	While (cAlias)->(!EOF())
		DbSelectArea("SUB")
		DbGoto((cAlias)->SUBREC)
		LjWriteLog( cARQLOG, "2.01A - CANCELADO ITEM DO ATENDIMENTO: "+SUB->UB_FILIAL+"_"+SUB->UB_NUM+"_"+SUB->UB_ITEM )
		Reclock("SUB",.F.)
		SUB->UB_01CANC 	:= "S"
		SUB->UB_01DTCAN	:= dDatabase
		SUB->UB_01USRCA	:= UsrRetName(__cUserID) + "|" + DtoC(dDataBase) + "|" + TIME()
		Msunlock()
		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())
		
	DbSelectArea("SUB")
	DbSetOrder(1)
	If DbSeek(cOrcamento)
		
		While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM == cOrcamento
			
			nCont	+= 1
			If SUB->UB_01CANC=="S"
				nCancel	+= 1
			Endif
			
			//��������������������������������������������Ŀ
			//�Retorno as quantidades prevista no estoque. �
			//����������������������������������������������
			If SUB->UB_CONDENT=='3'
				LjWriteLog( cARQLOG, "2.02 - RETORNO AS QUANTIDADES PREVISTA NO ESTOQUE DO ITEM: "+SUB->UB_FILIAL+SUB->UB_ITEM+SUB->UB_PRODUTO )
				U_AtualB2Pre("+",SUB->UB_QUANT,If(SUB->UB_XFORFAT=='1',SUB->UB_FILIAL,cFilAtu),SUB->UB_PRODUTO,SUB->UB_LOCAL)
			Endif
			
			DbSelectArea("SUB")
			DbSkip()
		End
	Endif
Endif
LjWriteLog( cARQLOG, "2.03 - QUANTIDADE DE ITENS DO ATENDIMENTO	: "+ALLTRIM(STR(nCont)) )
LjWriteLog( cARQLOG, "2.04 - QUANTIDADE DE ITENS CANCELADOS	: "+ALLTRIM(STR(nCancel)) )

//�����������������������������������Ŀ
//�Atualiza o orcamento do Televendas �
//�������������������������������������
DbSelectArea("SUA")
DbSetOrder(1)
If DbSeek(cOrcamento)
	LjWriteLog( cARQLOG, "2.05 - ENTROU NO ATENDIMENTO: "+cOrcamento+" PARA ATUALIZAR O STATUS" )
	If cStatus == "CAN"
		If AllTrim(SUA->UA_STATUS) == "NF."
			cStatus := "NF."
		ElseIf AllTrim(SUA->UA_STATUS) == "LIB"
			cStatus := "CAN"
		ElseIf AllTrim(SUA->UA_STATUS) == "SUP"
			cStatus := "CAN"
		Else
			cStatus := cStatus
		EndIf
	Else
		cStatus := cStatus
	EndIf
	
	If nCont==nCancel
		LjWriteLog( cARQLOG, "2.06 - ATENDIMENTO: "+cOrcamento+" TOTALMENTE CANCELADO" )
		RecLock("SUA",.F.)
		Replace UA_STATUS	With cStatus
		
		If nStatus == 4 .And. (cStatus == "CAN")
			Replace UA_CANC   	With "S"
			MSMM(,TamSx3("UA_OBSCANC")[1],,"Eliminado por res�duo",1,,,"SUA","UA_CODCANC")
		EndIf
		MsUnLock()
	Else
		LjWriteLog( cARQLOG, "2.06 - ATENDIMENTO: "+cOrcamento+" PARCIALMENTE CANCELADO" )
	Endif
	
EndIf

RestArea(aAreaSUA)
RestArea(aArea)

LjWriteLog( cARQLOG, "FINALIZADO ROTINA DE ELIMINACAO DE PEDIDO MT500GRNCC() - DATA/HORA: "+DToC(Date())+" AS "+Time() )
LjWriteLog( cARQLOG, Replicate('-',80) )

Return Nil