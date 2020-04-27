#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA120G3 �Autor  � SYMM CONSULTORIA   � Data �  27/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para gerar ou nao o bloqueio do pedido(SCR)��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA120G3()

Local aArea:= GetArea()
Local lRet := .T.

If SC7->C7_01TPMAT=='3' .And. INCLUI
	lRet := .F.
Endif

If SC7->C7_01TPMAT=='2' .And. INCLUI
	U_AtualB2Pre("+",SC7->C7_QUANT,SC7->C7_FILIAL,SC7->C7_PRODUTO,SC7->C7_LOCAL)
Endif
                       
RestArea(aArea)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AtualB2Pre� Autor � TOTVS                 � Data �10/10/2014���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para atualizacao dos campos B2_01SALPE			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GravaB2Pre(ExpC1,ExpN1,ExpC2)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Sinal da Opera��o  ("+" ou "-")                    ���
���          � ExpN1 = Quantidade da Operacao                             ���
���          � ExpC2 = Produto		                                      ���
���          � ExpC3 = Local 		                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Mata650                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AtualB2Pre(cSinal,nQuant,cFilAtu,cProduto,cLocal)

Local nMultiplic:=If(cSinal == "-",-1,1)

nQuant:= If(nQuant < 0, 0, nQuant)

dbSelectArea("SB2")
dbSetOrder(1)
If !DbSeek(cFilAtu + PADR(cProduto,TAMSX3("B2_COD")[1]) + cLocal )
	CriaSb2( PADR(cProduto,TAMSX3("B2_COD")[1]) , cLocal )	
Endif

Reclock("SB2",.F.)
Replace B2_01SALPE With B2_01SALPE+(nQuant*nMultiplic)
SB2->(MsUnlock())

SB2->(DbCloseArea())//#CMG20180626.n

Return            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120EXC �Autor  � SYMM CONSULTORIA   � Data �  27/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto se encontra no final do evento 3 da MaAvalPc       ���
���Desc.     � (Exclus�o do PC) antes dos eventos de contabiliza��o.      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120EXC()

Local aArea:= GetArea()

If SC7->C7_01TPMAT=='2' .And. ( DTOS(SC7->C7_EMISSAO) >= "20141101" )
	U_AtualB2Pre("-",SC7->C7_QUANT,SC7->C7_FILIAL,SC7->C7_PRODUTO,SC7->C7_LOCAL)
Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT235G1  �Autor  � SYMM CONSULTORIA   � Data �  27/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada Ap�s gravar arquivos em Pedido de Compra, ���
���Desc.     � fechado por residuo..     	 							  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT235G1()

Local aArea:= GetArea()

If SC7->C7_01TPMAT=='2' .And. ( DTOS(SC7->C7_EMISSAO) >= "20141101" )
	U_AtualB2Pre("-",SC7->C7_QUANT,SC7->C7_FILIAL,SC7->C7_PRODUTO,SC7->C7_LOCAL)
Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120DEL �Autor  � SYMM CONSULTORIA   � Data �  27/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada Ap�s gravar arquivos em Pedido de Compra, ���
���Desc.     � fechado por residuo..     	 							  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120DEL()

Local aArea	    := GetArea()
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])== "C7_PRODUTO"})
Local nPQuant 	:= aScan(aHeader,{|x| AllTrim(x[2])== "C7_QUANT"})
Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])== "C7_LOCAL"})
Local nPTpMat	:= aScan(aHeader,{|x| AllTrim(x[2])== "C7_01TPMAT"})

If aCols[n][nPTpMat]=='2'

	dbSelectArea("SB2")
	dbSetOrder(1)
	If DbSeek(xFilial("SC7") + PADR(aCols[n][nPProduto],TAMSX3("B2_COD")[1]) + aCols[n][nPLocal] )
		
		If (SB2->B2_01SALPE < aCols[n][nPQuant]) .And. ( DTOS(SC7->C7_EMISSAO) >= "20141101" )
			MsgStop("N�o � permitido excluir este item, porque a quantidade ja foi utilizado na venda.","Aten��o")
		 	aCols[n,Len(aCols[n])] := .T.
		 	Eval(bRefresh)
		Endif
	
	Endif

Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA120E  �Autor  � SYMM CONSULTORIA   � Data �  27/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada Ap�s gravar arquivos em Pedido de Compra, ���
���Desc.     � fechado por residuo..     	 							  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA120E()

Local aArea		:= GetArea()
Local cPedido 	:= Paramixb[2]
Local lExclui	:= (!INCLUI .And. !ALTERA)
Local lRet 		:= .T.

SC7->(DbSetOrder(1))
SC7->(DbSeek(xFilial("SC7") + cPedido ))
While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido
	
	If SC7->C7_01TPMAT=='2'
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		If DbSeek(xFilial("SC7") + PADR(SC7->C7_PRODUTO,TAMSX3("B2_COD")[1]) + SC7->C7_LOCAL )
			
			If (SB2->B2_01SALPE < SC7->C7_QUANT) .And. ( DTOS(SC7->C7_EMISSAO) >= "20141101" )
				MsgStop("N�o � permitido excluir este pedido, porque a quantidade ja foi utilizado na venda.","Aten��o")
				lRet := .F.
				Exit
			Endif
						
		Endif
		
	Endif
		
	SC7->(DbSkip())
End

RestArea(aArea)

Return lRet