#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWIZARD.CH"

/*/
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  KMJOBF01  � Autor � Caio Garcia         � Data � 26/04/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa ir� gerar pedidos de venda, faturar, transmitir   ���
���e realizar a entrada no estoque da matriz.                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Cliente                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � OBPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function KMJOBF01()

Local _cQuery := ""
Local _cFilial := ""
Local _cEmp := "01"
Local _cFil := "0101"

//If Time() > '10:00:00' //.And.  Time() < '11:00:00'

	ConOut("-----------------------------------------")
	ConOut("Inicio da rotina KMJOBF01: " +DToC(Date())+" - "+Time())
	ConOut("-----------------------------------------")
		
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES 'SA1,SC6,SC5,SC9,SF2,SD2,SE4,SF4,SB2,SB1' MODULO 'FAT'
	
	_cQuery := "SELECT UB_FILIAL FILIAL "
	_cQuery += " FROM " + RETSQLNAME("SUB") + " (NOLOCK) SUB "
	_cQuery += " INNER JOIN " + RETSQLNAME("SUA") + " (NOLOCK) SUA ON UA_FILIAL = UB_FILIAL AND UA_NUM = UB_NUM AND SUA.D_E_L_E_T_ <> '*' "
	_cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON SUB.UB_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ <>'*' " //devido o produto agregado n�o estar setado com 4 na SUB	
	_cQuery += " WHERE SUB.D_E_L_E_T_ <> '*' "
	_cQuery += " AND (UB_MOSTRUA IN ('4') OR SB1.B1_XACESSO ='1') "//Caso a UB n�o esteja marcado como agregado valido a SB1, para evitar n�o gerar a transfer�ncia	
	_cQuery += " AND UA_NUMSC5 <> '' "
	_cQuery += " AND UA_STATUS <> 'CAN' "  
	_cQuery += " AND UA_CANC <> 'S' "
	//_cQuery += " AND UA_FILIAL <> '0117' "		
	//_cQuery += " AND UA_EMISSAO >= '20180918' " - data alterada devido o ajuste da query, alguns pedidos n�o estavam alimentando o campo UB_MOSTRUA corretamente, por este motivo estou validando o campo B1_XACESSO
	_cQuery += " AND UA_EMISSAO >= '20190501' "
	_cQuery += " AND UB_FILIAL+UB_NUM+UB_ITEM NOT IN (SELECT C6_XCHVTRA FROM " + RETSQLNAME("SC6") + " (NOLOCK) SC6 WHERE SC6.D_E_L_E_T_ <> '*' AND C6_XCHVTRA <> '' AND C6_BLQ <> 'R') " //C6_BLQ - valida��o para desconsiderar pedidos com elimina��o de res�duo.
	_cQuery += " ORDER BY UB_FILIAL "
	_cQuery := ChangeQuery(_cQuery)              
	
	_cAlias   := GetNextAlias()
	
	DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
	
	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	
	If (_cAlias)->(!Eof())
		
		_cFilial := (_cAlias)->FILIAL
		
	EndIf
	
	(_cAlias)->(DbCloseArea())
	
	RESET ENVIRONMENT
	
	If !Empty(AllTrim(_cFilial))
		
		ConOut("EXECUTA PARA A FILIAL "+_cFilial)
		U_KMESTF01(_cEmp,_cFilial)
		
	EndIf
	
	ConOut("-----------------------------------------")
	ConOut("Fim da rotina KMJOBF01: " +Time())
	ConOut("-----------------------------------------")
	
//EndIf

Return

