-- drop existing tables
DROP TABLE USERS CASCADE CONSTRAINTS;
DROP TABLE CUSTOMERS CASCADE CONSTRAINTS;
DROP TABLE TRADERS CASCADE CONSTRAINTS;
DROP TABLE ADMINS CASCADE CONSTRAINTS;
DROP TABLE ACCESS_DETAILS CASCADE CONSTRAINTS;
DROP TABLE COLLECTION_SLOTS CASCADE CONSTRAINTS;
DROP TABLE TRADER_TYPES CASCADE CONSTRAINTS;
DROP TABLE SHOPS CASCADE CONSTRAINTS;
DROP TABLE PRODUCT_CATEGORIES CASCADE CONSTRAINTS;
DROP TABLE PRODUCTS CASCADE CONSTRAINTS;
DROP TABLE PRODUCT_REVIEWS CASCADE CONSTRAINTS;
DROP TABLE OFFERS CASCADE CONSTRAINTS;
DROP TABLE BASKETS CASCADE CONSTRAINTS;
DROP TABLE BASKET_PRODUCTS CASCADE CONSTRAINTS;
DROP TABLE INVOICES CASCADE CONSTRAINTS;
DROP TABLE PAYMENTS CASCADE CONSTRAINTS;

-- create tables
CREATE TABLE USERS (
    USER_ID NUMBER (6, 0),
    FIRST_NAME VARCHAR2 (50),
    LAST_NAME VARCHAR2 (50),
    EMAIL VARCHAR2 (250),
    VERIFICATION_TOKEN VARCHAR2 (300),
    ADDRESS VARCHAR2 (250),
    PHONE_NUMBER VARCHAR2 (16),
    PASSWORD VARCHAR2 (300) NOT NULL,
    PROFILE_IMG VARCHAR2 (50),
    IS_VERIFIED NUMBER (1, 0) DEFAULT 0,
    ACCOUNT_STATUS NUMBER (1, 0) DEFAULT 0,
    
    
    CONSTRAINT PK_USER PRIMARY KEY (USER_ID),
    CONSTRAINT UC_USER UNIQUE (EMAIL)
);

CREATE TABLE CUSTOMERS (
    USER_ID NUMBER (6, 0),
    CUSTOMER_ID NUMBER (6, 0),
    
    CONSTRAINT PK_CUSTOMER PRIMARY KEY (CUSTOMER_ID),
    CONSTRAINT FK_CUSTOMER FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE
);

CREATE TABLE TRADERS (
    USER_ID NUMBER (6, 0),
    TRADER_ID NUMBER (6, 0),
    
    CONSTRAINT PK_TRADER PRIMARY KEY (TRADER_ID),
    CONSTRAINT FK_TRADER FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE
);

CREATE TABLE ADMINS (
    USER_ID NUMBER (6, 0),
    ADMIN_ID NUMBER (6, 0),
    
    CONSTRAINT PK_ADMIN PRIMARY KEY (ADMIN_ID),
    CONSTRAINT FK_ADMIN FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE
);

CREATE TABLE ACCESS_DETAILS (
    USER_ID NUMBER (6, 0),
    ADMIN_ID NUMBER (6, 0),
    ACTION VARCHAR2 (50),
    ACCESSED_AT TIMESTAMP (0),
    
    CONSTRAINT PK_ACCESS_DETAIL PRIMARY KEY (USER_ID, ADMIN_ID),
    CONSTRAINT FK_ACCESS_DETAIL_1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_ACCESS_DETAIL_2 FOREIGN KEY (ADMIN_ID) REFERENCES ADMINS (ADMIN_ID) ON DELETE CASCADE
);

CREATE TABLE COLLECTION_SLOTS (
    ADMIN_ID NUMBER (6, 0),
    COLLECTION_SLOT_ID NUMBER (6, 0),
    LOCATION VARCHAR2 (250),
    COLLECTION_TIME TIMESTAMP (0),
    MAXIMUM_ORDER NUMBER (2, 0),
    COLLECTION_DAY VARCHAR2 (100),
    
    CONSTRAINT PK_COLLECTION_SLOT PRIMARY KEY (COLLECTION_SLOT_ID),
    CONSTRAINT FK_COLLECTION_SLOT FOREIGN KEY (ADMIN_ID) REFERENCES ADMINS (ADMIN_ID) ON DELETE CASCADE
);

CREATE TABLE TRADER_TYPES (
    TRADER_ID NUMBER (6, 0),
    TRADER_TYPE_ID NUMBER (6, 0),
    DESCRIPTION VARCHAR2 (250),
    
    CONSTRAINT PK_TRADER_TYPE PRIMARY KEY (TRADER_ID, TRADER_TYPE_ID),
    CONSTRAINT FK_TRADER_TYPE FOREIGN KEY (TRADER_ID) REFERENCES TRADERS (TRADER_ID) ON DELETE CASCADE
);

CREATE TABLE SHOPS (
    TRADER_ID NUMBER (6, 0),
    TRADER_TYPE_ID NUMBER (6, 0),
    SHOP_ID NUMBER (6, 0),
    SHOP_NAME VARCHAR2 (50),
    
    CONSTRAINT PK_SHOP PRIMARY KEY (SHOP_ID),
    CONSTRAINT FK_SHOP FOREIGN KEY (TRADER_ID, TRADER_TYPE_ID) REFERENCES TRADER_TYPES (TRADER_ID, TRADER_TYPE_ID) ON DELETE CASCADE
);

CREATE TABLE PRODUCT_CATEGORIES (
    SHOP_ID NUMBER (6, 0),
    PRODUCT_CATEGORY_ID NUMBER (6, 0),
    CATEGORY_NAME VARCHAR2 (50),
    DESCRIPTION VARCHAR2 (250),
    
    CONSTRAINT PK_PRODUCT_CATEGORY PRIMARY KEY (PRODUCT_CATEGORY_ID),
    CONSTRAINT FK_PRODUCT_CATEGORY FOREIGN KEY (SHOP_ID) REFERENCES SHOPS (SHOP_ID) ON DELETE CASCADE
);

CREATE TABLE PRODUCTS (
   PRODUCT_CATEGORY_ID NUMBER (6, 0),
   PRODUCT_ID NUMBER (6, 0),
   PRODUCT_NAME VARCHAR2 (200),
   DESCRIPTION VARCHAR2 (1000),
   RATE NUMBER (6, 2),
   IS_AVAILABLE NUMBER (1, 0),
   IMAGE VARCHAR2 (200),
   ALLERGY_INFO VARCHAR2 (1000),
   MIN_ORDER NUMBER (2, 0),
   MAX_ORDER NUMBER (2, 0),
   QUANTITY NUMBER (3, 0),

   CONSTRAINT PK_PRODUCT PRIMARY KEY (PRODUCT_ID),
   CONSTRAINT FK_PRODUCT FOREIGN KEY (PRODUCT_CATEGORY_ID) REFERENCES PRODUCT_CATEGORIES (PRODUCT_CATEGORY_ID) ON DELETE CASCADE
);

CREATE TABLE PRODUCT_REVIEWS (
   USER_ID NUMBER (6, 0),
   PRODUCT_ID NUMBER (6, 0),
   REPLY_OF NUMBER (6, 0),
   PRODUCT_REVIEW_ID NUMBER (6, 0),
   REVIEW VARCHAR2 (250),
  
   CONSTRAINT PK_PRODUCT_REVIEW PRIMARY KEY (PRODUCT_REVIEW_ID),
   CONSTRAINT FK_PRODUCT_REVIEW_1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE,
   CONSTRAINT FK_PRODUCT_REVIEW_2 FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS (PRODUCT_ID) ON DELETE CASCADE,
   CONSTRAINT FK_PRODUCT_REVIEW_3 FOREIGN KEY (REPLY_OF) REFERENCES PRODUCT_REVIEWS (PRODUCT_REVIEW_ID) ON DELETE CASCADE
);

CREATE TABLE OFFERS (
    PRODUCT_ID NUMBER (6, 0),
    OFFER_ID NUMBER (6, 0),
    PERCENTAGE_OFF NUMBER (3, 2),
    DESCRIPTION VARCHAR2 (250),
    
    CONSTRAINT PK_OFFER PRIMARY KEY (OFFER_ID),
    CONSTRAINT FK_OFFER FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS (PRODUCT_ID) ON DELETE CASCADE
);

CREATE TABLE BASKETS (
    BASKET_ID NUMBER (6, 0),
    CUSTOMER_ID NUMBER (6, 0),
    ACTIVE NUMBER (1, 0),
    
    CONSTRAINT PK_BASKET PRIMARY KEY (BASKET_ID)
);

CREATE TABLE BASKET_PRODUCTS (
    PRODUCT_ID NUMBER (6, 0),
    BASKET_ID NUMBER (6, 0),
    QUANTITY NUMBER (3, 0),
    
    CONSTRAINT PK_BASKET_PRODUCT PRIMARY KEY (PRODUCT_ID, BASKET_ID),
    CONSTRAINT FK_BASKET_PRODUCT_1 FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS (PRODUCT_ID) ON DELETE CASCADE,
    CONSTRAINT FK_BASKET_PRODUCT_2 FOREIGN KEY (BASKET_ID) REFERENCES BASKETS (BASKET_ID) ON DELETE CASCADE
);

CREATE TABLE INVOICES (
    COLLECTION_SLOT_ID NUMBER (6, 0),
    INVOICE_ID NUMBER (6, 0),
    INVOICE_DATE DATE,
    IS_COLLECTED NUMBER (1, 0),
    
    CONSTRAINT PK_INVOICE PRIMARY KEY (INVOICE_ID),
    CONSTRAINT FK_INVOICE FOREIGN KEY (COLLECTION_SLOT_ID) REFERENCES COLLECTION_SLOTS (COLLECTION_SLOT_ID) ON DELETE CASCADE
);

CREATE TABLE PAYMENTS (
    BASKET_ID NUMBER (6, 0),
    INVOICE_ID NUMBER (6, 0),
    PAYMENT_ID NUMBER (6, 0),
    PAYMENT_METHOD VARCHAR2 (50),
    AMOUNT NUMBER (6, 2),
    PAYMENT_DATE TIMESTAMP (2),
    
    CONSTRAINT PK_PAYMENT PRIMARY KEY (PAYMENT_ID),
    CONSTRAINT FK_PAYMENT_1 FOREIGN KEY (BASKET_ID) REFERENCES BASKETS (BASKET_ID) ON DELETE CASCADE,
    CONSTRAINT FK_PAYMENT_2 FOREIGN KEY (INVOICE_ID) REFERENCES INVOICES (INVOICE_ID) ON DELETE CASCADE
);
------------------------------------------------------------------------------------------------------------

-- drop existing sequence
DROP SEQUENCE USERS_SEQ;
DROP SEQUENCE CUSTOMERS_SEQ;
DROP SEQUENCE TRADERS_SEQ;
DROP SEQUENCE ADMINS_SEQ;
DROP SEQUENCE ACCESS_DETAILS_SEQ;
DROP SEQUENCE COLLECTION_SLOTS_SEQ;
DROP SEQUENCE TRADER_TYPES_SEQ;
DROP SEQUENCE SHOPS_SEQ;
DROP SEQUENCE PRODUCT_CATEGORIES_SEQ;
DROP SEQUENCE PRODUCTS_SEQ;
DROP SEQUENCE PRODUCT_REVIEWS_SEQ;
DROP SEQUENCE OFFERS_SEQ;
DROP SEQUENCE BASKETS_SEQ;
DROP SEQUENCE BASKET_PRODUCTS_SEQ;
DROP SEQUENCE INVOICES_SEQ;
DROP SEQUENCE PAYMENTS_SEQ;

-- create sequence
CREATE SEQUENCE USERS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE CUSTOMERS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE TRADERS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE ADMINS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE ACCESS_DETAILS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE COLLECTION_SLOTS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE TRADER_TYPES_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE SHOPS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE PRODUCT_CATEGORIES_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE PRODUCTS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE PRODUCT_REVIEWS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE OFFERS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE BASKETS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE BASKET_PRODUCTS_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE INVOICES_SEQ
START WITH 10
INCREMENT BY 1;

CREATE SEQUENCE PAYMENTS_SEQ
START WITH 10
INCREMENT BY 1;
------------------------------------------------------------------------------------------------------------

-- drop existing triggers
DROP TRIGGER INSERT_USERS_ID;
DROP TRIGGER INSERT_CUSTOMERS_ID;
DROP TRIGGER INSERT_TRADERS_ID;
DROP TRIGGER INSERT_ADMINS_ID;
--DROP TRIGGER INSERT_ACCESS_DETAILS_ID;
DROP TRIGGER INSERT_COLLECTION_SLOTS_ID;
DROP TRIGGER INSERT_TRADER_TYPES_ID;
DROP TRIGGER INSERT_SHOPS_ID;
DROP TRIGGER INSERT_PRODUCT_CATEGORIES_ID;
DROP TRIGGER INSERT_PRODUCTS_ID;
DROP TRIGGER INSERT_PRODUCT_REVIEWS_ID;
DROP TRIGGER INSERT_OFFERS_ID;
DROP TRIGGER INSERT_BASKETS_ID;
--DROP TRIGGER INSERT_BASKET_PRODUCTS_ID;
DROP TRIGGER INSERT_INVOICES_ID;
DROP TRIGGER INSERT_PAYMENTS_ID;

-- create triggers
CREATE OR REPLACE TRIGGER INSERT_USERS_ID
BEFORE INSERT ON USERS
FOR EACH ROW
    WHEN (NEW.USER_ID IS NULL)
BEGIN
    :NEW.USER_ID := USERS_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER INSERT_CUSTOMERS_ID
BEFORE INSERT ON CUSTOMERS
FOR EACH ROW
    WHEN (NEW.CUSTOMER_ID IS NULL)
BEGIN
    :NEW.CUSTOMER_ID := CUSTOMERS_SEQ.NEXTVAL;
END;            
/    

CREATE OR REPLACE TRIGGER INSERT_TRADERS_ID
BEFORE INSERT ON TRADERS
FOR EACH ROW
    WHEN (NEW.TRADER_ID IS NULL)
BEGIN
    :NEW.TRADER_ID := TRADERS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_ADMINS_ID
BEFORE INSERT ON ADMINS
FOR EACH ROW
    WHEN (NEW.ADMIN_ID IS NULL)
BEGIN
    :NEW.ADMIN_ID := ADMINS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_COLLECTION_SLOTS_ID
BEFORE INSERT ON COLLECTION_SLOTS
FOR EACH ROW
    WHEN (NEW.COLLECTION_SLOT_ID IS NULL)
BEGIN
    :NEW.COLLECTION_SLOT_ID := COLLECTION_SLOTS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_TRADER_TYPES_ID
BEFORE INSERT ON TRADER_TYPES
FOR EACH ROW
    WHEN (NEW.TRADER_TYPE_ID IS NULL)
BEGIN
    :NEW.TRADER_TYPE_ID := TRADER_TYPES_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_SHOPS_ID
BEFORE INSERT ON SHOPS
FOR EACH ROW
    WHEN (NEW.SHOP_ID IS NULL)
BEGIN
    :NEW.SHOP_ID := SHOPS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_PRODUCT_CATEGORIES_ID
BEFORE INSERT ON PRODUCT_CATEGORIES
FOR EACH ROW
    WHEN (NEW.PRODUCT_CATEGORY_ID IS NULL)
BEGIN
    :NEW.PRODUCT_CATEGORY_ID := PRODUCT_CATEGORIES_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER INSERT_PRODUCTS_ID
BEFORE INSERT ON PRODUCTS
FOR EACH ROW
    WHEN (NEW.PRODUCT_ID IS NULL)
BEGIN
    :NEW.PRODUCT_ID := PRODUCTS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_PRODUCT_REVIEWS_ID
BEFORE INSERT ON PRODUCT_REVIEWS
FOR EACH ROW
    WHEN (NEW.PRODUCT_REVIEW_ID IS NULL)
BEGIN
    :NEW.PRODUCT_REVIEW_ID := PRODUCT_REVIEWS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_OFFERS_ID
BEFORE INSERT ON OFFERS
FOR EACH ROW
    WHEN (NEW.OFFER_ID IS NULL)
BEGIN
    :NEW.OFFER_ID := OFFERS_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER INSERT_BASKETS_ID
BEFORE INSERT ON BASKETS
FOR EACH ROW
    WHEN (NEW.BASKET_ID IS NULL)
BEGIN
    :NEW.BASKET_ID := BASKETS_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_INVOICES_ID
BEFORE INSERT ON INVOICES
FOR EACH ROW
    WHEN (NEW.INVOICE_ID IS NULL)
BEGIN
    :NEW.INVOICE_ID := INVOICES_SEQ.NEXTVAL;
END;            
/

CREATE OR REPLACE TRIGGER INSERT_PAYMENTS_ID
BEFORE INSERT ON PAYMENTS
FOR EACH ROW
    WHEN (NEW.PAYMENT_ID IS NULL)
BEGIN
    :NEW.PAYMENT_ID := PAYMENTS_SEQ.NEXTVAL;
END;            
/
------------------------------------------------------------------------------------------------------------

