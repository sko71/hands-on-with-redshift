-- start query 34 in stream 0 using template query34.tpl
-- Display all customers with specific buy potentials and whose dependent count to vehicle count ratio is larger
-- than 1.2, who in three consecutive years made purchases with between 15 and 20 items in the beginning or the
-- end of each month in stores located in 8 counties.
select c_last_name
       ,c_first_name
       ,c_salutation
       ,c_preferred_cust_flag
       ,ss_ticket_number
       ,cnt from
   (select ss_ticket_number
          ,ss_customer_sk
          ,count(*) cnt
    from store_sales,date_dim,store,household_demographics
    where store_sales.ss_sold_date_sk = date_dim.d_date_sk
    and store_sales.ss_store_sk = store.s_store_sk
    and store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
    and (date_dim.d_dom between 1 and 3 or date_dim.d_dom between 25 and 28)
    and (household_demographics.hd_buy_potential = '501-1000' or
         household_demographics.hd_buy_potential = '0-500')
    and household_demographics.hd_vehicle_count > 0
    and (case when household_demographics.hd_vehicle_count > 0
	then household_demographics.hd_dep_count/ household_demographics.hd_vehicle_count
	else null
	end)  > 1.2
    and date_dim.d_year in (1998,1998+1,1998+2)
    and store.s_county in ('Williamson County','Ziebach County','Ziebach County','Williamson County',
                           'Ziebach County','Ziebach County','Ziebach County','Ziebach County')
    group by ss_ticket_number,ss_customer_sk) dn,customer
    where ss_customer_sk = c_customer_sk
      and cnt between 15 and 20
    order by c_last_name,c_first_name,c_salutation,c_preferred_cust_flag desc, ss_ticket_number;


-- start query 4 in stream 0 using template query4.tpl
-- Find customers who spend more money via catalog than in stores. Identify preferred customers and their
-- country of origin.
    with year_total as (
     select c_customer_id customer_id
           ,c_first_name customer_first_name
           ,c_last_name customer_last_name
           ,c_preferred_cust_flag customer_preferred_cust_flag
           ,c_birth_country customer_birth_country
           ,c_login customer_login
           ,c_email_address customer_email_address
           ,d_year dyear
           ,sum(((ss_ext_list_price-ss_ext_wholesale_cost-ss_ext_discount_amt)+ss_ext_sales_price)/2) year_total
           ,'s' sale_type
     from customer
         ,store_sales
         ,date_dim
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
           ,sum((((cs_ext_list_price-cs_ext_wholesale_cost-cs_ext_discount_amt)+cs_ext_sales_price)/2) ) year_total
           ,'c' sale_type
     from customer
         ,catalog_sales
         ,date_dim
     where c_customer_sk = cs_bill_customer_sk
       and cs_sold_date_sk = d_date_sk
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
           ,sum((((ws_ext_list_price-ws_ext_wholesale_cost-ws_ext_discount_amt)+ws_ext_sales_price)/2) ) year_total
           ,'w' sale_type
     from customer
         ,web_sales
         ,date_dim
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
         ,year_total t_c_firstyear
         ,year_total t_c_secyear
         ,year_total t_w_firstyear
         ,year_total t_w_secyear
     where t_s_secyear.customer_id = t_s_firstyear.customer_id
       and t_s_firstyear.customer_id = t_c_secyear.customer_id
       and t_s_firstyear.customer_id = t_c_firstyear.customer_id
       and t_s_firstyear.customer_id = t_w_firstyear.customer_id
       and t_s_firstyear.customer_id = t_w_secyear.customer_id
       and t_s_firstyear.sale_type = 's'
       and t_c_firstyear.sale_type = 'c'
       and t_w_firstyear.sale_type = 'w'
       and t_s_secyear.sale_type = 's'
       and t_c_secyear.sale_type = 'c'
       and t_w_secyear.sale_type = 'w'
       and t_s_firstyear.dyear =  1999
       and t_s_secyear.dyear = 1999+1
       and t_c_firstyear.dyear =  1999
       and t_c_secyear.dyear =  1999+1
       and t_w_firstyear.dyear = 1999
       and t_w_secyear.dyear = 1999+1
       and t_s_firstyear.year_total > 0
       and t_c_firstyear.year_total > 0
       and t_w_firstyear.year_total > 0
       and case when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total else null end
               > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else null end
       and case when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total else null end
               > case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else null end
     order by t_s_secyear.customer_id
             ,t_s_secyear.customer_first_name
             ,t_s_secyear.customer_last_name
             ,t_s_secyear.customer_birth_country
    ;


-- start query 7 in stream 0 using template query7.tpl
-- Compute the average quantity, list price, discount, and sales price for promotional items sold in stores where the
-- promotion is not offered by mail or a special event. Restrict the results to a specific gender, marital and
-- educational status

     select i_item_id,
             avg(ss_quantity) agg1,
             avg(ss_list_price) agg2,
             avg(ss_coupon_amt) agg3,
             avg(ss_sales_price) agg4
      from store_sales, customer_demographics, date_dim, item, promotion
      where ss_sold_date_sk = d_date_sk and
            ss_item_sk = i_item_sk and
            ss_cdemo_sk = cd_demo_sk and
            ss_promo_sk = p_promo_sk and
            cd_gender = 'F' and
            cd_marital_status = 'W' and
            cd_education_status = 'College' and
            (p_channel_email = 'N' or p_channel_event = 'N') and
            d_year = 2001
      group by i_item_id
      order by i_item_id
      ;

-- start query 11 in stream 0 using template query11.tpl - GOOD LONG QUERY
--Find customers whose increase in spending was large over the web than in stores this year compared to last
--year.

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
 from customer
     ,store_sales
     ,date_dim
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
 from customer
     ,web_sales
     ,date_dim
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


-- start query 31 in stream 0 using template query31.tpl
-- List counties where the percentage growth in web sales is consistently higher compared to the percentage
-- growth in store sales in the first three consecutive quarters for a given year.

with ss as
 (select ca_county,d_qoy, d_year,sum(ss_ext_sales_price) as store_sales
 from store_sales,date_dim,customer_address
 where ss_sold_date_sk = d_date_sk
  and ss_addr_sk=ca_address_sk
 group by ca_county,d_qoy, d_year),
 ws as
 (select ca_county,d_qoy, d_year,sum(ws_ext_sales_price) as web_sales
 from web_sales,date_dim,customer_address
 where ws_sold_date_sk = d_date_sk
  and ws_bill_addr_sk=ca_address_sk
 group by ca_county,d_qoy, d_year)
 select
        ss1.ca_county
       ,ss1.d_year
       ,ws2.web_sales/ws1.web_sales web_q1_q2_increase
       ,ss2.store_sales/ss1.store_sales store_q1_q2_increase
       ,ws3.web_sales/ws2.web_sales web_q2_q3_increase
       ,ss3.store_sales/ss2.store_sales store_q2_q3_increase
 from
        ss ss1
       ,ss ss2
       ,ss ss3
       ,ws ws1
       ,ws ws2
       ,ws ws3
 where
    ss1.d_qoy = 1
    and ss1.d_year = 2002
    and ss1.ca_county = ss2.ca_county
    and ss2.d_qoy = 2
    and ss2.d_year = 2002
 and ss2.ca_county = ss3.ca_county
    and ss3.d_qoy = 3
    and ss3.d_year = 2002
    and ss1.ca_county = ws1.ca_county
    and ws1.d_qoy = 1
    and ws1.d_year = 2002
    and ws1.ca_county = ws2.ca_county
    and ws2.d_qoy = 2
    and ws2.d_year = 2002
    and ws1.ca_county = ws3.ca_county
    and ws3.d_qoy = 3
    and ws3.d_year =2002
    and case when ws1.web_sales > 0 then ws2.web_sales/ws1.web_sales else null end
       > case when ss1.store_sales > 0 then ss2.store_sales/ss1.store_sales else null end
    and case when ws2.web_sales > 0 then ws3.web_sales/ws2.web_sales else null end
       > case when ss2.store_sales > 0 then ss3.store_sales/ss2.store_sales else null end
 order by ss1.ca_county;


-- start query 38 in stream 0 using template query38.tpl
-- Display count of customers with purchases from all 3 channels in a given year.

 select count(*) from (
     select distinct c_last_name, c_first_name, d_date
     from store_sales, date_dim, customer
           where store_sales.ss_sold_date_sk = date_dim.d_date_sk
       and store_sales.ss_customer_sk = customer.c_customer_sk
       and d_month_seq between 1221 and 1221 + 11
   intersect
     select distinct c_last_name, c_first_name, d_date
     from catalog_sales, date_dim, customer
           where catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
       and catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
       and d_month_seq between 1221 and 1221 + 11
   intersect
     select distinct c_last_name, c_first_name, d_date
     from web_sales, date_dim, customer
           where web_sales.ws_sold_date_sk = date_dim.d_date_sk
       and web_sales.ws_bill_customer_sk = customer.c_customer_sk
       and d_month_seq between 1221 and 1221 + 11
 ) hot_cust
 ;


-- start query 59 in stream 0 using template query59.tpl
-- Report the increase of weekly store sales from one year to the next year for each store and day of the week.

  with wss as
   (select d_week_seq,
          ss_store_sk,
          sum(case when (d_day_name='Sunday') then ss_sales_price else null end) sun_sales,
          sum(case when (d_day_name='Monday') then ss_sales_price else null end) mon_sales,
          sum(case when (d_day_name='Tuesday') then ss_sales_price else  null end) tue_sales,
          sum(case when (d_day_name='Wednesday') then ss_sales_price else null end) wed_sales,
          sum(case when (d_day_name='Thursday') then ss_sales_price else null end) thu_sales,
          sum(case when (d_day_name='Friday') then ss_sales_price else null end) fri_sales,
          sum(case when (d_day_name='Saturday') then ss_sales_price else null end) sat_sales
   from store_sales,date_dim
   where d_date_sk = ss_sold_date_sk
   group by d_week_seq,ss_store_sk
   )
    select top 100 s_store_name1,s_store_id1,d_week_seq1
         ,sun_sales1/sun_sales2,mon_sales1/mon_sales2
         ,tue_sales1/tue_sales2,wed_sales1/wed_sales2,thu_sales1/thu_sales2
         ,fri_sales1/fri_sales2,sat_sales1/sat_sales2
   from
   (select s_store_name s_store_name1,wss.d_week_seq d_week_seq1
          ,s_store_id s_store_id1,sun_sales sun_sales1
          ,mon_sales mon_sales1,tue_sales tue_sales1
          ,wed_sales wed_sales1,thu_sales thu_sales1
          ,fri_sales fri_sales1,sat_sales sat_sales1
    from wss,store,date_dim d
    where d.d_week_seq = wss.d_week_seq and
          ss_store_sk = s_store_sk and
          d_month_seq between 1201 and 1201 + 11) y,
   (select s_store_name s_store_name2,wss.d_week_seq d_week_seq2
          ,s_store_id s_store_id2,sun_sales sun_sales2
          ,mon_sales mon_sales2,tue_sales tue_sales2
          ,wed_sales wed_sales2,thu_sales thu_sales2
          ,fri_sales fri_sales2,sat_sales sat_sales2
    from wss,store,date_dim d
    where d.d_week_seq = wss.d_week_seq and
          ss_store_sk = s_store_sk and
          d_month_seq between 1201+ 12 and 1201 + 23) x
   where s_store_id1=s_store_id2
     and d_week_seq1=d_week_seq2-52
   order by s_store_name1,s_store_id1,d_week_seq1
  ;


-- query 57
--Find the item brands and categories for each call center and their monthly sales figures for a specified year,
-- where the monthly sales figure deviated more than 10% of the average monthly sales for the year, sorted by
-- deviation and call center. Report the sales deviation from the previous and following month.
  with v1 as(
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
    from item, catalog_sales, date_dim, call_center
    where cs_item_sk = i_item_sk and
         cs_sold_date_sk = d_date_sk and
         cc_call_center_sk= cs_call_center_sk and
         (
           d_year = 1999 or
           ( d_year = 1999-1 and d_moy =12) or
           ( d_year = 1999+1 and d_moy =1)
         )
    group by i_category, i_brand,
            cc_name , d_year, d_moy),
  v2 as(
    select v1.i_category ,v1.d_year, v1.d_moy ,v1.avg_monthly_sales
          ,v1.sum_sales, v1_lag.sum_sales psum, v1_lead.sum_sales nsum
    from v1, v1 v1_lag, v1 v1_lead
    where v1.i_category = v1_lag.i_category and
         v1.i_category = v1_lead.i_category and
         v1.i_brand = v1_lag.i_brand and
         v1.i_brand = v1_lead.i_brand and
         v1.cc_name = v1_lag.cc_name and
         v1.cc_name = v1_lead.cc_name and
         v1.rn = v1_lag.rn + 1 and
         v1.rn = v1_lead.rn - 1)
  select  *
  from v2
  where  d_year = 1999 and
          avg_monthly_sales > 0 and
          case when avg_monthly_sales > 0 then abs(sum_sales - avg_monthly_sales) / avg_monthly_sales else null end > 0.1
  order by sum_sales - avg_monthly_sales, 3
  limit 100;
