#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "MsOle.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SYTMR001  ºAutor  ³ Eduardo Patriani   º Data ³  31/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera relatorio do laudo tecnico utilizando o modelo .DOT	  º±±
±±ºDesc.     ³ a partir da abertura do chamado no SAC. 					  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SYTMR001(aLaudo,aAlter,nPosLaudo,aProdutos,aDefeitos,cObs)

Local cQuery		:= ""
Local cAlias 		:= CriaTrab(,.F.)
Local cPedido		:= M->UC_01PED // LUIZ EDUARDO F.C. - 01/06/2017 - TRAZER O CONTEUDO COMPLETO DO PEDIDO
Local cChamado		:= M->UC_CODIGO
Local cOperador 	:= ""
Local aObs			:= {}
Local cNomeCli		:= ""
Local cBairro		:= ""
Local cPonto		:= ""
Local cCidade		:= ""
Local cCEP			:= ""
Local cUF			:= ""
Local cTelefone		:= ""
Local cNota			:= ""
Local cDescricao	:= ""
Local cDefeito		:= ""
Local nX			:= 0
Local nY			:= 0
Local nMotivos		:= 0
Local cMsg			:= ""
Local oPDF
Local cPathPDF		:= GetTempPath()//"\SYSTEM\"
Local cArqPDF		:= "LAUDO.PDF"
Local cBmp			:= "\system\logo.png""
Local cSofaF 		:= "\system\SOFA_F.png"
Local cSofaB 		:= "\system\SOFA_B.png"
Local nWidthBMP		:= 0
Local nHeightBMP	:= 0
Local nRBoxTop		:= 0 //Indica a linha inicial do box principal
Local nCBoxTop		:= 0 //Indica a coluna inicial do box principal
Local nRBoxBot		:= 0 //Indica a linha Final do box principal
Local nCBoxBot		:= 0 //Indica a coluna final do box principal
Local cPxPrinc		:= "-2" //Valor padrao da espessura do box principal
Local nRowBMP		:= 0
Local nLinImp		:= 0
Local nColImp		:= 0
Local nColBMP		:= 0
Local aBox01		:= {}
Local aBox02		:= {}
Local aBox03		:= {}
Local aBox04		:= {}
Local aBox05		:= {}
Local aBox06		:= {}
Local aBox07		:= {}
Local aBox08		:= {}
Local aBox09		:= {}
Local aBox10		:= {}
Local aBox11		:= {}
Local aBox12		:= {}
Local aBox13		:= {}
Local aBox14		:= {}
Local aBox15		:= {}
Local aBox16		:= {}
Local aBox17		:= {}
Local aBox18		:= {}
Local aBox19		:= {}
Local aBox20		:= {}
Local aBox21		:= {}
Local aBox22		:= {}
Local aBox23		:= {}
Local aBox24		:= {}
Local aBox25		:= {}
Local aBox26		:= {}
Local aBox27		:= {}
Local aBox28		:= {}
Local aBox29		:= {}
Local aBox30		:= {}
Local aBox31		:= {}
Local aBox32		:= {}
Local aBox33		:= {}
Local aBox34		:= {}
Local aBox35		:= {}
Local aBox36		:= {}
Local aBox37		:= {}
Local aBox38		:= {}
Local aBox39		:= {}
Local aBox40		:= {}
Local aBox41		:= {}
Local aBox42		:= {}
Local aBox43		:= {}
Local aBox44		:= {}
Local oFontNeg		:= TFont():New()
Local oFontNor		:= TFont():New()
Local oFontNor11	:= TFont():New()
Local aTMP			:= {}
Local lRet			:= .F.

oFontNeg:Bold		:= .T.
oFontNeg:Name		:= "Arial"
oFontNeg:nHeight	:= 14

oFontNor:Bold 		:= .F.
oFontNor:Name		:= "Arial"
oFontNor:nHeight	:= 14

oFontNor11:Bold 	:= .F.
oFontNor11:Name		:= "Arial"
oFontNor11:nHeight	:= 11

/*
	Estrutura do array 'aLaudo'
	1->aCols[nX,nPRODUTO]
	2->aCols[nX,nObs]
	3->aCols[nX,nDtEntr]
	4->aCols[nX,nDescDef]
	5->aCols[nX,nXDESDE2]
	6->aCols[nX,nXDESDE3]
	7->aCols[nX,nXNumLaudo]
	8->aCols[nX,nxUser] Responsavel pela emissao do laudo
*/

cQuery := "SELECT DISTINCT D2_PEDIDO AS PEDIDO, D2_DOC AS NOTA FROM "+RetSqlName("SD2")+" SD2 WHERE D2_PEDIDO = '"+Right(cPedido , 6)+"' AND SD2.D_E_L_E_T_ = ' ' "

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),cAlias,.F.,.T.)
While (cAlias)->(!EOF())
	cPedido := (cAlias)->PEDIDO
	cNota 	:= (cAlias)->NOTA	
	(cAlias)->(dbSkip())
EndDo
(cAlias)->(DbCloseArea()) 

SUD->(DbSetOrder(1))
SUD->(DBSEEK(XFILIAL("SUD")+cChamado))

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + M->UC_CHAVE))

SB1->(DbSetOrder(1))

cOperador 	:= ALLTRIM(Posicione("SU7",1,xFilial("SU7")+M->UC_OPERADO,"U7_NOME"))
cNomeCli	:= ALLTRIM(SA1->A1_NOME)
cBairro		:= ALLTRIM(SA1->A1_END) + "  - " + ALLTRIM(SA1->A1_BAIRRO)
cPonto		:= ALLTRIM(SA1->A1_COMPLEM)
cCidade		:= ALLTRIM(SA1->A1_MUN)
cCEP		:= SA1->A1_CEP
cUF			:= SA1->A1_EST

cTelefone	:= "( " + AllTrim(SA1->A1_DDD)+ ")" +  AllTrim(SA1->A1_TEL) + ;
 					IIF(!Empty(SA1->A1_TEL2)  , "|(" + AllTrim(SA1->A1_DDD) + ")" + AllTrim(SA1->A1_TEL2) ,;
 					IIF(!Empty(SA1->A1_XTEL3) , "|(" + AllTrim(SA1->A1_DDD) + ")" + AllTrim(SA1->A1_XTEL3) , "" ))


oFontNeg:Bold		:= .T.
oFontNeg:Name		:= "Arial"
oFontNeg:nHeight	:= 14

oFontNor:Bold 		:= .F.
oFontNor:Name		:= "Arial"
oFontNor:nHeight	:= 14

oFontNor11:Bold 	:= .F.
oFontNor11:Name		:= "Arial"
oFontNor11:nHeight	:= 11

nWidthBMP	:= 300 //Largura do logo
nHeightBMP	:= 150 //Altura do logo
nRBoxTop	:= 50 //Indica a linha inicial do box principal
nCBoxTop	:= 20 //Indica a coluna inicial do box principal
nRBoxBot	:= 3000 //Indica a linha Final do box principal
nCBoxBot	:= 2400 //Indica a coluna final do box principal
cPxPrinc	:= "-2" //Valor padrao da espessura do box principal
nRowBMP		:= nRBoxTop + 10 //Linha inicial de impressao do logo (Utiliza como base a variavel nRBoxTop, que indica a coluna minima inicial do box.)
nColBMP		:= nCBoxTop + 20 // Coluna inicial de impressão do logo

oPDF	:= FWMsPrinter():New(cArqPDF,6,.T., ,.T., , , , ,.F., , .T., )

oPDF:StartPage()

oPDF:Box( nRBoxTop , nCBoxTop , nRBoxBot , nCBoxBot , cPxPrinc )// Box principal do laudo

//=================================================
aBox01		:= {nRBoxTop,;
				nCBoxTop  ,;
				nRBoxTop + 320 ,;
				nCBoxBot - 880}

aBox02		:= {aBox01[1],;
				aBox01[4],;
				aBox01[3],;
				aBox01[4] + (nCBoxBot - aBox01[4]) }

oPDF:Box( aBox01[1] , aBox01[2] , aBox01[3] , aBox01[4] , cPxPrinc )// Quadro referente ao responsavel pelo laudo tecnico/Atendimento
oPDF:Box( aBox02[1] , aBox02[2] , aBox02[3] , aBox02[4] , cPxPrinc )// Quadro referente ao numero do laudo

oPDF:SayBitmap( nRowBMP , nColBMP , cBmp , nWidthBMP , nHeightBMP )

//oPdf:Say(nLinImp := (aBox01[1] + 250) , nColImp := aBox01[02] + 20 , "Resp. pelo Atendimento : " + Posicione('SU7', 1 , xFilial('SU7') + SUC->UC_OPERADO, 'U7_NOME') , oFontNeg)
oPdf:Say(nLinImp := (aBox01[1] + 250) , nColImp := aBox01[02] + 20 , "Resp. pelo Atendimento : " + Posicione("SUL" , 1 ,xFilial("SUL") + SUC->UC_TIPO , "UL_DESC") , oFontNeg)
oPdf:Say(nLinImp + 50 , nColImp  , "Resp. pelo laudo técnico : " + aLaudo[1,8] , oFontNeg)

oPdf:Say(nLinImp	:= (aBox01[1] + 60) , nColImp	:= aBox02[2] + 200 , " Pedido de Assistência Técnica " , oFontNor)
oPdf:Say(nLinImp += 60 , nColImp  , "Komfort House Sofás" , oFontNor)
oPdf:Say(nLinImp += 60 , nColImp + 50 , "SAC: (11) 4343-3989" , oFontNor)
oPdf:Say(nLinImp += 60 , nColImp - 60 , "serviraocliente@komforthouse.com.br" , oFontNeg)
oPdf:Say(nLinImp + 60 , nColImp := aBox02[2] + 120, "Laudo técnico - nº: " + fCodLaudo(aLaudo,aAlter,nPosLaudo) , oFontNeg)

//=================================================

aBox03		:= {aBox02[3],;
				nCBoxTop,;
				aBox02[3] + 60,;
				nCBoxBot - 880 }

oPDF:Box( aBox03[1] , aBox03[2] , aBox03[3] , aBox03[4] , cPxPrinc )// Quadro referente a: Resolvido (Sim ou nao)

aBox04		:= {aBox03[1],;
				aBox03[4],;
				aBox03[3],;
				aBox03[4] + (nCBoxBot - aBox03[4]) }

oPDF:Box( aBox04[1] , aBox04[2] , aBox04[3] , aBox04[4] , cPxPrinc )// Quadro referente a: Data da visita

oPdf:Say(nLinImp := aBox03[1] + 30 , nColImp := aBox03[02] + 20  , "DATA DA VISITA : " + dToC(IIF(Empty(SUC->UC_XFOLLOW) , M->UC_XFOLLOW , SUC->UC_XFOLLOW)) , oFontNor)
oPdf:Say(nLinImp , nColImp := aBox04[2] + 20  , "DATA DE ABERTURA : " + dToC(SUC->UC_DATA) , oFontNor)

//=================================================
aBox05		:= {aBox04[3],;
				nCBoxTop,;
				aBox04[3] + 80,;
				nCBoxBot }

oPDF:Box( aBox05[1] , aBox05[2] , aBox05[3] , aBox05[4] , cPxPrinc )// Quadro referente a observacao

oPdf:Say(nLinImp := aBox05[1] + 40 , nColImp := aBox05[02] + 20  , "OBSERVAÇÃO: "  , oFontNor)

If Len(AllTrim(cObs)) > 0

	aObs	:= StrToKarr(cObs , "|")

	nLinImp := aBox05[1]

	For nX := 1 TO Len(aObs)

		cObs	:= aObs[nX]

		oPdf:Say(nLinImp += 40 , nColImp := aBox05[02] + 20  , IIF( nX == 1 , "OBSERVAÇÃO: " , "" )  + cObs , oFontNor)

	Next nX

EndIf

//=================================================

aBox06		:= {aBox05[3] - 1,;
				nCBoxTop,;
				aBox05[3] + 60,;
				nCBoxBot }

oPDF:Box( aBox06[1] , aBox06[2] , aBox06[3] , aBox06[4] , cPxPrinc )// Quadro referente ao endereco

oPdf:Say(nLinImp := aBox06[1] + 40 , nColImp := aBox06[02] + 20  , "ENDEREÇO: "  + cBairro  , oFontNor11)

//=================================================

aBox07		:= {aBox06[3] ,;
				nCBoxTop,;
				aBox06[3] + 60,;
				nCBoxBot - 880}

oPDF:Box( aBox07[1] , aBox07[2] , aBox07[3] , aBox07[4] , cPxPrinc )// Quadro referente ao cliente

aBox08		:= {aBox07[1],;
				aBox07[4],;
				aBox07[3] ,;
				aBox07[4] + (nCBoxBot - aBox07[4]) }

oPDF:Box( aBox08[1] , aBox08[2] , aBox08[3] , aBox08[4] , cPxPrinc )// Quadro referente ao complemento

cBairro := StrTran(cBairro , Space(2) , Space(1))

oPdf:Say(nLinImp := aBox07[1] + 40 , nColImp := aBox07[02] + 20  , "CLIENTE: " + cNomeCli  , oFontNor)

oPdf:Say(nLinImp := aBox08[1] + 40 , nColImp := aBox08[02] + 20  , "COMPLEMENTO / REF : " + cPonto  , oFontNor)

//=================================================

aBox09		:= {aBox08[3] ,;
				nCBoxTop,;
				aBox08[3] + 60,;
				nCBoxBot - 880 }

oPDF:Box( aBox09[1] , aBox09[2] , aBox09[3] , aBox09[4] , cPxPrinc )// Quadro referente a cidade

aBox10		:= {aBox09[1],;
				aBox09[4],;
				aBox09[3],;
				aBox09[4] + (nCBoxBot - (aBox09[4] + 400))}

oPDF:Box( aBox10[1] , aBox10[2] , aBox10[3] , aBox10[4] , cPxPrinc )// Quadro referente a cep

aBox11		:= {aBox10[1],;
				aBox10[4],;
				aBox10[3],;
				aBox10[4] + (nCBoxBot - aBox10[4])}

oPDF:Box( aBox11[1] , aBox11[2] , aBox11[3] , aBox11[4] , cPxPrinc )// Quadro referente a UF

oPdf:Say(nLinImp := aBox09[1] + 40 , nColImp := aBox09[02] + 20  , "CIDADE: " + cCidade  , oFontNor)

oPdf:Say(nLinImp := aBox10[1] + 40 , nColImp := aBox10[02] + 20  , "CEP : " + cCEP , oFontNor)

oPdf:Say(nLinImp := aBox11[1] + 40 , nColImp := aBox11[02] + 20  , "UF : " + cUF , oFontNor)

//=================================================

aBox12		:= {aBox11[3] ,;
				nCBoxTop,;
				aBox11[3] + 60,;
				nCBoxBot - 1300}

oPDF:Box( aBox12[1] , aBox12[2] , aBox12[3] , aBox12[4] , cPxPrinc )// Quadro referente ao telefone

aBox13		:= {aBox12[1],;
				aBox12[4],;
				aBox12[3] ,;
				aBox12[4] + (nCBoxBot - aBox12[4]) }

oPDF:Box( aBox13[1] , aBox13[2] , aBox13[3] , aBox13[4] , cPxPrinc )// Quadro referente ao chamado/protocolo

oPdf:Say(nLinImp := aBox12[1] + 40 , nColImp := aBox12[02] + 20  , "TELEFONE: " + cTelefone , oFontNor)

oPdf:Say(nLinImp := aBox13[1] + 40 , nColImp := aBox13[02] + 20  , "CHAMADO/PROTOCOLO : " + cChamado  , oFontNor)

//=================================================

aBox14		:= {aBox13[3] ,;
				nCBoxTop,;
				aBox13[3] + 60,;
				nCBoxBot - 1800 }

oPDF:Box( aBox14[1] , aBox14[2] , aBox14[3] , aBox14[4] , cPxPrinc )// Quadro referente ao pedido

aBox15		:= 	{aBox14[1],;
				aBox14[4],;
				aBox14[3],;
				aBox14[4] + (nCBoxBot - (aBox14[4] + 1000))}

oPDF:Box( aBox15[1] , aBox15[2] , aBox15[3] , aBox15[4] , cPxPrinc )// Quadro referente a nf

aBox16		:= {aBox15[1],;
				aBox15[4],;
				aBox15[3],;
				aBox15[4] + (nCBoxBot - aBox15[4])}

oPDF:Box( aBox16[1] , aBox16[2] , aBox16[3] , aBox16[4] , cPxPrinc )// Quadro referente a data de entrega

oPdf:Say(nLinImp := aBox14[1] + 40 , nColImp := aBox14[02] + 20  , "PEDIDO: " + cPedido )

oPdf:Say(nLinImp := aBox15[1] + 40 , nColImp := aBox15[02] + 20  , "NF DE VENDA : " + cNota)

oPdf:Say(nLinImp := aBox16[1] + 40 , nColImp := aBox16[02] + 20  , "DATA DE ENTREGA : " + dToC(aLaudo[1,3]) )

//=================================================
aBox17		:= {aBox16[3] ,;
				nCBoxTop,;
				aBox16[3] + 400,;
				nCBoxBot - 1600}

oPDF:Box( aBox17[1] , aBox17[2] , aBox17[3] , aBox17[4] , cPxPrinc )// Quadro referente ao Codigo

aBox18		:= {aBox17[1],;
				aBox17[4],;
				aBox17[3] ,;
				aBox17[4] + (nCBoxBot - aBox17[4]) }

oPDF:Box( aBox18[1] , aBox18[2] , aBox18[3] , aBox18[4] , cPxPrinc )// Quadro referente a DESCRIÇÃO

oPdf:Say(nLinImp := aBox17[1] + 40 , nColImp := aBox17[02] + 20  , "CÓDIGO: " )

oPdf:Say(aBox18[1] + 40 , aBox18[02] + 20  , "DESCRIÇÃO : " )

For nX := 1 TO Len(aProdutos)

	oPdf:Say(nLinImp += 40 , nColImp := aBox17[02] + 20  , aProdutos[nX , 1] , oFontNor11)

	oPdf:Say(nLinImp , nColImp := aBox18[02] + 20  , aProdutos[nX , 2] , oFontNor11)

Next nX

//=================================================
aBox19		:= {aBox18[3] ,;
				nCBoxTop,;
				aBox18[3] + 60,;
				nCBoxBot }

oPDF:Box( aBox19[1] , aBox19[2] , aBox19[3] , aBox19[4] , cPxPrinc )// Quadro referente ao defeito reclamado

oPdf:Say(nLinImp := aBox19[1] + 40 , nColImp := aBox19[02] + 1000 , "DEFEITO RECLAMADO : " )

//=================================================

aBox20		:= {aBox19[3] ,;
				nCBoxTop,;
				aBox19[3] + 100,;
				nCBoxBot }

oPDF:Box( nLinImp := aBox20[1] , nColImp := aBox20[2] , aBox20[3] , aBox20[4] , cPxPrinc )// Quadro referente a descrição dos defeitos

For nX := 1 TO Len(aDefeitos)

	oPdf:Say(nLinImp += 40 , nColImp := aBox19[02] + 20 , aDefeitos[nX] , oFontNor11)

Next nX

//=================================================
aBox21		:= {aBox20[3] ,;
				nCBoxTop,;
				aBox20[3] + 320,;
				nCBoxBot - 1199}

oPDF:Box( aBox21[1] , aBox21[2] , aBox21[3] , aBox21[4] , cPxPrinc )// Quadro referente a imagem do sofa (frente)

aBox22		:= {aBox21[1],;
				aBox21[4],;
				aBox21[3] ,;
				aBox21[4] + (nCBoxBot - aBox21[4]) }

oPDF:Box( aBox22[1] , aBox22[2] , aBox22[3] , aBox22[4] , cPxPrinc )// Quadro referente a imagem do sofa (parte traseira)

oPDF:SayBitmap( aBox21[1] + 10 , aBox21[2] + 200 , cSofaF , nWidthBMP := 800, nHeightBMP  := 300)

oPDF:SayBitmap( aBox21[1] + 10 , aBox22[2] + 200 , cSofaB , nWidthBMP , nHeightBMP )

//=================================================
aBox23		:= {aBox22[3] ,;
				nCBoxTop,;
				aBox22[3] + 60,;
				nCBoxBot }

oPDF:Box( aBox23[1] , aBox23[2] , aBox23[3] , aBox23[4] , cPxPrinc )// Quadro referente a "assinale em qual parte do produto esta(ao) o(s) defeito(s)"

oPdf:Say(nLinImp := aBox23[1] + 40 , nColImp := aBox23[02] + 600  , "ASSINALE ABAIXO EM QUAL PARTE DO PRODUTO SE LOCALIZA(M) O(S) DEFEITO(S): " , oFontNeg )

//================================================= Itens a assinalar
aBox24		:= {aBox23[3] + 40,;
				nCBoxTop  + 40,;
				aBox23[3] + 100,;
				0}

aBox24[4]	:= aBox24[2] + 100

oPDF:Box( aBox24[1] , aBox24[2] , aBox24[3] , aBox24[4] , cPxPrinc )// Poltrona

aBox25		:= {aBox24[1] ,;
				aBox24[4] + 350 ,;
				aBox24[3] ,;
				0}

aBox25[4]	:= aBox25[2] + 100

oPDF:Box( aBox25[1] , aBox25[2] , aBox25[3] , aBox25[4] , cPxPrinc )// Sofa Cama

aBox26		:= {aBox25[1] ,;
				aBox25[4] + 350 ,;
				aBox25[3] ,;
				0}

aBox26[4]	:= aBox26[2] + 100

oPDF:Box( aBox26[1] , aBox26[2] , aBox26[3] , aBox26[4] , cPxPrinc )// Forro

aBox27		:= {aBox26[1] ,;
				aBox26[4] + 350 ,;
				aBox26[3] ,;
				0}

aBox27[4]	:= aBox27[2] + 100

oPDF:Box( aBox27[1] , aBox27[2] , aBox27[3] , aBox27[4] , cPxPrinc )// Base dos pes

aBox28		:= {aBox27[1] ,;
				aBox27[4] + 350 ,;
				aBox27[3] ,;
				0}

aBox28[4]	:= aBox28[2] + 100

oPDF:Box( aBox28[1] , aBox28[2] , aBox28[3] , aBox28[4] , cPxPrinc )// Sofa Canto

aBox29		:= {aBox28[1] + 120,;
				nCBoxTop  + 40,;
				aBox28[3] + 120,;
				0}

aBox29[4]	:= aBox29[2] + 100

oPDF:Box( aBox29[1] , aBox29[2] , aBox29[3] , aBox29[4] , cPxPrinc )// Assento direito

aBox30		:= {aBox29[1],;
				aBox29[4]  + 350,;
				aBox29[3],;
				0}

aBox30[4]	:= aBox30[2] + 100

oPDF:Box( aBox30[1] , aBox30[2] , aBox30[3] , aBox30[4] , cPxPrinc )// braco direito

aBox31		:= {aBox30[1],;
				aBox30[4]  + 350,;
				aBox30[3],;
				0}

aBox31[4]	:= aBox31[2] + 100

oPDF:Box( aBox31[1] , aBox31[2] , aBox31[3] , aBox31[4] , cPxPrinc )// almofada/encosto

aBox32		:= {aBox31[1],;
				aBox31[4]  + 350,;
				aBox31[3],;
				0}

aBox32[4]	:= aBox32[2] + 100

oPDF:Box( aBox32[1] , aBox32[2] , aBox32[3] , aBox32[4] , cPxPrinc )// pes

aBox33		:= {aBox32[1],;
				aBox32[4]  + 350,;
				aBox32[3],;
				0}

aBox33[4]	:= aBox33[2] + 100

oPDF:Box( aBox33[1] , aBox33[2] , aBox33[3] , aBox33[4] , cPxPrinc )// tecido

aBox34		:= {aBox33[1] + 120,;
				nCBoxTop  + 40,;
				aBox33[3] + 120,;
				0}

aBox34[4]	:= aBox34[2] + 100

oPDF:Box( aBox34[1] , aBox34[2] , aBox34[3] , aBox34[4] , cPxPrinc )// Assento esquerdo

aBox35		:= {aBox34[1],;
				aBox34[4]  + 350,;
				aBox34[3],;
				0}

aBox35[4]	:= aBox35[2] + 100

oPDF:Box( aBox35[1] , aBox35[2] , aBox35[3] , aBox35[4] , cPxPrinc )// braco esquerdo

aBox36		:= {aBox35[1],;
				aBox35[4]  + 350,;
				aBox35[3],;
				0}

aBox36[4]	:= aBox36[2] + 100

oPDF:Box( aBox36[1] , aBox36[2] , aBox36[3] , aBox36[4] , cPxPrinc )// almofada ass.

aBox37		:= {aBox36[1],;
				aBox36[4]  + 350,;
				aBox36[3],;
				0}

aBox37[4]	:= aBox37[2] + 100

oPDF:Box( aBox37[1] , aBox37[2] , aBox37[3] , aBox37[4] , cPxPrinc )// caixa de encosto

aBox38		:= {aBox37[1],;
				aBox37[4]  + 350,;
				aBox37[3],;
				0}

aBox38[4]	:= aBox38[2] + 100

oPDF:Box( aBox38[1] , aBox38[2] , aBox38[3] , aBox38[4] , cPxPrinc )// retratil

oPdf:Say(nLinImp := aBox24[01] + 40 , nColImp := aBox24[04] + 20  , "POLTRONA " , oFontNor11 )

oPdf:Say(nLinImp := aBox25[01] + 40 , nColImp := aBox25[04] + 20  , "SOFA CAMA " , oFontNor11 )

oPdf:Say(nLinImp := aBox26[01] + 40 , nColImp := aBox26[04] + 20  , "FORRO " , oFontNor11 )

oPdf:Say(nLinImp := aBox27[01] + 40 , nColImp := aBox27[04] + 20  , "BASE DOS PÉS " , oFontNor11 )

oPdf:Say(nLinImp := aBox28[01] + 40 , nColImp := aBox28[04] + 20  , "SOFA CANTO" , oFontNor11 )

oPdf:Say(nLinImp := aBox29[01] + 40 , nColImp := aBox29[04] + 20  , "ASSENTO DIR." , oFontNor11 )

oPdf:Say(nLinImp := aBox30[01] + 40 , nColImp := aBox30[04] + 20  , "BRAÇO DIR." , oFontNor11 )

oPdf:Say(nLinImp := aBox31[01] + 40 , nColImp := aBox31[04] + 20  , "ALMOFADA/ENCOSTO" , oFontNor11 )

oPdf:Say(nLinImp := aBox32[01] + 40 , nColImp := aBox32[04] + 20  , "PÉS" , oFontNor11 )

oPdf:Say(nLinImp := aBox33[01] + 40 , nColImp := aBox33[04] + 20  , "TECIDO" , oFontNor11 )

oPdf:Say(nLinImp := aBox34[01] + 40 , nColImp := aBox34[04] + 20  , "ASSENTO ESQ." , oFontNor11 )

oPdf:Say(nLinImp := aBox35[01] + 40 , nColImp := aBox35[04] + 20  , "BRAÇO ESQ." , oFontNor11 )

oPdf:Say(nLinImp := aBox36[01] + 40 , nColImp := aBox36[04] + 20  , "ALMOFADA ASS." , oFontNor11 )

oPdf:Say(nLinImp := aBox37[01] + 40 , nColImp := aBox37[04] + 20  , "CAIXA DE ENCOSTO" , oFontNor11 )

oPdf:Say(nLinImp := aBox38[01] + 40 , nColImp := aBox38[04] + 20  , "RETRATIL" , oFontNor11 )

//=================================================
aBox39		:= {aBox38[3] + 20,;
				nCBoxTop,;
				aBox38[3] + 80,;
				nCBoxBot }

oPDF:Box( aBox39[1] , aBox39[2] , aBox39[3] , aBox39[4] , cPxPrinc )// Quadro referente a "DESCRIÇÃO DETALHADA DO PROBLEMA VISTORIADO PELO TÉCNICO"

oPdf:Say(nLinImp := aBox39[1] + 40 , nColImp := aBox39[02] + 700  , "DESCRIÇÃO DETALHADA DO PROBLEMA VISTORIADO PELO TÉCNICO" , oFontNeg )

//=================================================
aBox40		:= {aBox39[3] ,;
				nCBoxTop,;
				aBox39[3] + 380,;
				nCBoxBot }

oPDF:Box( aBox40[1] , aBox40[2] , aBox40[3] , aBox40[4] , cPxPrinc )// Quadro referente a "DESCRIÇÃO DETALHADA DO PROBLEMA VISTORIADO PELO TÉCNICO"

oPdf:Say(nLinImp := aBox40[3] + 60 , nColImp := aBox40[02] + 20  , "EU, ________________________________________________________portador do RG ____________________________ declaro que recebi " , oFontNeg )
oPdf:Say(nLinImp += 60 , nColImp  , "o técnico da Komfort House. Declaro ainda, que acompanhei a vistoria realizada estando ciente de que, se no momento da troca houver vícios " , oFontNeg )
oPdf:Say(nLinImp += 60 , nColImp  , "diversos do acima assinalados, a troca somente será realizada mediante o pagamento de 20% do valor do produto." , oFontNeg )

//=================================================	"TÉCNICO"
aBox41		:= {nLinImp + 20,;
				nCBoxTop,;
				nLinImp + 80,;
				nCBoxBot - 880 }

aBox42		:= {aBox41[1],;
				aBox41[4],;
				aBox41[3],;
				aBox41[4] + (nCBoxBot - aBox41[4]) }

oPDF:Box( aBox41[1] , aBox41[2] , aBox41[3] , aBox41[4] , cPxPrinc )// Quadro referente a "TÉCNICO"

oPDF:Box( aBox42[1] , aBox42[2] , aBox42[3] , aBox42[4] , cPxPrinc )// Resolvido Sim/nao

oPdf:Say(nLinImp := aBox41[1] + 30 , nColImp := aBox41[02] + 20  , "TÉCNICO : " , oFontNeg )

oPdf:Say(nLinImp := aBox42[1] + 30 , nColImp := aBox42[02] + 20 , "RESOLVIDO:  SIM  (       )    Não  (       )" , oFontNeg)

//=================================================
aBox43		:= {aBox42[3],;
				nCBoxTop,;
				aBox42[3] + 60,;
				nCBoxBot - 1240}

aBox44		:= {aBox43[1],;
				aBox43[4],;
				aBox43[3],;
				aBox43[4] + (nCBoxBot - aBox43[4]) - 1 }

oPDF:Box( aBox43[1] , aBox43[2] , aBox43[3] , aBox43[4] , cPxPrinc )// HORARIO DE ENTRADA

oPDF:Box( aBox44[1] , aBox44[2] , aBox44[3] , aBox44[4] , cPxPrinc )// HORARIO DE SAÍDA

oPdf:Say(nLinImp := aBox43[1] + 30 , nColImp := aBox43[02] + 20  , "HORÁRIO DE ENTRADA : " , oFontNeg )

oPdf:Say(nLinImp , nColImp := aBox44[02] + 20  , "HORÁRIO DE SAÍDA : " , oFontNeg )

oPdf:Say(nLinImp := aBox44[3] + 40 , nColImp := aBox43[02] + 20  , "ASSINATURA DO CLIENTE : " , oFontNeg )

//=================================================

fErase(cPathPDF+cArqPDF)

oPDF:cPathPDF	:= cPathPDF // Caso seja utilizada impressão em IMP_PDF

oPDF:Print()

oPDF:SetViewPDF(.T.)

lRet	:= .T.

Return lRet

/*
=====================================================================================
Programa.:              fRetOpe
Autor....:              Luis Artuso
Data.....:              17/01/2020
Descricao / Objetivo:
Doc. Origem:            Retorna o nome do usuario, que sera gravado no laudo tecnico
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function fRetOpe(cCodOpe)

	//Local cNomeOpe	:= RetCodUsr(cCodOpe)
	//Local cNomeOpe	:= UsrRetName(cCodOpe)

Return UsrRetName(cCodOpe)

/*
=====================================================================================
Programa.:              fCodLaudo
Autor....:              Luis Artuso
Data.....:              17/01/2020
Descricao / Objetivo:
Doc. Origem:            Retorna o codigo do laudo (sequencial)
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function fCodLaudo(aArray,aAlter,nPosLaudo)
	/*
		No array 'aArray', sao informados os produtos que serao impressos o laudo tecnico
		No array 'aAlter', são informadas as posicoes do array 'aCols' que terao o campo UD_XLAUDO gravados.
		Esta gravacao ocorrera desde seja impresso o primeiro laudo. Para reimpressoes, sera reutilizado o numero do laudo.
		O parametro 'nPosLaudo', informa em qual posicao do array 'aCols' esta o campo UD_XLAUDO.
	*/

	Local cQuery	:= ""
	Local cCodLaudo	:= ""
	Local cTMP01	:= "TMP01"
	Local cRet		:= ""
	Local aAreaSUD	:= SUD->(GetArea())
	Local nRecno	:= 0
	Local nX		:= 0

	cCodLaudo		:= aArray[1,7]

	If (Empty(cCodLaudo)) //Se nao foi gerado nenhum laudo para o produto

		cQuery		:= "SELECT MAX(SUD.UD_XLAUDO) CODIGO FROM " + RetSqlName("SUD") + " SUD "
		cQuery		+= " WHERE SUD.D_E_L_E_T_ = ' ' "

		cQuery		:= StrTran(cQuery , Space(2) , Space(1))

		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cTMP01 , .T. , .F.) //Verifica qual o ultimo laudo gerado

		cRet	:= AllTrim(StrZero(Val( (cTMP01)->CODIGO ) + 1 , 6)) // Acrescenta 1 ao ultimo numero de laudo gerado

		(cTMP01)->(dbCloseArea())

		For nX := 1 TO Len(aAlter)

			aCols[aAlter[nX] , nPosLaudo]	:= cRet //Altera o array 'aCols', para que o campo UD_XLAUDO seja gravado com o número do laudo

		Next nX

	Else

		cRet	:= cCodLaudo //reutiliza a numeracao anterior do laudo

	EndIf

	RestArea(aAreaSUD)

Return cRet