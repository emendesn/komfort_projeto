#Include "Protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �KMOMSF01  �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMOMSF01()

Local oBitmap1
Local oButton1
Local oButton2
Local oGet1
Local _cNota := Space(9)
Local oGet2
Local _cCarga := DAK->DAK_COD
Local oGet3
Local _cSerie := Space(3)
Local oSay1
Local oSay2
Local oSay3
Private lSai := .F.
Private _lNota := .F.
Private oDlg

DEFINE MSDIALOG oDlg TITLE "Associa NF x Carga" FROM 000, 000  TO 260, 380 COLORS 0, 16777215 PIXEL

@ 010, 005 SAY oSay1 PROMPT "Informe a nota fiscal:" SIZE 053, 014 OF oDlg COLORS 0, 16777215 PIXEL
@ 026, 005 SAY oSay2 PROMPT "Informe a Serie:" SIZE 053, 014 OF oDlg COLORS 0, 16777215 PIXEL
@ 042, 005 SAY oSay3 PROMPT "Informe a Carga:" SIZE 053, 014 OF oDlg COLORS 0, 16777215 PIXEL
@ 009, 060 MSGET oGet1 VAR _cNota SIZE 113, 010 OF oDlg COLORS 0, 16777215 F3 "SF202" Valid !Empty(AllTrim(_cNota)) PIXEL
@ 025, 060 MSGET oGet2 VAR _cSerie SIZE 113, 010 OF oDlg COLORS 0, 16777215 Valid fVldNF(_cNota,_cSerie,_cCarga) PIXEL
@ 039, 060 MSGET oGet3 VAR _cCarga SIZE 113, 010 OF oDlg COLORS 0, 16777215 F3 "DAK" When _lNota Valid fVldCarga(_cCarga) PIXEL
@ 081, 005 BITMAP oBitmap1 SIZE 064, 042 OF oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
@ 080, 078 BUTTON oButton1 PROMPT "Associar" SIZE 106, 027 OF oDlg ACTION (Vai(_cNota,_cSerie,_cCarga),oDlg:End()) PIXEL
@ 113, 148 BUTTON oButton2 PROMPT "Sair" SIZE 036, 013 OF oDlg ACTION oDlg:End() PIXEL

If !lSai
	
	Activate Dialog oDlg CENTER //valid Cancela()
	
Else
	
	oDlg:End()
	
EndIf

SF2->(DbCloseArea())
SA1->(DbCloseArea())

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �Cancela   �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Cancela()

lSai := MsgYesNo("Deseja Sair da Rotina?","SAIR?")

Return( lSai )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �Vai       �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Vai(_cNota,_cSerie,_cCarga)

Local _lProcessa := .T.
Local _cSequen   := ""
Local _cChega    := ""
Local _cTmSer    := ""
Local _cHora     := ""
Local _cDAIPed   := ""
Local _cDAIPer   := ""
Local _cDAIRot   := ""
Local _cDAIRoe   := ""
Local _cCarOri   := ""
Local _dSaida    := CtoD("//")
Local _dChega    := CtoD("//")
Local _dData     := CtoD("//")
Local _nPeso     := 0
Local _nCapa     := 0

_lProcessa := fVldCarga(_cCarga)

If _lProcessa
	
	lSai := MsgYesNo("Confirma a inclus�o da Nota "+AllTrim(_cNota)+" "+AllTrim(_cSerie)+" na carga "+AllTrim(_cCarga)+ "?")
	
	If lSai
		
		DbSelectArea("DAI")
		DAI->(DbSetOrder(1))//DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
		DAI->(DbGoTop())
		
		DAI->(DbSeek(xFilial("DAI")+_cCarga))
		
		//Aqui utilizo para pegar os dados do ultimo registro
		While DAI->DAI_FILIAL == xFilial("DAI") .And. DAI->DAI_COD == _cCarga
			
			_cSequen   := DAI->DAI_SEQUEN
			_cChega    := DAI->DAI_CHEGAD
			_cTmSer    := DAI->DAI_TMSERV
			_cHora     := DAI->DAI_HORA
			_dSaida    := DAI->DAI_DTSAID
			_dChega    := DAI->DAI_DTCHEG
			_dData     := DAI->DAI_DATA
			_nCapa     := DAI->DAI_CAPVOL
			_cCarOri   := DAI->DAI_CARORI
			
			DAI->(DbSkip())
			
		EndDo
		
		_cSequen := StrZero(Val(_cSequen)+5,6)
		
		DbSelectArea("SF2")
		SF2->(DbSetOrder(1))
		SF2->(DbGoTop())
		
		SF2->(DbSeek(xFilial("SF2")+_cNota+_cSerie))
		_nPeso := SF2->F2_PBRUTO
		
		DbSelectArea("DAI")
		DAI->(DbSetOrder(3))//DAI_FILIAL+DAI_NFISCA+DAI_SERIE+DAI_CLIENT+DAI_LOJA
		DAI->(DbGoTop())
		
		SET DELETED OFF//Habilita registros deletados
		If DAI->(DbSeek(xFilial("DAI")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			
			_cDAIPed   := DAI->DAI_PEDIDO
			_cDAIPer   := DAI->DAI_PERCUR
			_cDAIRot   := DAI->DAI_ROTA
			_cDAIRoe   := DAI->DAI_ROTEIR
			
		EndIf
		SET DELETED ON//Desabilita registros deletados
		
		If Empty(AllTrim(_cDAIPed))
			
			DbSelectArea("SC9")
			SC9->(DbSetOrder(6))//C9_FILIAL+C9_SERIENF+C9_NFISCAL+C9_CARGA+C9_SEQCAR
			SC9->(DbGoTop())
			
			If SC9->(DbSeek(xFilial("SC9")+SF2->F2_SERIE+SF2->F2_DOC))
				
				_cDAIPed := SC9->C9_PEDIDO
				_cDAIPer   := '999999'
				_cDAIRot   := '999999'
				_cDAIRoe   := '999999'
				
			Else
				
				lSai := .F.
				
			EndIf
			
		EndIf
		
		If lSai
			
			BeginTran()
			
			RecLock("DAI",.T.)//Inclus�o
			
			DAI->DAI_FILIAL := xFilial("DAI")
			DAI->DAI_COD    := _cCarga
			DAI->DAI_SEQCAR := '01'
			DAI->DAI_SEQUEN := _cSequen
			DAI->DAI_PEDIDO := _cDAIPed
			DAI->DAI_CLIENT := SF2->F2_CLIENTE
			DAI->DAI_LOJA   := SF2->F2_LOJA
			DAI->DAI_VENDED := ''
			DAI->DAI_PESO   := _nPeso
			DAI->DAI_CAPVOL := _nCapa
			DAI->DAI_PERCUR := _cDAIPer
			DAI->DAI_ROTA   := _cDAIRot
			DAI->DAI_ROTEIR := _cDAIRoe
			DAI->DAI_NFISCA := SF2->F2_DOC
			DAI->DAI_SERIE  := SF2->F2_SERIE
			DAI->DAI_DATA   := _dData
			DAI->DAI_HORA   := _cHora
			DAI->DAI_CARORI := _cCarOri
			DAI->DAI_DTCHEG := _dChega
			DAI->DAI_CHEGAD := _cChega
			DAI->DAI_TMSERV := _cTmSer
			DAI->DAI_DTSAID := _dSaida
			DAI->DAI_VALFRE := 0
			DAI->DAI_FREAUT := 0
			DAI->DAI_SDOC   := SF2->F2_SERIE
			
			DAI->(MsUnLock())
			
			RecLock("DAK",.F.)
			DAK->DAK_PESO := DAK->DAK_PESO+_nPeso
			DAK->(MsUnLock())   
			
			RecLock("SF2",.F.)
			SF2->F2_CARGA  := _cCarga
			SF2->F2_SEQCAR := '01'
			SF2->(MsUnLock())
			
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))//C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED
			SC9->(DbGoTop())
			
			SC9->(DbSeek(xFilial("SC9")+_cDAIPed))
			
			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == _cDAIPed
				
				Reclock("SC9",.F.)
				C9_CARGA   := _cCarga
				C9_SEQCAR  := '01'
				C9_SEQENT  := _cSequen
				SC9->(MsUnlock())
			     
				SC9->(DbSkip())
			
			EndDo
				
			EndTran()      
			
			oDlg:End()
			
		Else
			
			MsgStop("N�o foi encontrado a SC9 da nota fiscal! O programa n�o ser� executado!","NOSC9")
			
			oDlg:End()
			
		EndIf
		
	Else
		
		lSai:= .F.
		
	EndIf
	
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �fVldNf    �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fVldNF(_cNota,_cSerie,_cCarga)

Local _lRet   := .T.
Local _lCarga := .F.

_lNota := .F.

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
SF2->(DbGoTop())

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())

If Empty(AllTrim(_cNota))
	
	MsgStop("Nota n�o informada!","NONOTA")
	_lRet := .F.
	
EndIf

If Empty(AllTrim(_cSerie))
	
	MsgStop("Serie n�o informada!","NOSERIE")
	_lRet := .F.
	
EndIf

DbSelectArea("DAI")
DAI->(DbSetOrder(1))//DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
DAI->(DbGoTop())

If SF2->(DbSeek(xFilial("SF2")+_cNota+_cSerie))
	
	If !Empty(AllTrim(SF2->F2_CARGA))
		
		DAI->(DbSeek(xFilial("DAI")+SF2->F2_CARGA))
		//Verifica se a nota j� est� na carga
		While DAI->DAI_FILIAL == xFilial("DAI") .And. DAI->DAI_COD == SF2->F2_CARGA
			
			If DAI->DAI_NFISCA+DAI->DAI_SERIE == SF2->F2_DOC+SF2->F2_SERIE
				
				_lCarga := .T.
				
			EndIf
			
			DAI->(DbSkip())
			
		EndDo
		
	EndIf
	
	If !_lCarga//Se n�o estiver na carga
		
		SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		
		_lRet := MsgYesNo("Confirma a NF "+AllTrim(_cNota)+" "+AllTrim(_cSerie)+" do cliente "+AllTrim(SA1->A1_NOME)+" ?")
		
		If _lRet//Libera o campo da carga
			
			_lNota := .T.
			
		EndIf
		
	Else
		
		MsgStop("Nota j� est� associada a carga "+SF2->F2_CARGA+"! Por favor tire a nota de carga primeiro!","JATEMCARGA")
		_lRet := .F.
		
	EndIf
	
Else
	
	MsgStop("Nota n�o encontrada!","NAOACHOUNF")
	_lRet := .F.
	
EndIf

Return _lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �fVldCarga  �AUTOR: �Caio Garcia           �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fVldCarga(_cCarga)

Local _lRet := .T.
Local lBlqCar   := ( DAK->(FieldPos("DAK_BLQCAR")) > 0 )
Local cCplInt   := SuperGetMv("MV_CPLINT",.F.,"2")
Local lBloqueio := .F.

DbSelectArea("DAK")
DAK->(DbSetOrder(1))

If DAK->(DbSeek(xFilial("DAK")+_cCarga))
	
	lBloqueio := OsBlqExec(DAK->DAK_COD, DAK->DAK_SEQCAR)
	//Integra��o OMSxCPL
	If DAK->(ColumnPos("DAK_VIAROT")) > 0
		If !Empty(DAK->DAK_VIAROT) .And. cCplInt == '1'
			Help(" ",1,"OMS200MNTCPL")//Carga gerada pela integra��o com o Cockpit Log�stico, manuten��o n�o permitida.
			_lRet := .F.
		EndIf
	EndIf
	
	If	GetMV("MV_MANCARG") == "N" .And. DAK->DAK_FEZNF == "1"
		Help(" ",1,"OMS200CFAT") //Esta carga j� se encontra faturada.
		_lRet := .F.
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Primeiro verifica se a carga selecionada ainda pode ser edit.�
	//����������������������������������������������������������������
	If !Empty(DAK->DAK_JUNTOU) .And. DAK->DAK_JUNTOU != "JUNTOU" .And. DAK->DAK_JUNTOU != "MANUAL" .And. DAK->DAK_JUNTOU != "ASSOCI"
		Help(" ",1,"DS2602141") //A carga selecionada est� indispon�vel para manipula��es.
		_lRet := .F.
	EndIf
	
	If DAK->DAK_ACECAR == "1"
		Help(" ",1,"DS2602143") //Retorno de Cargas j� realizado, n�o � poss�vel a Manipula��o desta Carga.
		_lRet := .F.
	EndIf
	
	//�������������������������������������������������������������������Ŀ
	//�Verifica se existe o campo e se esta bloqueada                     �
	//���������������������������������������������������������������������
	If ( lBlqCar .And. DAK->DAK_BLQCAR == '1' ) .Or. lBloqueio
		_lRet := .F.
		Help(" ",1,"OMS200CGBL") //Carga bloqueada ou com servi�o em execu��o.
	EndIf
	
EndIf

Return _lRet
