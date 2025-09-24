CREATE OR REPLACE VIEW V_PROTHEUS_BI_PROFISSIONAIS AS
SELECT
    TRIM(R.RD0_CODIGO) as "fun_ide",
    TRIM(R.RD0_NOME) as "nome",
    TRIM(R.RD0_SIGLA) as "matricula",
    (SELECT RN.NRN_DESC FROM PROTHEUS.NRN010 RN WHERE RN.NRN_COD = RU.NUR_CCAT) as "cargo",
    TRIM((select s7.ns7_nome from protheus.ns7010 s7 where s7.ns7_cod = Ru.Nur_Cescr)) as "filial",
    TRIM((SELECT c.ctt_desc01 FROM PROTHEUS.CTT010 C WHERE C.CTT_CUSTO = R.RD0_CC)) as "equipe",
    CASE WHEN R.RD0_DTADMI = ' ' THEN R.RD0_DTADMI ELSE
         SUBSTR(R.RD0_DTADMI,7,2) || '/' || SUBSTR(R.RD0_DTADMI,5,2)  || '/' || SUBSTR(R.RD0_DTADMI,1,4) END as "data_admissao",
    CASE WHEN R.RD0_DTADMI = ' ' THEN R.RD0_DTADMI ELSE
         SUBSTR(R.RD0_DTADMI,1,4) END as "ano_admissao",
    CASE WHEN R.RD0_DTADMI = ' ' THEN R.RD0_DTADMI ELSE
         SUBSTR(R.RD0_DTADMI,5,2) END as "mes_admissao",
    CASE WHEN R.RD0_DTADEM = ' ' THEN R.RD0_DTADEM ELSE
         SUBSTR(R.RD0_DTADEM,7,2) || '/' || SUBSTR(R.RD0_DTADEM,5,2)  || '/' || SUBSTR(R.RD0_DTADEM,1,4) END as "data_desligamento",
    CASE WHEN R.RD0_DTADEM = ' ' THEN R.RD0_DTADEM ELSE
         SUBSTR(R.RD0_DTADEM,1,4) END as "ano_demissao",
    CASE WHEN RD0_DTADEM = ' ' THEN R.RD0_DTADEM ELSE
         SUBSTR(R.RD0_DTADEM,5,2) END as "mes_demissao",
    CASE WHEN R.RD0_DTADMI = ' ' THEN R.RD0_DTADMI ELSE
         SUBSTR(R.RD0_DTADMI,7,2) || '/' || SUBSTR(R.RD0_DTADMI,5,2)  || '/' || SUBSTR(R.RD0_DTADMI,1,4) END AS "data_cargo_ini",
    CASE WHEN R.RD0_DTADEM = ' ' THEN R.RD0_DTADEM ELSE
         SUBSTR(R.RD0_DTADEM,7,2) || '/' || SUBSTR(R.RD0_DTADEM,5,2)  || '/' || SUBSTR(R.RD0_DTADEM,1,4) END as "data_cargo_fin",
    case when r.rd0_msblql = '1' then 'INATIVO' else 'ATIVO' end "status",
    /* CASE
        WHEN r.rd0_msblql = 0 THEN NULL
        ELSE
            CASE
                WHEN R.RD0_DTADEM IS NOT NULL THEN R.RD0_DTADEM - R.RD0_DTADMI
                ELSE (select current_date from dual) - to_date(R.RD0_DTADMI)
            END
    END AS "dias_ativos", */
    ' ' AS "dias_ativos",
    ' '  AS "anos_ativos",
    SUBSTR(R.RD0_CIC,1,3) || '.' ||SUBSTR(R.RD0_CIC,4,3) || '.' ||SUBSTR(R.RD0_CIC,7,3) || '-' || SUBSTR(R.RD0_CIC,10,2) as "cpf", -- 4 02.01-CPF
    TRIM(R.RD0__RG) || ' / ' || TRIM(R.RD0__RDGRG) as "RG / Orgao emissor", -- 5 02.02-RG / ORGAO EMISSOR
    TRIM(R.RD0__PIS) as "PIS/PASEP", -- 6 02.04-PIS/PASEP
    TRIM(RU.NUR_OAB) || ' / ' || NUR__DOAB as "OAB / Estado / Data Registro", -- 10 02.06-OAB / ESTADO / DATA REGISTRO
    TRIM(R.RD0__CTPS) AS "OAB / Estado / Data Registro - CTPS",  -- 18 02.06-CTPS
    TRIM(R.RD0__GRPS) AS "Grupo Sanguineo e Fator RH", -- 19 06.02-GRUPO SANGUINEO E FATOR RH
    TRIM(R.RD0__TITUL) AS "Titulo de Eleitor / Zona / Secao", -- 22 02.05-TITULO DE ELEITOR / ZONA / SEC?O
    SUBSTR(R.RD0_DTNASC,7,2) || '/' || SUBSTR(R.RD0_DTNASC,5,2)  || '/' || SUBSTR(R.RD0_DTNASC,1,4) AS "Data Nascimento Completa", --27 01.01-DATA DE NASCIMENTO
    SUBSTR(R.RD0_DTNASC,7,2) as "dia_nascimento",
    SUBSTR(R.RD0_DTNASC,5,2) as "mes_nascimento",
    SUBSTR(R.RD0_DTNASC,1,4) as "ano_nascimento",
    R.RD0__GRAUE as "Grau de Escolaridade", -- 28 03.01-GRAU DE ESCOLARIDADE
    CASE R.RD0__ECIV
          WHEN '1' THEN 'SOLTEIRO(A)'
          WHEN '2' THEN 'CASADO(A)'
          WHEN '3' THEN 'DIVORCIADO(A)'
          WHEN '4' THEN 'SEPARADO(A)'
          WHEN '5' THEN 'VIUVO(A)'
          WHEN '6' THEN 'AMANCIADO(A)'
          WHEN '7' THEN 'UNIAO ESTAVEL'
    END as "Estado Civil", -- 29 01.02-ESTADO CIVIL
    trim(RD0_NUMCEL) as "celular",
    R.RD0__NACIO as "Nacionalidade", -- 30 01.04-NACIONALIDADE
    R.RD0__PLSAU as "Plano de Saude", -- 31 06.01-PLANO DE SAUDE
    R.RD0__EMERG as "Contato de Emergencia 1", -- 32 06.03-CONTATO DE EMERGENCIA 1  + 33 06.04-CONTATO DE EMERGENCIA 2
    ' ' as "Contato de Emergencia 2",
    R.RD0__IUTIL as "Informacoes uteis", --34 99.01-INFORMAC?ES UTEIS
    R.RD0__HPREF as "Hospitais de Preferencia", -- 35 06.06-HOSPITAIS DE PREFERENCIA
    R.RD0__PSAUD as "Problemas de Saude", -- 36 06.05-PROBLEMAS DE SAUDE
    R.RD0__CARGO as "Cargo 1", -- 37 99.02-CARGO 1
    ' ' as "Cargo 2",
    -- R.RD0__BAC as "Banco / Ag / Conta Corrente", -- 40 05.01-BANCO / AG / CONTA CORRENTE
    TRIM(FIL.FIL_BANCO) || ' / ' || TRIM(FIL.FIL_AGENCI) || ' / ' || TRIM(FIL.FIL_CONTA) || '-' || TRIM(FIL.FIL_DVCTA) AS "Banco / Ag / Conta Corrente",
    R.RD0__NATD as "naturalidade", -- 41 01.03-NATURALIDADE
    R.RD0__PAI as "pai", -- 42 01.05-PAI
    R.RD0__MAE as "mae", -- 43 01.06-MAE
    R.RD0__INST2 as "instituicao", -- 44 03.02-INSTITUIC?O SUPERIOR
    R.RD0__DEPE as "N Dependentes", -- 45 01.07-N? DEPENDENTES
    R.RD0__CINS2 as "curso", -- 46 03.03-CURSO
    R.RD0__MATR MATRICULA, -- 47 03.04-MATRICULA
    R.RD0__PERIO as "periodo", -- 48 03.05-PERIODO
    R.RD0__VTRAN as "Vale Transporte", -- 49 04.01-VALE TRANSPRTE
    R.RD0__EDESD as "Estagio:Vencimento Contrato", --50 07.01-ESTAGIO:VENCIMENTO CONTRATO
    R.RD0__EDES1 as "Estagio:Vencimento Aditivo 1", --51 07.02-ESTAGIO:VENCIMENTO ADITIVO 1
    R.RD0__EDES2 as "Estagio:Vencimento Aditivo 2", --52 07.03-ESTAGIO:VENCIMENTO ADITIVO 2
    R.RD0__EDES3 as "Estagio:Vencimento Aditivo 3", --53 07.04-ESTAGIO:VENCIMENTO ADITIVO 3
    R.RD0__PESXP as "Periodo de Experi¿ncia (90 dias) vcto", --54 07.05-PERIODO DE EXPERIENCIA (90 DIAS) VCTO
    R.RD0__DTEXA as "Exame Medico (anual) vcto", --55 07.06-EXAME MEDICO (ANUAL) VCTO
    R.RD0__FERIN as "Ferias:Data Inicial", -- 56 07.07-FERIAS:DATA INICIAL
    R.RD0__FERFI as "Ferias:Data Limite", -- 57 07.08-FERIAS:DATA LIMITE
    R.RD0__DTASS as "Dt Ativacao Assistencia Medica", -- 58 07.09-DT ATIVAC?O ASSISTENCIA MEDICA
    ' ' as "trainee",
    R.RD0__DINS2 as "Data de Conclusao", -- 60 03.06-DATA DE CONCLUS?O SUPERIOR
    RU.NUR__OEMI as "oab_desde", -- 61 02.07-OAB_DESDE
    CASE R.RD0_SEXO
         WHEN 'M' THEN 'MASCULINO'
         WHEN 'F' THEN 'FEMININO'
     ELSE 'ANONIMIZADO'
      END AS "sexo" , -- 62 01.08-SEXO
    R.RD0__BCO2 as "Banco / Ag / Conta Corrente - CC-02", -- 63 05.02-BANCO / AG / CONTA CORRENTE
    R.RD0__BCO3 as "Banco / Ag / Conta Corrente - CC-03", -- 64 05.03-BANCO / AG / CONTA CORRENTE
    R.RD0__INST1 AS "Instituicao Ensino Medio", -- 65 03.07-INSTITUIC?O ENSINO MEDIO
    R.RD0__CINS3 AS "Pos Graduacao", -- 66 03.08-POS GRADUAC?O
    R.RD0__INST3 as "Instituicao Pos Graduacao", -- 67 03.09-INSTITUIC?O POS GRADUAC?O
    R.RD0__CINS4 as "mestrado", -- 68 03.10-MESTRADO
    R.RD0__INST4 AS "Instituicao Mestrado", -- 69 03.11-INSTITUIC?O MESTRADO
    R.RD0__DCPOS AS "Data de Conclusao de Pos Graduacao", -- 70 03.08.1-DATA DE CONCLUS?O DE POS GRADUAC?O
    R.RD0__DINS4 AS "Data de Conclusao do Mestrado", -- 71 03.10.1-DATA DE CONCLUS?O DA MESTRADO
    CASE WHEN R.RD0__LGPD = '1' THEN 'SIM' ELSE 'NAO' END AS "Aceite - LGPD", -- 72 01.00-ACEITE LGPD
    RD0_END AS "logradouro",
    RD0_NUMEND as "numero",
    RD0_CMPEND as "complemento",
    RD0_BAIRRO as "bairro",
    RD0_CEP as "cep",
    RD0_MUN as "cidade",
    RD0_UF as "estado",
    ' ' as "pais",
    R.RD0_EMAILC as "email_kincaid",
    R.RD0_EMAIL as "email_pessoal",
    (SELECT MAX(SUBSTR(W.NUS_AMINI,1,4) || '-'||SUBSTR(W.NUS_AMINI,5,2)) FROM PROTHEUS.NUS010 W WHERE W.NUS_CPART = RD0_CODIGO AND W.D_E_L_E_T_ = ' ') ANO_MES_HISTORICO,
    RU.NUR_USERAD USUARIO_AD,
    SUBSTR(RU.NUR_HRDIAD,1,2) || ':' ||  SUBSTR(RU.NUR_HRDIAD,3,2) HORAS_DISPONIVEIS_DIA,
    R.RD0__INST5 AS "Instituição Ensino Superior 2",
    R.RD0__CIN11 AS "Curso Ensino Superior 2",
    R.RD0_INST6 AS "Instituição Ensino Superior 3",
    R.RD0__CINS6 AS "Curso Ensino Superior 3",
    R.RD0__INST7 AS "Instituição Pós Graduação 2",
    R.RD0__CINS7 AS "Curso Pós Graduação 2",
    R.RD0__INST8 as "Instituição Pós Graduação 3",
    R.RD0__CINS8 as "Curso Pós Graduação 3",
    R.RD0__INST9 as "Instituição Mestrado 2",
    R.RD0__CINS9 as "Curso Mestrado 2"
FROM PROTHEUS.RD0010 R
LEFT JOIN PROTHEUS.NUR010 RU ON RU.NUR_CPART = R.RD0_CODIGO AND R.RD0_FILIAL = RU.NUR_FILIAL AND RU.D_E_L_E_T_ = ' '
LEFT JOIN PROTHEUS.FIL010 FIL ON R.RD0_SIGLA = FIL.FIL_FORNEC AND FIL.D_E_L_E_T_ = ' '
 WHERE
 R.D_E_L_E_T_ = ' ';
