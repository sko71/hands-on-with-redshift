copy call_center from 's3://yourbucketname/manifest/tpcdscallcenter.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy catalog_sales from 's3://yourbucketname/manifest/tpcdscatalogsales.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy customer from 's3://yourbucketname/manifest/tpcdscustomer.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' ACCEPTINVCHARS manifest;
copy date_dim from 's3://yourbucketname/manifest/tpcdsdatedim.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy household_demographics from 's3://yourbucketname/manifest/tpcdsdhouseholddemographics.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy item from 's3://yourbucketname/manifest/tpcdsitem.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy store from 's3://yourbucketname/manifest/tpcdsstore.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy store_sales from 's3://yourbucketname/manifest/tpcdsstoresales.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
copy web_sales from 's3://yourbucketname/manifest/tpcdswebsales.manifest' iam_role 'arn:aws:iam::<your_account_number>:role/<your_role_name>' manifest;
