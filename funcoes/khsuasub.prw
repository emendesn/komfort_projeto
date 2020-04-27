#include 'protheus.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE "TBICONN.CH"
 
//--------------------------------------------------------------
/*/{Protheus.doc} KHSUASUB
Description //Cria SUA E SUB
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington raul
@since 11/06/2019 /*/
//--------------------------------------------------------------
user function KHSUASUB(cPedido,cSuaNum)
    
    Local aArea := getArea()
    Local aCabec := {}
    Local aItens := {}
    Local aItensSUB := {}
    Local aCabecSUA := {}
    Local lExecAuto := superGetMv("KH_EXECSUA",.F.,.F.)
    

    Local lAvalCre 	:= .T.	// Avaliacao de Credito
    Local lBloqCre 	:= .F. 	// Bloqueio de Credito
    Local lAvalEst	:= .T.	// Avaliacao de Estoque
    Local lBloqEst	:= .T.	// Bloqueio de Estoque
    
    default cPedido := ""
    
    Private cRotina := "2"  //Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca
    Private lMsErroAuto := .F.
    private n :=0
    
    DbSelectArea("SC5")
    SC5->(DbSetOrder(1)) //C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_
    
    dbSelectArea("SC6")
    SC6->(DbSetOrder(1)) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
    
    if SC5->(DbSeek(xfilial()+ cPedido))
        aCabec := {   SC5->C5_NUM,;       //1
                      SC5->C5_CLIENTE,;   //2
                      SC5->C5_LOJACLI,;   //3
                      SC5->C5_CONDPAG,;   //4
                      SC5->C5_TRANSP,;    //5
                      SC5->C5_FRETE,;     //6
                      SC5->C5_DESPESA,;   //7
                      SC5->C5_TPCARGA,;   //8
                      SC5->C5_PEDPEND,;   //9
                      SC5->C5_EMISSAO;    //10
                  }
    else
        ConOut(Repl("-",80))
        ConOut(PadC("Pedido "+ cPedido + " Não Localizado."  ,80))
        ConOut(Repl("-",80))
        restArea(aArea)
        Return .F.
    endif

    nValorLiq := 0
 
    if SC6->(DbSeek(xFilial() + cPedido))
        while SC6->C6_NUM == cPedido
            aAdd(aItens,{;
                            SC6->C6_ITEM,;    //1
                            SC6->C6_PRODUTO,; //2
                            SC6->C6_QTDVEN,;  //3
                            SC6->C6_PRCVEN,;  //4
                            SC6->C6_VALOR,;   //5
                            SC6->C6_TES,;     //6
                            SC6->C6_CF,;      //7
                            SC6->C6_UM,;      //8 
                            SC6->C6_LOCAL,;   //9 
                            recno();  //10
                             })

            nValorLiq += SC6->C6_VALOR

        SC6->(Dbskip())
        end
    else
        ConOut(Repl("-",80))
        ConOut(PadC("Itens do Pedido "+ cPedido + " não foram Localizado."  ,80))
        ConOut(Repl("-",80))
        restArea(aArea)
        Return .F.
    endif

    nDesconto   := 0
    nFrete      := aCabec[6]
    nDespesa    := aCabec[7]

    nVlrBrut := nValorLiq
    nVlrMerc := nValorLiq
    nValorLiq += (nFrete + nDespesa)
    
    DbSelectArea("SA1")
    DbSetOrder(1)

    If !SA1->(DbSeek(xFilial("SA1") + aCabec[2] + aCabec[3]))
        ConOut(Repl("-",80))
        ConOut("Cliente: " + aCabec[2] + " Loja: " + aCabec[3] + " não foi localizado.")
        ConOut(Repl("-",80))
        Return .F.
    Else
        cCod        := SA1->A1_COD
        cLoja       := SA1->A1_LOJA
        cEndc       := SA1->A1_ENDCOB
        cBairroc    := SA1->A1_BAIRROC
        cMunc       := SA1->A1_MUNC
        cCepc       := SA1->A1_CEPC
        cCepe       := SA1->A1_CEPE
        cEstc       := SA1->A1_ESTC
        cEnde       := SA1->A1_ENDENT
        cBairroe    := SA1->A1_BAIRROE
        cMune       := SA1->A1_MUNE
        cEste       := SA1->A1_ESTE
        cTipoCli    := SA1->A1_TIPO
    Endif
      
    cNumSUA := cSuaNum

		      DbSelectArea("SUA")
		      SUA->(DbSetOrder(1))//UA_FILIAL, UA_NUM, R_E_C_N_O_, D_E_L_E_T_ 
		      If SUA->(DbSeek("0142"+cNumSUA))         
		        	recLock("SUA",.F.)
		        Else
		        	recLock("SUA",.T.)
		        EndIf
		            SUA->UA_FILIAL  := "0142"     //Verificar qual a filial deve ser incluida - lOJA VIRTUAL CRIADA 
		            SUA->UA_NUM     := cNumSUA  
		            SUA->UA_NUMSC5  := aCabec[1]
		            SUA->UA_CLIENTE := cCod     
		            SUA->UA_LOJA    := cLoja    
		            SUA->UA_OPERADO := "      "   //Codigo do Operador
		            SUA->UA_OPER    := "1"        //1-Faturamento 2-Orcamento 3-Atendimento
		            SUA->UA_TMK     := "4"        //1-Ativo 2-Receptivo
		            SUA->UA_CONDPG  := aCabec[4]  //Condicao de Pagamento
		            SUA->UA_TRANSP  := aCabec[5]  //Transportadora
		            SUA->UA_ENDCOB  := cEndc    
		            SUA->UA_BAIRROC := cBairroc 
		            SUA->UA_MUNC    := cMunc    
		            SUA->UA_CEPC    := cCepc    
		            SUA->UA_ESTC    := cEstc    
		            SUA->UA_ENDENT  := cEnde    
		            SUA->UA_BAIRROE := cBairroe 
		            SUA->UA_MUNE    := cMune    
		            SUA->UA_CEPE    := cCepe    
		            SUA->UA_ESTE    := cEste    
		            SUA->UA_PROSPEC := .F.
		            SUA->UA_VEND	:= "00874"      
		            SUA->UA_DESCONT := nDesconto
		            SUA->UA_FRETE   := nFrete   
		            SUA->UA_DESPESA := nDespesa 
		            SUA->UA_MIDIA   := "000001" 
		            SUA->UA_EMISSAO := aCabec[10]
		            SUA->UA_FORMPG  := "R$"     
		            SUA->UA_INICIO  := time()   
		            SUA->UA_FIM     := time()   
		            SUA->UA_VALBRUT := nVlrBrut 
		            SUA->UA_VALMERC := nVlrMerc 
		            SUA->UA_DTLIM   := DDATABASE
		            SUA->UA_VLRLIQ  := nValorLiq
		            SUA->UA_ENTRADA := 0
		            SUA->UA_PARCELA := 0
		            SUA->UA_FINANC  := nVlrBrut
		            SUA->UA_MOEDA   := 1      
		            SUA->UA_TPCARGA := aCabec[8]
		            SUA->UA_TIPOCLI := cTipoCli 
		            SUA->UA_PEDPEND := aCabec[9]
		            //SUA->UA_01FILIA"   ,""         //Descrição da filial
		            SUA->UA_XPERLIB := 0
		            SUA->(msUnlock())
		
		        	    For nx := 1 To len(aItens)
		                DbSelectArea("SUB")
		                SUB->(DbSetOrder(1))//UB_FILIAL, UB_NUM, UB_ITEM, UB_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
		                If SUB->(DbSeek("0142"+cNumSUA+aItens[nx][1]+aItens[nx][2])) 
		                	recLock("SUB",.F.)
		                Else
		                	recLock("SUB",.T.)
		                EndIf 
		               
		                SUB->UB_FILIAL  := "0142" // LOJA VIRTUAL CRIADA
		                SUB->UB_NUM     := cNumSUA 
		                SUB->UB_ITEM    := aItens[nx][1]
		                SUB->UB_PRODUTO := aItens[nx][2]
		                SUB->UB_QUANT   := aItens[nx][3]
		                SUB->UB_VRUNIT  := aItens[nx][4]
		                SUB->UB_VLRITEM := aItens[nx][5]
		                SUB->UB_TES     := aItens[nx][6]
		                SUB->UB_CF      := aItens[nx][7]
		                SUB->UB_MOSTRUA := "1"          
		                SUB->UB_DESC    := 0            
		                SUB->UB_VALDESC := 0            
		                SUB->UB_LOCAL   := aItens[nx][9]          //INFORMAR O ARMAZEM DO ECOMMERCE
		                SUB->UB_01DESCL := Posicione('NNR',1,xFilial('NNR')+aItens[nx][9],'NNR_DESCRI')   //DESCRIÇÃO DO ARMAZEM
		                SUB->UB_UM      := aItens[nx][8]
		                SUB->UB_DTENTRE := ddatabase    
		                SUB->UB_DTVALID := ddatabase    
		                SUB->UB_CONDENT  := "2"          
		                SUB->UB_TPENTRE := "3"          
		            SUB->(msUnlock())
		                                
		        next nx
                ConfirmSx8()
		      
    restArea(aArea)

Return cNumSUA
	
