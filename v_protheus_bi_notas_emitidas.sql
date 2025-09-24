create or replace view v_protheus_bi_notas_emitidas as
select consulta."filial",
       consulta."nome_chave",
       consulta."cliente",
       consulta."codigo_cliente",
       consulta."grupo_empresa",
       LISTAGG(consulta."codigo_contrato", ' / ') within group (order by consulta."codigo_contrato") as "codigo_contrato",
       LISTAGG(consulta."contrato", ' / ') as "contrato",
       consulta."pagador",
       consulta."pais",
       consulta."codigo_pagador",
       consulta."advogado_responsavel",
       consulta."sigla_responsavel",
       consulta."numero_nota",
       consulta."numero_nota_protheus",
       consulta."ramo_atividade",
       consulta."tabela_honorarios",
       consulta."moeda_tabela",
       consulta."advogado_contrato",
       consulta."sigla_adv_contrato",
       consulta."moeda",
       consulta."valor_bruto",
       consulta."valor_liquido",
       consulta."impostos",
       consulta."valor_despesas",
       consulta."descontos",
       consulta."moeda_capa_nota",
       consulta."valor_capa_nota",
       consulta."data_emissao",
       consulta."ano_emissao",
       consulta."mes_emissao",
       consulta."data_vencimento",
       consulta."ano_vencimento",
       consulta."mes_vencimento",
       consulta."data_cancelamento",
       consulta."ano_cancelamento",
       consulta."mes_cancelamento",
       consulta."tipo_nota",
       consulta."cnpj_cpf",
       consulta."nota_situacao",
       consulta."exito_sucumbencia"
from ( select
        trim(ns7.ns7_nome) as "filial",
        -- ns7.ns7_cod nxa_cescr,
        trim(sa1.a1_nreduz) as "nome_chave",
        trim(sa1.a1_nome) as "cliente",
        trim(sa1.a1_cod) || '-' || trim(sa1.a1_loja) as "codigo_cliente",
        nvl((select trim(acy.acy_descri) from protheus.acy010 acy where acy.acy_grpven = sa1.a1_grpven and acy.d_e_l_e_t_ = ' '),' ') as "grupo_empresa",
        trim(nt0.nt0_cod) as "codigo_contrato",
        nt0.nt0_nome AS "contrato",
        trim(aa1.a1_nome) as "pagador",
        trim(nxa.nxa_pais) as "pais",
        trim(aa1.a1_cod) || '-' || trim(aa1.a1_loja) as "codigo_pagador",
        trim(rd0.rd0_nome) as "advogado_responsavel",
        trim(rd0.rd0_sigla) as "sigla_responsavel",
        nxa.nxa__lm as "numero_nota",
        nxa.nxa_cod as "numero_nota_protheus",
        trim(nvl((select aov.aov_desseg from protheus.aov010 aov where aov.aov_codseg = sa1.a1_codseg),' ')) as "ramo_atividade",
        (select nrf.nrf_desc from protheus.nrf010 nrf where nrf.nrf_cod = nuh.nuh_ctabh) as "tabela_honorarios",
        case (select nrf.nrf_moeda from protheus.nrf010 nrf where nrf.nrf_cod = nuh.nuh_ctabh)
             when '01' then 'R$'
             when '02' then 'US$'
             when '03' then 'EUR'
        end as "moeda_tabela",
        trim(rr0.rd0_nome) as "advogado_contrato",
        trim(rr0.rd0_sigla) as "sigla_adv_contrato",
        case nxa.nxa_cmoeda
            when '01' then 'R$'
            when '02' then 'US$'
            when '03' then 'EUR'
        end as "moeda",
        nxa.nxa_vlfath  as "valor_bruto",
        (nxa.nxa_vlfath + nxa.nxa_vlfatd) - (nxa.nxa_pis + nxa.nxa_cofins + nxa.nxa_csll + nxa.nxa_irrf + nxa.nxa_iss + nxa.nxa_inss + nxa.nxa_vldesc) as "valor_liquido",
        (nxa.nxa_pis + nxa.nxa_cofins + nxa.nxa_csll + nxa.nxa_irrf + nxa.nxa_iss + nxa.nxa_inss) as "impostos",
        nxb.nxb_vlfatd as "valor_despesas",
        nxa.nxa_vldesc as "descontos",
        /* Desconsiderar o proporcional para esta view.
      case
          when nxa.nxa_situac = '1' then
            case
              when (nxb.nxb_vlfath + nxb.nxb_vlfatd) > 0 then
                case
                  when (nxa.nxa_vlfath + nxa.nxa_vlfatd) > 0 then
                  (nxa.nxa_vlfath + nxa.nxa_vlfatd) *  (((nxb.nxb_vlfath + nxb.nxb_vlfatd) * 100) / (nxa.nxa_vlfath + nxa.nxa_vlfatd) / 100)
                end
            end
        end as "valor_bruto_proporcional",*/
        case nxa.nxa_cmoeda
            when '01' then 'R$'
            when '02' then 'US$'
            when '03' then 'EUR'
        end as "moeda_capa_nota",
        nxa.nxa_vlfath  as "valor_capa_nota",
        to_char(substr(nxa.nxa_dtemi,7,2) || '/' || substr(nxa.nxa_dtemi,5,2)|| '/' || substr(nxa.nxa_dtemi,1,4)) as "data_emissao",
        to_char(substr(nxa.nxa_dtemi,1,4)) as "ano_emissao",
        to_char(substr(nxa.nxa_dtemi,5,2)) as "mes_emissao",
        to_char(substr(nxa.nxa_dtvenc,7,2) || '/' || substr(nxa.nxa_dtvenc,5,2)|| '/' || substr(nxa.nxa_dtvenc,1,4)) as "data_vencimento",
        to_char(substr(nxa.nxa_dtvenc,1,4)) as "ano_vencimento",
        to_char(substr(nxa.nxa_dtvenc,5,2)) as "mes_vencimento",
        to_char(substr(nxa.nxa_dtcanc,7,2) || '/' || substr(nxa.nxa_dtcanc,5,2)|| '/' || substr(nxa.nxa_dtcanc,1,4)) as "data_cancelamento",
        to_char(substr(nxa.nxa_dtcanc,1,4)) as "ano_cancelamento",
        to_char(substr(nxa.nxa_dtcanc,5,2)) as "mes_cancelamento",
        case
           when nxa.nxa_vlfatd > 0 then 'DESPESAS'
           else 'HONORARIOS'
        end as "tipo_nota",
        case
            when length(trim(nxa.nxa_cgccpf)) = 14 then
               substr(nxa.nxa_cgccpf,1,2) || '.'|| substr(nxa.nxa_cgccpf,3,3)|| '.'|| substr(nxa.nxa_cgccpf,6,3)|| '/'||substr(nxa.nxa_cgccpf,9,3)|| '-'||substr(nxa.nxa_cgccpf,13,2)
            else
               substr(nxa.nxa_cgccpf,1,3) || '.'|| substr(nxa.nxa_cgccpf,4,3)|| '.'|| substr(nxa.nxa_cgccpf,7,3)|| '-'||substr(nxa.nxa_cgccpf,10,2)
        end "cnpj_cpf",
        case when nxa.nxa_situac = '1' then 'ATIVA' else 'CANCELADA' end "nota_situacao",
        nr9.nr9_desc as "exito_sucumbencia"
     -- protheus.fn_quantidade_contrato_fat(nxa.nxa_filial, nxa.nxa_cescr, nxa.nxa_cod) qtd_contratos,
     -- nxa.r_e_c_n_o_,
     -- nxa.nxa_capa,
     -- nxa.nxa_ctipof,
     -- nr9.nr9_desc,
     -- nxa.nxa_txtfat,
     -- nra.nra_desc as dados_adicionais
     -- nxb.nxb_vlfath + nxb.nxb_vlfatd as valor_contrato,
     -- trim(aa1.a1_nreduz) as cliente__nome,
     -- trim(nxa.nxa_cod) as numero_nota,
     -- trim(nxa.nxa__lm) as numero_nota_lm,
     -- nxb.nxb_drate as descontos,
     -- nxa.nxa_pis as valor_pis,
     -- nxa.nxa_cofins as valor_cofins,
     -- nxa.nxa_csll as valor_csll,
     -- nxa.nxa_irrf as valor_irrf,
     -- nxa.nxa_iss as valor_iss,
     -- nxa.nxa_inss as valor_inss,
     from protheus.nxa010 nxa
     left join protheus.ns7010 ns7 on nxa.nxa_filial = ns7.ns7_filial and nxa.nxa_cescr = ns7.ns7_cod and nxa.d_e_l_e_t_= ' ' and ns7.d_e_l_e_t_ = ' '
     left join protheus.sa1010 sa1 on nxa.nxa_filial = sa1.a1_filial  and nxa.nxa_cclien = sa1.a1_cod and nxa.nxa_cloja = sa1.a1_loja and sa1.d_e_l_e_t_ = ' '
     left join protheus.nuh010 nuh on sa1.a1_filial = nuh.nuh_filial  and sa1.a1_cod = nuh.nuh_cod and sa1.a1_loja = nuh.nuh_loja and nuh.d_e_l_e_t_ = ' '
     left join protheus.rd0010 rd0 on nuh.nuh_cpart = rd0.rd0_codigo and rd0.d_e_l_e_t_ = ' '
     left join protheus.sa1010 aa1 on nxa.nxa_filial = sa1.a1_filial  and nxa.nxa_clipg = aa1.a1_cod and nxa.nxa_lojpg = aa1.a1_loja and aa1.d_e_l_e_t_ = ' '
     left join protheus.nxb010 nxb on nxa.nxa_filial = nxb.nxb_filial and nxa.nxa_cescr = nxb.nxb_cescr and nxa.nxa_cod = nxb.nxb_cfatur and nxb.d_e_l_e_t_ = ' '
     left join protheus.nt0010 nt0 on nt0.nt0_cod = nxb.nxb_ccontr and nt0.d_e_l_e_t_ = ' '
     -- left join protheus.nt0010 nt0 on nt0.nt0_cod = nxa.nxa_ccontr and nt0.d_e_l_e_t_ = ' '
     -- left join protheus.nt0010 nt0 on nxb.nxb_filial = nt0.nt0_filial and nxb.nxb_ccontr = nt0.nt0_cod and nxb.nxb_cclien = nt0.nt0_cclien and nxb.nxb_cloja = nt0.nt0_cloja and nt0.d_e_l_e_t_ = ' ' and rownum <= 1
     left join protheus.rd0010 rr0 on rr0.rd0_filial = nt0.nt0_filial and rr0.rd0_codigo = nt0.nt0_cpart1 and rr0.d_e_l_e_t_ = ' '
     left join protheus.nr9010 nr9 on nxa.nxa_ctipof = nr9.nr9_cod
     left join protheus.nra010 nra on nra.nra_cod = nt0.nt0_ctphon and nra.d_e_l_e_t_ = ' '
     where nxa.nxa_vlfatd = 0
     and nxa.nxa_situac = '1'
     AND NXA.NXA_TIPO <> 'MF'
     -- and nxa.nxa_cod like '000003710'
     order by nxb.r_e_c_n_o_) consulta
       group by (
        consulta."filial",
        consulta."nome_chave",
        consulta."cliente",
        consulta."codigo_cliente",
        consulta."grupo_empresa",
        consulta."pagador",
        consulta."pais",
        consulta."codigo_pagador",
        consulta."advogado_responsavel",
        consulta."sigla_responsavel",
        consulta."numero_nota",
        consulta."numero_nota_protheus",
        consulta."ramo_atividade",
        consulta."tabela_honorarios",
        consulta."moeda_tabela",
        consulta."advogado_contrato",
        consulta."sigla_adv_contrato",
        consulta."moeda",
        consulta."valor_bruto",
        consulta."valor_liquido",
        consulta."impostos",
        consulta."valor_despesas",
        consulta."descontos",
        consulta."moeda_capa_nota",
        consulta."valor_capa_nota",
        consulta."data_emissao",
        consulta."ano_emissao",
        consulta."mes_emissao",
        consulta."data_vencimento",
        consulta."ano_vencimento",
        consulta."mes_vencimento",
        consulta."data_cancelamento",
        consulta."ano_cancelamento",
        consulta."mes_cancelamento",
        consulta."tipo_nota",
        consulta."cnpj_cpf",
        consulta."nota_situacao",
        consulta."exito_sucumbencia");
