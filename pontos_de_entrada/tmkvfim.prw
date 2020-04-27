#INCLUDE "protheus.ch"

STATIC cOpFat := Alltrim(GetMv("MV_OPFAT"))
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TMKVFIM  � Autor � Eduardo Patriani   � Data �  17/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Ap�s a grava��o do Pedido de Venda - quando a opera��o for ���
���          � de FATURAMENTO - na rotina de Televendas. 				  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TMKVFIM()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aArea     := GetArea()
Local aAreaSL4	:= SL4->(GetArea())
Local cAtende   := SUA->UA_NUM
Local cPedido   := SUA->UA_NUMSC5

IF SUA->UA_OPER=="2" //Orcamento
	//���������������������������������������������Ŀ
	//� Envia Workflow para Responsavel Tecnico.    �
	//�����������������������������������������������
	If !Empty(SUA->UA_VEND1) .And. ( SUA->UA_ENWKFRT=='2' .Or. Empty(SUA->UA_ENWKFRT))
		U_SYVW100(cAtende)
	Endif
Endif

//������������������������������������������������������������dH�
//�Grava o numero do pedido gerado pelo faturamento, no pedido�
//�de venda vinculado. [FATURAMENTO]                          �
//������������������������������������������������������������dH�
If SUA->UA_OPER=="1" .And. !Empty(SUA->UA_01PEDAN)
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + cPedido ))
		Reclock("SC5",.F.)
		SC5->C5_01PEDAN := SUA->UA_01PEDAN
		Msunlock()
	Endif
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + SC5->C5_01PEDAN ))
		Reclock("SC5",.F.)
		SC5->C5_01PEDAN := cPedido
		Msunlock()
	Endif
	
	
Endif

//�����������������������������������������������������������Ŀ
//�Grava as parcelas no contas a receber conforme a tabela    �
//�SL4 (negociacoes de pagamento), somente quando faturamento.�
//�������������������������������������������������������������
If SUA->UA_OPER=="1" //Faturamento
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + cPedido ))
		Reclock("SC5",.F.)
		SC5->C5_VEND2		:= SUA->UA_VEND1
		SC5->C5_COMIS2	:= Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND1,"A3_COMIS")
		SC5->C5_01TPOP 	:= "1"
		SC5->C5_PEDPEND	:= SUA->UA_PEDPEND
		SC5->C5_NUMTMK	:= cAtende
		Msunlock()
	Endif
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6") + cPedido ))
		While SC6->( !Eof() ) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6") + cPedido
			RecLock("SC6",.F.)
			SC6->C6_WKF1 := "2"
			SC6->C6_WKF2 := "2"
			SC6->C6_WKF3 := "2"
			Msunlock()
			SC6->(DbSkip())
		End
	Endif
	
Endif

RestArea(aAreaSL4)
RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpTerRet �Autor  �Microsiga           � Data �  17/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime Termo de Retirada de Mercadoria.                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//User Function ImpTerRet(cAtende)		//#RVC20180717.o
User Function ImpTerRet(cLoja,cAtende)	//#RVC20180717.n

Local lRet := .F.

If SUA->UA_OPER<>"1"
	MsgStop("Termo de Retira s� � possivel realizar a impress�o com opera��o Faturamento","Aten��o!")
	Return
Endif

SUB->(DbSetOrder(1))
//If SUB->(DbSeek(xFilial("SUB") + cAtende ))	//#RVC20180717.o
If SUB->(DbSeek(cLoja + cAtende ))				//#RVC20180717.n
	While SUB->(!Eof()) .And. SUB->UB_FILIAL+SUB->UB_NUM == cLoja + cAtende
		If SUB->UB_CONDENT=="1" .And. (SUB->UB_TPENTRE=="1" .Or. SUB->UB_TPENTRE=="2" ) //Estoque + Retirada Posterior
			lRet := .T.
			Exit
		Endif
		SUB->(DbSkip())
	End
Endif

If lRet
	//#RVC20180723.bo
/*	//If MsgYesNO("Este pedido possui Mercadoria(s) para Retirada. Deseja imprimir o Termo de Retirada ?","Aten��o")
	U_KMOMSR04(cAtende)   //#CMG20180619.n
	//Endif	*/
	//#RVC20180723.eo

	//#RVC20180723.bn
	If !EMPTY(SUA->UA_01SAC)
		U_KMOMSR04(SUA->UA_01SAC)
	EndIf
	//#RVC20180723.en

Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITRenuncia�Autor  �Microsiga           � Data �  17/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime Termo de Renuncia.                   			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ITRenuncia(cAtende)

Local cTabMost 	:= GetMv("MV_SYTABMO",,"003")	//Tabela de Preco de Mostruario
Local lRet 	  	:= .F.

If SUA->UA_OPER<>"1"
	MsgStop("Termo de Renuncia s� � possivel realizar a impress�o com opera��o Faturamento","Aten��o!")
	Return
Endif

SUB->(DbSetOrder(1))
If SUB->(DbSeek(xFilial("SUB") + cAtende ))
	While SUB->(!Eof()) .And. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB") + cAtende
		
		If SUB->UB_01TABPA==cTabMost
			lRet := .T.
			Exit
		Endif
		
		SUB->(DbSkip())
	End
Endif

If lRet
	//If MsgYesNO("Este pedido possui Mercadoria(s) de Mostru�rio(s). Deseja imprimir o Termo de Renuncia ?","Aten��o")
	U_SYVR104()
	//Endif
Endif

Return