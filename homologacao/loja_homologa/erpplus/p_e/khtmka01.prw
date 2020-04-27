#INCLUDE 'Protheus.ch'
#INCLUDE "TBICONN.CH"
 
//--------------------------------------------------------------
/*/{Protheus.doc} KHTMKA01
Description //Geração automatica das tabelas SUA e SUB - Televendas
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 11/06/2019 /*/
//--------------------------------------------------------------
User Function KHTMKA01(cPedido)
    
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
   
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Incluir atendimentos do televendas   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ConOut("Inicio: " +Time())
    
    cNumSUA := GetSxeNum("SUA","UA_NUM")


    aCabecSUA := {}
    
    if lExecAuto

        AADD(aCabecSUA,{"UA_FILIAL"    ,"0142"         ,Nil})  //Verificar qual a filial deve ser incluida - LOJA VIRTUAL
        AADD(aCabecSUA,{"UA_NUM"       ,cNumSUA        ,Nil})
        AADD(aCabecSUA,{"UA_NUMSC5"    ,aCabec[1]      ,Nil})
        AADD(aCabecSUA,{"UA_CLIENTE"   ,cCod           ,Nil})
        AADD(aCabecSUA,{"UA_LOJA"      ,cLoja          ,Nil})
        AADD(aCabecSUA,{"UA_OPERADO"   ,"      "       ,Nil})  //Codigo do Operador
        AADD(aCabecSUA,{"UA_OPER"      ,"1"            ,Nil})  //1-Faturamento 2-Orcamento 3-Atendimento
        AADD(aCabecSUA,{"UA_TMK"       ,"4"            ,Nil})  //1-Ativo 2-Receptivo
        AADD(aCabecSUA,{"UA_CONDPG"    ,aCabec[4]      ,Nil})  //Condicao de Pagamento
        AADD(aCabecSUA,{"UA_TRANSP"    ,aCabec[5]      ,Nil})  //Transportadora
        AADD(aCabecSUA,{"UA_ENDCOB"    ,cEndc          ,Nil})
        AADD(aCabecSUA,{"UA_BAIRROC"   ,cBairroc       ,Nil})
        AADD(aCabecSUA,{"UA_MUNC"      ,cMunc          ,Nil})
        AADD(aCabecSUA,{"UA_CEPC"      ,cCepc          ,Nil})
        AADD(aCabecSUA,{"UA_ESTC"      ,cEstc          ,Nil})
        AADD(aCabecSUA,{"UA_ENDENT"    ,cEnde          ,Nil})
        AADD(aCabecSUA,{"UA_BAIRROE"   ,cBairroe       ,Nil})
        AADD(aCabecSUA,{"UA_MUNE"      ,cMune          ,Nil})
        AADD(aCabecSUA,{"UA_CEPE"      ,cCepe          ,Nil})
        AADD(aCabecSUA,{"UA_ESTE"      ,cEste          ,Nil})
        AADD(aCabecSUA,{"UA_PROSPEC"   ,"F"            ,Nil})
        AADD(aCabecSUA,{"UA_DESCONT"   ,nDesconto      ,Nil})
        AADD(aCabecSUA,{"UA_FRETE"     ,nFrete         ,Nil})
        AADD(aCabecSUA,{"UA_DESPESA"   ,nDespesa       ,Nil})
        AADD(aCabecSUA,{"UA_MIDIA"     ,"000001"       ,Nil})
        AADD(aCabecSUA,{"UA_EMISSAO"   ,aCabec[10]     ,Nil})
        AADD(aCabecSUA,{"UA_FORMPG"    ,"R$"           ,Nil})
        AADD(aCabecSUA,{"UA_INICIO"    ,time()         ,Nil})
        AADD(aCabecSUA,{"UA_FIM"       ,time()         ,Nil})
        AADD(aCabecSUA,{"UA_VALBRUT"   ,nVlrBrut       ,Nil})
        AADD(aCabecSUA,{"UA_VALMERC"   ,nVlrMerc       ,Nil})
        AADD(aCabecSUA,{"UA_DTLIM"     ,DDATABASE      ,Nil})
        AADD(aCabecSUA,{"UA_VLRLIQ"    ,nValorLiq      ,Nil})
        AADD(aCabecSUA,{"UA_ENTRADA"   ,DDATABASE      ,Nil})
        AADD(aCabecSUA,{"UA_PARCELA"   ,DDATABASE      ,Nil})
        AADD(aCabecSUA,{"UA_FINANC"    ,DDATABASE      ,Nil})
        AADD(aCabecSUA,{"UA_MOEDA"     ,"1"            ,Nil})
        AADD(aCabecSUA,{"UA_TPCARGA"   ,aCabec[8]      ,Nil})
        AADD(aCabecSUA,{"UA_TIPOCLI"   ,cTipoCli       ,Nil})
        AADD(aCabecSUA,{"UA_PEDPEND"   ,aCabec[9]      ,Nil})
    //AADD(aCabecSUA,{"UA_01FILIA"   ,""             ,Nil})  //Descrição da filial
        AADD(aCabecSUA,{"UA_XPERLIB"   ,0              ,Nil})

        aItensSUB := {}

        For nx := 1 To len(aItens)
            
            aLinha := {}
            
            AADD(aLinha,{"UB_ITEM"      ,aItens[nx][1]  ,Nil})
            AADD(aLinha,{"UB_PRODUTO"   ,aItens[nx][2]  ,Nil})
            AADD(aLinha,{"UB_QUANT"     ,aItens[nx][3]  ,Nil})
            AADD(aLinha,{"UB_VRUNIT"    ,aItens[nx][4]  ,Nil})
            AADD(aLinha,{"UB_VLRITEM"   ,aItens[nx][5]  ,Nil})
            AADD(aLinha,{"UB_TES"       ,aItens[nx][6]  ,Nil})
            AADD(aLinha,{"UB_CF"        ,aItens[nx][7]  ,Nil})
            AADD(aLinha,{"UB_MOSTRUA"   ,"1"            ,Nil})
            AADD(aLinha,{"UB_DESC"      ,0              ,Nil})
            AADD(aLinha,{"UB_VALDESC"   ,0              ,Nil})
            AADD(aLinha,{"UB_LOCAL"     ,aItens[nx][9]  ,Nil}) //ARMAZEM DO ECOMMERCE CRIADO
            AADD(aLinha,{"UB_01DESCL"   ,Posicione('NNR',1,xFilial('NNR')+aItens[nx][9],'NNR_DESCRI')  ,Nil}) //DESCRIÇÃO DO ARMAZEM
            AADD(aLinha,{"UB_UM"        ,aItens[nx][8]  ,Nil})
            AADD(aLinha,{"UB_DTENTRE"   ,ddatabase      ,Nil})
            AADD(aLinha,{"UB_DTVALID"   ,ddatabase      ,Nil})
            AADD(aLinha,{"UB_CONENT"    ,"2"            ,Nil})
            AADD(aLinha,{"UB_TPENTRE"   ,"3"            ,Nil})

            AADD(aItensSUB,aLinha)
        Next nx

        //TMKA271(aCabecSUA,aItensSUB,3,cRotina)
        
        n := len(aItensSUB) 
        SetModulo("SIGATMK",'TMK') 
        TMKA271(aCabecSUA,aItensSUB,3,cRotina)
        //MSExecAuto({|x,y,z,w| TMKA271(x,y,z,w)},aCabecSUA,aItensSUB,3,'2') 

        If !lMsErroAuto
            ConOut("Atendimento "+ SUA->UA_NUM +" incluído com sucesso!")
            //alert("Atendimento "+ SUA->UA_NUM +" incluído com sucesso!")
            ConfirmSx8()
        Else
            RollbackSx8()
            ConOut("Erro na inclusão!")
            Mostraerro()
            DisarmTransaction()
            restArea(aArea)
            Break
        Endif
    
    else
    

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
		 EndIf
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
		        For zx := 1 To len(aItens)
         
		        	U_fSBF(cPedido,aItens[zx][1],aItens[zx][2],aItens[zx][9],aItens[zx][3])
			
		        next zx 	  
   
   

    ConOut("Fim  : "+Time())
    restArea(aArea)

Return cNumSUA