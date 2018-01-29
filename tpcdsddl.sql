CREATE TABLE public.call_center (
	cc_call_center_sk int8 NOT NULL,
	cc_call_center_id char(16) NOT NULL,
	cc_rec_start_date date,
	cc_rec_end_date date,
	cc_closed_date_sk int8,
	cc_open_date_sk int8,
	cc_name varchar(50),
	cc_class varchar(50),
	cc_employees int8,
	cc_sq_ft int8,
	cc_hours varchar(20),
	cc_manager varchar(40),
	cc_mkt_id int8,
	cc_mkt_class varchar(50),
	cc_mkt_desc varchar(100),
	cc_market_manager varchar(40),
	cc_division int8,
	cc_division_name varchar(50),
	cc_company int8,
	cc_company_name varchar(50),
	cc_street_number varchar(10),
	cc_street_name varchar(60),
	cc_street_type varchar(15),
	cc_suite_number varchar(10),
	cc_city varchar(60),
	cc_county varchar(30),
	cc_state char(2),
	cc_zip char(10),
	cc_country varchar(20),
	cc_gmt_offset numeric(5,2),
	cc_tax_percentage numeric(5,2)
);

CREATE TABLE public.catalog_page (
	cp_catalog_page_sk int8 NOT NULL,
	cp_catalog_page_id char(16) NOT NULL,
	cp_start_date_sk int8,
	cp_end_date_sk int8,
	cp_department varchar(50),
	cp_catalog_number int8,
	cp_catalog_page_number int8,
	cp_description varchar(100),
	cp_type varchar(100)
);

CREATE TABLE public.catalog_returns (
	cr_returned_date_sk int8,
	cr_return_time_sk int8,
	cr_item_sk int8 NOT NULL,
	cr_refunded_customer_sk int8,
	cr_refunded_cdemo_sk int8,
	cr_refunded_hdemo_sk int8,
	cr_refunded_addr_sk int8,
	cr_returning_customer_sk int8,
	cr_returning_cdemo_sk int8,
	cr_returning_hdemo_sk int8,
	cr_returning_addr_sk int8,
	cr_call_center_sk int8,
	cr_catalog_page_sk int8,
	cr_ship_mode_sk int8,
	cr_warehouse_sk int8,
	cr_reason_sk int8,
	cr_order_number int8 NOT NULL,
	cr_return_quantity int8,
	cr_return_amount numeric(7,2),
	cr_return_tax numeric(7,2),
	cr_return_amt_inc_tax numeric(7,2),
	cr_fee numeric(7,2),
	cr_return_ship_cost numeric(7,2),
	cr_refunded_cash numeric(7,2),
	cr_reversed_charge numeric(7,2),
	cr_store_credit numeric(7,2),
	cr_net_loss numeric(7,2)
);

CREATE TABLE public.catalog_sales (
	cs_sold_date_sk int8,
	cs_sold_time_sk int8,
	cs_ship_date_sk int8,
	cs_bill_customer_sk int8,
	cs_bill_cdemo_sk int8,
	cs_bill_hdemo_sk int8,
	cs_bill_addr_sk int8,
	cs_ship_customer_sk int8,
	cs_ship_cdemo_sk int8,
	cs_ship_hdemo_sk int8,
	cs_ship_addr_sk int8,
	cs_call_center_sk int8,
	cs_catalog_page_sk int8,
	cs_ship_mode_sk int8,
	cs_warehouse_sk int8,
	cs_item_sk int8 NOT NULL,
	cs_promo_sk int8,
	cs_order_number int8 NOT NULL,
	cs_quantity int8,
	cs_wholesale_cost numeric(7,2),
	cs_list_price numeric(7,2),
	cs_sales_price numeric(7,2),
	cs_ext_discount_amt numeric(7,2),
	cs_ext_sales_price numeric(7,2),
	cs_ext_wholesale_cost numeric(7,2),
	cs_ext_list_price numeric(7,2),
	cs_ext_tax numeric(7,2),
	cs_coupon_amt numeric(7,2),
	cs_ext_ship_cost numeric(7,2),
	cs_net_paid numeric(7,2),
	cs_net_paid_inc_tax numeric(7,2),
	cs_net_paid_inc_ship numeric(7,2),
	cs_net_paid_inc_ship_tax numeric(7,2),
	cs_net_profit numeric(7,2)
);

CREATE TABLE public.customer (
	c_customer_sk int8 NOT NULL,
	c_customer_id char(16) NOT NULL,
	c_current_cdemo_sk int8,
	c_current_hdemo_sk int8,
	c_current_addr_sk int8,
	c_first_shipto_date_sk int8,
	c_first_sales_date_sk int8,
	c_salutation char(10),
	c_first_name char(20),
	c_last_name char(30),
	c_preferred_cust_flag char(1),
	c_birth_day int8,
	c_birth_month int8,
	c_birth_year int8,
	c_birth_country varchar(20),
	c_login char(13),
	c_email_address char(50),
	c_last_review_date int8
);

CREATE TABLE public.customer_address (
	ca_address_sk int8 NOT NULL,
	ca_address_id char(16) NOT NULL,
	ca_street_number char(10),
	ca_street_name varchar(60),
	ca_street_type char(15),
	ca_suite_number char(10),
	ca_city varchar(60),
	ca_county varchar(30),
	ca_state char(2),
	ca_zip char(10),
	ca_country varchar(20),
	ca_gmt_offset numeric(5,2),
	ca_location_type char(20)
);

CREATE TABLE public.customer_demographics (
	cd_demo_sk int8 NOT NULL,
	cd_gender char(1),
	cd_marital_status char(1),
	cd_education_status char(20),
	cd_purchase_estimate int8,
	cd_credit_rating char(10),
	cd_dep_count int8,
	cd_dep_employed_count int8,
	cd_dep_college_count int8
);

CREATE TABLE public.date_dim (
	d_date_sk int8 NOT NULL,
	d_date_id char(16) NOT NULL,
	d_date date,
	d_month_seq int8,
	d_week_seq int8,
	d_quarter_seg int8,
	d_year int8,
	d_dow int8,
	d_moy int8,
	d_dom int8,
	d_qoy int8,
	d_fy_year int8,
	d_fy_quarter_seq int8,
	d_fy_week_seq int8,
	d_day_name char(9),
	d_quarter_name char(6),
	d_holiday char(1),
	d_weekend char(1),
	d_following_holiday char(1),
	d_first_dom int8,
	d_last_dom int8,
	d_same_day_1y int8,
	d_same_day_1q int8,
	d_current_day char(1),
	d_current_week char(1),
	d_current_month char(1),
	d_current_quarter char(1),
	d_current_year char(1)
);

-- DON'T NEED THIS TABLE
CREATE TABLE public.dsdgen_version (
	dv_version varchar(24) NOT NULL,
	dv_create_date date NOT NULL,
	dv_create_time timestamp NOT NULL,
	dv_cmdline_args varchar(200)
);

CREATE TABLE public.household_demographics (
	hd_demo_sk int8 NOT NULL,
	hd_income_band_sk int8 NOT NULL,
	hd_buy_potential char(15),
	hd_dep_count int8,
	hd_vehicle_count int8
);

CREATE TABLE public.income_band (
	ib_income_band_sk int8 NOT NULL,
	ib_lower_bound int8,
	ib_upper_bound int8
);

CREATE TABLE public.inventory (
	inv_date_sk int8 NOT NULL,
	inv_item_sk int8 NOT NULL,
	inv_warehouse_sk int8 NOT NULL,
	inv_quantity_on_hand int8
);

CREATE TABLE public.item (
	i_item_sk int8 NOT NULL,
	i_item_id char(16) NOT NULL,
	i_rec_start_date date,
	i_rec_end_date date,
	i_item_desc varchar(200),
	i_current_price numeric(7,2),
	i_wholesale_cost numeric(7,2),
	i_brand_id int8,
	i_brand char(50),
	i_class_id int8,
	i_class char(50),
	i_category_id int8,
	i_category char(50),
	i_manufact_id int8,
	i_manufact char(50),
	i_size char(20),
	i_formulation char(20),
	i_color char(20),
	i_units char(10),
	i_container char(10),
	i_manager_id int8,
	i_product_name char(50)
);

CREATE TABLE public.promotion (
	p_promo_sk int8 NOT NULL,
	p_promo_id char(16) NOT NULL,
	p_start_date_sk int8,
	p_end_date_sk int8,
	p_item_sk int8,
	p_cost numeric(15,2),
	p_response_target int8,
	p_promo_name char(50),
	p_channel_dmail char(1),
	p_channel_email char(1),
	p_channel_catalog char(1),
	p_channel_tv char(1),
	p_channel_radio char(1),
	p_channel_press char(1),
	p_channel_event char(1),
	p_channel_demo char(1),
	p_channel_details varchar(100),
	p_purpose char(15),
	p_discount_active char(1)
);

CREATE TABLE public.reason (
	r_reason_sk int8 NOT NULL,
	r_reason_id char(16) NOT NULL,
	r_reason_desc char(100)
);

CREATE TABLE public.ship_mode (
	sm_ship_mode_sk int8 NOT NULL,
	sm_ship_mode_id char(16) NOT NULL,
	sm_type char(30),
	sm_code char(10),
	sm_carrier char(20),
	sm_contract char(20)
);

CREATE TABLE public.store (
	s_store_sk int8 NOT NULL,
	s_store_id char(16) NOT NULL,
	s_rec_start_date date,
	s_rec_end_date date,
	s_closed_date_sk int8,
	s_store_name varchar(50),
	s_number_employees int8,
	s_floor_space int8,
	s_hours char(20),
	s_manager varchar(40),
	s_market_id int8,
	s_geography_class varchar(100),
	s_market_desc varchar(100),
	s_market_manager varchar(40),
	s_division_id int8,
	s_division_name varchar(40),
	s_company_id int8,
	s_company_name varchar(50),
	s_street_number varchar(10),
	s_street_name varchar(60),
	s_street_type varchar(15),
	s_suite_number varchar(10),
	s_city varchar(60),
	s_county varchar(30),
	s_state char(2),
	s_zip char(10),
	s_country varchar(20),
	s_gmt_offset numeric(5,2),
	s_tax_percentage numeric(5,2)
);

CREATE TABLE public.store_returns (
	sr_returned_date_sk int8,
	sr_return_time_sk int8,
	sr_item_sk int8 NOT NULL,
	sr_customer_sk int8,
	sr_cdemo_sk int8,
	sr_hdemo_sk int8,
	sr_addr_sk int8,
	sr_store_sk int8,
	sr_reason_sk int8,
	sr_ticket_number int8 NOT NULL,
	sr_return_quantity int8,
	sr_return_amt numeric(7,2),
	sr_return_tax numeric(7,2),
	sr_return_amt_inc_tax numeric(7,2),
	sr_fee numeric(7,2),
	sr_return_ship_cost numeric(7,2),
	sr_refunded_cash numeric(7,2),
	sr_reversed_charge numeric(7,2),
	sr_store_credit numeric(7,2),
	sr_net_loss numeric(7,2)
);

CREATE TABLE public.store_sales (
	ss_sold_date_sk int8,
	ss_sold_time_sk int8,
	ss_item_sk int8 NOT NULL,
	ss_customer_sk int8,
	ss_cdemo_sk int8,
	ss_hdemo_sk int8,
	ss_addr_sk int8,
	ss_store_sk int8,
	ss_promo_sk int8,
	ss_ticket_number int8 NOT NULL,
	ss_quantity int8,
	ss_wholesale_cost numeric(7,2),
	ss_list_price numeric(7,2),
	ss_sales_price numeric(7,2),
	ss_ext_discount_amt numeric(7,2),
	ss_ext_sales_price numeric(7,2),
	ss_ext_wholesale_cost numeric(7,2),
	ss_ext_list_price numeric(7,2),
	ss_ext_tax numeric(7,2),
	ss_coupon_amt numeric(7,2),
	ss_net_paid numeric(7,2),
	ss_net_paid_inc_tax numeric(7,2),
	ss_net_profit numeric(7,2)
);

CREATE TABLE public.time_dim (
	t_time_sk int8 NOT NULL,
	t_time_id char(16) NOT NULL,
	t_time int8,
	t_hour int8,
	t_minute int8,
	t_second int8,
	t_am_pm char(2),
	t_shift char(20),
	t_sub_shift char(20),
	t_meal_time char(20)
);

CREATE TABLE public.warehouse (
	w_warehouse_sk int8 NOT NULL,
	w_warehouse_id char(16) NOT NULL,
	w_warehouse_name varchar(20),
	w_warehouse_sq_ft int8,
	w_street_number char(10),
	w_street_name varchar(60),
	w_street_type char(15),
	w_suite_number char(10),
	w_city varchar(60),
	w_county varchar(30),
	w_state char(2),
	w_zip char(10),
	w_country varchar(20),
	w_gmt_offset numeric(5,2)
);

CREATE TABLE public.web_page (
	wp_web_page_sk int8 NOT NULL,
	wp_web_page_id char(16) NOT NULL,
	wp_rec_start_date date,
	wp_rec_end_date date,
	wp_creation_date_sk int8,
	wp_access_date_sk int8,
	wp_autogen_flag char(1),
	wp_customer_sk int8,
	wp_url varchar(100),
	wp_type char(50),
	wp_char_count int8,
	wp_link_count int8,
	wp_image_count int8,
	wp_max_ad_count int8
);

CREATE TABLE public.web_returns (
	wr_returned_date_sk int8,
	wr_returned_time_sk int8,
	wr_item_sk int8 NOT NULL,
	wr_refunded_customer_sk int8,
	wr_refunded_cdemo_sk int8,
	wr_refunded_hdemo_sk int8,
	wr_refunded_addr_sk int8,
	wr_returning_customer_sk int8,
	wr_returning_cdemo_sk int8,
	wr_returning_hdemo_sk int8,
	wr_returning_addr_sk int8,
	wr_web_page_sk int8,
	wr_reason_sk int8,
	wr_order_number int8 NOT NULL,
	wr_return_quantity int8,
	wr_return_amt numeric(7,2),
	wr_return_tax numeric(7,2),
	wr_return_amt_inc_tax numeric(7,2),
	wr_fee numeric(7,2),
	wr_return_ship_cost numeric(7,2),
	wr_refunded_cash numeric(7,2),
	wr_reversed_charge numeric(7,2),
	wr_amount_credit numeric(7,2),
	wr_net_loss numeric(7,2)
);

CREATE TABLE public.web_sales (
	ws_sold_date_sk int8,
	ws_sold_time_sk int8,
	ws_ship_date_sk int8,
	ws_item_sk int8 NOT NULL,
	ws_bill_customer_sk int8,
	ws_bill_cdemo_sk int8,
	ws_bill_hdemo_sk int8,
	ws_bill_addr_sk int8,
	ws_ship_customer_sk int8,
	ws_ship_cdemo_sk int8,
	ws_ship_hdemo_sk int8,
	ws_ship_addr_sk int8,
	ws_web_page_sk int8,
	ws_web_site_sk int8,
	ws_ship_mode_sk int8,
	ws_warehouse_sk int8,
	ws_promo_sk int8,
	ws_order_number int8 NOT NULL,
	ws_quantity int8,
	ws_wholesale_cost numeric(7,2),
	ws_list_price numeric(7,2),
	ws_sales_price numeric(7,2),
	ws_ext_discount_amt numeric(7,2),
	ws_ext_sales_price numeric(7,2),
	ws_ext_wholesale_cost numeric(7,2),
	ws_ext_list_price numeric(7,2),
	ws_ext_tax numeric(7,2),
	ws_coupon_amt numeric(7,2),
	ws_ext_ship_cost numeric(7,2),
	ws_net_paid numeric(7,2),
	ws_net_paid_inc_tax numeric(7,2),
	ws_net_paid_inc_ship numeric(7,2),
	ws_net_paid_inc_ship_tax numeric(7,2),
	ws_net_profit numeric(7,2)
);
