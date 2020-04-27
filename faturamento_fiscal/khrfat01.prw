
#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

#DEFINE ENTER CHR(13)+CHR(10)

User Function KHRFAT01()

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "KHRFAT01"+'.XLS'     
	Local aFields := {"C5_NUM","C5_EMISSAO","C5_XDTCAN","C5_XUSRCAN","C5_CLIENTE","A1_NOME","E1_NUM","E1_STATUS","E1_TIPO","E1_PARCELA","E1_VALOR"}
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local aCab := {}
    Local aItens := {}
    Local cTitle := "Pedidos Excluidos"

    cQuery := "SELECT C5_NUM AS PEDIDO, C5_EMISSAO AS EMISSAO," + ENTER
    cQuery += " CONVERT(VARCHAR,DATEADD(DAY,((ASCII(SUBSTRING(C5_USERLGA,12,1)) - 50) * 100 + (ASCII(SUBSTRING(C5_USERLGA,16,1)) - 50)),'19960101'),112) AS EXCLUSAO," + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 11,1)+SUBSTRING(C5_USERLGA, 15,1)+" + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 2, 1)+SUBSTRING(C5_USERLGA, 6, 1)+" + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 10,1)+SUBSTRING(C5_USERLGA, 14,1)+" + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 1, 1)+SUBSTRING(C5_USERLGA, 5, 1)+" + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 9, 1)+SUBSTRING(C5_USERLGA, 13,1)+" + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 17,1)+SUBSTRING(C5_USERLGA, 4, 1)+" + ENTER
    cQuery += " SUBSTRING(C5_USERLGA, 8, 1) USUARIO," + ENTER
    cQuery += " C5_CLIENTE AS CLIENTE," + ENTER
    cQuery += " A1_NOME AS NOME," + ENTER
    cQuery += " E1_NUM AS TITULO," + ENTER
    cQuery += " E1_STATUS AS STATUS_TITULO," + ENTER
    cQuery += " CASE" + ENTER
	cQuery += " WHEN C.D_E_L_E_T_ = '' THEN 'ATIVO'" + ENTER
	cQuery += " ELSE 'DELETADO'" + ENTER
    cQuery += " END AS STATUS_REGISTRO_TITULO," + ENTER
    cQuery += " E1_TIPO AS TIPO," + ENTER
    cQuery += " E1_PARCELA AS PARCELA," + ENTER
    cQuery += " E1_VALOR AS VALOR" + ENTER
    cQuery += " FROM "+ retSqlName("SC5")+ " A" + ENTER
    cQuery += " INNER JOIN "+ retSqlName("SA1")+" B ON A.C5_CLIENTE = B.A1_COD AND A.C5_LOJACLI = B.A1_LOJA" + ENTER
    cQuery += " INNER JOIN "+ retSqlName("SE1")+" C ON A.C5_NUM = C.E1_PEDIDO" + ENTER
    cQuery += " WHERE CONVERT(VARCHAR,DATEADD(DAY,((ASCII(SUBSTRING(C5_USERLGA,12,1)) - 50) * 100 + (ASCII(SUBSTRING(C5_USERLGA,16,1)) - 50)),'19960101'),112) > C5_EMISSAO" + ENTER
    cQuery += " AND C5_01TPOP = '1'" + ENTER
    cQuery += " AND A.D_E_L_E_T_ = '*'" + ENTER
    cQuery += " AND B.D_E_L_E_T_ = ''" + ENTER
    cQuery += " ORDER BY C5_NUM" + ENTER

    PLSQuery(cQuery, cAlias)

    While (cAlias)->(!eof())
        aAdd(aItens,{ (cAlias)->PEDIDO,;
                      (cAlias)->EMISSAO,; 
                      (cAlias)->EXCLUSAO,;
                      UsrRetName((cAlias)->USUARIO),;
                      (cAlias)->CLIENTE,;
                      (cAlias)->NOME,;
                      (cAlias)->TITULO,;
                      (cAlias)->STATUS_TITULO,;
                      (cAlias)->TIPO,;
                      (cAlias)->PARCELA,;
                      (cAlias)->VALOR,;
                      (cAlias)->STATUS_REGISTRO_TITULO })
        (cAlias)->(dbSkip())
    End
    
    (cAlias)->(DbCloseArea())

    if len(aItens) == 0
        Return(MsgAlert("Não existe pedidos excluidos fora do periodo!!","Atenção"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nX
	
    aAdd(aCab,{"Status_Registro_Titulo","STATUS_REG","",20,0,,"","C","","","","",,'V',,,})

    cNamePlan := cNameTable := cTitle

    oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)

	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		else // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		endif
	next nx

    for nx := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aItens[nx][1],;
											stod(aItens[nx][2]) ,;
											stod(aItens[nx][3]) ,;
											aItens[nx][4],;
                                            aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            aItens[nx][8],;
                                            aItens[nx][9],;
                                            aItens[nx][10],;
                                            aItens[nx][11],;
                                            aItens[nx][12];
											},{1,2,3,4,5,6,7,8,9,10,11,12})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open",  cArqTemp, "", "C:\", 1 )
	
Return