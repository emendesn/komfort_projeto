#INCLUDE "Protheus.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVR108  � Autor � AP6 IDE            � Data �  07/05/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de produtos com montagens pendentes.             ���
�������������������������������������������������������������������������͹��
���Uso       � Casa Cenario                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function SYVR108()
Local oReport := ReportDef()

oReport:PrintDialog()

Return Nil
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVR108  � Autor � AP6 IDE            � Data �  24/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de produtos com montagens pendentes.             ���
�������������������������������������������������������������������������͹��
���Uso       � Casa Cenario                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ReportDef()

Local oBreak,oBreak1, oCell, oReport, oSection 
Local cPerg	  := PADR("SYVR108",10)
Local cReport := "SYVR108"
Local cTitulo := "Relat�rio de produtos com montagens pendentes."
Local cDescri := "Este programa ir� emitir a rela��o de produtos com montagens pendentes."

oReport := TReport():New("SYVR108","Produtos Montagens Pendentes",,{|oReport| ReportPrint(oReport)},"Rela��o de produtos com montagens pendentes.")

AjustaSX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return(.T.)
Endif

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection1)                                      �
//����������������������������������������������������������������                                                       
oSection1 := TRSection():New(oReport, "Rela��o de produtos com montagens pendentes.", {"SC5","SC6","SB1","SB4"}, {"Por Filial"} )

//��������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                      �
//�                                                              �
//�TRCell():New                                                  �
//�ExpO1 : Objeto TSection que a secao pertence                  �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado    �
//�ExpC3 : Nome da tabela de referencia da celula                �
//�ExpC4 : Titulo da celula                                      �
//�        Default : X3Titulo()                                  �
//�ExpC5 : Picture                                               �
//�        Default : X3_PICTURE                                  �
//�ExpC6 : Tamanho                                               �
//�        Default : X3_TAMANHO                                  �
//�ExpL7 : Informe se o tamanho esta em pixel                    �
//�        Default : False                                       �
//�ExpB8 : Bloco de c�digo para impressao.                       �
//�        Default : ExpC2                                       �
//�                                                              �
//����������������������������������������������������������������
TRCell():New(oSection1,"C5_FILIAL" 		,,RetTitle("C5_FILIAL") 	,,TamSX3("C5_FILIAL")[1])
TRCell():New(oSection1,"C5_NUMTMK" 		,,RetTitle("C5_NUMTMK") 	,,TamSX3("C5_NUMTMK")[1])
TRCell():New(oSection1,"C5_NUM"   		,,RetTitle("C5_NUM")   		,,TamSX3("C5_NUM")[1])
TRCell():New(oSection1,"NOME_CLI" 		,,"Nome Cliente"   			,,40)
TRCell():New(oSection1,"C6_PRODUTO"   	,,RetTitle("C6_PRODUTO")   	,,TamSX3("C6_PRODUTO")[1])
TRCell():New(oSection1,"B1_DESC"		,,RetTitle("B1_DESC")		,,TamSX3("B1_DESC")[1])
TRCell():New(oSection1,"C6_LOCAL"   	,,RetTitle("C6_LOCAL")   	,,TamSX3("C6_LOCAL")[1])
TRCell():New(oSection1,"C6_QTDVEN"   	,,RetTitle("C6_QTDVEN")   	,,TamSX3("C6_QTDVEN")[1])
TRCell():New(oSection1,"C6_DTAGEND"   	,,RetTitle("C6_DTAGEND")   	,,TamSX3("C6_DTAGEND")[1]) 
TRCell():New(oSection1,"C6_DTENTOK"   	,,RetTitle("C6_DTENTOK")   	,,TamSX3("C6_DTENTOK")[1])
TRCell():New(oSection1,"B4_01VLMON"   	,,RetTitle("B4_01VLMON")   	,,TamSX3("B4_01VLMON")[1])
TRCell():New(oSection1,"TOT_MONTA"   	,,"Valor Total Montagem"   	,,TamSX3("B4_01VLMON")[1])

oSection1:Cell("C6_QTDVEN"):SetHeaderAlign("RIGHT")
oSection1:Cell("B4_01VLMON"):SetHeaderAlign("RIGHT")
oSection1:Cell("TOT_MONTA"):SetHeaderAlign("RIGHT")
                                  
oBreak := TRBreak():New(oSection1,oSection1:Cell("C5_FILIAL"),"Totais por Filial")

TRFunction():New(oSection1:Cell("TOT_MONTA") ,Nil,"SUM",oBreak)

//oReport:SetTotalInLine(.F.)
oReport:SetLandscape()

Return( oReport )
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVR108  � Autor � AP6 IDE            � Data �  24/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de pagamento dos montadores                      ���
�������������������������������������������������������������������������͹��
���Uso       � Casa Cenario                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ReportPrint( oReport )

Local cQuery       	:= ""
Local cAlias       	:= GetNextAlias()
Local oSection1 	:= oReport:Section(1)
Local nOrdem 	   	:= oSection1:GetOrder()
Local cNomeCli     	:= ""
Local cQuebra		:= ""

cQuery := "SELECT 	C5_FILIAL," + CRLF
cQuery += "			C5_NUMTMK," + CRLF
cQuery += "			C5_NUM," + CRLF
cQuery += "			C5_CLIENTE," + CRLF
cQuery += "			C5_LOJACLI," + CRLF
cQuery += "			C6_PRODUTO," + CRLF
cQuery += "			B1_DESC," + CRLF
cQuery += "			C6_LOCAL," + CRLF
cQuery += "			C6_QTDVEN," + CRLF
cQuery += "			C6_DTAGEND," + CRLF
cQuery += "			C6_DTENTOK," + CRLF
cQuery += "			C6_DTMONTA," + CRLF
cQuery += "			B4_01VLMON" + CRLF
cQuery += "FROM "+RetSqlName("SC6")+" SC6" + CRLF
cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_NUM=C6_NUM AND SC5.D_E_L_E_T_ = ' '" + CRLF
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_ = ' '" + CRLF
cQuery += "INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_COD=B1_01PRODP AND SB4.D_E_L_E_T_ = ' '" + CRLF
cQuery += "WHERE 	C6_FILIAL=C5_FILIAL " + CRLF
cQuery += "AND		C6_FILIAL  BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"'" + CRLF
cQuery += "AND		C5_NUM 	   BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"'" + CRLF
cQuery += "AND   	C6_DTAGEND BETWEEN '"+Dtos(Mv_Par05)+"' AND '"+Dtos(Mv_Par06)+"'" + CRLF
cQuery += "AND   	C6_DTAGEND <> ' '" + CRLF
cQuery += "AND		C6_LOCAL   BETWEEN '"+Mv_Par07+"' AND '"+Mv_Par08+"'" + CRLF
cQuery += "AND		C6_PRODUTO BETWEEN '"+Mv_Par09+"' AND '"+Mv_Par10+"'" + CRLF
cQuery += "AND		(C6_DTENTOK <> ' ' OR C6_DTENTOK = ' ') " + CRLF
cQuery += "AND		C6_DTMONTA = ' '" + CRLF
cQuery += "AND		B4_01VLMON > 0" + CRLF
cQuery += "AND		SC6.D_E_L_E_T_ = ' '" + CRLF
cQuery += "ORDER BY C5_FILIAL,C5_NUM" + CRLF

DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)

TCSetField(cAlias,"B4_01VLMON","N",TamSx3("B4_01VLMON" )[1], TamSx3("B4_01VLMON")[2])
TCSetField(cAlias,"C6_QTDVEN" ,"N",TamSx3("C6_QTDVEN"  )[1], TamSx3("C6_QTDVEN" )[2])
TCSetField(cAlias,"C6_DTAGEND","D",8)
TCSetField(cAlias,"C6_DTENTOK","D",8)

oReport:SetMeter( 1 )
oSection1:Init()

(cAlias)->( dbGoTop() )
While (cAlias)->( !Eof() )
	oReport:IncMeter()
	
	// -- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf
			
	cNomeCli := (cAlias)->C5_CLIENTE+(cAlias)->C5_LOJACLI+"-"+Posicione("SA1",1,xFilial("SA1")+(cAlias)->C5_CLIENTE+(cAlias)->C5_LOJACLI,"A1_NOME")
		
	oSection1:Cell("C5_FILIAL"  		):SetBlock( { || (cAlias)->C5_FILIAL	} )
	oSection1:Cell("C5_NUMTMK"    		):SetBlock( { || (cAlias)->C5_NUMTMK	} )
	oSection1:Cell("C5_NUM"  			):SetBlock( { || (cAlias)->C5_NUM		} )
	oSection1:Cell("NOME_CLI" 			):SetBlock( { || cNomeCli				} )
	oSection1:Cell("C6_PRODUTO"    		):SetBlock( { || (cAlias)->C6_PRODUTO	} )
	oSection1:Cell("B1_DESC" 			):SetBlock( { || (cAlias)->B1_DESC		} )
	oSection1:Cell("C6_LOCAL"			):SetBlock( { || (cAlias)->C6_LOCAL	} )
	oSection1:Cell("C6_QTDVEN"			):SetBlock( { || (cAlias)->C6_QTDVEN	} )
	oSection1:Cell("C6_DTAGEND"			):SetBlock( { || (cAlias)->C6_DTAGEND	} )
	oSection1:Cell("C6_DTENTOK"			):SetBlock( { || (cAlias)->C6_DTENTOK 	} )
	oSection1:Cell("B4_01VLMON"			):SetBlock( { || (cAlias)->B4_01VLMON	} )
	oSection1:Cell("TOT_MONTA"			):SetBlock( { || (cAlias)->C6_QTDVEN * (cAlias)->B4_01VLMON } )
					
	oSection1:PrintLine()

	(cAlias)->( dbSkip() )
	
EndDo
oSection1:Finish()

(cAlias)->( dbCloseArea() )

Return( oReport )
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SYPERGUNTA�Autor  �Microsiga           � Data �  25/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AjustaSX1(cPerg)

Local aArea := GetArea()
Local aPerg := {}
Local i

Aadd(aPerg,{cPerg,"01","Da Filial"		,"MV_CH1","C",06,0,"G","MV_PAR01","","","","",""})
Aadd(aPerg,{cPerg,"02","Ate Filial"		,"MV_CH2","C",06,0,"G","MV_PAR02","","","","",""})
Aadd(aPerg,{cPerg,"03","Do Pedido"		,"MV_CH3","C",06,0,"G","MV_PAR03","","","","",""})
Aadd(aPerg,{cPerg,"04","Ate Pedido"		,"MV_CH4","C",06,0,"G","MV_PAR04","","","","",""})
Aadd(aPerg,{cPerg,"05","Da Dt.Agenda"	,"MV_CH5","D",08,0,"G","MV_PAR05","","","","",""})
Aadd(aPerg,{cPerg,"06","Ate Dt.Agenda"	,"MV_CH6","D",08,0,"G","MV_PAR06","","","","",""})
Aadd(aPerg,{cPerg,"07","Do Armazem"		,"MV_CH7","C",02,0,"G","MV_PAR07","","","","",""})
Aadd(aPerg,{cPerg,"08","Ate Armazem"	,"MV_CH8","C",02,0,"G","MV_PAR08","","","","",""})
Aadd(aPerg,{cPerg,"09","Do Produto"		,"MV_CH9","C",30,0,"G","MV_PAR09","SB1","","","",""})
Aadd(aPerg,{cPerg,"10","Ate Produto"	,"MV_CHA","C",30,0,"G","MV_PAR10","SB1","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)
For i := 1 To Len(aPerg)
	IF  !DbSeek(aPerg[i,1]+aPerg[i,2])
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIF
	Replace X1_GRUPO   with aPerg[i,01] ;		Replace X1_ORDEM   with aPerg[i,02]
	Replace X1_PERGUNT with aPerg[i,03] ;		Replace X1_VARIAVL with aPerg[i,04]
	Replace X1_TIPO	   with aPerg[i,05] ;		Replace X1_TAMANHO with aPerg[i,06]
	Replace X1_PRESEL  with aPerg[i,07] ;		Replace X1_GSC	   with aPerg[i,08]
	Replace X1_VAR01   with aPerg[i,09] ;		Replace X1_F3	   with aPerg[i,10]
	Replace X1_DEF01   with aPerg[i,11] ;		Replace X1_DEF02   with aPerg[i,12]
	Replace X1_DEF03   with aPerg[i,13] ;		Replace X1_DEF04   with aPerg[i,14]
	MsUnlock()
Next i
RestArea(aArea)
Return

Return(.T.)