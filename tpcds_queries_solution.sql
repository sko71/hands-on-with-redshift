-- These tpc-ds queries have been edited slightly from the output of dsdqgen program.

-- start query 34 in stream 0 using template query34.tpl
-- referencing store_sales_dist,date_dim_all,store_all,household_demographics_all
select c_last_name
       ,c_first_name
       ,c_salutation
       ,c_preferred_cust_flag
       ,ss_ticket_number
       ,cnt from
   (select ss_ticket_number
          ,ss_customer_sk
          ,count(*) cnt
    from store_sales_dist,date_dim_all,store_all,household_demographics_all
    where store_sales_dist.ss_sold_date_sk = date_dim_all.d_date_sk
    and store_sales_dist.ss_store_sk = store_all.s_store_sk
    and store_sales_dist.ss_hdemo_sk = household_demographics_all.hd_demo_sk
    and (date_dim_all.d_dom between 1 and 3 or date_dim_all.d_dom between 25 and 28)
    and (household_demographics_all.hd_buy_potential = '501-1000' or
         household_demographics_all.hd_buy_potential = '0-500')
    and household_demographics_all.hd_vehicle_count > 0
    and (case when household_demographics_all.hd_vehicle_count > 0
	then household_demographics_all.hd_dep_count/ household_demographics_all.hd_vehicle_count
	else null
	end)  > 1.2
    and date_dim_all.d_year in (1998,1998+1,1998+2)
    and store_all.s_county in ('Williamson County','Ziebach County','Ziebach County','Williamson County',
                           'Ziebach County','Ziebach County','Ziebach County','Ziebach County')
    group by ss_ticket_number,ss_customer_sk) dn,customer
    where ss_customer_sk = c_customer_sk
      and cnt between 15 and 20
    order by c_last_name,c_first_name,c_salutation,c_preferred_cust_flag desc, ss_ticket_number;

-- start query 11 in stream 0 using template query11.tpl
--Find customers whose increase in spending was large over the web than in stores this year compared to last
--year.
-- referencing customer_all and date_dim_all

with year_total as (
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,c_preferred_cust_flag customer_preferred_cust_flag
       ,c_birth_country customer_birth_country
       ,c_login customer_login
       ,c_email_address customer_email_address
       ,d_year dyear
       ,sum(ss_ext_list_price-ss_ext_discount_amt) year_total
       ,'s' sale_type
 from customer_all
     ,store_sales
     ,date_dim_all
 where c_customer_sk = ss_customer_sk
   and ss_sold_date_sk = d_date_sk
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,c_preferred_cust_flag
         ,c_birth_country
         ,c_login
         ,c_email_address
         ,d_year
 union all
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,c_preferred_cust_flag customer_preferred_cust_flag
       ,c_birth_country customer_birth_country
       ,c_login customer_login
       ,c_email_address customer_email_address
       ,d_year dyear
       ,sum(ws_ext_list_price-ws_ext_discount_amt) year_total
       ,'w' sale_type
 from customer_all
     ,web_sales
     ,date_dim_all
 where c_customer_sk = ws_bill_customer_sk
   and ws_sold_date_sk = d_date_sk
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,c_preferred_cust_flag
         ,c_birth_country
         ,c_login
         ,c_email_address
         ,d_year
         )
  select
                  t_s_secyear.customer_id
                 ,t_s_secyear.customer_first_name
                 ,t_s_secyear.customer_last_name
                 ,t_s_secyear.customer_birth_country
 from year_total t_s_firstyear
     ,year_total t_s_secyear
     ,year_total t_w_firstyear
     ,year_total t_w_secyear
 where t_s_secyear.customer_id = t_s_firstyear.customer_id
         and t_s_firstyear.customer_id = t_w_secyear.customer_id
         and t_s_firstyear.customer_id = t_w_firstyear.customer_id
         and t_s_firstyear.sale_type = 's'
         and t_w_firstyear.sale_type = 'w'
         and t_s_secyear.sale_type = 's'
         and t_w_secyear.sale_type = 'w'
         and t_s_firstyear.dyear = 1998
         and t_s_secyear.dyear = 1998+1
         and t_w_firstyear.dyear = 1998
         and t_w_secyear.dyear = 1998+1
         and t_s_firstyear.year_total > 0
         and t_w_firstyear.year_total > 0
         and case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else 0.0 end
             > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else 0.0 end
 order by t_s_secyear.customer_id
         ,t_s_secyear.customer_first_name
         ,t_s_secyear.customer_last_name
         ,t_s_secyear.customer_birth_country
;

- start query 11 in stream 0 using template query11.tpl
--Find customers whose increase in spending was large over the web than in stores this year compared to last
--year.
-- referencing customer_all, date_dim_all, store_sales_dist_sort and web_sales_dist_sort

with year_total as (
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,c_preferred_cust_flag customer_preferred_cust_flag
       ,c_birth_country customer_birth_country
       ,c_login customer_login
       ,c_email_address customer_email_address
       ,d_year dyear
       ,sum(ss_ext_list_price-ss_ext_discount_amt) year_total
       ,'s' sale_type
 from customer_all
     ,store_sales_dist_sort
     ,date_dim_all
 where c_customer_sk = ss_customer_sk
   and ss_sold_date_sk = d_date_sk
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,c_preferred_cust_flag
         ,c_birth_country
         ,c_login
         ,c_email_address
         ,d_year
 union all
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,c_preferred_cust_flag customer_preferred_cust_flag
       ,c_birth_country customer_birth_country
       ,c_login customer_login
       ,c_email_address customer_email_address
       ,d_year dyear
       ,sum(ws_ext_list_price-ws_ext_discount_amt) year_total
       ,'w' sale_type
 from customer_all
     ,web_sales_dist_sort
     ,date_dim_all
 where c_customer_sk = ws_bill_customer_sk
   and ws_sold_date_sk = d_date_sk
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,c_preferred_cust_flag
         ,c_birth_country
         ,c_login
         ,c_email_address
         ,d_year
         )
  select
                  t_s_secyear.customer_id
                 ,t_s_secyear.customer_first_name
                 ,t_s_secyear.customer_last_name
                 ,t_s_secyear.customer_birth_country
 from year_total t_s_firstyear
     ,year_total t_s_secyear
     ,year_total t_w_firstyear
     ,year_total t_w_secyear
 where t_s_secyear.customer_id = t_s_firstyear.customer_id
         and t_s_firstyear.customer_id = t_w_secyear.customer_id
         and t_s_firstyear.customer_id = t_w_firstyear.customer_id
         and t_s_firstyear.sale_type = 's'
         and t_w_firstyear.sale_type = 'w'
         and t_s_secyear.sale_type = 's'
         and t_w_secyear.sale_type = 'w'
         and t_s_firstyear.dyear = 1998
         and t_s_secyear.dyear = 1998+1
         and t_w_firstyear.dyear = 1998
         and t_w_secyear.dyear = 1998+1
         and t_s_firstyear.year_total > 0
         and t_w_firstyear.year_total > 0
         and case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else 0.0 end
             > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else 0.0 end
 order by t_s_secyear.customer_id
         ,t_s_secyear.customer_first_name
         ,t_s_secyear.customer_last_name
         ,t_s_secyear.customer_birth_country
;

-- query 57
--Find the item brands and categories for each call center and their monthly sales figures for a specified year,
-- where the monthly sales figure deviated more than 10% of the average monthly sales for the year, sorted by
-- deviation and call center. Report the sales deviation from the previous and following month.

-- query 57 (edited)
-- query referencing item_all, date_dim_all , call_center_all
select i_category, i_brand, cc_name, d_year, d_moy,
        sum(cs_sales_price) sum_sales,
        avg(sum(cs_sales_price)) over
          (partition by i_category, i_brand,
                     cc_name, d_year)
          avg_monthly_sales,
        rank() over
          (partition by i_category, i_brand,
                     cc_name
           order by d_year, d_moy) rn
from item_all, catalog_sales, date_dim_all , call_center_all
where cs_item_sk = i_item_sk and
       cs_sold_date_sk = d_date_sk and
       cc_call_center_sk= cs_call_center_sk
group by i_category, i_brand,
          cc_name , d_year, d_moy;


-- query 57 (edited)
-- query referencing catalog_sales_dist, item_all, date_dim_all , call_center_all
select i_category, i_brand, cc_name, d_year, d_moy,
          sum(cs_sales_price) sum_sales,
          avg(sum(cs_sales_price)) over
            (partition by i_category, i_brand,
                        cc_name, d_year)
                    avg_monthly_sales,
            rank() over
            (partition by i_category, i_brand,
                      cc_name
             order by d_year, d_moy) rn
from item_all, catalog_sales_dist, date_dim_all , call_center_all
where cs_item_sk = i_item_sk and
       cs_sold_date_sk = d_date_sk and
       cc_call_center_sk= cs_call_center_sk
group by i_category, i_brand,
          cc_name , d_year, d_moy;
