#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA60FIL   � Autor | Caio Garcia        � Data �  29/06/18   ���
�������������������������������������������������������������������������͹��
��|Descri��o | Valida marcacao de titulo                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������͹��
��� MV_PAR01 � Descricao da pergunta1 do SX1                              ���
��� MV_PAR02 � Descricao da pergunta2 do SX1                              ���
��� MV_PAR03 � Descricao do pergunta3 do SX1                              ���
��� MV_PAR03 � Descricao do pergunta4 do SX1                              ���
�������������������������������������������������������������������������͹��
��� MV_PAR01 � Descricao do parametro 1                                   ���
��� MV_PAR02 � Descricao do parametro 2                                   ���
��� MV_PAR03 � Descricao do parametro 3                                   ���
��� MV_PAR03 � Descricao do parametro 4                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
FA60FIL - Filtro de registros processados do border�. ( < cPort> , < cAgen> , 
< cConta> , < cSituacao> , < dVencIni> , < dVencFim> , < nLimite> , < nMoeda>
, < cContrato> , < dEmisDe> , < dEmisAte> , < cCliDe> , < cCliAte> ) --> URET
*/
User Function FA60FIL()

Local cFiltr:=""     
Local cGrpLib	:= GetMv("MV_KOGRPLB")
Local cUserId	:= __cUserID
Local cTipoX	:= ""					//#RVC20181019.n

If Alltrim(cUserId) $ cGrpLib

	cFiltr:="ALLTRIM(SE1->E1_TIPO) == 'BOL' .And. ALLTRIM(SE1->E1_NUMBCO) <> ' '"	//#RVC20181019.n
//	cFiltr:="SE1->E1_TIPO == 'BOL' .And. E1_NUMBCO <> ' '"							//#RVC20181019.o
	
Else
	cTipoX := StrTran(Alltrim(cTipos),"/","")			//#RVC20181019.n
	cTipoX := StrTran(cTipoX," ","")					//#RVC20181019.n
	
	cFiltr:="ALLTRIM(SE1->E1_TIPO) $ '" + cTipoX +"' " 	//#RVC20181019.n

//	cFiltr:="SE1->E1_PORTADO == '"+cPort060+"' "		//#RVC20181019.o

EndIf	

Return(cFiltr)
