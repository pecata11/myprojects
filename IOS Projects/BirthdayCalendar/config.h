//
//  config.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 9/22/12.
//
//

#ifndef BirthdayCalendar_config_h
#define BirthdayCalendar_config_h

//#define SEND_APP_REQUESTS

#define FROM_CONTACTS

#define GA_TRACKING_ID              @"UA-36999217-1"
#define INAPP_PRODUCT_NAME          @"1YearSubscription"

#define PROTO_VERSION               @"1.2"
#define PROTO_API_KEY               @"C4rdi0SH0l1d4y4P1"

//#define __DISPLAY_BANNER__

#define __PRODUCTION__
#undef  __PRODUCTION__

#ifdef __PRODUCTION__

#define REST_URL_BASE               @"https://www.daviacalendar.com/rest_accounts/"
#define CREATE_ACCOUNT_URL          REST_URL_BASE "create_account"
#define LOGIN_ACCOUNT_URL           REST_URL_BASE "login_account"
#define LOGOUT_ACCOUNT_URL          REST_URL_BASE "logout_account"
#define RESET_ACCOUNT_URL           REST_URL_BASE "reset_account"
#define RESEND_EMAIL_URL            REST_URL_BASE "resend_confirmation_email"

#else

#define REST_URL_BASE               @"http://daviacalendar-staging.herokuapp.com/rest_accounts/"
//#define REST_URL_BASE               @"http://192.168.102.54/rest_accounts/"
#define CREATE_ACCOUNT_URL          REST_URL_BASE "create_account"
#define LOGIN_ACCOUNT_URL           REST_URL_BASE "login_account"
#define LOGOUT_ACCOUNT_URL          REST_URL_BASE "logout_account"
#define RESET_ACCOUNT_URL           REST_URL_BASE "reset_account"
#define RESEND_EMAIL_URL            REST_URL_BASE "resend_confirmation_email"

#endif

#endif
