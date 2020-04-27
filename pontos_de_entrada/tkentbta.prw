//--------------------------------------------------------------
/*/{Protheus.doc} NomeDaFuncao
Description //Ponto-de-Entrada: TKENTBTA - Opção Altera na janela de seleção de entidades
//                                          Este ponto de entrada é executado na opção Altera da janela de seleção de entidades, 
//                                          onde sua finalidade é permitir que o  usuário faça validações antes da abertura do cadastro da entidade.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
User Function TKENTBTA()

	Local _cEntidade := ParamIxb[1]
	Local _cCodigo   := ParamIxb[2]
	Local _cLoja     := ParamIxb[3]

    local aArea := getArea()

    Private aCpos := {  "A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3",;
    					"A1_CONTATO","A1_EMAIL","A1_COMPLEM","A1_NOME","A1_NREDUZ","A1_XHISTCR","A1_XFILMAT",;
    					"A1_XNTRAB","A1_XENDTRB","A1_XDTADM","A1_XCARGO","A1_XVLRSAL","A1_XDDDTC","A1_XTELCML","A1_XNRAMAL",;
    					"A1_DDDTELR","A1_XTELREC","A1_XCNTREC","A1_XHISTCR","A1_DDDTR1","A1_TELREC1","A1_DDDTR2",;
    					"A1_TELREC2","A1_XSCOR","A1_XPASPC","A1_XQTRES","A1_XVLTRE","A1_XOCUPA","A1_XNATUR","A1_XNONJG ",;
    					"A1_XCPFJG","A1_XCARJG","A1_XADMJG","A1_XSALJG","A1_XNEMJG","A1_XDDDJG","A1_XFONJG","A1_XDDDCJG",;
    					"A1_FOEMJG","A1_XPAREC","A1_XAUTJG","A1_CGC","A1_DTNASC","A1_XCPFJU","A1_DDDSPC3","A1_TELSCP3","A1_XINADIN","A1_ENDENT",;
    					"A1_XIDADE","A1_XESTCIV","A1_XNOMERC","A1_XCPFRC","A1_XGPARRC","A1_XDDDRC","A1_XTELRC","A1_XEMPRC","A1_XDTARC",;
    					"A1_XCARGRC","A1_XDDDERC","A1_XTEMPRC","A1_XHOLER","A1_XCBANC","A1_XCENDER","A1_XDOCPES","A1_XIMPREN","A1_XENDGO",;
    					"A1_XENDSPC","A1_XANCRED","A1_XDANALI","A1_BAIRROE","A1_COMPENT","A1_01MUNEN","A1_MUNE","A1_ESTE","A1_CEPE","A1_PFISICA",;
                        "A1_RENCOM","A1_DTNCOM","A1_TELSPC","A1_CNPJEMP","A1_SCREMP","A1_XTEMLR","A1_XMORADI" }
	
    Private cCadastro := "Cadastro de Clientes - Alteração de Cadastro"
    
    dbSelectArea("SA1")
    SA1->(dbSetOrder(1)) //A1_FILIAL, A1_COD, A1_LOJA, R_E_C_N_O_, D_E_L_E_T_

    if SA1->(dbSeek(xFilial()+_cCodigo+_cLoja))
        AxAltera("SA1",SA1->(Recno()),4,,aCpos)
    endif

    restArea(aArea)

Return .F.