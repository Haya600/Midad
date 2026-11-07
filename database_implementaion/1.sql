
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
IF DB_ID('midad_db') IS NULL CREATE DATABASE midad_db;
GO
USE midad_db;
GO

/* 1. USER_ACCOUNT — one login table for all three roles --------------- */
CREATE TABLE user_accounts (
    user_id        INT IDENTITY(1,1) NOT NULL,
    email          NVARCHAR(150) NOT NULL,
    password_hash  VARCHAR(255)  NOT NULL,
    role           VARCHAR(10)   NOT NULL,
    account_status VARCHAR(25)   NOT NULL CONSTRAINT DF_users_status DEFAULT ('Pending Verification'),
    phone          VARCHAR(10)   NOT NULL,   -- Midad format 05XXXXXXXX (Blueprint §9.2)
    created_at     DATETIME2(0)  NOT NULL CONSTRAINT DF_users_created DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_user_accounts PRIMARY KEY (user_id),
    CONSTRAINT UQ_user_accounts_email UNIQUE (email),
    CONSTRAINT UQ_user_accounts_phone UNIQUE (phone),
    CONSTRAINT CK_user_accounts_role   CHECK (role IN ('Hotel','Supplier','Admin')),
    CONSTRAINT CK_user_accounts_status CHECK (account_status IN ('Pending Verification','Active','Suspended')),
    CONSTRAINT CK_user_accounts_phone  CHECK (phone LIKE '05[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

/* 2. ADMIN ------------------------------------------------------------ */
CREATE TABLE admins (
    admin_id    INT IDENTITY(1,1) NOT NULL,
    user_id     INT           NOT NULL,
    full_name   NVARCHAR(100) NOT NULL,
    employee_no VARCHAR(20)   NOT NULL,
    CONSTRAINT PK_admins PRIMARY KEY (admin_id),
    CONSTRAINT UQ_admins_user UNIQUE (user_id),
    CONSTRAINT UQ_admins_employee_no UNIQUE (employee_no),
    CONSTRAINT FK_admins_user FOREIGN KEY (user_id) REFERENCES user_accounts (user_id)
);
GO

/* 3. HOTEL ------------------------------------------------------------ */
CREATE TABLE hotels (
    hotel_id          INT IDENTITY(1,1) NOT NULL,
    user_id           INT           NOT NULL,
    hotel_name        NVARCHAR(120) NOT NULL,
    commercial_reg_no CHAR(10)      NOT NULL,
    contact_person    NVARCHAR(100) NOT NULL,
    city              NVARCHAR(50)  NOT NULL,
    profile_status    VARCHAR(20)   NOT NULL CONSTRAINT DF_hotels_status DEFAULT ('Pending'),
    CONSTRAINT PK_hotels PRIMARY KEY (hotel_id),
    CONSTRAINT UQ_hotels_user UNIQUE (user_id),
    CONSTRAINT UQ_hotels_name UNIQUE (hotel_name),
    CONSTRAINT UQ_hotels_cr UNIQUE (commercial_reg_no),
    CONSTRAINT FK_hotels_user FOREIGN KEY (user_id) REFERENCES user_accounts (user_id),
    CONSTRAINT CK_hotels_cr     CHECK (commercial_reg_no NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_hotels_status CHECK (profile_status IN ('Pending','Verified','Rejected'))
);
GO

/* 4. SUPPLIER --------------------------------------------------------- */
CREATE TABLE suppliers (
    supplier_id       INT IDENTITY(1,1) NOT NULL,
    user_id           INT           NOT NULL,
    company_name      NVARCHAR(120) NOT NULL,
    commercial_reg_no CHAR(10)      NOT NULL,
    contact_person    NVARCHAR(100) NOT NULL,
    city              NVARCHAR(50)  NOT NULL,
    avg_rating        DECIMAL(3,2)  NOT NULL CONSTRAINT DF_suppliers_rating DEFAULT (0),
    profile_status    VARCHAR(20)   NOT NULL CONSTRAINT DF_suppliers_status DEFAULT ('Pending'),
    supply_categories NVARCHAR(200) NULL,   -- [UI] PUB-08 "Supply categories" (comma-separated list)
    CONSTRAINT PK_suppliers PRIMARY KEY (supplier_id),
    CONSTRAINT UQ_suppliers_user UNIQUE (user_id),
    CONSTRAINT UQ_suppliers_cr UNIQUE (commercial_reg_no),
    CONSTRAINT FK_suppliers_user FOREIGN KEY (user_id) REFERENCES user_accounts (user_id),
    CONSTRAINT CK_suppliers_cr     CHECK (commercial_reg_no NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_suppliers_rating CHECK (avg_rating BETWEEN 0 AND 5),
    CONSTRAINT CK_suppliers_status CHECK (profile_status IN ('Pending','Verified','Rejected'))
);
GO

/* 5. SUPPLY_REQUEST --------------------------------------------------- */
CREATE TABLE supply_requests (
    request_id             INT IDENTITY(1035,1) NOT NULL,   -- shown as REQ-1035… like the prototypes (REQ-1042)
    hotel_id               INT           NOT NULL,
    request_status         VARCHAR(15)   NOT NULL CONSTRAINT DF_requests_status DEFAULT ('Draft'),
    priority               VARCHAR(10)   NOT NULL,
    requested_by           NVARCHAR(100) NOT NULL,
    created_at             DATETIME2(0)  NOT NULL CONSTRAINT DF_requests_created DEFAULT (SYSDATETIME()),
    required_delivery_date DATE          NOT NULL,   -- [UI] UC1-04 "Required delivery date *" (also in D1/D2 use cases)
    CONSTRAINT PK_supply_requests PRIMARY KEY (request_id),
    CONSTRAINT FK_requests_hotel FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id),
    CONSTRAINT CK_requests_status   CHECK (request_status IN ('Draft','Open','Awarded','Closed','Cancelled')),
    CONSTRAINT CK_requests_priority CHECK (priority IN ('High','Medium','Low'))
);
GO
CREATE INDEX IX_requests_hotel  ON supply_requests (hotel_id);
CREATE INDEX IX_requests_status ON supply_requests (request_status, required_delivery_date);
GO

/* 6. SUPPLIES — the items of a request -------------------------------- */
CREATE TABLE supplies (
    supply_id       INT IDENTITY(1,1) NOT NULL,
    request_id      INT            NOT NULL,
    supply_name     NVARCHAR(120)  NOT NULL,
    category        NVARCHAR(40)   NOT NULL,
    unit_of_measure VARCHAR(20)    NOT NULL CONSTRAINT DF_supplies_uom DEFAULT ('pieces'),
    description     NVARCHAR(500)  NULL,     -- "Specifications" on the form
    quantity        INT            NOT NULL,
    unit_price      DECIMAL(10,2)  NULL,
    reorder_level   INT            NULL,
    active_status   BIT            NOT NULL CONSTRAINT DF_supplies_active DEFAULT (1),
    image_url       NVARCHAR(500)  NULL,
    created_at      DATETIME2(0)   NOT NULL CONSTRAINT DF_supplies_created DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_supplies PRIMARY KEY (supply_id),
    CONSTRAINT FK_supplies_request FOREIGN KEY (request_id) REFERENCES supply_requests (request_id) ON DELETE CASCADE,
    CONSTRAINT CK_supplies_category CHECK (category IN ('Linen & Bedding','Amenities','Cleaning & Hygiene','Food & Beverage','Tableware','Equipment')),
    CONSTRAINT CK_supplies_uom      CHECK (unit_of_measure IN ('pieces','sets','units','boxes','cartons','litres','kg')),
    CONSTRAINT CK_supplies_qty      CHECK (quantity > 0),
    CONSTRAINT CK_supplies_price    CHECK (unit_price IS NULL OR unit_price >= 0),
    CONSTRAINT CK_supplies_reorder  CHECK (reorder_level IS NULL OR reorder_level >= 0)
);
GO
CREATE INDEX IX_supplies_request ON supplies (request_id);
GO

/* 7. BID — resolves Hotel M:N Supplier --------------------------------- */
CREATE TABLE bids (
    bid_id                  INT IDENTITY(1,1) NOT NULL,
    request_id              INT           NOT NULL,
    supplier_id             INT           NOT NULL,
    bid_price               DECIMAL(12,2) NOT NULL,   -- total, excluding VAT (UC2-04 hint "Excluding VAT · BID.bid_price")
    estimated_delivery_days INT           NOT NULL,
    bid_status              VARCHAR(15)   NOT NULL CONSTRAINT DF_bids_status DEFAULT ('Submitted'),
    created_at              DATETIME2(0)  NOT NULL CONSTRAINT DF_bids_created DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_bids PRIMARY KEY (bid_id),
    CONSTRAINT FK_bids_request  FOREIGN KEY (request_id)  REFERENCES supply_requests (request_id),
    CONSTRAINT FK_bids_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id),
    CONSTRAINT CK_bids_price  CHECK (bid_price > 0),
    CONSTRAINT CK_bids_days   CHECK (estimated_delivery_days BETWEEN 1 AND 180),
    CONSTRAINT CK_bids_status CHECK (bid_status IN ('Submitted','Accepted','Rejected','Cancelled'))
);
GO
-- UC2-03: "you may hold only one active bid per request"
CREATE UNIQUE INDEX UX_bids_one_active ON bids (request_id, supplier_id) WHERE bid_status IN ('Submitted','Accepted');
CREATE INDEX IX_bids_supplier ON bids (supplier_id);
GO

/* 8. CONTRACT (0..1 per bid) ------------------------------------------- */
CREATE TABLE contracts (
    contract_id          INT IDENTITY(1,1) NOT NULL,
    bid_id               INT           NOT NULL,
    contract_no          VARCHAR(20)   NOT NULL,
    contract_value       DECIMAL(12,2) NOT NULL,
    agreed_delivery_date DATE          NOT NULL,
    contract_status      VARCHAR(20)   NOT NULL CONSTRAINT DF_contracts_status DEFAULT ('Pending Signatures'),
    document_url         NVARCHAR(500) NULL,
    hotel_signed_at      DATETIME2(0)  NULL,
    supplier_signed_at   DATETIME2(0)  NULL,
    generated_at         DATETIME2(0)  NOT NULL CONSTRAINT DF_contracts_generated DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_contracts PRIMARY KEY (contract_id),
    CONSTRAINT UQ_contracts_bid UNIQUE (bid_id),
    CONSTRAINT UQ_contracts_no  UNIQUE (contract_no),
    CONSTRAINT FK_contracts_bid FOREIGN KEY (bid_id) REFERENCES bids (bid_id),
    CONSTRAINT CK_contracts_value  CHECK (contract_value > 0),
    CONSTRAINT CK_contracts_status CHECK (contract_status IN ('Pending Signatures','Signed','Cancelled')),
    CONSTRAINT CK_contracts_signed CHECK (contract_status <> 'Signed' OR (hotel_signed_at IS NOT NULL AND supplier_signed_at IS NOT NULL))
);
GO

/* 9. PURCHASE_ORDER (0..1 per contract) ------------------------------- */
CREATE TABLE purchase_orders (
    order_id               INT IDENTITY(1,1) NOT NULL,
    contract_id            INT          NOT NULL,
    order_no               VARCHAR(20)  NOT NULL,
    order_status           VARCHAR(15)  NOT NULL CONSTRAINT DF_orders_status DEFAULT ('Created'),
    expected_delivery_date DATE         NOT NULL,
    actual_delivery_date   DATE         NULL,
    created_at             DATETIME2(0) NOT NULL CONSTRAINT DF_orders_created DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_purchase_orders PRIMARY KEY (order_id),
    CONSTRAINT UQ_orders_contract UNIQUE (contract_id),
    CONSTRAINT UQ_orders_no UNIQUE (order_no),
    CONSTRAINT FK_orders_contract FOREIGN KEY (contract_id) REFERENCES contracts (contract_id),
    CONSTRAINT CK_orders_status    CHECK (order_status IN ('Created','Processing','Shipped','Delivered','Completed','Cancelled')),
    CONSTRAINT CK_orders_delivered CHECK (order_status NOT IN ('Delivered','Completed') OR actual_delivery_date IS NOT NULL)
);
GO

/* 10. INVOICE (0..1 per order) ---------------------------------------- */
CREATE TABLE invoices (
    invoice_id        INT IDENTITY(1,1) NOT NULL,
    order_id          INT           NOT NULL,
    invoice_no        VARCHAR(20)   NOT NULL,
    subtotal_amount   DECIMAL(12,2) NOT NULL,
    vat_amount        DECIMAL(12,2) NOT NULL,   -- 15 % Saudi VAT
    total_amount      DECIMAL(12,2) NOT NULL,
    issue_date        DATE          NOT NULL,
    invoice_status    VARCHAR(20)   NOT NULL CONSTRAINT DF_invoices_status DEFAULT ('Unpaid'),
    commission_amount DECIMAL(12,2) NOT NULL,   -- Midad's 10 % platform commission (D1)
    CONSTRAINT PK_invoices PRIMARY KEY (invoice_id),
    CONSTRAINT UQ_invoices_order UNIQUE (order_id),
    CONSTRAINT UQ_invoices_no UNIQUE (invoice_no),
    CONSTRAINT FK_invoices_order FOREIGN KEY (order_id) REFERENCES purchase_orders (order_id),
    CONSTRAINT CK_invoices_amounts CHECK (subtotal_amount > 0 AND vat_amount >= 0 AND commission_amount >= 0
                                          AND total_amount = subtotal_amount + vat_amount),
    CONSTRAINT CK_invoices_status  CHECK (invoice_status IN ('Unpaid','Paid','Refunded','Partially Refunded'))
);
GO

/* 11. PAYMENT --------------------------------------------------------- */
CREATE TABLE payments (
    payment_id       INT IDENTITY(1,1) NOT NULL,
    invoice_id       INT           NOT NULL,
    hotel_id         INT           NOT NULL,
    amount           DECIMAL(12,2) NOT NULL,
    payment_method   VARCHAR(15)   NOT NULL,
    card_last4       CHAR(4)       NOT NULL,
    payment_status   VARCHAR(15)   NOT NULL,
    paid_at          DATETIME2(0)  NOT NULL CONSTRAINT DF_payments_paid DEFAULT (SYSDATETIME()),
    card_holder_name NVARCHAR(100) NOT NULL,
    card_number      VARCHAR(19)   NOT NULL,   -- masked only '**** **** **** 1234' — never the full PAN, never the CVV
    card_expiry_date CHAR(5)       NOT NULL,   -- 'MM/YY'
    CONSTRAINT PK_payments PRIMARY KEY (payment_id),
    CONSTRAINT FK_payments_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id),
    CONSTRAINT FK_payments_hotel   FOREIGN KEY (hotel_id)   REFERENCES hotels (hotel_id),
    CONSTRAINT CK_payments_amount  CHECK (amount > 0),
    CONSTRAINT CK_payments_method  CHECK (payment_method IN ('Credit Card','Debit Card')),
    CONSTRAINT CK_payments_status  CHECK (payment_status IN ('Paid','Failed','Refunded')),
    CONSTRAINT CK_payments_last4   CHECK (card_last4 NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_payments_mask    CHECK (card_number LIKE '**** **** **** [0-9][0-9][0-9][0-9]' AND RIGHT(card_number,4) = card_last4),
    CONSTRAINT CK_payments_expiry  CHECK (card_expiry_date LIKE '[0-1][0-9]/[0-9][0-9]')
);
GO
CREATE INDEX IX_payments_invoice ON payments (invoice_id);
CREATE INDEX IX_payments_hotel   ON payments (hotel_id);
GO

/* 12. REFUND_REQUEST -------------------------------------------------- */
CREATE TABLE refund_requests (
    refund_id         INT IDENTITY(1,1) NOT NULL,
    order_id          INT            NOT NULL,
    hotel_id          INT            NOT NULL,
    reason            NVARCHAR(1000) NOT NULL,
    evidence_file_url NVARCHAR(500)  NOT NULL,
    requested_amount  DECIMAL(12,2)  NOT NULL,
    refund_status     VARCHAR(15)    NOT NULL CONSTRAINT DF_refunds_status DEFAULT ('Pending'),
    requested_at      DATETIME2(0)   NOT NULL CONSTRAINT DF_refunds_requested DEFAULT (SYSDATETIME()),
    admin_id          INT            NULL,   -- the only optional parent in the ERD
    verified_at       DATETIME2(0)   NULL,
    CONSTRAINT PK_refund_requests PRIMARY KEY (refund_id),
    CONSTRAINT FK_refunds_order FOREIGN KEY (order_id) REFERENCES purchase_orders (order_id),
    CONSTRAINT FK_refunds_hotel FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id),
    CONSTRAINT FK_refunds_admin FOREIGN KEY (admin_id) REFERENCES admins (admin_id),
    CONSTRAINT CK_refunds_amount CHECK (requested_amount > 0),
    CONSTRAINT CK_refunds_status CHECK (refund_status IN ('Pending','Approved','Rejected')),
    CONSTRAINT CK_refunds_verified CHECK ((refund_status = 'Pending' AND admin_id IS NULL AND verified_at IS NULL)
                                       OR (refund_status <> 'Pending' AND admin_id IS NOT NULL AND verified_at IS NOT NULL))
);
GO
CREATE INDEX IX_refunds_order ON refund_requests (order_id);
GO

/* 13. RATING (0..1 per order) ----------------------------------------- */
CREATE TABLE ratings (
    rating_id      INT IDENTITY(1,1) NOT NULL,
    order_id       INT            NOT NULL,
    hotel_id       INT            NOT NULL,
    supplier_id    INT            NOT NULL,
    star_rating    TINYINT        NOT NULL,
    review_comment NVARCHAR(1000) NULL,
    created_at     DATETIME2(0)   NOT NULL CONSTRAINT DF_ratings_created DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_ratings PRIMARY KEY (rating_id),
    CONSTRAINT UQ_ratings_order UNIQUE (order_id),
    CONSTRAINT FK_ratings_order    FOREIGN KEY (order_id)    REFERENCES purchase_orders (order_id),
    CONSTRAINT FK_ratings_hotel    FOREIGN KEY (hotel_id)    REFERENCES hotels (hotel_id),
    CONSTRAINT FK_ratings_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id),
    CONSTRAINT CK_ratings_star CHECK (star_rating BETWEEN 1 AND 5)
);
GO
CREATE INDEX IX_ratings_supplier ON ratings (supplier_id);
GO








SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

USE midad_db;
GO

IF OBJECT_ID('dbo.notifications', 'U') IS NULL
BEGIN
    CREATE TABLE notifications (
        notification_id INT IDENTITY(1,1) NOT NULL,
        user_id         INT           NOT NULL,          -- recipient
        event_type      VARCHAR(30)   NOT NULL,
        message         NVARCHAR(300) NOT NULL,
        link_url        NVARCHAR(300) NULL,              -- relative path in the app, e.g. /hotel/requests/1042?tab=bids
        is_read         BIT           NOT NULL CONSTRAINT DF_notifications_read DEFAULT (0),
        created_at      DATETIME2(0)  NOT NULL CONSTRAINT DF_notifications_created DEFAULT (SYSDATETIME()),
        CONSTRAINT PK_notifications PRIMARY KEY (notification_id),
        CONSTRAINT FK_notifications_user FOREIGN KEY (user_id) REFERENCES user_accounts (user_id),
        CONSTRAINT CK_notifications_type CHECK (event_type IN
            ('New bid', 'New supply request', 'Bid accepted', 'Bid rejected', 'Bid updated', 'Request updated'))
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_notifications_user' AND object_id = OBJECT_ID('dbo.notifications'))
    CREATE INDEX IX_notifications_user ON notifications (user_id, is_read, created_at DESC);
GO

PRINT 'notifications table ready.';
GO

