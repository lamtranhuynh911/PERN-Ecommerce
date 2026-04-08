# ==============================================================================
# TERRAFORM.TFVARS - INPUT VALUES
# ==============================================================================

environment = "dev"
location    = "southeastasia"
node_count  = 1

# Application Configurations (Safe to store here)
db_host   = "aws-1-ap-south-1.pooler.supabase.com"
db_port   = 6543
db_user   = "postgres.lkczlvflgckzmzldlsge"
db_name   = "postgres"
app_port  = 9000
smtp_from = "tranhuynhlam911@gmail.com"
smtp_user = "tranhuynhlam911"
vite_google_client_id = "926599606710-feabn75ggmr1ofggru6mdiupq1vtl4qr.apps.googleusercontent.com"
vite_stripe_pub_key = "VITE_STRIPE_PUB_KEY=pk_test_51SnfZ7Ho4mzcNxtWRuqKSjP7gya7ZeV646uV5KxEY1riC9CRtIYFa0ulQ2NzqSigdWwd27QFLEtis1ymc8sJyhfJ00utRylTB6"
vite_paystack_pub_key = "pk_test_uuiduw984x4h4xx41489j94n"