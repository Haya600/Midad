
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;   -- required by the filtered unique index on bids
GO
USE midad_db;
GO
/* user_accounts (14) */
SET IDENTITY_INSERT user_accounts ON;
INSERT INTO user_accounts (user_id, email, password_hash, role, account_status, phone, created_at) VALUES
(1, N'amal.alharbi@midad.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Admin', 'Active', '0551203344', '2026-06-01 09:00:00'),
(2, N'turki.alqahtani@midad.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Admin', 'Active', '0562209981', '2026-06-01 09:30:00'),
(3, N'haya.mushaweh@movenpick-alkhobar.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Hotel', 'Active', '0554128830', '2026-07-02 10:15:00'),
(4, N'ghalia.kabli@hilton-dhahran.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Hotel', 'Active', '0567340192', '2026-07-05 11:40:00'),
(5, N'noura.aldossary@sheraton-dammam.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Hotel', 'Active', '0598811204', '2026-07-08 09:05:00'),
(6, N'sultan.alharbi@hi-jubail.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Hotel', 'Active', '0532284517', '2026-07-12 14:20:00'),
(7, N'reem.alzahrani@novotel-dammam.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Hotel', 'Active', '0545502763', '2026-07-20 08:50:00'),
(8, N'faisal.alotaibi@radisson-khobar.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Hotel', 'Pending Verification', '0509917635', '2026-10-09 16:10:00'),
(9, N'jouri@aljazeera-supplies.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Supplier', 'Active', '0552184470', '2026-07-03 12:00:00'),
(10, N'gori.moneef@gulflinen.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Supplier', 'Active', '0573316608', '2026-07-04 10:30:00'),
(11, N'sales@easternamenities.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Supplier', 'Active', '0581049927', '2026-07-06 13:45:00'),
(12, N'orders@najd-hospitality.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Supplier', 'Active', '0536620418', '2026-07-10 09:10:00'),
(13, N'lama@khobartableware.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Supplier', 'Active', '0547738150', '2026-07-15 15:25:00'),
(14, N'yousef@jubailclean.sa', '$2y$10$J4eyO6nIhvbH0RhH3Qs5WOs1sy3fXsSWH5q64A71RrD7OyaRQ6m4G', 'Supplier', 'Pending Verification', '0590264371', '2026-10-10 11:05:00');
SET IDENTITY_INSERT user_accounts OFF;
GO

/* admins (2) */
SET IDENTITY_INSERT admins ON;
INSERT INTO admins (admin_id, user_id, full_name, employee_no) VALUES
(1, 1, N'Amal Abdullah Alharbi', 'MID-ADM-001'),
(2, 2, N'Turki Saad Al-Qahtani', 'MID-ADM-002');
SET IDENTITY_INSERT admins OFF;
GO

/* hotels (6) */
SET IDENTITY_INSERT hotels ON;
INSERT INTO hotels (hotel_id, user_id, hotel_name, commercial_reg_no, contact_person, city, profile_status) VALUES
(1, 3, N'Mövenpick Al Khobar', '2051048832', N'Haya Ibrahim Mushaweh', N'Al Khobar', 'Verified'),
(2, 4, N'Hilton Dhahran', '2052217764', N'Ghalia Fahad Kabli', N'Dhahran', 'Verified'),
(3, 5, N'Sheraton Dammam Hotel', '2050903318', N'Noura Al-Dossary', N'Dammam', 'Verified'),
(4, 6, N'Holiday Inn Al Jubail', '2055630471', N'Sultan Al-Harbi', N'Jubail', 'Verified'),
(5, 7, N'Novotel Dammam Business Park', '2050418896', N'Reem Al-Zahrani', N'Dammam', 'Verified'),
(6, 8, N'Radisson Blu Al Khobar', '2051762240', N'Faisal Al-Otaibi', N'Al Khobar', 'Pending');
SET IDENTITY_INSERT hotels OFF;
GO

/* suppliers (6) */
SET IDENTITY_INSERT suppliers ON;
INSERT INTO suppliers (supplier_id, user_id, company_name, commercial_reg_no, contact_person, city, avg_rating, profile_status, supply_categories) VALUES
(1, 9, N'Al Jazeera Hotel Supplies', '2055012345', N'Jouri Malhi Alharbi', N'Dammam', 0.00, 'Verified', N'Linen & Bedding, Amenities'),
(2, 10, N'Gulf Linen Trading', '2051177302', N'Gori Moneef', N'Al Khobar', 3.00, 'Verified', N'Linen & Bedding'),
(3, 11, N'Eastern Amenities Co.', '2050284419', N'Abdulrahman Al-Shammari', N'Dammam', 5.00, 'Verified', N'Amenities, Cleaning & Hygiene'),
(4, 12, N'Najd Hospitality Equipment', '2055871136', N'Mohammed Al-Ghamdi', N'Jubail', 0.00, 'Verified', N'Equipment, Tableware'),
(5, 13, N'Khobar Tableware House', '2051309957', N'Lama Al-Subaie', N'Al Khobar', 4.00, 'Verified', N'Tableware, Food & Beverage'),
(6, 14, N'Jubail Clean & Care', '2055504283', N'Yousef Al-Malki', N'Jubail', 0.00, 'Pending', N'Cleaning & Hygiene');
SET IDENTITY_INSERT suppliers OFF;
GO

/* supply_requests (12) */
SET IDENTITY_INSERT supply_requests ON;
INSERT INTO supply_requests (request_id, hotel_id, request_status, priority, requested_by, created_at, required_delivery_date) VALUES
(1035, 3, 'Closed', 'High', N'Noura Al-Dossary — Procurement', '2026-08-03 09:20:00', '2026-08-25'),
(1036, 1, 'Closed', 'Medium', N'Haya Ibrahim — Procurement', '2026-08-10 10:05:00', '2026-09-05'),
(1037, 2, 'Closed', 'Low', N'Ghalia Kabli — Housekeeping', '2026-08-18 08:45:00', '2026-09-20'),
(1038, 4, 'Closed', 'Medium', N'Sultan Al-Harbi — Procurement', '2026-08-25 11:30:00', '2026-09-25'),
(1039, 5, 'Awarded', 'High', N'Reem Al-Zahrani — Purchasing', '2026-09-10 09:00:00', '2026-10-20'),
(1040, 2, 'Awarded', 'Medium', N'Ghalia Kabli — Housekeeping', '2026-09-22 10:40:00', '2026-10-18'),
(1041, 1, 'Open', 'Medium', N'Haya Ibrahim — Procurement', '2026-10-02 09:30:00', '2026-10-28'),
(1042, 1, 'Open', 'High', N'Haya Ibrahim — Procurement', '2026-09-29 10:12:00', '2026-10-15'),
(1043, 3, 'Open', 'Low', N'Noura Al-Dossary — Procurement', '2026-10-06 13:10:00', '2026-11-05'),
(1044, 5, 'Open', 'High', N'Reem Al-Zahrani — Purchasing', '2026-10-10 08:30:00', '2026-10-30'),
(1045, 1, 'Draft', 'Low', N'Haya Ibrahim — Procurement', '2026-10-11 17:45:00', '2026-11-20'),
(1046, 4, 'Cancelled', 'Medium', N'Sultan Al-Harbi — Procurement', '2026-09-05 12:00:00', '2026-09-30');
SET IDENTITY_INSERT supply_requests OFF;
GO

/* supplies (16) */
SET IDENTITY_INSERT supplies ON;
INSERT INTO supplies (supply_id, request_id, supply_name, category, unit_of_measure, description, quantity, unit_price, reorder_level, active_status, image_url, created_at) VALUES
(1, 1035, N'Bathroom amenity sets', N'Amenities', 'sets', N'5-piece kit: shampoo, conditioner, body wash, lotion and soap, 30 ml each, hotel branding.', 1200, NULL, NULL, 1, N'https://upload.wikimedia.org/wikipedia/commons/2/29/Ambience_Hotel_Taipei_Bathroom_amenities_%282931659842%29.jpg', '2026-08-03 09:20:00'),
(2, 1036, N'Bath towels, 600 gsm', N'Linen & Bedding', 'pieces', N'70 × 140 cm, white, double-stitched hem, colourfast.', 600, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/69/Stacks-of-gym-towels-on-wood-bench.jpg/960px-Stacks-of-gym-towels-on-wood-bench.jpg', '2026-08-10 10:05:00'),
(3, 1036, N'Hand towels, 500 gsm', N'Linen & Bedding', 'pieces', N'40 × 70 cm, white, matching the bath towels.', 600, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/8d/Towel_rails_radiator_with_hanger.jpg/960px-Towel_rails_radiator_with_hanger.jpg', '2026-08-10 10:05:00'),
(4, 1037, N'Disposable slippers', N'Amenities', 'pieces', N'Closed-toe, 4 mm EVA sole, white waffle, one size.', 3000, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/1/13/Hotel_slippers_from_mr_jaba.jpg/960px-Hotel_slippers_from_mr_jaba.jpg', '2026-08-18 08:45:00'),
(5, 1038, N'Porcelain dinner plates, 27 cm', N'Tableware', 'pieces', N'Bone white, rolled rim, dishwasher and oven safe.', 800, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/3/3b/Dinner_plates.jpg/960px-Dinner_plates.jpg', '2026-08-25 11:30:00'),
(6, 1038, N'Stainless cutlery sets', N'Tableware', 'sets', N'18/10 stainless steel, 4-piece set, mirror finish.', 400, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b9/Cutlery_designed_by_Zaha_Hadid_for_company_WMF%2C_2007_N.2.jpg/960px-Cutlery_designed_by_Zaha_Hadid_for_company_WMF%2C_2007_N.2.jpg', '2026-08-25 11:30:00'),
(7, 1039, N'Housekeeping trolleys', N'Equipment', 'units', N'Stainless frame, lockable cabinet, 3 shelves, linen bag and bin.', 12, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/f/fa/Ramstein%E2%80%99s_best_new_building_in_town_%287075655%29.jpg/960px-Ramstein%E2%80%99s_best_new_building_in_town_%287075655%29.jpg', '2026-09-10 09:00:00'),
(8, 1040, N'Single-serve amenity kits', N'Amenities', 'sets', N'Dental kit, shaving kit and vanity kit in a recycled-paper pouch.', 2000, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/89/Bath_amenities_%26_toiletries_%282940557801%29.jpg/960px-Bath_amenities_%26_toiletries_%282940557801%29.jpg', '2026-09-22 10:40:00'),
(9, 1041, N'Restaurant table linen', N'Linen & Bedding', 'pieces', N'180 × 180 cm, ivory damask, stain-release finish.', 300, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/1/17/Table_setting_in_a_restaurant.JPG/960px-Table_setting_in_a_restaurant.JPG', '2026-10-02 09:30:00'),
(10, 1042, N'Cotton bed linen', N'Linen & Bedding', 'pieces', N'300 thread count, 100% cotton, white, hotel grade.', 400, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/8c/Bed_in_Seattle_hotel.jpg/960px-Bed_in_Seattle_hotel.jpg', '2026-09-29 10:12:00'),
(11, 1042, N'Bath towels, 600 gsm', N'Linen & Bedding', 'pieces', N'70 × 140 cm, white, double-stitched hem, colourfast.', 750, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/69/Stacks-of-gym-towels-on-wood-bench.jpg/960px-Stacks-of-gym-towels-on-wood-bench.jpg', '2026-09-29 10:12:00'),
(12, 1043, N'Pool towels, 500 gsm', N'Linen & Bedding', 'pieces', N'90 × 180 cm, navy and white stripes, quick-dry.', 500, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/0/03/Israel_Batch_2_%28204%29.JPG/960px-Israel_Batch_2_%28204%29.JPG', '2026-10-06 13:10:00'),
(13, 1044, N'Toothbrush kits', N'Amenities', 'sets', N'Soft-bristle toothbrush with 10 g toothpaste, individually wrapped.', 2500, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b9/Toothbrush%2C_Toothpaste%2C_Dental_Care_%28571741%29.jpg/960px-Toothbrush%2C_Toothpaste%2C_Dental_Care_%28571741%29.jpg', '2026-10-10 08:30:00'),
(14, 1044, N'Liquid hand soap, 5 L', N'Cleaning & Hygiene', 'units', N'Antibacterial, unscented, refill cans for dispensers.', 40, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b3/Blue_liquid_soap_in_a_plastic_dispenser_2.jpg/960px-Blue_liquid_soap_in_a_plastic_dispenser_2.jpg', '2026-10-10 08:30:00'),
(15, 1045, N'Glass tumblers, 300 ml', N'Tableware', 'pieces', N'Tempered glass, stackable, dishwasher safe.', 600, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/9/93/Tumbler_MET_176278.jpg/960px-Tumbler_MET_176278.jpg', '2026-10-11 17:45:00'),
(16, 1046, N'Coffee capsules', N'Food & Beverage', 'boxes', N'Espresso-compatible, 20 capsules per box, medium roast.', 250, NULL, NULL, 1, N'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/cc/Nespresso-capsules_AB-01.jpg/960px-Nespresso-capsules_AB-01.jpg', '2026-09-05 12:00:00');
SET IDENTITY_INSERT supplies OFF;
GO

/* bids (21) */
SET IDENTITY_INSERT bids ON;
INSERT INTO bids (bid_id, request_id, supplier_id, bid_price, estimated_delivery_days, bid_status, created_at) VALUES
(1, 1035, 3, 39600.00, 10, 'Accepted', '2026-08-04 11:00:00'),
(2, 1035, 1, 42000.00, 8, 'Rejected', '2026-08-04 15:30:00'),
(3, 1036, 2, 21300.00, 12, 'Accepted', '2026-08-11 09:40:00'),
(4, 1036, 1, 22800.00, 10, 'Rejected', '2026-08-11 13:15:00'),
(5, 1037, 3, 7500.00, 7, 'Accepted', '2026-08-19 10:10:00'),
(6, 1037, 1, 8100.00, 6, 'Rejected', '2026-08-19 16:00:00'),
(7, 1038, 5, 28400.00, 14, 'Accepted', '2026-08-26 12:20:00'),
(8, 1038, 4, 30200.00, 12, 'Rejected', '2026-08-26 17:05:00'),
(9, 1039, 4, 26400.00, 18, 'Accepted', '2026-09-11 10:30:00'),
(10, 1039, 5, 27000.00, 20, 'Rejected', '2026-09-11 14:45:00'),
(11, 1040, 3, 18000.00, 9, 'Accepted', '2026-09-23 09:15:00'),
(12, 1040, 2, 19400.00, 11, 'Rejected', '2026-09-23 12:40:00'),
(13, 1041, 1, 9450.00, 10, 'Submitted', '2026-10-03 11:20:00'),
(14, 1041, 2, 9900.00, 8, 'Submitted', '2026-10-04 08:55:00'),
(15, 1042, 2, 46900.00, 14, 'Submitted', '2026-09-30 09:05:00'),
(16, 1042, 1, 48750.00, 12, 'Submitted', '2026-09-30 14:26:00'),
(17, 1042, 3, 51200.00, 10, 'Submitted', '2026-10-01 10:40:00'),
(18, 1042, 5, 49800.00, 16, 'Submitted', '2026-10-01 16:15:00'),
(19, 1043, 2, 14000.00, 9, 'Submitted', '2026-10-07 10:00:00'),
(20, 1043, 1, 14800.00, 10, 'Cancelled', '2026-10-07 15:20:00'),
(21, 1046, 5, 11250.00, 6, 'Rejected', '2026-09-06 10:30:00');
SET IDENTITY_INSERT bids OFF;
GO

/* contracts (6) */
SET IDENTITY_INSERT contracts ON;
INSERT INTO contracts (contract_id, bid_id, contract_no, contract_value, agreed_delivery_date, contract_status, document_url, hotel_signed_at, supplier_signed_at, generated_at) VALUES
(1, 1, 'MID-CT-2026-001', 39600.00, '2026-08-15', 'Signed', N'/storage/contracts/MID-CT-2026-001.pdf', '2026-08-05 10:00:00', '2026-08-05 15:30:00', '2026-08-05 07:00:00'),
(2, 3, 'MID-CT-2026-002', 21300.00, '2026-08-24', 'Signed', N'/storage/contracts/MID-CT-2026-002.pdf', '2026-08-12 09:20:00', '2026-08-12 13:45:00', '2026-08-12 05:40:00'),
(3, 5, 'MID-CT-2026-003', 7500.00, '2026-08-27', 'Signed', N'/storage/contracts/MID-CT-2026-003.pdf', '2026-08-20 11:00:00', '2026-08-20 16:10:00', '2026-08-20 06:10:00'),
(4, 7, 'MID-CT-2026-004', 28400.00, '2026-09-11', 'Signed', N'/storage/contracts/MID-CT-2026-004.pdf', '2026-08-27 10:40:00', '2026-08-28 09:15:00', '2026-08-27 08:20:00'),
(5, 9, 'MID-CT-2026-005', 26400.00, '2026-10-01', 'Signed', N'/storage/contracts/MID-CT-2026-005.pdf', '2026-09-12 12:00:00', '2026-09-13 10:30:00', '2026-09-12 06:30:00'),
(6, 11, 'MID-CT-2026-006', 18000.00, '2026-10-03', 'Pending Signatures', N'/storage/contracts/MID-CT-2026-006.pdf', '2026-09-24 10:05:00', NULL, '2026-09-24 05:15:00');
SET IDENTITY_INSERT contracts OFF;
GO

/* purchase_orders (5) */
SET IDENTITY_INSERT purchase_orders ON;
INSERT INTO purchase_orders (order_id, contract_id, order_no, order_status, expected_delivery_date, actual_delivery_date, created_at) VALUES
(1, 1, 'PO-2026-0001', 'Completed', '2026-08-15', '2026-08-15', '2026-08-05 15:35:00'),
(2, 2, 'PO-2026-0002', 'Completed', '2026-08-24', '2026-08-24', '2026-08-12 13:50:00'),
(3, 3, 'PO-2026-0003', 'Completed', '2026-08-27', '2026-08-27', '2026-08-20 16:15:00'),
(4, 4, 'PO-2026-0004', 'Completed', '2026-09-11', '2026-09-11', '2026-08-28 09:20:00'),
(5, 5, 'PO-2026-0005', 'Processing', '2026-10-01', NULL, '2026-09-13 10:35:00');
SET IDENTITY_INSERT purchase_orders OFF;
GO

/* invoices (5) */
SET IDENTITY_INSERT invoices ON;
INSERT INTO invoices (invoice_id, order_id, invoice_no, subtotal_amount, vat_amount, total_amount, issue_date, invoice_status, commission_amount) VALUES
(1, 1, 'INV-2026-0001', 39600.00, 5940.00, 45540.00, '2026-08-05', 'Paid', 3960.00),
(2, 2, 'INV-2026-0002', 21300.00, 3195.00, 24495.00, '2026-08-12', 'Partially Refunded', 2130.00),
(3, 3, 'INV-2026-0003', 7500.00, 1125.00, 8625.00, '2026-08-20', 'Paid', 750.00),
(4, 4, 'INV-2026-0004', 28400.00, 4260.00, 32660.00, '2026-08-28', 'Paid', 2840.00),
(5, 5, 'INV-2026-0005', 26400.00, 3960.00, 30360.00, '2026-09-13', 'Unpaid', 2640.00);
SET IDENTITY_INSERT invoices OFF;
GO

/* payments (5) */
SET IDENTITY_INSERT payments ON;
INSERT INTO payments (payment_id, invoice_id, hotel_id, amount, payment_method, card_last4, payment_status, paid_at, card_holder_name, card_number, card_expiry_date) VALUES
(1, 1, 3, 45540.00, 'Debit Card', '4410', 'Paid', '2026-08-05 17:30:00', N'NOURA ALDOSSARY', '**** **** **** 4410', '09/28'),
(2, 2, 1, 24495.00, 'Credit Card', '8823', 'Paid', '2026-08-12 15:45:00', N'HAYA MUSHAWEH', '**** **** **** 8823', '11/27'),
(3, 3, 2, 8625.00, 'Credit Card', '3051', 'Paid', '2026-08-20 18:10:00', N'GHALIA KABLI', '**** **** **** 3051', '02/29'),
(4, 4, 4, 32660.00, 'Credit Card', '0917', 'Failed', '2026-08-28 10:15:00', N'SULTAN ALHARBI', '**** **** **** 0917', '05/27'),
(5, 4, 4, 32660.00, 'Debit Card', '6278', 'Paid', '2026-08-28 11:15:00', N'SULTAN ALHARBI', '**** **** **** 6278', '07/28');
SET IDENTITY_INSERT payments OFF;
GO

/* refund_requests (2) */
SET IDENTITY_INSERT refund_requests ON;
INSERT INTO refund_requests (refund_id, order_id, hotel_id, reason, evidence_file_url, requested_amount, refund_status, requested_at, admin_id, verified_at) VALUES
(1, 2, 1, N'42 hand towels arrived with torn hems and loose threads; they cannot be used in guest rooms.', N'/storage/refunds/RF-0001-torn-towels.jpg', 1029.00, 'Approved', '2026-08-26 10:30:00', 1, '2026-08-28 14:00:00'),
(2, 4, 4, N'36 dinner plates were broken in transit; the outer cartons were crushed on delivery.', N'/storage/refunds/RF-0002-broken-plates.jpg', 1278.00, 'Pending', '2026-10-08 09:45:00', NULL, NULL);
SET IDENTITY_INSERT refund_requests OFF;
GO

/* ratings (4) */
SET IDENTITY_INSERT ratings ON;
INSERT INTO ratings (rating_id, order_id, hotel_id, supplier_id, star_rating, review_comment, created_at) VALUES
(1, 1, 3, 3, 5, N'Excellent kits, consistent filling and delivered two days early.', '2026-08-17 10:00:00'),
(2, 2, 1, 2, 3, N'Bath towels were good, but part of the hand towels arrived damaged. Refund was handled quickly.', '2026-08-29 12:15:00'),
(3, 3, 2, 3, 5, N'Slippers matched the sample exactly. Will order again.', '2026-08-28 09:30:00'),
(4, 4, 4, 5, 4, N'Good quality plates and cutlery; packaging should be stronger.', '2026-09-13 11:00:00');
SET IDENTITY_INSERT ratings OFF;
GO
SELECT 'user_accounts' t, COUNT(*) n FROM user_accounts UNION ALL SELECT 'admins', COUNT(*) FROM admins
UNION ALL SELECT 'hotels', COUNT(*) FROM hotels UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'supply_requests', COUNT(*) FROM supply_requests UNION ALL SELECT 'supplies', COUNT(*) FROM supplies
UNION ALL SELECT 'bids', COUNT(*) FROM bids UNION ALL SELECT 'contracts', COUNT(*) FROM contracts
UNION ALL SELECT 'purchase_orders', COUNT(*) FROM purchase_orders UNION ALL SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'payments', COUNT(*) FROM payments UNION ALL SELECT 'refund_requests', COUNT(*) FROM refund_requests
UNION ALL SELECT 'ratings', COUNT(*) FROM ratings;
GO
