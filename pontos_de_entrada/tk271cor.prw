#include "protheus.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} TK271COR
Description //Define a Lengenda das Rotinas (TeleMarketing, Televendas e Telecobranca)
@param xParam Parameter //Opção da pasta selecionada (1=TeleMarketing, 2=Televendas e 3=Telecobranca)
@return xRet Return //array com as legendas definidas
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function TK271COR(cPasta)
	
	Local aArea := getArea()
	Local cOpcao := cPasta
	Local aCores := {}
	
	Do Case
		Case cOpcao == "1" //TeleMarketing -> 1
			aCores := {{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 2)" , "BR_VERMELHO" },;	// Pendente --> Padrão
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 3)" , "BR_VERDE"   },;	// Encerrado --> Padrão
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 1)" , "BR_AZUL"    },;	// Planejada --> Padrão
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 4)" , "BR_AMARELO" },;	// Em Andamento --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 5)" , "BR_LARANJA" },;	// Visita Tec --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 6)" , "BR_PINK"    },;	// Devolucao --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 7)" , "BR_BRANCO"  },;	// Retorno --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 8)" , "BR_VIOLETA" },;	// Troca Aut --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 9)" , "BR_AZUL_CLARO"},;	// Email Fab --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 10)" , "BR_VERDE_ESCURO"},;	// Foto --> Customizado Komfort	 					
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 11)" , "BR_MARRON"},;	// Canc/Bloqueado --> Customizado Komfort
						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 12)" , "BR_MARRON_OCEAN"},;	// Canc/Liberado --> Customizado Komfort
						{"(!EMPTY(SUC->UC_CODCANC))","BR_PRETO"		}} 								  	// Cancelado --> Padrão
		
		Case cOpcao == "2" //Televendas -> 2
			aCores := {{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" , "BR_VERDE"   },;	// Faturamento - VERDE --> Padrão
						{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))", "BR_VERMELHO"},;// Faturado - VERMELHO --> Padrão
						{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"	, "BR_AZUL"   },;						// Orcamento - AZUL --> Padrão
						{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"	, "BR_MARRON" },; 						// Atendimento - MARRON --> Padrão
						{"(!EMPTY(SUA->UA_CODCANC))","BR_PRETO"		}} 														// Cancelado --> Padrão
		
		Case cOpcao == "3" //Telecobranca -> 3
			aCores := {{"(EMPTY(ACF->ACF_CCANC) .AND. VAL(ACF->ACF_STATUS) == 1)",	"BR_AZUL"		},;	// Atendimento --> Padrão
						{"(EMPTY(ACF->ACF_CCANC) .AND. VAL(ACF->ACF_STATUS) == 2)",	"BR_VERDE"		},;	// Cobranca --> Padrão
						{"(EMPTY(ACF->ACF_CCANC) .AND. VAL(ACF->ACF_STATUS) == 3)",	"BR_VERMELHO"	},;	// Encerrado --> Padrão
						{"(!EMPTY(ACF->ACF_CCANC))",								"BR_CINZA"		}}	// Cancelado --> Padrão
	endCase

	restArea(aArea)

Return aCores