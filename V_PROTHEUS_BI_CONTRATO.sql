CREATE OR REPLACE VIEW V_PROTHEUS_BI_CONTRATO AS
SELECT
    trim(nt0.nt0_cod) AS "codigo_contrato",
    trim(nt0.nt0_nome) AS "contrato",
    (select nra.nra_desc from protheus.nra010 nra where nra.nra_cod = nt0.nt0_ctphon and nra.d_e_l_e_t_ = ' ' and rownum = 1) AS "modalidade_adicional",
    trim(nt0.nt0_cclien) || '-' || trim(nt0.nt0_cloja) AS "codigo_cliente",
    trim(sa1.a1_nreduz) as "cliente",
    -- substr(nt0.nt0_dtinc,7,2) || '/' || substr(nt0.nt0_dtinc,5,2) || '/' || substr(nt0.nt0_dtinc,1,4) AS "data_cadastro",
    nt0.nt0_dtinc AS "data_cadastro",
    -- to_char(nt0.nt0_dtinc, 'dd/MM/yyyy') as "data_cadastro",
    trim(acy.acy_grpven) grupo_codigo,
        trim(acy.acy_descri) grupo_nome,
        trim(sa1.a1_nome) cliente_razao_social,
        substr(sa1.a1_dtcad,7,2) || '/' || substr(sa1.a1_dtcad,5,2) || '/' || substr(sa1.a1_dtcad,1,4) AS cliente_data_cadastro,
        -- substr(sa1.a1_dtnasc,7,2) || '/' || substr(sa1.a1_dtnasc,5,2) || '/' || substr(sa1.a1_dtnasc,1,4) AS cliente_data_abertura,
        substr(NUH.NUH_DTEFT,7,2) || '/' || substr(NUH.NUH_DTEFT,5,2) || '/' || substr(NUH.NUH_DTEFT,1,4) AS cliente_data_efetivo,
        substr(nuh.nuh_dtenc,7,2) || '/' || substr(nuh.nuh_dtenc,5,2) || '/' || substr(nuh.nuh_dtenc,1,4) cliente_data_encerramento,
        (SELECT SYA.YA_DESCR FROM PROTHEUS.SYA010 SYA WHERE SYA.YA_CODGI = SA1.A1_PAIS and sya.d_e_l_e_t_ = ' ' and rownum = 1) CLIENTE_PAIS,
        -- sa1.a1_est CLIENTE_UF,
        -- TRIM(SA1.A1_MUN) CLIENTE_MUNICIPIO,
        -- TRIM(SA1.A1_BAIRRO) CLIENTE_BAIRRO,
        -- SA1.A1_CEP CLIENTE_CEP,
        -- TRIM(SA1.A1_END) || ' - ' || SA1.A1__NUM  CLIENTE_ENDERECO,
        -- TRIM(SA1.A1_COMPLEM) CLIENTE_COMPLEMENTO  ,
        CASE WHEN SA1.A1_TIPO = 'F' THEN 'NACIONAL' ELSE 'INTERNACIONAL' END CLIENTE_TIPO,
        -- CASE WHEN  SA1.A1_PESSOA = 'J' THEN 'JURIDICA' ELSE 'FISICA' END CLIENTE_PESSOA,
        -- CASE WHEN SA1.A1_PESSOA = 'J' THEN
        --  SUBSTR(SA1.A1_CGC,1,2) || '.'|| SUBSTR(SA1.A1_CGC,3,3)|| '.'|| SUBSTR(SA1.A1_CGC,6,3)|| '/'||SUBSTR(SA1.A1_CGC,9,3)|| '-'||SUBSTR(SA1.A1_CGC,13,2) ELSE
        --  SUBSTR(SA1.A1_CGC,1,3) || '.'|| SUBSTR(SA1.A1_CGC,4,3)|| '.'|| SUBSTR(SA1.A1_CGC,7,3)|| '-'||SUBSTR(SA1.A1_CGC,10,2) END
        -- "cliente_CNPJ/CPF",
        (SELECT AOV.AOV_DESSEG FROM PROTHEUS.AOV010 AOV WHERE AOV.AOV_CODSEG = SA1.A1_CODSEG and aov.d_e_l_e_t_ = ' ' and rownum = 1) CLIENTE_SEGMENTO,
        trim(sed.ed_descric) cliente_natureza,
        case sa1.a1_abatimp
          when '1' then 'Calculo do Sistema'
          when '2' then 'Efetua Retencao'
          when '3' then 'Nao Efetua Retencao'
        end cliente_status_impostos,
        case nuh.nuh_perfil
          when '1' then 'Cliente/Pagador'
          when '2' then 'Somente Pagador'
          when '3' then 'Nao-Cliente'
        end Cliente_perfil,
        case when sa1.a1_msblql = '1' then 'INATIVO' else 'ATIVO' end CLIENTE_STATUS,
        CASE WHEN NUH.NUH_SITCAD = '1' THEN 'POTENCIAL' ELSE 'EFETIVO' END CLIENTE_SITUACAO,
        CASE WHEN NUH.NUH_SITCAD = '1' THEN 'PROVISORIO' ELSE 'DEFINITIVO' END CLIENTE_CADASTRO,
        ns7.ns7_nome as CLIENTE_FILIAL,
        rd01.rd0_nome cliente_socio_nome,
        rd01.rd0_sigla "adv_cliente",
        NUH.NUH_CBANCO CLIENTE_BANCO,
        SA6.A6_NOME CLIENTE_BANCO_NOME,
        NUH.NUH_CAGENC CLIENTE_BANCO_AGENCIA,
        SA6.A6_NOMEAGE CLIENTE_BANCO_AGENCIA_NOME,
        NUH.NUH_CCONTA CLIENTE_CONTA_CORRENTE,
        PROTHEUS.FN_ULTIMA_FATURA_CLIENTE_DATA(SA1.A1_COD, SA1.A1_LOJA) CLIENTE_ULTIMA_FATURA,
        -- nt0.nt0__code codigo_externo,
        -- trim(nve.nve_numcas) caso_codigo,
        -- trim(nve.nve_titulo) caso_assunto,
        -- dbms_lob.substr(nve.NVE_OBSCAD,4000,1) caso_obs_cadastro,
        -- dbms_lob.substr(nve.NVE_OBSFAT,4000,1) caso_obs_faturamento,
        -- case when NVE_COBRAV = '1' then 'SIM' else 'NAO' end caso_cobravel,
        -- (select rev.rd0_sigla from protheus.rd0010 rev where rev.rd0_filial = nve.nve_filial and rev.rd0_codigo = nve.nve_cpart1 and rev.d_e_l_e_t_ = ' ') caso_revisor,
        -- (select rb.nrb_desc from protheus.nrb010 rb where rb.nrb_filial = nve.nve_filial and rb.nrb_cod = nve.nve_careaj and rb.d_e_l_e_t_ = ' 'and rownum = 1) Caso_area_juridica,
        (select rf.nrf_desc from protheus.nrf010 rf where rf.nrf_filial = nve.nve_filial and rf.nrf_cod = nve.nve_ctabh and rf.d_e_l_e_t_ = ' ' and rownum = 1) caso_tabela_honorario,
        (select LISTAGG(TRIM(TRIM(co.a1_nome)|| ';'  ) )  from protheus.vw_pagadores_contrato co where co.nxp_ccontr = nt0.nt0_cod and co.nxp_filial = nt0.nt0_filial) contrato_pagadores,
        trim(case when nt0.nt0_sit = '2' then 'DEFINITIVO' else 'PROVISORIO' end) AS contrato_situacao,
        trim(case when nt0.nt0_ATIVO = '2' then 'INATIVO' else 'ATIVO' end) AS contrato_status,
        case nt0.nt0_cmoeli
          when '01' then 'R$'
          when '02' then 'US$'
          when '03' then 'EUR'
        end contrato_Moeda_Limite ,
        nt0.nt0_vlrli contrato_valor_limite,
        substr(nt0.nt0_dtvigi,7,2) || '/' || substr(nt0.nt0_dtvigi,5,2) || '/' || substr(nt0.nt0_dtvigi,1,4) contrato_vigencia_inicial,
        substr(nt0.nt0_dtvigf,7,2) || '/' || substr(nt0.nt0_dtvigf,5,2) || '/' || substr(nt0.nt0_dtvigf,1,4) contrato_vigencia_final,
        dbms_lob.substr(nt0.nt0_obs,4000,1) AS contrato_observacoes,
        dbms_lob.substr(nt0.nt0__obsfa,4000,1) AS faturamento_observacoes,
        rd0.rd0_nome AS contrato_socio_resp_nome,
        rd0.rd0_sigla AS "matricula_funcionario",
        case nt0.nt0__code
          when '2' then 'EX-PROSPECT'
          when '3' then 'GUARDA CHUVA'
          when '4' then 'PRO-BONO'
          when '5' then 'CONTRATO ASSINADO'
          when '6' then 'ACEITE CLIENTE SEM CONTRATO'
          when '7' then 'CLUB'
          WHEN '8' THEN 'MINUTA DE CONTRATO'
          WHEN '9' THEN 'PROSPECT'
        end Contrato_status_Contratacao,
        PROTHEUS.FN_ULTIMA_FATURA_CONTRATO_DATA(SA1.A1_COD, SA1.A1_LOJA,  NT0.NT0_COD) CONTRATO_ULTIMA_FATURA,
        substr(nt0.nt0__dreaj,7,2) || '/' || substr(nt0.nt0__dreaj,5,2) || '/' || substr(nt0.nt0__dreaj,1,4) AS contrato_data_reajuste,
        nw5.nw5_desc contrato_indice_reajuste,
        VWC.VALOR_HONORARIOS_R$ CONTRATO_VL_HONORARIOS_R$,
        VWC.VALOR_DESPESAS_R$ CONTRATO_VL_DESPESAS_R$,
        VWC.VALOR_HONORARIOS_US$ CONTRATO_VL_HONORARIOS_US$,
        VWC.VALOR_DESPESAS_US$ VALOR_DESPESAS_US$,
        VWC.VALOR_HONORARIOS_EURO VALOR_HONORARIOS_EURO,
        VWC.VALOR_DESPESAS_EURO VALOR_DESPESAS_EURO,
        VWC.valor_TOTAL_honorario_r$ valor_TOTAL_honorario_r$,
        VWC.valor_TOTAL_despesas_r$ valor_TOTAL_despesas_r$
FROM protheus.nve010 nve
     left join protheus.nut010 nut on nut.nut_cclien = nve.nve_cclien and nut.nut_cloja = nve.nve_lclien and nut.nut_ccaso = nve.nve_numcas
     left join protheus.nt0010 nt0 on nut.nut_ccontr = nt0.nt0_cod
     -- left join protheus.nt0010 nt0 on nve.nve__contr = nt0.nt0_cod and nve.d_e_l_e_t_ = ' '
     LEFT JOIN protheus.vw_cst_contrato_faturamento_F VWC ON NT0.NT0_FILIAL = VWC.filial AND NT0.NT0_CCLIEN = VWC.cliente AND NT0.NT0_CLOJA = VWC.loja AND NT0.NT0_COD = VWC.contrato
     left join protheus.nw5010 nw5 on nt0.nt0_filial = nw5.nw5_filial and nt0.nt0__cindi = nw5.nw5_cod and nw5.d_e_l_e_t_ = ' '
     LEFT JOIN protheus.sa1010 sa1 ON nt0.nt0_filial = sa1.a1_filial and nt0.nt0_cclien = sa1.a1_cod and nt0.nt0_cloja = sa1.a1_loja and nt0.d_e_l_e_t_ = ' ' and sa1.a1_filial = ' '
     LEFT JOIN protheus.rd0010 rd0 ON rd0.rd0_filial = nt0.nt0_filial and rd0.rd0_codigo = nt0.nt0_cpart1 and rd0.d_e_l_e_t_ = ' '
     left join protheus.acy010 acy ON acy.acy_filial = nve.nve_filial and acy.acy_grpven =  nve.nve_cgrpcl and acy.d_e_l_e_t_ = ' '
     left join protheus.nrf010 nrf on nrf.nrf_filial = nve.nve_filial and  nrf.nrf_cod  = nve.nve_ctabh and nrf.d_e_l_e_t_ = ' '
     left join protheus.sed010 sed on sed.ed_codigo = sa1.a1_naturez and sed.d_e_l_e_t_ = ' '
     left join protheus.nuh010 nuh on sa1.a1_filial = nuh.nuh_filial and sa1.a1_cod = nuh.nuh_cod and sa1.a1_loja = nuh.nuh_loja and nuh.d_e_l_e_t_ = ' '
     left join protheus.rd0010 rd01 on rd01.rd0_filial = nuh.nuh_filial and rd01.rd0_codigo = nuh.nuh_cpart and rd01.d_e_l_e_t_ = ' '
     LEFT JOIN PROTHEUS.SA6010 SA6 ON NUH.NUH_CBANCO || NUH.NUH_CAGENC || NUH.NUH_CCONTA = SA6.A6_COD || SA6.A6_AGENCIA || SA6.A6_NUMCON AND SA6.D_E_L_E_T_ = ' '
     left join protheus.ns7010 ns7 on ns7.ns7_cod = nuh.nuh_cescr
     -- WHERE nve.nve_numcas = nt0.nt0_cod;
