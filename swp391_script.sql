USE [master]
GO
DROP DATABASE [SWP391_Project]
GO
CREATE DATABASE [SWP391_Project] 
GO
USE [SWP391_Project]
----------------------------------------------------------------
-----USER ROLE-----
CREATE TABLE tblUserRole
(
	[role_ID] [nvarchar](10) PRIMARY KEY NOT NULL ,
	[role_Name] [nvarchar](20) UNIQUE NOT NULL ,
	[description] [nvarchar](Max)
)
GO

-----USER-----
CREATE TABLE tblUser
(
	username nvarchar(30) PRIMARY KEY,
	[password] nvarchar(30) NOT NULL,
	role_ID nvarchar(10) NOT NULL,
	[phone] nvarchar(11),
	[email] [nvarchar](30),
	[status] [decimal](1)
)
GO

CREATE TABLE tblCustomer
(
	[username] nvarchar(30) PRIMARY KEY,
	[password] [nvarchar](30) NOT NULL,
	[role_ID] [nvarchar](10) REFERENCES tblUserRole(role_ID) NOT NULL,
	[phone] nvarchar(11) NOT NULL,
	[email] [nvarchar](30) UNIQUE NOT NULL,
	[name] nvarchar(30) NOT NULL,
	gender [int],
	dob date,
	avatar nvarchar(max),
	point [decimal](9),
	[status] [decimal](1)
)
GO

CREATE TABLE tblProvider
(
	[username] nvarchar(30) PRIMARY KEY,
	[password] [nvarchar](30) NOT NULL,
	[role_ID] [nvarchar](10) REFERENCES tblUserRole(role_ID) NOT NULL,
	[phone] [nvarchar](11) UNIQUE ,
	[email] [nvarchar](30) UNIQUE ,
	[name] nvarchar(30) UNIQUE NOT NULL,
	[logo] nvarchar(max) ,
	[status] [decimal](1)
)
GO

-----ADDRESS-----
CREATE TABLE tblProvince_City
(
	[province_Name] [nvarchar](25) UNIQUE NOT NULL,
	[province_ID] [nvarchar](10) PRIMARY KEY
)
GO

CREATE TABLE tblDistrict
(
	[district_ID] nvarchar(10) PRIMARY KEY,
	[city_name] [nvarchar](35) NOT NULL ,
	[prefix] nvarchar(20) ,
	[province_ID] nvarchar(10) REFERENCES tblProvince_City([province_ID])
)
GO

CREATE TABLE tblAddress
(
	[address_ID] [int] IDENTITY(1,1) PRIMARY KEY ,
	street nvarchar(max) ,
	[district_ID] nvarchar(10) REFERENCES tblDistrict([district_ID]) NOT NULL ,
	[user_ID] nvarchar(30) REFERENCES tblUser(username) NOT NULL,
	[status] int
)
GO


-----PRODUCT-----
CREATE TABLE tblProductCategory
(
	category_ID nvarchar(10) PRIMARY KEY NOT NULL ,
	[name] nvarchar(20) UNIQUE NOT NULL,
	[image] [nvarchar](max) NOT NULL
)
GO

CREATE TABLE tblProduct
(
	product_ID nvarchar(10) PRIMARY KEY NOT NULL ,
	category_ID nvarchar(10) REFERENCES tblProductCategory(category_ID) NOT NULL,
	[name] nvarchar(60) UNIQUE NOT NULL,
	[image] nvarchar(max) NOT NULL,
)
GO

CREATE TABLE tblProductDetail
(
	id [int] IDENTITY(1,1) PRIMARY KEY ,
	provider_ID nvarchar(30) REFERENCES tblProvider(username) NOT NULL,
	product_ID nvarchar(10) REFERENCES tblProduct(product_ID) NOT NULL ,
	[name] nvarchar(60) NOT NULL,
	quantity decimal(2) NOT NULL,
	price decimal (9) NOT NULL,
	[image] nvarchar(max) ,
	[description] nvarchar(max) ,
	[status] decimal(1) NOT NULL
)
GO

-----ORDER-----
CREATE TABLE tblOrder
(
	order_ID [int] IDENTITY(1,1) PRIMARY KEY ,
	order_Date [date] NOT NULL ,
	customer_ID nvarchar(30) REFERENCES tblCustomer(username) NOT NULL,
	[status] decimal(1) NOT NULL  ,
	total decimal(9) NOT NULL,
	payment nvarchar(10),
)
GO

CREATE TABLE tblOrder_Product_Detail
(
	id [int] IDENTITY(1,1) PRIMARY KEY ,
	product_detail_ID [int] REFERENCES tblProductDetail(id) NOT NULL,
	order_ID [int] REFERENCES tblOrder(order_ID) NOT NULL ,
	quantity decimal(2) NOT NULL ,
	price decimal(9) NOT NULL ,
	[status] decimal(1) NOT NULL
)
GO

-----SERVICE-----
CREATE TABLE tblServiceCategory
(
	category_ID nvarchar(10) PRIMARY KEY NOT NULL ,
	[name] nvarchar(20) UNIQUE NOT NULL ,
	[image] nvarchar(max)
)
GO

CREATE TABLE tblService
(
	service_ID nvarchar(30) PRIMARY KEY NOT NULL ,
	category_ID nvarchar(10) REFERENCES tblServiceCategory(category_ID) NOT NULL,
	[name] nvarchar(40) UNIQUE NOT NULL ,
	[image] nvarchar(max)
)
GO

--STAFF
CREATE TABLE tblStaff
(
	staff_ID [int] IDENTITY(1,1) PRIMARY KEY ,
	provider_ID nvarchar(30) REFERENCES tblProvider(username) NOT NULL,
	service_ID nvarchar(30) REFERENCES tblService(service_ID) NOT NULL,
	[name] nvarchar(40) NOT NULL,
	[id_card] nvarchar(12) NOT NULL UNIQUE,
	[avatar] nvarchar(max),
	[status] decimal(1) NOT NULL,
)

GO


CREATE TABLE tblServiceDetail
(
	id [int] IDENTITY(1,1) PRIMARY KEY ,
	provider_ID nvarchar(30) REFERENCES tblProvider(username) NOT NULL ,
	service_ID nvarchar(30) REFERENCES tblService(service_ID) NOT NULL ,
	staff_ID [int] REFERENCES tblStaff(staff_ID),
	[name] nvarchar(30) NOT NULL ,
	[price] decimal(9) NOT NULL ,
	[description] nvarchar(max)  ,
	[status] decimal(1) NOT NULL
)
GO

CREATE TABLE tblOrder_Service_Detail
(
	id [int] IDENTITY(1,1) PRIMARY KEY ,
	staff_ID [int] REFERENCES tblStaff(staff_ID) NOT NULL ,
	service_Detail_ID [int] REFERENCES tblServiceDetail(id) NOT NULL ,
	order_ID [int] REFERENCES tblOrder(order_ID) NOT NULL ,
	price decimal(9) NOT NULL ,
	[status] decimal(1) NOT NULL
)
GO

-----REVENUE-----
CREATE TABLE tblRevenueByYear
(
	[year] decimal(4) PRIMARY KEY NOT NULL ,
	order_Count decimal(2) NOT NULL,
	role_Detail_Count decimal(2) NOT NULL,
	total decimal(9) NOT NULL
)
GO

CREATE TABLE tblRevenueByMonth
(
	revenue_Month_ID nvarchar(6) PRIMARY KEY NOT NULL ,
	[year] decimal(4) REFERENCES tblRevenueByYear(year) ,
	order_Count decimal(2) NOT NULL,
	role_Detail_Count decimal(2) NOT NULL,
	[month] decimal(2) NOT NULL ,
	propotion decimal(5,3) NOT NULL ,
	total decimal(9) NOT NULL
)
GO

-----ADMIN-----
CREATE TABLE tblAdminMaster
(
	[user_Name] nvarchar(30) PRIMARY KEY NOT NULL ,
	[password] nvarchar(30) NOT NULL
)
GO

CREATE TABLE tblAdminRole
(
	role_ID nvarchar(6) PRIMARY KEY NOT NULL ,
	role_Name nvarchar(20) UNIQUE NOT NULL
) 
GO

CREATE TABLE tblAdmin
(
	[user_Name] nvarchar(30) PRIMARY KEY NOT NULL ,
	password nvarchar(30) NOT NULL ,
	role_ID nvarchar(6) REFERENCES tblAdminRole(role_ID) NOT NULL,
	status int
)
GO

CREATE TABLE tblDeliveryNotification
(
	id int IDENTITY(1, 1) PRIMARY KEY,
	time datetime,
	username nvarchar(30),
	message nvarchar(max)
)

--- DELIVERY --
CREATE TABLE tblShipper
(
	username nvarchar(30) PRIMARY KEY,
	[password] nvarchar(30),
	[name] nvarchar(30),
	[phone] nvarchar(11),
	[MRC] nvarchar(6),
	[status] int,
	wallet decimal(12)
)
GO

CREATE TABLE tblDelivery
(
	id int IDENTITY(1,1) PRIMARY KEY,
	order_id int REFERENCES tblOrder(order_ID),
	address nvarchar(max),
	username_Shipper nvarchar(30) REFERENCES tblShipper(username),
	[status] int
)
GO

CREATE TABLE tblShipperIncome
(
	id int IDENTITY(1,1) PRIMARY KEY,
	[month] int,
	[year] int,
	shipper_id nvarchar(30) REFERENCES tblShipper(username),
	total decimal(12)
)
GO

CREATE TABLE tblReviewProduct
(
	id int IDENTITY(1,1) PRIMARY KEY,
	username nvarchar(30) REFERENCES tblCustomer(username),
	product_id int REFERENCES tblProductDetail(id),
	comment nvarchar(max),
	rating int,
	[status] int
)
GO

------------------------------------------------------- TRIGGER ---------------------------------------------------------------
--- b???ng customer: ????ng k?? account -> c???p nh???t b???ng user
CREATE TRIGGER trig_cus_insert ON tblCustomer 
FOR INSERT
AS
BEGIN
	DECLARE @username nvarchar(30), @password nvarchar(30), @role_ID nvarchar(10), @phone nvarchar (11), @email nvarchar(30), @status decimal(1)

	SELECT @username = username, @password = password, @role_ID = role_ID, @phone = phone, @email = email, @status = status
	FROM inserted

	INSERT INTO tblUser
		(username, password, role_ID, phone, email, status)
	VALUES
		(@username, @password, @role_ID, @phone, @email, @status)
END;
GO

--- b???ng customer: ch???nh s???a th??ng tin -> c???p nh???t b???ng user
CREATE TRIGGER trig_cus_updateStatus ON tblCustomer 
AFTER UPDATE
AS
BEGIN
	DECLARE @username nvarchar(30), @password nvarchar(30), @phone nvarchar (11), @email nvarchar(30), @status decimal(1)

	SELECT @username = username, @password = password, @phone = phone, @email = email, @status = status
	FROM inserted

	UPDATE tblUser SET password = @password, phone = @phone, email = @email,  status = @status WHERE username LIKE @username
END;
GO

--- b???ng provider: ????ng k?? account -> c???p nh???t b???ng user
CREATE TRIGGER trig_pro_insert ON tblProvider 
FOR INSERT
AS
BEGIN
	DECLARE @username nvarchar(30), @password nvarchar(30), @role_ID nvarchar(10), @phone nvarchar (11), @email nvarchar(30), @status decimal(1)

	SELECT @username = username, @password = password, @role_ID = role_ID, @phone = phone, @email = email, @status = status
	FROM inserted

	INSERT INTO tblUser
		(username, password, role_ID, phone, email, status)
	VALUES
		(@username, @password, @role_ID, @phone, @email, @status)
END;
GO

--- b???ng provider: ch???nh s???a th??ng tin -> c???p nh???t b???ng user
CREATE TRIGGER trig_pro_updateStatus ON tblProvider 
AFTER UPDATE
AS
BEGIN

	DECLARE @username nvarchar(30), @password nvarchar(30), @phone nvarchar (11), @email nvarchar(30), @status decimal(1)

	SELECT @username = username, @password = password, @phone = phone, @email = email, @status = status
	FROM inserted

	UPDATE tblUser SET password = @password, phone = @phone, email = @email,  status = @status WHERE username = @username
END;
GO

--- b???ng shipper: t???o account -> c???p nh???t b???ng user
CREATE TRIGGER trig_shipper_insert ON tblShipper
FOR INSERT
AS
BEGIN
	DECLARE @username nvarchar(30), @password nvarchar(30), @status decimal(1)

	SELECT @username = username, @password = password, @status = status
	FROM inserted

	INSERT INTO tblUser
		(username, password, role_ID, status)
	VALUES
		(@username, @password, 'SHIP', @status)
END;
GO

--- b???ng provider: ch???nh s???a th??ng tin -> c???p nh???t b???ng user
CREATE TRIGGER trig_shipper_updateStatus ON tblShipper 
AFTER UPDATE
AS
BEGIN

	DECLARE @username nvarchar(30), @status decimal(1)

	SELECT @username = username, @status = status
	FROM inserted

	UPDATE tblUser SET status = @status WHERE username = @username
END;
GO

-------- shipper income ---------
CREATE TRIGGER trig_shipper_income ON tblDelivery
AFTER UPDATE
AS
BEGIN
	IF (select COUNT(*)
	from inserted
	where status = 3) = 0
	RETURN

	DECLARE @order_date date, @order_id int, @price decimal(12), @shipper_id nvarchar(30)

	SELECT @order_id = order_id, @shipper_id = username_Shipper
	FROM inserted;

	SELECT @order_date = o.order_date
	FROM tblOrder o
	WHERE o.order_ID = @order_id

	SET @price = (select sum(price * quantity)
	from tblOrder_Product_Detail
	where order_ID = @order_id)*0.03

	IF (select COUNT(*)
	from tblShipperIncome sibm
	where MONTH(@order_date) = sibm.month and YEAR(@order_date) = sibm.year and @shipper_id = sibm.shipper_id) = 0
	BEGIN
		INSERT INTO tblShipperIncome
			(month, year, shipper_id, total)
		values
			(MONTH(@order_date), YEAR(@order_date), @shipper_id , @price)
	END
	ELSE
	BEGIN
		UPDATE tblShipperIncome SET total = total + @price WHERE month = MONTH(@order_date) and year = YEAR(@order_date) and shipper_id = @shipper_id
	END
END;
GO

-------------------- tblDeliveryNOtification -----------------
CREATE TRIGGER trig_delivery_notify ON tblDelivery
AFTER UPDATE, INSERT
AS
BEGIN
	DECLARE @insert int, @update int

	select @update = COUNT(*)
	from inserted
	where status = 3

	select @insert = COUNT(*)
	from inserted
	where status = 0 and username_Shipper IS NULL

	IF (@insert = 0 and @update = 0) RETURN

	DECLARE @time datetime, @username nvarchar(30), @message nvarchar(max), @status int

	SELECT @username = o.customer_ID, @status = i.status
	FROM inserted i JOIN tblOrder o ON i.order_id = o.order_ID;

	SET @time = CURRENT_TIMESTAMP

	IF (@status = 3)
	BEGIN
		SET @message = 'has received order on assigned address'
	END
	ELSE IF(@status = 0)
	BEGIN
		SET @message = 'has created new order on assigned address'
	END

	INSERT INTO tblDeliveryNotification
		(time, username, message)
	VALUES
		(@time, @username, @message)
END;
GO
-------------------------------------------------------- INSERT -----------------------------------------------------------------
-- b???ng role

INSERT INTO tblUserRole
	(role_ID, role_Name, description)
VALUES
	('CUS', 'Customer', 'Welcome to shopping and using our service, manage your home, your building facilities')
INSERT INTO tblUserRole
	(role_ID, role_Name, description)
VALUES
	('PRO', 'Provider', 'Experience our services to promote products and make profits')

--B???ng th??ng tin provider 
--Theo Product
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('bach_hoa_xanh' , '12345678' , 'PRO', '0344350704' , 'bachhoaxanhne@gmail.com', 'Bach Hoa Xanh', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('dien_may_cho_lon' , '12345678' , 'PRO', '0344350888' , 'dienmaycholonne@gmail.com', 'Dien May Cho Lon', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('cho_tot_tot' , '12345678' , 'PRO', '0344350987' , 'chototsieutot@gmail.com', 'Cho Tot', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('homepurnish' , '12345678' , 'PRO', '0344353379' , 'homefurnishings@gmail.com', 'Home Furnishings', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('zarahome' , '12345678' , 'PRO', '0366357979' , 'zarahome@gmail.com', 'Zara Home', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('homefurniture' , '12345678' , 'PRO', '0966397979' , 'homeFurniture@gmail.com', 'Home Furniture', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('getintouch' , '12345678' , 'PRO', '0966694321' , 'getintouch@gmail.com', 'Get In Touch', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('petro' , '12345678' , 'PRO', '0966691234' , 'petro@gmail.com', 'Petro', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('minhchau' , '12345678' , 'PRO', '0966691235' , 'minhchau@gmail.com', 'Minh Chau Ceramic', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
--Theo Service
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('fptcompany' , '12345678' , 'PRO', '0966697979' , 'fptcompany@gmail.com', 'FPT', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('moveronline' , '12345678' , 'PRO', '0918154849' , 'moveOnline@gmail.com', 'Mover Online', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('electrician' , '12345678' , 'PRO', '0918145999' , 'elec@gmail.com', 'Electrician', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('homecleaning' , '12345678' , 'PRO', '0918149999' , 'homecleaning@gmail.com', 'Home Cleaning', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('homeimprovement' , '12345678' , 'PRO', '0918134948' , 'homeimprovement@gmail.com', 'Home Improvement', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('plumbers' , '12345678' , 'PRO', '0918134945' , 'plumbers@gmail.com', 'Plumbers', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('laundry' , '12345678' , 'PRO', '0918134947' , 'dryClean@gmail.com', 'Laundry / Dry Clean', 'https://thumbs.dreamstime.com/z/card-kitchen-shelves-cooking-utensils-retro-style-51223757.jpg', 1)
INSERT INTO tblProvider
	(username, password , role_ID , phone , email , name , logo , status)
VALUES
	('michelin_car_service' , '12345678' , 'PRO', '0918234947' , 'michelinlincar@gmail.com', 'Michelin Car Service', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIjRrt9Oxl-E2NTsmLUEX4rKFou5rEpwWt9K1P44AGM9jgvcbrC6cJiPZ69SyvsAEmaGY&usqp=CAU', 1)

-- B???ng t???nh/th??nh
INSERT INTO tblProvince_City
	([province_Name], [province_ID])
VALUES
	(N'H??? Ch?? Minh', '1'),
	(N'H?? N???i', '2'),
	(N'???? N???ng', '3'),
	(N'B??nh D????ng', '4'),
	( N'?????ng Nai', '5'),
	(N'Kh??nh H??a', '6'),
	(N'H???i Ph??ng', '7'),
	(N'Long An', '8'),
	(N'Qu???ng Nam', '9'),
	(N'B?? R???a V??ng T??u', '10'),
	(N'????k L??k', '11'),
	(N'C???n Th??', '12'),
	(N'B??nh Thu???n ', '13'),
	(N'L??m ?????ng', '14'),
	(N'Th???a Thi??n Hu???', '15'),
	(N'Ki??n Giang', '16'),
	( N'B???c Ninh', '17'),
	(N'Qu???ng Ninh', '18'),
	(N'Thanh Hoa', '19'),
	( N'Ngh??? An', '20'),
	(N'H???i D????ng', '21'),
	(N'Gia Lai', '22'),
	(N'B??nh Ph?????c', '23'),
	(N'H??ng Y??n', '24'),
	( N'B??nh ?????nh', '25'),
	(N'Ti???n Giang', '26'),
	(N'Th??i B??nh', '27'),
	(N'B???c Giang', '28'),
	(N'Ho?? B??nh', '29'),
	( N'An Giang', '30'),
	( N'V??nh Ph??c', '31'),
	( N'T??y Ninh', '32'),
	(N'Th??i Nguy??n', '33'),
	(N'L??o Cai', '34'),
	(N'Nam ?????nh', '35'),
	(N'Quang Ng??i', '36'),
	(N'B???n Tre', '37'),
	(N'?????k N??ng', '38'),
	(N'C?? Mau', '39'),
	(N'V??nh Long', '40'),
	(N'Ninh B??nh', '41'),
	(N'Ph?? Th???', '42'),
	(N'Ninh Thu???n', '43'),
	(N'Ph?? Y??n', '44'),
	(N'H?? Nam', '45'),
	(N'H?? T??nh', '46'),
	(N'?????ng Th??p', '47'),
	(N'S??c Tr??ng', '48'),
	(N'Kon Tum', '49'),
	(N'Qu??ng B??nh', '50'),
	(N'Qu??ng Tr???', '51'),
	(N'Tr?? Vinh', '52'),
	(N'H???u Giang', '53'),
	(N'S??n La', '54'),
	(N'B???c Li??u', '55'),
	(N'Y??n B??i', '56'),
	( N'Tuy??n Quang', '57'),
	( N'??i???n Bi??n', '58'),
	(N'Lai Ch??u', '59'),
	(N'L???ng S??n', '60'),
	(N'H?? Giang', '61'),
	(N'B???c K???n', '62'),
	(N'Cao B???ng', '63');
-- b???ng ?????a ch???
INSERT INTO tblDistrict
	([district_ID], [city_name], prefix, [province_ID])
VALUES
	(1, N'B??nh Ch??nh', N'Huy???n', 1),
	(2, N'B??nh T??n', N'Qu???n', 1),
	(3, N'B??nh Th???nh', N'Qu???n', 1),
	(4, N'C???n Gi???', N'Huy???n', 1),
	(5, N'C??? Chi', N'Huy???n', 1),
	(6, N'G?? V???p', N'Qu???n', 1),
	(7, N'H??c M??n', N'Huy???n', 1),
	(8, N'Nh?? B??', N'Huy???n', 1),
	(9, N'Ph?? Nhu???n', N'Qu???n', 1),
	(10, N'Qu???n 1', N'Qu???n', 1),
	(11, N'Qu???n 10', N'Qu???n', 1),
	(12, N'Qu???n 11', N'Qu???n', 1),
	(13, N'Qu???n 12', N'Qu???n', 1),
	(14, N'Qu???n 2', N'Qu???n', 1),
	(15, N'Qu???n 3', N'Qu???n', 1),
	(16, N'Qu???n 4', N'Qu???n', 1),
	(17, N'Qu???n 5', N'Qu???n', 1),
	(18, N'Qu???n 6', N'Qu???n', 1),
	(19, N'Qu???n 7', N'Qu???n', 1),
	(20, N'Qu???n 8', N'Qu???n', 1),
	(21, N'Qu???n 9', N'Qu???n', 1),
	(22, N'T??n B??nh', N'Qu???n', 1),
	(23, N'T??n Ph??', N'Qu???n', 1),
	(24, N'Th??? ?????c', N'Qu???n', 1),
	(25, N'Ba ????nh', N'Qu???n', 2),
	(26, N'Ba V??', N'Huy???n', 2),
	(27, N'B???c T??? Li??m', N'Qu???n', 2),
	(28, N'C???u Gi???y', N'Qu???n', 2),
	(29, N'Ch????ng M???', N'Huy???n', 2),
	(30, N'??an Ph?????ng', N'Huy???n', 2),
	(31, N'????ng Anh', N'Huy???n', 2),
	(32, N'?????ng ??a', N'Qu???n', 2),
	(33, N'Gia L??m', N'Huy???n', 2),
	(34, N'H?? ????ng', N'Qu???n', 2),
	(35, N'Hai B?? Tr??ng', N'Qu???n', 2),
	(36, N'Ho??i ?????c', N'Huy???n', 2),
	(37, N'Ho??n Ki???m', N'Qu???n', 2),
	(38, N'Ho??ng Mai', N'Qu???n', 2),
	(39, N'Long Bi??n', N'Qu???n', 2),
	(40, N'M?? Linh', N'Huy???n', 2),
	(41, N'M??? ?????c', N'Huy???n', 2),
	(42, N'Nam T??? Li??m', N'Qu???n', 2),
	(43, N'Ph?? Xuy??n', N'Huy???n', 2),
	(44, N'Ph??c Th???', N'Huy???n', 2),
	(45, N'Qu???c Oai', N'Huy???n', 2),
	(46, N'S??c S??n', N'Huy???n', 2),
	(47, N'S??n T??y', N'Th??? x??', 2),
	(48, N'T??y H???', N'Qu???n', 2),
	(49, N'Th???ch Th???t', N'Huy???n', 2),
	(50, N'Thanh Oai', N'Huy???n', 2),
	(51, N'Thanh Tr??', N'Huy???n', 2),
	(52, N'Thanh Xu??n', N'Qu???n', 2),
	(53, N'Th?????ng T??n', N'Huy???n', 2),
	(54, N'???ng H??a', N'Huy???n', 2),
	(55, N'C???m L???', N'Qu???n', 3),
	(56, N'H???i Ch??u', N'Qu???n', 3),
	(57, N'H??a Vang', N'Huy???n', 3),
	(58, N'Ho??ng Sa', N'Huy???n', 3),
	(59, N'Li??n Chi???u', N'Qu???n', 3),
	(60, N'Ng?? H??nh S??n', N'Qu???n', 3),
	(61, N'S??n Tr??', N'Qu???n', 3),
	(62, N'Thanh Kh??', N'Qu???n', 3),
	(63, N'B??u B??ng', N'Huy???n', 4),
	(64, N'B???n C??t', N'Th??? x??', 4),
	(65, N'D???u Ti???ng', N'Huy???n', 4),
	(66, N'D?? An', N'Th??? x??', 4),
	(67, N'Ph?? Gi??o', N'Huy???n', 4),
	(68, N'T??n Uy??n', N'Huy???n', 4),
	(69, N'Th??? D???u M???t', N'Th??? x??', 4),
	(70, N'Thu???n An', N'Huy???n', 4),
	(71, N'Bi??n H??a', N'Th??nh ph???', 5),
	(72, N'C???m M???', N'Huy???n', 5),
	(73, N'?????nh Qu??n', N'Huy???n', 5),
	(74, N'Long Kh??nh', N'Th??? x??', 5),
	(75, N'Long Th??nh', N'Huy???n', 5),
	(76, N'Nh??n Tr???ch', N'Huy???n', 5),
	(77, N'T??n Ph??', N'Qu???n', 5),
	(78, N'Th???ng Nh???t', N'Huy???n', 5),
	(79, N'Tr???ng Bom', N'Huy???n', 5),
	(80, N'V??nh C???u', N'Huy???n', 5),
	(81, N'Xu??n L???c', N'Huy???n', 5),
	(82, N'Cam L??m', N'Huy???n', 6),
	(83, N'Cam Ranh', N'Th??nh ph???', 6),
	(84, N'Di??n Kh??nh', N'Huy???n', 6),
	(85, N'Kh??nh S??n', N'Huy???n', 6),
	(86, N'Kh??nh V??nh', N'Huy???n', 6),
	(87, N'Nha Trang', N'Th??nh ph???', 6),
	(88, N'Ninh H??a', N'Th??? x??', 6),
	(89, N'Tr?????ng Sa', N'Huy???n', 6),
	(90, N'V???n Ninh', N'Huy???n', 6),
	(91, N'An D????ng', N'Huy???n', 7),
	(92, N'An L??o', N'Huy???n', 7),
	(93, N'B???ch Long V??', N'Huy???n', 7),
	(94, N'C??t H???i', N'Huy???n', 7),
	(95, N'????? S??n', N'Qu???n', 7),
	(96, N'D????ng Kinh', N'Qu???n', 7),
	(97, N'H???i An', N'Qu???n', 7),
	(98, N'H???ng B??ng', N'Qu???n', 7),
	(99, N'Ki???n An', N'Qu???n', 7),
	(100, N'Ki???n Th???y', N'Huy???n', 7),
	(101, N'L?? Ch??n', N'Qu???n', 7),
	(102, N'Ng?? Quy???n', N'Qu???n', 7),
	(103, N'Th???y Nguy??n', N'Huy???n', 7),
	(104, N'Ti??n L??ng', N'Huy???n', 7),
	(105, N'V??nh B???o', N'Huy???n', 7),
	(106, N'B???n L???c', N'Huy???n', 8),
	(107, N'C???n ???????c', N'Huy???n', 8),
	(108, N'C???n Giu???c', N'Huy???n', 8),
	(109, N'Ch??u Th??nh', N'Huy???n', 8),
	(110, N'?????c H??a', N'Huy???n', 8),
	(111, N'?????c Hu???', N'Huy???n', 8),
	(112, N'Ki???n T?????ng', N'Th??? x??', 8),
	(113, N'M???c H??a', N'Huy???n', 8),
	(114, N'T??n An', N'Th??nh ph???', 8),
	(115, N'T??n H??ng', N'Huy???n', 8),
	(116, N'T??n Th???nh', N'Huy???n', 8),
	(117, N'T??n Tr???', N'Huy???n', 8),
	(118, N'Th???nh H??a', N'Huy???n', 8),
	(119, N'Th??? Th???a', N'Huy???n', 8),
	(120, N'V??nh H??ng', N'Huy???n', 8),
	(121, N'B???c Tr?? My', N'Huy???n', 9),
	(122, N'?????i L???c', N'Huy???n', 9),
	(123, N'??i???n B??n', N'Huy???n', 9),
	(124, N'????ng Giang', N'Huy???n', 9),
	(125, N'Duy Xuy??n', N'Huy???n', 9),
	(126, N'Hi???p ?????c', N'Huy???n', 9),
	(127, N'H???i An', N'Th??nh ph???', 9),
	(128, N'Nam Giang', N'Huy???n', 9),
	(129, N'Nam Tr?? My', N'Huy???n', 9),
	(130, N'N??ng S??n', N'Huy???n', 9),
	(131, N'N??i Th??nh', N'Huy???n', 9),
	(132, N'Ph?? Ninh', N'Huy???n', 9),
	(133, N'Ph?????c S??n', N'Huy???n', 9),
	(134, N'Qu??? S??n', N'Huy???n', 9),
	(135, N'Tam K???', N'Th??nh ph???', 9),
	(136, N'T??y Giang', N'Huy???n', 9),
	(137, N'Th??ng B??nh', N'Huy???n', 9),
	(138, N'Ti??n Ph?????c', N'Huy???n', 9),
	(139, N'B?? R???a', N'Th??? x??', 10),
	(140, N'Ch??u ?????c', N'Huy???n', 10),
	(141, N'C??n ?????o', N'Huy???n', 10),
	(142, N'?????t ?????', N'Huy???n', 10),
	(143, N'Long ??i???n', N'Huy???n', 10),
	(144, N'T??n Th??nh', N'Huy???n', 10),
	(145, N'V??ng T??u', N'Th??nh ph???', 10),
	(146, N'Xuy??n M???c', N'Huy???n', 10),
	(147, N'Bu??n ????n', N'Huy???n', 11),
	(148, N'Bu??n H???', N'Th??? x??', 11),
	(149, N'Bu??n Ma Thu???t', N'Th??nh ph???', 11),
	(150, N'C?? Kuin', N'Huy???n', 11),
	(151, N'C?? M\gar', N'Huy???n', 11),
	(152, N'Ea H\Leo', N'Huy???n', 11),
	(153, N'Ea Kar', N'Huy???n', 11),
	(154, N'Ea S??p', N'Huy???n', 11),
	(155, N'Kr??ng Ana', N'Huy???n', 11),
	(156, N'Kr??ng B??ng', N'Huy???n', 11),
	(157, N'Kr??ng Buk', N'Huy???n', 11),
	(158, N'Kr??ng N??ng', N'Huy???n', 11),
	(159, N'Kr??ng P???c', N'Huy???n', 11),
	(160, N'L??k', N'Huy???n', 11),
	(161, N'M\??r??k', N'Huy???n', 11),
	(162, N' Th???i Lai', N'Huy???n', 12),
	(163, N'B??nh Th???y', N'Qu???n', 12),
	(164, N'C??i R??ng', N'Qu???n', 12),
	(165, N'C??? ?????', N'Huy???n', 12),
	(166, N'Ninh Ki???u', N'Qu???n', 12),
	(167, N'?? M??n', N'Qu???n', 12),
	(168, N'Phong ??i???n', N'Huy???n', 12),
	(169, N'Th???t N???t', N'Qu???n', 12),
	(170, N'V??nh Th???nh', N'Huy???n', 12),
	(171, N'B???c B??nh', N'Huy???n', 13),
	(172, N'?????o Ph?? Qu??', N'Huy???n', 13),
	(173, N'?????c Linh', N'Huy???n', 13),
	(174, N'H??m T??n', N'Huy???n', 13),
	(175, N'H??m Thu???n B???c', N'Huy???n', 13),
	(176, N'H??m Thu???n Nam', N'Huy???n', 13),
	(177, N'La Gi', N'Th??? x??', 13),
	(178, N'Phan Thi???t', N'Th??nh ph???', 13),
	(179, N'T??nh Linh', N'Huy???n', 13),
	(180, N'Tuy Phong', N'Huy???n', 13),
	(181, N'B???o L??m', N'Huy???n', 14),
	(182, N'B???o L???c', N'Th??nh ph???', 14),
	(183, N'C??t Ti??n', N'Huy???n', 14),
	(184, N'????? Huoai', N'Huy???n', 14),
	(185, N'???? L???t', N'Th??nh ph???', 14),
	(186, N'????? T???h', N'Huy???n', 14),
	(187, N'??am R??ng', N'Huy???n', 14),
	(188, N'Di Linh', N'Huy???n', 14),
	(189, N'????n D????ng', N'Huy???n', 14),
	(190, N'?????c Tr???ng', N'Huy???n', 14),
	(191, N'L???c D????ng', N'Huy???n', 14),
	(192, N'L??m H??', N'Huy???n', 14),
	(193, N'A L?????i', N'Huy???n', 15),
	(194, N'Hu???', N'Th??nh ph???', 15),
	(195, N'H????ng Th???y', N'Th??? x??', 15),
	(196, N'H????ng Tr??', N'Huy???n', 15),
	(197, N'Nam ????ng', N'Huy???n', 15),
	(198, N'Phong ??i???n', N'Huy???n', 15),
	(199, N'Ph?? L???c', N'Huy???n', 15),
	(200, N'Ph?? Vang', N'Huy???n', 15),
	(201, N'Qu???ng ??i???n', N'Huy???n', 15),
	(202, N'An Bi??n', N'Huy???n', 16),
	(203, N'An Minh', N'Huy???n', 16),
	(204, N'Ch??u Th??nh', N'Huy???n', 16),
	(205, N'Giang Th??nh', N'Huy???n', 16),
	(206, N'Gi???ng Ri???ng', N'Huy???n', 16),
	(207, N'G?? Quao', N'Huy???n', 16),
	(208, N'H?? Ti??n', N'Th??? x??', 16),
	(209, N'H??n ?????t', N'Huy???n', 16),
	(210, N'Ki??n H???i', N'Huy???n', 16),
	(211, N'Ki??n L????ng', N'Huy???n', 16),
	(212, N'Ph?? Qu???c', N'Huy???n', 16),
	(213, N'R???ch Gi??', N'Th??nh ph???', 16),
	(214, N'T??n Hi???p', N'Huy???n', 16),
	(215, N'U minh Th?????ng', N'Huy???n', 16),
	(216, N'V??nh Thu???n', N'Huy???n', 16),
	(217, N'B???c Ninh', N'Th??nh ph???', 17),
	(218, N'Gia B??nh', N'Huy???n', 17),
	(219, N'L????ng T??i', N'Huy???n', 17),
	(220, N'Qu??? V??', N'Huy???n', 17),
	(221, N'Thu???n Th??nh', N'Huy???n', 17),
	(222, N'Ti??n Du', N'Huy???n', 17),
	(223, N'T??? S??n', N'Th??? x??', 17),
	(224, N'Y??n Phong', N'Huy???n', 17),
	(225, N'Ba Ch???', N'Huy???n', 18),
	(226, N'B??nh Li??u', N'Huy???n', 18),
	(227, N'C???m Ph???', N'Th??nh ph???', 18),
	(228, N'C?? T??', N'Huy???n', 18),
	(229, N'?????m H??', N'Huy???n', 18),
	(230, N'????ng Tri???u', N'Huy???n', 18),
	(231, N'H??? Long', N'Th??nh ph???', 18),
	(232, N'H???i H??', N'Huy???n', 18),
	(233, N'Ho??nh B???', N'Huy???n', 18),
	(234, N'M??ng C??i', N'Th??nh ph???', 18),
	(235, N'Qu???ng Y??n', N'Huy???n', 18),
	(236, N'Ti??n Y??n', N'Huy???n', 18),
	(237, N'U??ng B??', N'Th??? x??', 18),
	(238, N'V??n ?????n', N'Huy???n', 18),
	(239, N'B?? Th?????c', N'Huy???n', 19),
	(240, N'B???m S??n', N'Th??? x??', 19),
	(241, N'C???m Th???y', N'Huy???n', 19),
	(242, N'????ng S??n', N'Huy???n', 19),
	(243, N'H?? Trung', N'Huy???n', 19),
	(244, N'H???u L???c', N'Huy???n', 19),
	(245, N'Ho???ng H??a', N'Huy???n', 19),
	(246, N'Lang Ch??nh', N'Huy???n', 19),
	(247, N'M?????ng L??t', N'Huy???n', 19),
	(248, N'Nga S??n', N'Huy???n', 19),
	(249, N'Ng???c L???c', N'Huy???n', 19),
	(250, N'Nh?? Thanh', N'Huy???n', 19),
	(251, N'Nh?? Xu??n', N'Huy???n', 19),
	(252, N'N??ng C???ng', N'Huy???n', 19),
	(253, N'Quan H??a', N'Huy???n', 19),
	(254, N'Quan S??n', N'Huy???n', 19),
	(255, N'Qu???ng X????ng', N'Huy???n', 19),
	(256, N'S???m S??n', N'Th??? x??', 19),
	(257, N'Th???ch Th??nh', N'Huy???n', 19),
	(258, N'Thanh H??a', N'Th??nh ph???', 19),
	(259, N'Thi???u H??a', N'Huy???n', 19),
	(260, N'Th??? Xu??n', N'Huy???n', 19),
	(261, N'Th?????ng Xu??n', N'Huy???n', 19),
	(262, N'T??nh Gia', N'Huy???n', 19),
	(263, N'Tri???u S??n', N'Huy???n', 19),
	(264, N'V??nh L???c', N'Huy???n', 19),
	(265, N'Y??n ?????nh', N'Huy???n', 19),
	(266, N'Anh S??n', N'Huy???n', 20),
	(267, N'Con Cu??ng', N'Huy???n', 20),
	(268, N'C???a L??', N'Th??? x??', 20),
	(269, N'Di???n Ch??u', N'Huy???n', 20),
	(270, N'???? L????ng', N'Huy???n', 20),
	(271, N'Ho??ng Mai', N'Th??? x??', 20),
	(272, N'H??ng Nguy??n', N'Huy???n', 20),
	(273, N'K??? S??n', N'Huy???n', 20),
	(274, N'Nam ????n', N'Huy???n', 20),
	(275, N'Nghi L???c', N'Huy???n', 20),
	(276, N'Ngh??a ????n', N'Huy???n', 20),
	(277, N'Qu??? Phong', N'Huy???n', 20),
	(278, N'Qu??? Ch??u', N'Huy???n', 20),
	(279, N'Qu??? H???p', N'Huy???n', 20),
	(280, N'Qu???nh L??u', N'Huy???n', 20),
	(281, N'T??n K???', N'Huy???n', 20),
	(282, N'Th??i H??a', N'Th??? x??', 20),
	(283, N'Thanh Ch????ng', N'Huy???n', 20),
	(284, N'T????ng D????ng', N'Huy???n', 20),
	(285, N'Vinh', N'Th??nh ph???', 20),
	(286, N'Y??n Th??nh', N'Huy???n', 20),
	(287, N'B??nh Giang', N'Huy???n', 21),
	(288, N'C???m Gi??ng', N'Huy???n', 21),
	(289, N'Ch?? Linh', N'Th??? x??', 21),
	(290, N'Gia L???c', N'Huy???n', 21),
	(291, N'H???i D????ng', N'Th??nh ph???', 21),
	(292, N'Kim Th??nh', N'Huy???n', 21),
	(293, N'Kinh M??n', N'Huy???n', 21),
	(294, N'Nam S??ch', N'Huy???n', 21),
	(295, N'Ninh Giang', N'Huy???n', 21),
	(296, N'Thanh H??', N'Huy???n', 21),
	(297, N'Thanh Mi???n', N'Huy???n', 21),
	(298, N'T??? K???', N'Huy???n', 21),
	(299, N'An Kh??', N'Th??? x??', 22),
	(300, N'AYun Pa', N'Th??? x??', 22),
	(301, N'Ch?? P??h', N'Huy???n', 22),
	(302, N'Ch?? P??h', N'Huy???n', 22),
	(303, N'Ch?? S??', N'Huy???n', 22),
	(304, N'Ch??PR??ng', N'Huy???n', 22),
	(305, N'????k ??oa', N'Huy???n', 22),
	(306, N'????k P??', N'Huy???n', 22),
	(307, N'?????c C??', N'Huy???n', 22),
	(308, N'Ia Grai', N'Huy???n', 22),
	(309, N'Ia Pa', N'Huy???n', 22),
	(310, N'KBang', N'Huy???n', 22),
	(311, N'K??ng Chro', N'Huy???n', 22),
	(312, N'Kr??ng Pa', N'Huy???n', 22),
	(313, N'Mang Yang', N'Huy???n', 22),
	(314, N'Ph?? Thi???n', N'Huy???n', 22),
	(315, N'Plei Ku', N'Th??nh ph???', 22),
	(316, N'B??nh Long', N'Th??? x??', 23),
	(317, N'B?? ????ng', N'Huy???n', 23),
	(318, N'B?? ?????p', N'Huy???n', 23),
	(319, N'B?? Gia M???p', N'Huy???n', 23),
	(320, N'Ch??n Th??nh', N'Huy???n', 23),
	(321, N'?????ng Ph??', N'Huy???n', 23),
	(322, N'?????ng Xo??i', N'Th??? x??', 23),
	(323, N'H???n Qu???n', N'Huy???n', 23),
	(324, N'L???c Ninh', N'Huy???n', 23),
	(325, N'Ph?? Ri???ng', N'Huy???n', 23),
	(326, N'Ph?????c Long', N'Th??? x??', 23),
	(327, N'??n Thi', N'Huy???n', 24),
	(328, N'H??ng Y??n', N'Th??nh ph???', 24),
	(329, N'Kho??i Ch??u', N'Huy???n', 24),
	(330, N'Kim ?????ng', N'Huy???n', 24),
	(331, N'M??? H??o', N'Huy???n', 24),
	(332, N'Ph?? C???', N'Huy???n', 24),
	(333, N'Ti??n L???', N'Huy???n', 24),
	(334, N'V??n Giang', N'Huy???n', 24),
	(335, N'V??n L??m', N'Huy???n', 24),
	(336, N'Y??n M???', N'Huy???n', 24),
	(337, N'An L??o', N'Huy???n', 25),
	(338, N'An Nh??n', N'Huy???n', 25),
	(339, N'Ho??i ??n', N'Huy???n', 25),
	(340, N'Ho??i Nh??n', N'Huy???n', 25),
	(341, N'Ph?? C??t', N'Huy???n', 25),
	(342, N'Ph?? M???', N'Huy???n', 25),
	(343, N'Quy Nh??n', N'Th??nh ph???', 25),
	(344, N'T??y S??n', N'Huy???n', 25),
	(345, N'Tuy Ph?????c', N'Huy???n', 25),
	(346, N'V??n Canh', N'Huy???n', 25),
	(347, N'V??nh Th???nh', N'Huy???n', 25),
	(348, N'C??i B??', N'Huy???n', 26),
	(349, N'Cai L???y', N'Th??? x??', 26),
	(350, N'Ch??u Th??nh', N'Huy???n', 26),
	(351, N'Ch??? G???o', N'Huy???n', 26),
	(352, N'G?? C??ng', N'Th??? x??', 26),
	(353, N'G?? C??ng ????ng', N'Huy???n', 26),
	(354, N'G?? C??ng T??y', N'Huy???n', 26),
	(355, N'Huy???n Cai L???y', N'Huy???n', 26),
	(356, N'M??? Tho', N'Th??nh ph???', 26),
	(357, N'T??n Ph?? ????ng', N'Huy???n', 26),
	(358, N'T??n Ph?????c', N'Huy???n', 26),
	(359, N'????ng H??ng', N'Huy???n', 27),
	(360, N'H??ng H??', N'Huy???n', 27),
	(361, N'Ki???n X????ng', N'Huy???n', 27),
	(362, N'Qu???nh Ph???', N'Huy???n', 27),
	(363, N'Th??i B??nh', N'Th??nh ph???', 27),
	(364, N'Th??i Thu???', N'Huy???n', 27),
	(365, N'Ti???n H???i', N'Huy???n', 27),
	(366, N'V?? Th??', N'Huy???n', 27),
	(367, N'B???c Giang', N'Th??nh ph???', 28),
	(368, N'Hi???p H??a', N'Huy???n', 28),
	(369, N'L???ng Giang', N'Huy???n', 28),
	(370, N'L???c Nam', N'Huy???n', 28),
	(371, N'L???c Ng???n', N'Huy???n', 28),
	(372, N'S??n ?????ng', N'Huy???n', 28),
	(373, N'T??n Y??n', N'Huy???n', 28),
	(374, N'Vi???t Y??n', N'Huy???n', 28),
	(375, N'Y??n D??ng', N'Huy???n', 28),
	(376, N'Y??n Th???', N'Huy???n', 28),
	(377, N'Cao Phong', N'Huy???n', 29),
	(378, N'???? B???c', N'Huy???n', 29),
	(379, N'H??a B??nh', N'Th??nh ph???', 29),
	(380, N'Kim B??i', N'Huy???n', 29),
	(381, N'K??? S??n', N'Huy???n', 29),
	(382, N'L???c S??n', N'Huy???n', 29),
	(383, N'L???c Th???y', N'Huy???n', 29),
	(384, N'L????ng S??n', N'Huy???n', 29),
	(385, N'Mai Ch??u', N'Huy???n', 29),
	(386, N'T??n L???c', N'Huy???n', 29),
	(387, N'Y??n Th???y', N'Huy???n', 29),
	(388, N'An Ph??', N'Huy???n', 30),
	(389, N'Ch??u ?????c', N'Th??? x??', 30),
	(390, N'Ch??u Ph??', N'Huy???n', 30),
	(391, N'Ch??u Th??nh', N'Huy???n', 30),
	(392, N'Ch??? M???i', N'Huy???n', 30),
	(393, N'Long Xuy??n', N'Th??nh ph???', 30),
	(394, N'Ph?? T??n', N'Huy???n', 30),
	(395, N'T??n Ch??u', N'Th??? x??', 30),
	(396, N'Tho???i S??n', N'Huy???n', 30),
	(397, N'T???nh Bi??n', N'Huy???n', 30),
	(398, N'Tri T??n', N'Huy???n', 30),
	(399, N'B??nh Xuy??n', N'Huy???n', 31),
	(400, N'L???p Th???ch', N'Huy???n', 31),
	(401, N'Ph??c Y??n', N'Th??? x??', 31),
	(402, N'S??ng L??', N'Huy???n', 31),
	(403, N'Tam ?????o', N'Huy???n', 31),
	(404, N'Tam D????ng', N'Huy???n', 31),
	(405, N'V??nh T?????ng', N'Huy???n', 31),
	(406, N'V??nh Y??n', N'Th??nh ph???', 31),
	(407, N'Y??n L???c', N'Huy???n', 31),
	(408, N'B???n C???u', N'Huy???n', 32),
	(409, N'Ch??u Th??nh', N'Huy???n', 32),
	(410, N'D????ng Minh Ch??u', N'Huy???n', 32),
	(411, N'G?? D???u', N'Huy???n', 32),
	(412, N'H??a Th??nh', N'Huy???n', 32),
	(413, N'T??n Bi??n', N'Huy???n', 32),
	(414, N'T??n Ch??u', N'Huy???n', 32),
	(415, N'T??y Ninh', N'Th??? x??', 32),
	(416, N'Tr???ng B??ng', N'Huy???n', 32),
	(417, N'?????i T???', N'Huy???n', 33),
	(418, N'?????nh H??a', N'Huy???n', 33),
	(419, N'?????ng H???', N'Huy???n', 33),
	(420, N'Ph??? Y??n', N'Huy???n', 33),
	(421, N'Ph?? B??nh', N'Huy???n', 33),
	(422, N'Ph?? L????ng', N'Huy???n', 33),
	(423, N'S??ng C??ng', N'Th??? x??', 33),
	(424, N'Th??i Nguy??n', N'Th??nh ph???', 33),
	(425, N'V?? Nhai', N'Huy???n', 33),
	(426, N'B???c H??', N'Huy???n', 34),
	(427, N'B???o Th???ng', N'Huy???n', 34),
	(428, N'B???o Y??n', N'Huy???n', 34),
	(429, N'B??t X??t', N'Huy???n', 34),
	(430, N'L??o Cai', N'Th??nh ph???', 34),
	(431, N'M?????ng Kh????ng', N'Huy???n', 34),
	(432, N'Sa Pa', N'Huy???n', 34),
	(433, N'V??n B??n', N'Huy???n', 34),
	(434, N'Xi Ma Cai', N'Huy???n', 34),
	(435, N'Giao Th???y', N'Huy???n', 35),
	(436, N'H???i H???u', N'Huy???n', 35),
	(437, N'M??? L???c', N'Huy???n', 35),
	(438, N'Nam ?????nh', N'Th??nh ph???', 35),
	(439, N'Nam Tr???c', N'Huy???n', 35),
	(440, N'Ngh??a H??ng', N'Huy???n', 35),
	(441, N'Tr???c Ninh', N'Huy???n', 35),
	(442, N'V??? B???n', N'Huy???n', 35),
	(443, N'Xu??n Tr?????ng', N'Huy???n', 35),
	(444, N'?? Y??n', N'Huy???n', 35),
	(445, N'Ba T??', N'Huy???n', 36),
	(446, N'B??nh S??n', N'Huy???n', 36),
	(447, N'?????c Ph???', N'Huy???n', 36),
	(448, N'L?? S??n', N'Huy???n', 36),
	(449, N'Minh Long', N'Huy???n', 36),
	(450, N'M??? ?????c', N'Huy???n', 36),
	(451, N'Ngh??a H??nh', N'Huy???n', 36),
	(452, N'Qu???ng Ng??i', N'Th??nh ph???', 36),
	(453, N'S??n H??', N'Huy???n', 36),
	(454, N'S??n T??y', N'Huy???n', 36),
	(455, N'S??n T???nh', N'Huy???n', 36),
	(456, N'T??y Tr??', N'Huy???n', 36),
	(457, N'Tr?? B???ng', N'Huy???n', 36),
	(458, N'T?? Ngh??a', N'Huy???n', 36),
	(459, N'Ba Tri', N'Huy???n', 37),
	(460, N'B???n Tre', N'Th??nh ph???', 37),
	(461, N'B??nh ?????i', N'Huy???n', 37),
	(462, N'Ch??u Th??nh', N'Huy???n', 37),
	(463, N'Ch??? L??ch', N'Huy???n', 37),
	(464, N'Gi???ng Tr??m', N'Huy???n', 37),
	(465, N'M??? C??y B???c', N'Huy???n', 37),
	(466, N'M??? C??y Nam', N'Huy???n', 37),
	(467, N'Th???nh Ph??', N'Huy???n', 37),
	(468, N'C?? J??t', N'Huy???n', 38),
	(469, N'D??k GLong', N'Huy???n', 38),
	(470, N'D??k Mil', N'Huy???n', 38),
	(471, N'D??k R\L???p', N'Huy???n', 38),
	(472, N'D??k Song', N'Huy???n', 38),
	(473, N'Gia Ngh??a', N'Th??? x??', 38),
	(474, N'Kr??ng N??', N'Huy???n', 38),
	(475, N'Tuy ?????c', N'Huy???n', 38),
	(476, N'C?? Mau', N'Th??nh ph???', 39),
	(477, N'C??i N?????c', N'Huy???n', 39),
	(478, N'?????m D??i', N'Huy???n', 39),
	(479, N'N??m C??n', N'Huy???n', 39),
	(480, N'Ng???c Hi???n', N'Huy???n', 39),
	(481, N'Ph?? T??n', N'Huy???n', 39),
	(482, N'Th???i B??nh', N'Huy???n', 39),
	(483, N'Tr???n V??n Th???i', N'Huy???n', 39),
	(484, N'U Minh', N'Huy???n', 39),
	(485, N'B??nh Minh', N'Huy???n', 40),
	(486, N'B??nh T??n', N'Qu???n', 40),
	(487, N'Long H???', N'Huy???n', 40),
	(488, N'Mang Th??t', N'Huy???n', 40),
	(489, N'Tam B??nh', N'Huy???n', 40),
	(490, N'Tr?? ??n', N'Huy???n', 40),
	(491, N'V??nh Long', N'Th??nh ph???', 40),
	(492, N'V??ng Li??m', N'Huy???n', 40),
	(493, N'Gia Vi???n', N'Huy???n', 41),
	(494, N'Hoa L??', N'Huy???n', 41),
	(495, N'Kim S??n', N'Huy???n', 41),
	(496, N'Nho Quan', N'Huy???n', 41),
	(497, N'Ninh B??nh', N'Th??nh ph???', 41),
	(498, N'Tam ??i???p', N'Th??? x??', 41),
	(499, N'Y??n Kh??nh', N'Huy???n', 41),
	(500, N'Y??n M??', N'Huy???n', 41),
	(501, N'C???m Kh??', N'Huy???n', 42),
	(502, N'??oan H??ng', N'Huy???n', 42),
	(503, N'H??? H??a', N'Huy???n', 42),
	(504, N'L??m Thao', N'Huy???n', 42),
	(505, N'Ph?? Ninh', N'Huy???n', 42),
	(506, N'Ph?? Th???', N'Th??? x??', 42),
	(507, N'Tam N??ng', N'Huy???n', 42),
	(508, N'T??n S??n', N'Huy???n', 42),
	(509, N'Thanh Ba', N'Huy???n', 42),
	(510, N'Thanh S??n', N'Huy???n', 42),
	(511, N'Thanh Th???y', N'Huy???n', 42),
	(512, N'Vi???t Tr??', N'Th??nh ph???', 42),
	(513, N'Y??n L???p', N'Huy???n', 42),
	(514, N'B??c ??i', N'Huy???n', 43),
	(515, N'Ninh H???i', N'Huy???n', 43),
	(516, N'Ninh Ph?????c', N'Huy???n', 43),
	(517, N'Ninh S??n', N'Huy???n', 43),
	(518, N'Phan Rang - Th??p Ch??m', N'Th??nh ph???', 43),
	(519, N'Thu???n B???c', N'Huy???n', 43),
	(520, N'Thu???n Nam', N'Huy???n', 43),
	(521, N'????ng H??a', N'Huy???n', 44),
	(522, N'?????ng Xu??n', N'Huy???n', 44),
	(523, N'Ph?? H??a', N'Huy???n', 44),
	(524, N'S??n H??a', N'Huy???n', 44),
	(525, N'S??ng C???u', N'Th??? x??', 44),
	(526, N'S??ng Hinh', N'Huy???n', 44),
	(527, N'T??y H??a', N'Huy???n', 44),
	(528, N'Tuy An', N'Huy???n', 44),
	(529, N'Tuy H??a', N'Th??nh ph???', 44),
	(530, N'B??nh L???c', N'Huy???n', 45),
	(531, N'Duy Ti??n', N'Huy???n', 45),
	(532, N'Kim B???ng', N'Huy???n', 45),
	(533, N'L?? Nh??n', N'Huy???n', 45),
	(534, N'Ph??? L??', N'Th??nh ph???', 45),
	(535, N'Thanh Li??m', N'Huy???n', 45),
	(536, N'C???m Xuy??n', N'Huy???n', 46),
	(537, N'Can L???c', N'Huy???n', 46),
	(538, N'?????c Th???', N'Huy???n', 46),
	(539, N'H?? T??nh', N'Th??nh ph???', 46),
	(540, N'H???ng L??nh', N'Th??? x??', 46),
	(541, N'H????ng Kh??', N'Huy???n', 46),
	(542, N'H????ng S??n', N'Huy???n', 46),
	(543, N'K??? Anh', N'Huy???n', 46),
	(544, N'L???c H??', N'Huy???n', 46),
	(545, N'Nghi Xu??n', N'Huy???n', 46),
	(546, N'Th???ch H??', N'Huy???n', 46),
	(547, N'V?? Quang', N'Huy???n', 46),
	(548, N'Cao L??nh', N'Th??nh ph???', 47),
	(549, N'Ch??u Th??nh', N'Huy???n', 47),
	(550, N'H???ng Ng???', N'Th??? x??', 47),
	(551, N'Huy???n Cao L??nh', N'Huy???n', 47),
	(552, N'Huy???n H???ng Ng???', N'Huy???n', 47),
	(553, N'Lai Vung', N'Huy???n', 47),
	(554, N'L???p V??', N'Huy???n', 47),
	(555, N'Sa ????c', N'Th??? x??', 47),
	(556, N'Tam N??ng', N'Huy???n', 47),
	(557, N'T??n H???ng', N'Huy???n', 47),
	(558, N'Thanh B??nh', N'Huy???n', 47),
	(559, N'Th??p M?????i', N'Huy???n', 47),
	(560, N'Ch??u Th??nh', N'Huy???n', 48),
	(561, N'C?? Lao Dung', N'Huy???n', 48),
	(562, N'K??? S??ch', N'Huy???n', 48),
	(563, N'Long Ph??', N'Huy???n', 48),
	(564, N'M??? T??', N'Huy???n', 48),
	(565, N'M??? Xuy??n', N'Huy???n', 48),
	(566, N'Ng?? N??m', N'Huy???n', 48),
	(567, N'S??c Tr??ng', N'Th??nh ph???', 48),
	(568, N'Th???nh Tr???', N'Huy???n', 48),
	(569, N'Tr???n ?????', N'Huy???n', 48),
	(570, N'V??nh Ch??u', N'Huy???n', 48),
	(571, N'????k Glei', N'Huy???n', 49),
	(572, N'????k H??', N'Huy???n', 49),
	(573, N'????k T??', N'Huy???n', 49),
	(574, N'Ia HDrai', N'Huy???n', 49),
	(575, N'Kon Pl??ng', N'Huy???n', 49),
	(576, N'Kon R???y', N'Huy???n', 49),
	(577, N'KonTum', N'Th??nh ph???', 49),
	(578, N'Ng???c H???i', N'Huy???n', 49),
	(579, N'Sa Th???y', N'Huy???n', 49),
	(580, N'Tu M?? R??ng', N'Huy???n', 49),
	(581, N'Ba ?????n', N'Th??? x??', 50),
	(582, N'B??? Tr???ch', N'Huy???n', 50),
	(583, N'?????ng H???i', N'Th??nh ph???', 50),
	(584, N'L??? Th???y', N'Huy???n', 50),
	(585, N'Minh H??a', N'Huy???n', 50),
	(586, N'Qu???ng Ninh', N'Huy???n', 50),
	(587, N'Qu???ng Tr???ch', N'Huy???n', 50),
	(588, N'Tuy??n H??a', N'Huy???n', 50),
	(589, N'Cam L???', N'Huy???n', 51),
	(590, N'??a Kr??ng', N'Huy???n', 51),
	(591, N'?????o C???n c???', N'Huy???n', 51),
	(592, N'????ng H??', N'Th??nh ph???', 51),
	(593, N'Gio Linh', N'Huy???n', 51),
	(594, N'H???i L??ng', N'Huy???n', 51),
	(595, N'H?????ng H??a', N'Huy???n', 51),
	(596, N'Qu???ng Tr???', N'Th??? x??', 51),
	(597, N'Tri???u Phong', N'Huy???n', 51),
	(598, N'V??nh Linh', N'Huy???n', 51),
	(599, N'C??ng Long', N'Huy???n', 52),
	(600, N'C???u K??', N'Huy???n', 52),
	(601, N'C???u Ngang', N'Huy???n', 52),
	(602, N'Ch??u Th??nh', N'Huy???n', 52),
	(603, N'Duy??n H???i', N'Huy???n', 52),
	(604, N'Ti???u C???n', N'Huy???n', 52),
	(605, N'Tr?? C??', N'Huy???n', 52),
	(606, N'Tr?? Vinh', N'Th??nh ph???', 52),
	(607, N'Ch??u Th??nh', N'Huy???n', 53),
	(608, N'Ch??u Th??nh A', N'Huy???n', 53),
	(609, N'Long M???', N'Huy???n', 53),
	(610, N'Ng?? B???y', N'Th??? x??', 53),
	(611, N'Ph???ng Hi???p', N'Huy???n', 53),
	(612, N'V??? Thanh', N'Th??nh ph???', 53),
	(613, N'V??? Th???y', N'Huy???n', 53),
	(614, N'B???c Y??n', N'Huy???n', 54),
	(615, N'Mai S??n', N'Huy???n', 54),
	(616, N'M???c Ch??u', N'Huy???n', 54),
	(617, N'M?????ng La', N'Huy???n', 54),
	(618, N'Ph?? Y??n', N'Huy???n', 54),
	(619, N'Qu???nh Nhai', N'Huy???n', 54),
	(620, N'S??n La', N'Th??nh ph???', 54),
	(621, N'S??ng M??', N'Huy???n', 54),
	(622, N'S???p C???p', N'Huy???n', 54),
	(623, N'Thu???n Ch??u', N'Huy???n', 54),
	(624, N'V??n H???', N'Huy???n', 54),
	(625, N'Y??n Ch??u', N'Huy???n', 54),
	(626, N'B???c Li??u', N'Th??nh ph???', 55),
	(627, N'????ng H???i', N'Huy???n', 55),
	(628, N'Gi?? Rai', N'Huy???n', 55),
	(629, N'H??a B??nh', N'Huy???n', 55),
	(630, N'H???ng D??n', N'Huy???n', 55),
	(631, N'Ph?????c Long', N'Huy???n', 55),
	(632, N'V??nh L???i', N'Huy???n', 55),
	(633, N'L???c Y??n', N'Huy???n', 56),
	(634, N'M?? Cang Ch???i', N'Huy???n', 56),
	(635, N'Ngh??a L???', N'Th??? x??', 56),
	(636, N'Tr???m T???u', N'Huy???n', 56),
	(637, N'Tr???n Y??n', N'Huy???n', 56),
	(638, N'V??n Ch???n', N'Huy???n', 56),
	(639, N'V??n Y??n', N'Huy???n', 56),
	(640, N'Y??n B??i', N'Th??nh ph???', 56),
	(641, N'Y??n B??nh', N'Huy???n', 56),
	(642, N'Chi??m H??a', N'Huy???n', 57),
	(643, N'H??m Y??n', N'Huy???n', 57),
	(644, N'L??m B??nh', N'Huy???n', 57),
	(645, N'Na Hang', N'Huy???n', 57),
	(646, N'S??n D????ng', N'Huy???n', 57),
	(647, N'Tuy??n Quang', N'Th??nh ph???', 57),
	(648, N'Y??n S??n', N'Huy???n', 57),
	(649, N'??i???n Bi??n', N'Huy???n', 58),
	(650, N'??i???n Bi??n ????ng', N'Huy???n', 58),
	(651, N'??i???n Bi??n Ph???', N'Th??nh ph???', 58),
	(652, N'M?????ng ???ng', N'Huy???n', 58),
	(653, N'M?????ng Ch??', N'Huy???n', 58),
	(654, N'M?????ng Lay', N'Th??? x??', 58),
	(655, N'M?????ng Nh??', N'Huy???n', 58),
	(656, N'N???m P???', N'Huy???n', 58),
	(657, N'T???a Ch??a', N'Huy???n', 58),
	(658, N'Tu???n Gi??o', N'Huy???n', 58),
	(659, N'Lai Ch??u', N'Th??? x??', 59),
	(660, N'M?????ng T??', N'Huy???n', 59),
	(661, N'N???m Nh??n', N'Huy???n', 59),
	(662, N'Phong Th???', N'Huy???n', 59),
	(663, N'S??n H???', N'Huy???n', 59),
	(664, N'Tam ???????ng', N'Huy???n', 59),
	(665, N'T??n Uy??n', N'Huy???n', 59),
	(666, N'Than Uy??n', N'Huy???n', 59),
	(667, N'B???c S??n', N'Huy???n', 60),
	(668, N'B??nh Gia', N'Huy???n', 60),
	(669, N'Cao L???c', N'Huy???n', 60),
	(670, N'Chi L??ng', N'Huy???n', 60),
	(671, N'????nh L???p', N'Huy???n', 60),
	(672, N'H???u L??ng', N'Huy???n', 60),
	(673, N'L???ng S??n', N'Th??nh ph???', 60),
	(674, N'L???c B??nh', N'Huy???n', 60),
	(675, N'Tr??ng ?????nh', N'Huy???n', 60),
	(676, N'V??n L??ng', N'Huy???n', 60),
	(677, N'V??n Quan', N'Huy???n', 60),
	(678, N'B???c M??', N'Huy???n', 61),
	(679, N'B???c Quang', N'Huy???n', 61),
	(680, N'?????ng V??n', N'Huy???n', 61),
	(681, N'H?? Giang', N'Th??nh ph???', 61),
	(682, N'Ho??ng Su Ph??', N'Huy???n', 61),
	(683, N'M??o V???c', N'Huy???n', 61),
	(684, N'Qu???n B???', N'Huy???n', 61),
	(685, N'Quang B??nh', N'Huy???n', 61),
	(686, N'V??? Xuy??n', N'Huy???n', 61),
	(687, N'X??n M???n', N'Huy???n', 61),
	(688, N'Y??n Minh', N'Huy???n', 61),
	(689, N'Ba B???', N'Huy???n', 62),
	(690, N'B???c K???n', N'Th??? x??', 62),
	(691, N'B???ch Th??ng', N'Huy???n', 62),
	(692, N'Ch??? ?????n', N'Huy???n', 62),
	(693, N'Ch??? M???i', N'Huy???n', 62),
	(694, N'Na R??', N'Huy???n', 62),
	(695, N'Ng??n S??n', N'Huy???n', 62),
	(696, N'P??c N???m', N'Huy???n', 62),
	(697, N'B???o L???c', N'Huy???n', 63),
	(698, N'B???o L??m', N'Huy???n', 63),
	(699, N'Cao B???ng', N'Th??? x??', 63),
	(700, N'H??? Lang', N'Huy???n', 63),
	(701, N'H?? Qu???ng', N'Huy???n', 63),
	(702, N'H??a An', N'Huy???n', 63),
	(703, N'Nguy??n B??nh', N'Huy???n', 63),
	(704, N'Ph???c H??a', N'Huy???n', 63),
	(705, N'Qu???ng Uy??n', N'Huy???n', 63),
	(706, N'Th???ch An', N'Huy???n', 63),
	(707, N'Th??ng N??ng', N'Huy???n', 63),
	(708, N'Tr?? L??nh', N'Huy???n', 63),
	(709, N'Tr??ng Kh??nh', N'Huy???n', 63);

-- b???ng lo???i s???n ph???m theo khu v???c

INSERT INTO tblProductCategory
	(category_ID, name, image)
VALUES
	('KC', 'Kitchen', 'https://png.pngtree.com/png-clipart/20220823/original/pngtree-cartoon-kitchen-png-png-image_8476833.png')
INSERT INTO tblProductCategory
	(category_ID, name, image)
VALUES
	('LVR', 'Living Room', 'https://static.vecteezy.com/system/resources/thumbnails/009/586/037/small/interior-moderm-living-room-isometric-view-3d-render-png.png')
INSERT INTO tblProductCategory
	(category_ID, name, image)
VALUES
	('BR', 'Bedroom', 'https://png.pngtree.com/png-clipart/20220823/original/pngtree-isentropic-bedroom-png-png-image_8474318.png')
INSERT INTO tblProductCategory
	(category_ID, name, image)
VALUES
	('OSH', 'Outside Home', 'https://png.pngtree.com/png-clipart/20220228/original/pngtree-yellow-flower-in-vase-png-image_7325173.png')
INSERT INTO tblProductCategory
	(category_ID, name, image)
VALUES
	('BAR', 'Bathroom', 'https://www.transparentpng.com/thumb/bathtub/bathtub-icons-png-10.png')

-- b???ng lo???i s???n ph???m
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('1', 'KC', 'Spoon', 'https://www.freeiconspng.com/thumbs/fork-and-knife-png/fork-and-knife-png-spoon--24.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('2', 'KC', 'Bowl', 'https://www.pngall.com/wp-content/uploads/2018/05/Bowl-PNG-Image.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('3', 'KC', 'Cooking Pot', 'https://www.pngall.com/wp-content/uploads/10/Cooking-Pot-PNG-Photos.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('4', 'KC', 'Rice Cooker', 'https://www.weightwatchers.com/us/shop/assets-proxy/weight-watchers/image/upload/q_auto/v1/prod/en-us-ec/static-asset/US_RICE_COOKER_520321-9969_TRANSPARENT_1200x1200.png?auto=webp')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('5', 'KC', 'Soap', 'https://pngimg.com/uploads/soap/soap_PNG55.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('6', 'KC', 'Gas', 'https://gas24h.com.vn/upload/products/2020/06/size2/1636352267-0-s-gas-xanh-duong.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('7', 'KC', 'Water Bottle', 'https://www.transparentpng.com/thumb/water-bottle/fO4Ttp-water-bottle-vector.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('8', 'KC', 'Fridge', 'https://www.fisherpaykel.com/dw/image/v2/BCJJ_PRD/on/demandware.static/-/Sites-fpa-master-catalog/default/dw65aad765/pdp/fp-02-RF730QZUVB1-10-mug-dp.png?sw=585&sh=706&sm=fit')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('9', 'KC', 'Food', 'https://freepngimg.com/save/13869-healthy-food-png-picture/740x560')

INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('10', 'LVR', 'Television', 'https://www.pngmart.com/files/7/LED-Television-PNG-Transparent.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('11', 'LVR', 'Table & Chair', 'https://png.pngtree.com/png-clipart/20220117/original/pngtree-simple-hand-painted-table-and-chair-transparent-material-png-image_7122618.png')

INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('12', 'BR', 'Bed', 'https://www.transparentpng.com/thumb/bed/luxury-leather-storage-bed-transparent-png-XlWqDj.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('13', 'BR', 'Curtain', 'https://blinckr.com/image/cache/catalog/Cotton%20Candy%20Fuschia%20Curtain/Cottoncandy%20Fuschia%20Curtain_Transparent-270x270.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('14', 'BR', 'Wardrobe & Mirror ', 'https://files.ekmcdn.com/ronzfurniture/images/roma-large-4-door-wardrobe-almirah-white-603453--2190-p.png?v=38ec6a49-65cb-49b2-b612-f4fc372582b7')

INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('15', 'BAR', 'Shower', 'https://www.nicepng.com/png/full/635-6350081_hot-water-shower-with-water-png.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('16', 'BAR', 'Dental Hygiene Tools', 'https://www.jennyngaidds.com/storage/app/media/stock/cleaning-tools.png')

INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('17', 'OSH', 'Flower Vase ', 'https://i.pinimg.com/originals/29/e3/e4/29e3e4350ee14bc5dcc5726c2d5c9ba7.png')
INSERT INTO tblProduct
	(product_ID, category_ID, name , image)
VALUES
	('18', 'OSH', 'Fire Extinguisher', 'https://freepngimg.com/save/140738-fire-extinguisher-vector-hd-image-free/1181x2115')

--B???ng s???n ph???m chi ti???t theo t???ng s???n ph???m c???ng 


INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '1', 'Dinner Spoon Silver', 50, 3, 'https://masflex.com.ph/wp-content/uploads/2021/04/YS-83.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '1', 'Cake Fork Silver', 50, 2, 'https://img.christofle.com/image/upload/s--2MQbtDgo--/c_limit,dpr_2.0,f_auto,h_500,q_auto,w_500/media/catalog/product/C/a/Cake_20fork_20America_20_20Silver_20plated_00001046000101_F_2_1.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '1', 'Tea Spoon Gold', 50, 8, 'https://www.nicepng.com/png/full/137-1375331_milano-tea-spoon-gold-plated-gold-spoon-png.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '1', 'Tea Spoon Wooden Gold', 50, 7, 'https://cdn-amz.woka.io/images/I/71VDt3URLML._SR720,720_.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '1', 'Tea Spoon Chrome', 50, 6, 'https://www.wmf-professional.com/media/catalog/product/cache/2/image/508x/040ec09b1e35df139433887a97daa66f/5/4/5483726040.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '1', 'Table Knife Gold', 50, 5, 'https://img.christofle.com/image/upload/s--1noiI0BK--/c_limit,dpr_2.0,f_auto,h_500,q_auto,w_500/Products/02327012001101_STQ_qvsbbn.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '1', ' Dinner Fork Gold', 50, 3, 'https://img.christofle.com/image/upload/s--2Wk8N2t9--/c_limit,dpr_2.0,f_auto,h_500,q_auto,w_500/Products/354003_F_pnpdg2.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '1', 'Table Knife Gold', 50, 5, 'https://groupeabp.com/wp-content/uploads/product_images/4079.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '1', ' Dinner Fork Gold', 50, 3, 'https://img.christofle.com/image/upload/s--2Wk8N2t9--/c_limit,dpr_2.0,f_auto,h_500,q_auto,w_500/Products/354003_F_pnpdg2.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '2', 'Speckle Rice Bowl White', 50, 4, 'http://cdn.shopify.com/s/files/1/2270/8601/products/ace6984-hr_vrij_01_grande.png?v=1632137970' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '2', 'Speckle Rice Bowl Blue', 50, 3, 'https://assets.kogan.com/images/butlerco/BTR-505m/1-f198e87c17-505m-removebg-preview.png?auto=webp&canvas=340%2C226&fit=bounds&height=226&quality=90&width=340' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '2', 'Platinum Rim Salad Bowl Ivory', 50, 8, 'https://cdn.shopify.com/s/files/1/0253/0590/7299/products/312895010059_Plumes_or_Coupe_salade_Individual_salad_bowl_1024x1024@2x.png?v=1622543521' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '2', 'Botanical Salad Bowl Green', 50, 7, 'https://chairish-prod.freetls.fastly.net/image/product/master/f7dab701-5b6b-44f9-9abc-70f743e60edf/1990s-mikasa-queens-garden-ivy-leaf-pattern-salad-serving-set-5-pieces-1865' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '2', 'Regale Soup Bowl Black & Gold', 50, 6, 'https://sslimages.shoppersstop.com/sys-master/images/h75/hd2/8899184197662/9633369_9999.png_2000Wx3000H' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '2', 'Polka Soup Bowl', 50, 5, 'https://cdn.shopify.com/s/files/1/1317/9515/products/IMG_20150929_210249_edit_1024x1024@2x.png?v=1536599901' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '2', 'Nurina Cereal Bowl Dcream', 50, 7, 'https://www.seekpng.com/png/detail/990-9900037_800-x-596-8-cereal-bowl-with-cereal.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '2', 'Wooden Bowl', 50, 5, 'https://lofory.com/wp-content/uploads/2021/11/Natural-Wooden-Salad-Bowl-6.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '2', 'Ceramic Bowl', 50, 12, 'https://static.vecteezy.com/system/resources/previews/009/664/965/non_2x/empty-porcelain-ceramic-bowl-on-transparent-background-file-free-png.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
---------------
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '3', 'Ferric Iron Fry Pan', 50, 9, 'https://hellokitchen.com.au/wp-content/uploads/2021/09/PC220312-2.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '3', 'Ferric Cast Iron Kadai Black', 50, 9, 'https://mrbutlers.com/pub/media/catalog/product/cache/cf2a296d1dbef50483d61587672f6c7d/p/n/pngs-fileartboard-7_1.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '3', 'Classic Deep Pan', 50, 6, 'https://vietnamshine.com/wp-content/uploads/2017/11/ih-classic-deep-pan-26cm.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '3', 'Pietra-e-legno Sauce Pot', 50, 7, 'https://services.electrolux-medialibrary.com/118ed4c0ee6546f4a7684c7fef8c985aNrZmYkM861d1f/view/WS_PN/PSAAPL170PE00007.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '3', 'Classic Deep Pan', 50, 9, 'https://vietnamshine.com/wp-content/uploads/2017/11/ih-classic-deep-pan-26cm.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Gourmet Sauce Pot', 50, 10, 'https://www.aegnewzealand.co.nz/remote.jpg.ashx?width=3200&urlb64=aHR0cHM6Ly9yZXNvdXJjZS5lbGVjdHJvbHV4LmNvbS5hdS9QdWJsaWMvSW1hZ2UyL3Byb2R1Y3QvMjgzMjUvNTIxMTAvQkUtQUVHSGVyb0Nhcm91c2VsL0FFR0hlcm9DYXJvdXNlbC5wbmc&hmac=iqIYRok8jtw' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Classic Cooking Pot 22cm', 50, 15, 'https://cdn11.bigcommerce.com/s-1fdhnzvx71/images/stencil/532x532/products/128/407/PSL31320I_2017_10_27_20_11_39_UTC__22917.1581348822.386.513__17625.1588179770.png?c=1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Classic Cooking Pot 26cm', 50, 20, 'https://cdn11.bigcommerce.com/s-1fdhnzvx71/images/stencil/532x532/products/127/404/PSL31320I_2017_10_27_20_11_39_UTC__78759.1581349083.386.513__48351.1588179416.png?c=1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '3', 'Maximus Cooking Pot ', 50, 12, 'https://www.dehomebiz.com.my/image/dehomebiz/image/cache/data/all_product_images/product-729/morphy_richards_562010_multi_cooker_photo_10-810x585.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '3', 'Pro-x Deep Cooking Pot', 50, 12, 'https://media.prod.bunnings.com.au/api/public/content/29487e61f0614b409cf652abc5d3fc00?v=17f6a09f&t=w500dpr1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Forever Sauce Pan', 50, 12, 'https://cdn11.bigcommerce.com/s-jta5lqjn53/images/stencil/532x532/products/573/1084/6720c__56824.1581430091.png?c=1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '3', 'Marburg Grill Pan Black', 50, 12, 'https://assets.kogan.com/images/sirjohnsgifts/SJG-1331223855140/1-1907e02c68-107190.png?auto=webp&canvas=340%2C226&fit=bounds&height=226&quality=90&width=340' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '3', 'Ferric Iron Fry Pan', 50, 9, 'https://hellokitchen.com.au/wp-content/uploads/2021/09/PC220312-2.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('minhchau', '3', 'Ferric Cast Iron Kadai Black', 50, 9, 'https://mrbutlers.com/pub/media/catalog/product/cache/cf2a296d1dbef50483d61587672f6c7d/p/n/pngs-fileartboard-7_1.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '3', 'Classic Deep Pan', 50, 6, 'https://vietnamshine.com/wp-content/uploads/2017/11/ih-classic-deep-pan-26cm.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '3', 'Pietra-e-legno Sauce Pot', 50, 7, 'https://services.electrolux-medialibrary.com/118ed4c0ee6546f4a7684c7fef8c985aNrZmYkM861d1f/view/WS_PN/PSAAPL170PE00007.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '3', 'Classic Deep Pan', 50, 9, 'https://vietnamshine.com/wp-content/uploads/2017/11/ih-classic-deep-pan-26cm.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Gourmet Sauce Pot', 50, 10, 'https://www.aegnewzealand.co.nz/remote.jpg.ashx?width=3200&urlb64=aHR0cHM6Ly9yZXNvdXJjZS5lbGVjdHJvbHV4LmNvbS5hdS9QdWJsaWMvSW1hZ2UyL3Byb2R1Y3QvMjgzMjUvNTIxMTAvQkUtQUVHSGVyb0Nhcm91c2VsL0FFR0hlcm9DYXJvdXNlbC5wbmc&hmac=iqIYRok8jtw' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Classic Cooking Pot 22cm', 50, 15, 'https://cdn11.bigcommerce.com/s-1fdhnzvx71/images/stencil/532x532/products/128/407/PSL31320I_2017_10_27_20_11_39_UTC__22917.1581348822.386.513__17625.1588179770.png?c=1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Classic Cooking Pot 26cm', 50, 20, 'https://cdn11.bigcommerce.com/s-1fdhnzvx71/images/stencil/532x532/products/127/404/PSL31320I_2017_10_27_20_11_39_UTC__78759.1581349083.386.513__48351.1588179416.png?c=1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '3', 'Maximus Cooking Pot ', 50, 12, 'https://www.dehomebiz.com.my/image/dehomebiz/image/cache/data/all_product_images/product-729/morphy_richards_562010_multi_cooker_photo_10-810x585.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '3', 'Pro-x Deep Cooking Pot', 50, 12, 'https://cf.shopee.com.my/file/554f71cfcee00d75f4191c5c268e6b21' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '3', 'Forever Sauce Pan', 50, 12, 'https://cdn11.bigcommerce.com/s-jta5lqjn53/images/stencil/532x532/products/573/1084/6720c__56824.1581430091.png?c=1' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '3', 'Marburg Grill Pan Black', 50, 12, 'https://assets.kogan.com/images/sirjohnsgifts/SJG-1331223855140/1-1907e02c68-107190.png?auto=webp&canvas=340%2C226&fit=bounds&height=226&quality=90&width=340' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '4', 'Cuckoo 1l Rice Cooker', 50, 150,
		'https://samnec.com.vn/uploads/san-pham/2022-09-05-16-00-27cr-0690fsiwhcrvncv.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '4', 'Ava 1l Rice Cooker', 50, 50, 'https://sg-live-01.slatic.net/p/bc091a4d22da96467c979647cc21dbb2.png'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '4', 'Toshiba 1.2l Rice Cooker', 50, 120,
		'https://tchome.vn/Data/images/tuanup/10-3/t40/product_12731_3.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '4', 'HappyCook 1.2l Rice Cooker', 50, 120,
		'https://salt.tikicdn.com/ts/product/22/56/de/3f94a1e353909adc1ffd8ecb7d558f3c.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '4', 'HappyCook 1.8l Rice Cooker', 50, 210,
		'https://salt.tikicdn.com/ts/product/26/8a/29/84b2d31e29b2cf887830d0ee91f94027.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'Lix Dishwashing liquid', 50, 5,
		'https://cdn.shopify.com/s/files/1/2297/2851/products/Dish-washingLiquidLIXFreshLemonSize400gbottle_700x700.png?v=1597204384'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'SunLight Dishwashing liquid', 50, 7,
		'https://cdn.shopify.com/s/files/1/0403/2203/9970/products/CP_3_F.png?v=1607953014' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'SurF Dishwashing liquid', 50, 7,
		'https://vn-live-05.slatic.net/p/44b65bcdcc81a8c4278a9ef08bb4c8b4.png_525x525q80.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'IziHome Dishwashing liquid', 50, 7, 'https://cf.shopee.vn/file/30b38cfaebd50eefcd45e300b78a0ed0' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'EazyClean Dishwashing liquid', 50, 7,
		'http://ezeecares.com/wp-content/uploads/2013/09/ezee-dish-gel-yellow-green.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'Net Dishwashing liquid', 50, 6,
		'https://asmart.com.vn/wp-content/uploads/2021/09/NRC-NET-DD-huong-chanh-800g.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'Gift Dishwashing liquid', 50, 5,
		'https://vn-test-11.slatic.net/p/f87a22d9aa4acf8527cdc286c798b9bc.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'LifeBouy', 50, 13,
		'https://www.lifebuoy.in/content/dam/brands/lifebuoy/india/2133695-lifebuoy-innovation-total-soap-wrapper-125g---total-10.png'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'DoubleRich ShowerGel', 50, 17, 'https://sovina.vn/wp-content/uploads/2016/10/DBR1.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'Puri ShowerGel', 50, 12, 'https://media.ulta.com/i/ulta/2581853?w=720' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '5', 'Palmolive ShowerGel', 50, 15,
		'https://aswaqrak.ae/pub/media/catalog/product/cache/9e61d75d633e5fc1a695bad0376a2475/c/c/8714789515656.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Composite CPS Gas', 50, 46,
		'https://dailygashcm.com/wp-content/uploads/2018/07/Dai_Ly_Gas_Miss_binh-gas-chong-chay-no-composite-muc-nuoc-gas.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'PetroVietNam Bink Gas', 50, 146, 'https://gasviet.vn/wp-content/uploads/2018/12/gasviet-5.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1
)
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Composite 6kg Gas', 50, 23,
		'https://hethonggasbinhminh.vn/wp-content/uploads/2021/03/Dai_Ly_Gas_Miss_Conposite.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Oil Grey Gas', 50, 38,
		'https://www.swift-fuels.com/wp-content/uploads/2020/04/11kg-patio-gas-refill.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'ELF Gaz 12kg', 50, 38, 'https://gasluaxanh.com/wp-content/uploads/2021/04/total-elf-redbig.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.'
, 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Family Gas 12kg', 50, 40,
		'https://gasluaxanh.com/wp-content/uploads/2021/04/gas-gia-dinh-do-12kg-793x800-2.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Family Gas 45kg', 50, 138,
		'https://gasluaxanh.com/wp-content/uploads/2021/04/Binh-Gas-Gia-Dinh-Xam-45-Kg.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Family Gas Red 12kg', 50, 40,
		'https://gastuchau.vn/files/product/binh-gas-gia-dinh-do12-kg-gsnmvptl.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Oil Green Gas', 50, 39,
		'https://www.nicepng.com/png/full/74-743171_all-you-need-to-know-about-lpg-gas.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('petro', '6', 'Family Gas Blue 12kg', 50, 40,
		'https://images.squarespace-cdn.com/content/v1/5defa892a8313b70e3c9dab6/1596113910190-K9B91HYK4DRGAIE001H3/12kg+butane.png?format=1000w'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Satori Water 20L', 50, 5,
		'https://bizweb.dktcdn.net/100/422/803/products/satori.png?v=1625619757127' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Vihawa Water 20L', 50, 6,
		'https://thienhau.vn/wp-content/uploads/2014/07/nuoc-tinh-khiet-vihawa-20-lit-600x600.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Bidrico Water 20L', 50, 3,
		'https://dailynuockhoang.vn/wp-content/uploads/2019/10/Nuoc-Bidrico-20l-co-voi-600x614.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'I-on Life Water 20L', 50, 7,
		'https://www.queanhwater.com/wp-content/uploads/2019/07/b%C3%ACnh-n%C6%B0%E1%BB%9Bc-ion-life-19l_qu%E1%BA%BF-anh-food.png'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Lavi Water 20L', 50, 6,
		'https://nuockhoanglavievn.com/wp-content/uploads/2019/11/b%C3%ACnh-s%E1%BB%A9.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Viva Water 20L', 50, 6,
		'https://nuocuongtruongphat.com/wp-content/uploads/2020/03/nuoc-lavie-co-voi.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Aquafina 350ml *24', 50, 9, 'https://sangphatwater.vn/Upload/product/nuoc-aquafina-350l-8276.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Aquafina 500ml *24', 50, 10, 'https://nuocsuoisala.com/wp-content/uploads/2022/07/aquafina-500l.png'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Lavie 500ml *24', 50, 88,
		'https://nuockhoanglaviehanoi.com/wp-content/uploads/2019/04/1-thung-lavie-bao-nhieu-chai.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '7', 'Satori 500ml *24', 50, 10, 'https://nuocsuoisala.com/wp-content/uploads/2022/07/Satori-500ml.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '8', 'Samsung Inverter 236l', 50, 73,
		'https://2momart.vn/upload/products/082020/tu-lanh-samsung-inverter-rt22m4032dx-sv-gia-re.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '8', 'Toshiba Inverter 180l', 50, 53,
		'https://prices.vn/storage/photos/7/product/1594787705-tu-lanh-toshiba-inverter-gr-b22vu-ukg-180l0.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '8', 'Toshiba Inverter 90l', 50, 31,
		'https://vn-test-11.slatic.net/p/dc71e47775b9a4d4ccbe7700472fa481.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '8', 'Samsung Inverter 208l', 50, 61,
		'https://bizweb.dktcdn.net/100/184/135/products/1-43.png?v=1599541482817' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '8', 'Panasonic Inverter 322l', 50, 160,
		'https://2momart.vn/upload/products/052021/tu-lanh-panasonic-nr-bc360qkvn-nghieng-trai.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '8', 'Panasonic Inverter 322l', 50, 157,
		'https://2momart.vn/upload/products/052021/tu-lanh-panasonic-nr-bc360qkvn-nghieng-trai.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '8', 'Samsung Inverter 307l', 50, 140,
		'http://anhchinh.vn/media/product/14975_rb27n4190bu.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '8', 'LG Inverter 266l', 50, 80,
		'https://cdn.tgdd.vn/Products/Images/1943/106246/tu-lanh-lg-gn-l702sd-300x300.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '8', 'Panasonic Inverter 417l', 50, 204,
		'https://www.panasonic.com/content/dam/pim/vn/vi/NR/NR-BX4/NR-BX471GPK/ast-1271373.png.pub.thumb.644.644.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1
)
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Australian beef thighs 250g', 50, 11,
		'https://cdn.gdaymeat.com.au/wp-content/uploads/2022/03/Chucksteak666.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Beef encrusted 250g', 50, 8,
		'https://cdn.shopify.com/s/files/1/0278/9765/9462/products/groundbeef_250x250@2x.png?v=1591194631' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Australian beef middle 250g', 50, 8,
		'https://cdn.shopify.com/s/files/1/2297/2851/products/AustralianWagyuChuckEyeSteakSize300g-400g_Priceperkg_800x800.png?v=1628223330'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Bacon 250g', 50, 9,
		'https://dtgxwmigmg3gc.cloudfront.net/imagery/assets/derivations/icon/512/512/true/eyJpZCI6IjQ1ZjA5ZTU0Zjk0NzI3ZmI0NDRmOGM4Yjc3MGE1YTBjIiwic3RvcmFnZSI6InB1YmxpY19zdG9yZSJ9?signature=f96f37b69f389ae8fa821a36e4985d192b08fac01aea5a56ab6ea1397a9dbf05'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Australian beef thighs 500g', 50, 13,
		'https://cdn.shopify.com/s/files/1/2297/2851/products/AustralianWagyuChuckEyeSteakSize300g-400g_Priceperkg_800x800.png?v=1628223330'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Combo Grilled Meat 560g', 50, 26, 'https://cdn.shopify.com/s/files/1/0525/5829/9312/products/01_Starter_570x570.png?v=1615520877' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Australian beef ribs 500g', 50, 13,
		'https://cdn.shopify.com/s/files/1/0269/7723/9113/products/Beefcubeswhite_97668cbf-ab96-42ed-8815-84ff5d773cea_400x.png?v=1602324399'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Frozen Salmon 300g', 50, 12,
		'https://product.hstatic.net/200000077081/product/c_3f4771a6d5264caf998330d76d71abf6_1024x1024.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Frozen Fins Salmon 200g', 50, 30000,
		'https://thumbs.dreamstime.com/z/chopsticks-vector-illustration-eastern-traditional-cuisine-91586868.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Shirmp 500g', 50, 15,
		'https://www.balbiino.ee/wp-content/uploads/2019/12/KRR039-MARINE-koormiata-krevett-70-90-500g.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Saba Fish 400g', 50, 3,
		'https://images.squarespace-cdn.com/content/v1/5b182f57b105981d7e0a93d7/1530229488856-EWS2J3NQM0U2U041AQR7/4.png?format=1000w'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '9', 'Orange Fish 1.3kg', 50, 11, 'https://salmon-farm.com/wp-content/uploads/2021/12/27-12-2021.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '10', 'Samsung SmartTV 55inch', 50, 148,
		'https://images.samsung.com/is/image/samsung/p6pim/vn/ua55au7002kxxv/gallery/vn-uhd-au7002-ua55au7002kxxv-531928752?$650_519_PNG$'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '10', 'LG SmartTV', 50, 140,
		'https://bizweb.dktcdn.net/thumb/1024x1024/100/443/782/products/smart-tivi-lg-75uq8050psb-4k-75-inch-1.png?v=1664265469930'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('dien_may_cho_lon', '10', 'Sony GoogleTV', 50, 154,
		'https://tuson.vn/uploads/product/Tivi/Sony/2022/KD-65X75K/KD-65X75K%20AVATAR.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '10', 'Samsung SmartTV 43inch', 50, 118,
		'https://images.samsung.com/is/image/samsung/vn-uhd-nu7090-ua50nu7090kxxv-frontblack-108921423?$650_519_PNG$' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1
)
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '10', 'TCL SmartTV 55inch', 50, 109,
		'https://pre-dispatcher.tclking.com/content/dam/brandsite/region/vietnam/tivi-tcl-55-inch/Q716-front.png?auto=webp,smallest'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '10', 'LG SmartTV 55inch', 50, 130,
		'https://pre-dispatcher.tclking.com/content/dam/brandsite/region/vietnam/tivi-tcl-55-inch/Q716-front.png?auto=webp,smallest'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '10', 'Samsung SmartTV 50inch', 50, 130,
		'https://images.samsung.com/is/image/samsung/p6pim/vn/ua50au7700kxxv/gallery/vn-uhd-au7000-383862-ua50au7700kxxv-421623795?$650_519_PNG$'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '10', 'Sony SmartTV 55inch', 50, 148,
		'https://d13o3tuo14g2wf.cloudfront.net/thumbnails%2Flarge%2FAsset+Hierarchy%2FConsumer+Assets%2FTelevision%2FBRAVIA+LCD+HDTV%2FFY+22%2FX85K%2FProduct+shots%2FX85K_55_65_75%2FeComm%2F1--X85K-65-Sony-FRNT.png.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9kMTNvM3R1bzE0ZzJ3Zi5jbG91ZGZyb250Lm5ldC90aHVtYm5haWxzJTJGbGFyZ2UlMkZBc3NldCtIaWVyYXJjaHklMkZDb25zdW1lcitBc3NldHMlMkZUZWxldmlzaW9uJTJGQlJBVklBK0xDRCtIRFRWJTJGRlkrMjIlMkZYODVLJTJGUHJvZHVjdCtzaG90cyUyRlg4NUtfNTVfNjVfNzUlMkZlQ29tbSUyRjEtLVg4NUstNjUtU29ueS1GUk5ULnBuZy5wbmciLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjIxNDU3NjIwMDB9fX1dfQ__&Signature=TSRDmdrCnA7UhvXLkMZLkzYIkCK-apxdu4nxJ66CSLOLOTxIm8L9Dcb9H7CGgJ5jQ7mEsuOy6PxyVqrw9CSk2xwmm3Ja03PTiRWAoMPwAPyYF9lkHN5vzgeiR7ipLUmia-i-rCX8kKm27bWgb~xK11EfSMfbvlaBQov9yQGgMjzY5yXfjmaQ~baIFdHJ-9Prvl8DdfBsxAu4r-6LmZfra3yRGk41lqPOksfde3XAp55YYbVzPLC6eLK28uaVlu~76T0g-h0SbxfLgL1nF9hA8~e04WVvzxuo2iI58C7LVJdxqhzW15bGFt0~zXE80FyN5KRryRjxoc3pGvLCItG9kQ__&Key-Pair-Id=K37BLT9C6HMMJ0'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '10', 'Sony SmartTV 55inch', 50, 138,
		'https://d13o3tuo14g2wf.cloudfront.net/thumbnails%2Flarge%2FAsset+Hierarchy%2FConsumer+Assets%2FTelevision%2FBRAVIA+LCD+HDTV%2FFY+22%2FX85K%2FProduct+shots%2FX85K_55_65_75%2FeComm%2F1--X85K-65-Sony-FRNT.png.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9kMTNvM3R1bzE0ZzJ3Zi5jbG91ZGZyb250Lm5ldC90aHVtYm5haWxzJTJGbGFyZ2UlMkZBc3NldCtIaWVyYXJjaHklMkZDb25zdW1lcitBc3NldHMlMkZUZWxldmlzaW9uJTJGQlJBVklBK0xDRCtIRFRWJTJGRlkrMjIlMkZYODVLJTJGUHJvZHVjdCtzaG90cyUyRlg4NUtfNTVfNjVfNzUlMkZlQ29tbSUyRjEtLVg4NUstNjUtU29ueS1GUk5ULnBuZy5wbmciLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjIxNDU3NjIwMDB9fX1dfQ__&Signature=TSRDmdrCnA7UhvXLkMZLkzYIkCK-apxdu4nxJ66CSLOLOTxIm8L9Dcb9H7CGgJ5jQ7mEsuOy6PxyVqrw9CSk2xwmm3Ja03PTiRWAoMPwAPyYF9lkHN5vzgeiR7ipLUmia-i-rCX8kKm27bWgb~xK11EfSMfbvlaBQov9yQGgMjzY5yXfjmaQ~baIFdHJ-9Prvl8DdfBsxAu4r-6LmZfra3yRGk41lqPOksfde3XAp55YYbVzPLC6eLK28uaVlu~76T0g-h0SbxfLgL1nF9hA8~e04WVvzxuo2iI58C7LVJdxqhzW15bGFt0~zXE80FyN5KRryRjxoc3pGvLCItG9kQ__&Key-Pair-Id=K37BLT9C6HMMJ0'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Wood Trestle Table', 50, 500,
		'https://optimise2.assets-servd.host/fine-elk/production/images/Products/WEB_Oxford-trestle-table_metal-frame-bespoke.png?w=1200&q=80&fm=webp&fit=crop&crop=focalpoint&fp-x=0.5&fp-y=0.5&dm=1519299764&s=002a1d317198f96c03fbc516e8905490'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Wood Mango Coffee Table', 50, 70, 'https://static.henkschram.com/images/77004%20(1).png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1
)
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Square Wood Mango Table', 50, 100,
		'https://5.imimg.com/data5/SELLER/Default/2022/5/ON/KL/IA/138536105/6-500x500.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Cement Finish Table', 50, 200,
		'http://static1.squarespace.com/static/57239bd5f8baf385ff553066/5f96ea5ccc17a47254c7b088/5f986a7960c99853043154d9/1604436153903/?format=1500w'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Square Wood Mango Table', 50, 100,
		'https://5.imimg.com/data5/SELLER/Default/2022/5/ON/KL/IA/138536105/6-500x500.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Leather Sofa', 50, 200,
		'https://leathersofaco.com/reddot/uploads/img/content/cID_1307/canto-leather-sofa.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'L Shaped Sofa', 50, 750,
		'https://cdn.shopify.com/s/files/1/2405/3057/products/TINA_dimension_-01_2048x.png?v=1657697978' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Oak ArmChair', 50, 200,
		'https://cdn.shopify.com/s/files/1/0174/2162/products/DYKE_AND_DEAN_DE_MACHINEKAMER_Hans_Fauteuil_OAK_ARMCHAIR_GREY.png?v=1657655861'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'OBeveled Wood Table', 50, 55,
		'https://www.cherrystonefurniture.com/images/thumbs/0000249_flare-oval-coffee-table_450.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Lacquered Chair', 50, 55,
		'https://pilma.com/wp-content/uploads/2021/05/0743-657RJ-SILLA-NIZA-LACADO-ROJO.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '11', 'Small Tool Chair', 50, 25, 'https://cdn.pixabay.com/photo/2014/12/21/23/50/stool-576147__340.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '12', 'Wooden Box Bed', 50, 309,
		'https://www.godrejinterio.com/imagestore/B2C/MONC00016/MONC00016_01_1500x1500.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '12', 'White Box Bed', 50, 499, 'https://cdn4.afydecor.com/Beds/364/364.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '12', 'Bed With tail Drawer', 50, 890,
		'https://i.pinimg.com/736x/a9/39/90/a93990110944eb88f736be83cf0edb08--bookcase-headboard-beds-online.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '12', 'Hotel Bed', 50, 299,
		'https://i.pinimg.com/originals/9d/85/e6/9d85e62e83ed9a35caf92635b2c9e1cf.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '13', 'Linen Curtain With Piping', 50, 59,
		'https://static.wixstatic.com/media/8cc929_8d50830520e442b6af50a06c8961fd39~mv2.png/v1/fill/w_420,h_420,al_c,lg_1,q_85,enc_auto/8cc929_8d50830520e442b6af50a06c8961fd39~mv2.png'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('zarahome', '13', 'Cottan Curtain', 50, 39,
		'https://assets.pbimgs.com/pbimgs/ab/images/dp/wcm/202243/0058/seaton-textured-cotton-curtain-2-z.jpg'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '13', 'Cut-out Linen Curtain', 50, 49,
		'https://i.pinimg.com/564x/86/70/c3/8670c3f39b057bc5dc74eb77ad15bbf2--velvet-curtains-blue-curtains.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '13', 'White Linen Curtain', 50, 50,
		'https://i.pinimg.com/originals/1b/98/fc/1b98fcd65b6c372023898e800a84fbad.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Aberton 6 Door Wardrobe', 50, 500,
		'https://www.panemirates.com/images/pan-aberton-6-door-wardrobe-p40565-176939_image.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Janousek 6 Door Wardrobe', 50, 400,
		'https://secure.img1-cg.wfcdn.com/im/68746066/compr-r85/9819/98192010/carlsson-6-door-wardrobe.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Claudius 3 Door Wardrobe', 50, 300,
		'https://www.zadinteriors.com/store/wp-content/uploads/2021/06/6-x-4-side-view_3Door_dim.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Milan Collection 3 Door', 50, 200,
		'https://www.highcountrydoors.com/mfg_photos/Milan_collection_03.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Heinrich 6 Door Wardrobe', 50, 10,
		'https://image.made-in-china.com/2f0j00pWrzPveMEjqZ/Modern-Home-Six-Door-Wardrobes-Furniture-Sets-Designs-6-Door-MDF-Wooden-Bedroom-Wardrobe.jpg'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Ranstead 2 Door Wardrobe', 50, 70,
		'https://cdnprod.mafretailproxy.com/sys-master-root/h02/h26/12826476642334/011NFM1900023_media_2_480Wx480H' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Preystin Mirror 40x150cm', 50, 70,
		'https://m.media-amazon.com/images/I/41-i-GYwLBL._AC_UL320_.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Syrah Wall Mirror 19x133cm', 50, 70,
		'https://www.panemirates.com/qatar/en/images/pan-akira-wall-mirror-60x90cm-silver-p32997-140856_thumb.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('homefurniture', '14', 'Galen Wall Mirror Gold 62x62cm', 50, 70,
		'https://www.panemirates.com/images/pan-galen-wall-mirror-gold-62x62cm-p25441-104195_image.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '15', 'Shower By Plastic EL-H109', 50, 23,
		'https://salt.tikicdn.com/cache/w1200/ts/product/0f/7f/25/e11a9bd40c22a7d263ad4dc46ac22717.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '15', 'Shower By Inox EL-H110', 50, 3,
		'https://dienmay.vatbau.com/Products/Images/9338/230939/eurolife-el-h110-2-2-org.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '15', 'Shower Mitsubishi Cleansui', 50, 99,
		'https://www.mitsubishicleansui.vn/voisenkhuclo/wp-content/uploads/sites/3/2020/09/ES301_luxury.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '16', 'Electric ToothBrush Halio', 50, 11,
		'https://lh3.googleusercontent.com/xjIOWSy1Q2gOt9GjZT-zGk2QrWuApsk-0VfjYRCtoJT0YaOh3SvwSxl5z6kZLbN6YK8gzeLtzzJVFIzga4hJEOmWeub_XpGX'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '16', 'Electric ToothBrush Halio', 50, 120,
		'https://product.hstatic.net/1000006063/product/ht_1024x1024_2x_c7d5207180434e55b1c5d169a000814d_1024x1024.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.'
, 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '16', 'Electric ToothBrush P/S', 50, 110,
		'https://crestoralbproshop.com/media/wysiwyg/00069055132494_C1N0.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '16', 'Bamboo Charcoal ToothPaste', 50, 4,
		'https://www.colgate.com/content/dam/cp-sites/oral-care/oral-care-center/en-in/product-detail-pages/toothpaste/colgate-charcoal-clean.png'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '16', 'PS ToothPaste', 50, 99,
		'https://product.hstatic.net/1000190126/product/ps_nguasaurang_vt-1367645-png_d3974f6f1e3543b6bedae40c62d01931.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '16', 'Dental Clinic ToothPaste', 50, 59,
		'https://ibeaudy.vn/wp-content/uploads/2021/01/unnamed-300x300.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '17', 'Table Flower Vase', 50, 85,
		'https://i.pinimg.com/originals/19/d4/ca/19d4ca41435bfd70f475ffce7a96f3b1.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('bach_hoa_xanh', '17', 'Table Flower Vase', 50, 75, 'https://www.picng.com/upload/vase/png_vase_25246.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '17', 'Table Flower Vase', 50, 65,
		'https://cdn.shopify.com/s/files/1/2566/7252/products/0321-3-5-5_1200x1200.png?v=1646346669' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '17', 'Table Flower Vase', 50, 55, 'https://cdn.pixabay.com/photo/2018/01/11/10/00/rose-3075776__340.png' ,
		'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '17', 'Table Flower Vase', 50, 45,
		'https://ae01.alicdn.com/kf/H1a00a8aab20f483d923885edd5fb9223U/Modern-Black-Face-Vase-Ceramic-Head-Flower-Pot-Flower-Arrangement-Container-Living-Room-Dining-Table-Flower.jpg'
, 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '18', 'Globural Fire Extinguisher 6kg', 50, 60,
		'https://media1.svb-media.de/en/images/517538/gloria-pd6ga-powder-fire-extinguisher-6-kg-fire-class-abc.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '18', 'Globural Fire Extinguisher 8kg', 50, 70,
		'http://sc04.alicdn.com/kf/Hd9f07c037ab8417fa2d52ad28fd5c978F.jpg' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '18', 'Powder Fire Extinguisher 2kg', 50, 18,
		'https://eversafe.net/wp-content/uploads/2021/07/Home-Safety-Kit-04.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )
INSERT INTO tblProductDetail
	(provider_ID, product_ID, name, quantity, price, image, description, status)
VALUES
	('cho_tot_tot', '18', 'Powder Fire Extinguisher 4kg', 50, 38,
		'https://www.uniquefire.com/wp-content/uploads/2019/04/4-kg-fire-extinguisher-1.png' , 'A large, silver-plated vegetable spoon with the matching potato spoon from WMFs Rome series.The spoons are ideal for serving a wide variety of vegetables.Great companion on an elegantly set dining table.' , 1 )

--B???ng lo???i d???ch v??? theo nh??m 

INSERT INTO tblServiceCategory
	(category_ID, name, image)
VALUES
	('HC', 'Home Cleaning', 'https://www.pngkey.com/png/full/224-2244033_whether-you-need-my-cleaning-services-for-your.png')
INSERT INTO tblServiceCategory
	(category_ID, name, image)
VALUES
	('HI', 'Home Improvement', 'https://rothfield.com.au/wp-content/uploads/2021/06/Rothfield_3PL_Hero-Banner-.png')
INSERT INTO tblServiceCategory
	(category_ID, name, image)
VALUES
	('PBS', 'Plumbers', 'https://static.wixstatic.com/media/403b64_dc829afea69b46108304d88808cfe46e~mv2.png/v1/fill/w_416,h_350,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Yelm-Plumbing-and-Pumps-Sewer-Line-Repai.png')
INSERT INTO tblServiceCategory
	(category_ID, name, image)
VALUES
	('IT', 'IT Service', 'https://www.pngplay.com/wp-content/uploads/13/Software-IT-Services-Transparent-Background.png')
INSERT INTO tblServiceCategory
	(category_ID, name, image)
VALUES
	('CAR', 'Car Service', 'https://previews.123rf.com/images/macrovector/macrovector1503/macrovector150300186/37345149-car-service-concept-with-auto-repair-and-maintenance-decorative-icons-set-vector-illustration.jpg')
--B???ng lo???i d???ch v??? 

INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('1', 'HC', 'Deep Cleaning', 'https://spicandspan.de/assets/icons/sas_logo_icon_only.svg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('2', 'HC', 'Sofa Cleaning', 'https://freesvg.org/img/Sofa-lineart.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('3', 'HC', 'Exterior Cleaning', 'https://ozclean.com.au/goldcoast/images/services/exterior/exclusive-benefits.svg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('4', 'HC', 'Mattress Cleaning', 'https://cdn2.iconfinder.com/data/icons/cordless-stick-vacuum-cleaner-vac/324/stick-vac-13-512.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('5', 'HC', 'Carpet Cleaning', 'https://cdn2.iconfinder.com/data/icons/cleaning-hygiene/160/carpet-cleaning-512.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('6', 'HC', 'Scrubs Cleaning', 'https://previews.123rf.com/images/jemastock/jemastock1909/jemastock190928324/130728070-cleaning-and-hygiene-equipment-cleaning-shampoo-scrub-brush-icon-cartoon-vector-illustration-graphic.jpg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('7', 'HC', 'Window Cleaning', 'https://freesvg.org/img/1571751673windowwasher.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('8', 'HC', 'Ozone Treatment', 'https://cdn.shopify.com/s/files/1/0575/4470/4165/files/3457313_1000x1000.png?v=1624268288')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('9', 'HC', 'Disinfection', 'https://icons.veryicon.com/png/o/healthcate-medical/medical-health-1/disinfect.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('10', 'HC', 'Full Cleaning', 'https://cdn-icons-png.flaticon.com/512/994/994941.png')

INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('11', 'HI', 'Decluttering', 'https://cdn.iconscout.com/icon/premium/png-256-thumb/declutter-2105384-1770481.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('12', 'HI', 'Packing $ Unpacking', 'https://moveinterstate.com/wp-content/uploads/2020/02/Packing-square.svg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('13', 'HI', 'Transport Home', 'https://cdn-icons-png.flaticon.com/512/4950/4950837.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('14', 'HI', 'Electrician', 'https://media.istockphoto.com/vectors/electrician-man-working-to-install-and-maintain-electrical-equipment-vector-id1210520046?b=1&k=20&m=1210520046&s=170667a&w=0&h=34pJUCfo0VR2t2Ar4eU5pa47SYXMksIXbBfmIOx0z50=')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('15', 'HI', 'Curtain Decor', 'https://media.istockphoto.com/vectors/curtain-icon-vector-isolated-contour-symbol-illustration-vector-id1205466877?k=20&m=1205466877&s=170667a&w=0&h=QT9EIRhCG46MHaJZZcMiJ_bzHwmlGyyVvbZRCOa0kZM=')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('16', 'HI', 'Paint & Wallpaper', 'https://previews.123rf.com/images/seamartini/seamartini2011/seamartini201100228/158659605-house-renovation-professional-wallpapering-service-workman-in-overalls-and-paper-hat-aligning-wallpa.jpg')

INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('17', 'PBS', 'Piping', 'https://e7.pngegg.com/pngimages/152/870/png-clipart-custom-plumbing-plumber-central-heating-home-repair-toilet-angle-furniture-thumbnail.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('18', 'PBS', 'Filter', 'https://cdn-icons-png.flaticon.com/512/4992/4992693.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('19', 'PBS', 'Water Heater', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNGryqz3CztYinE033TCu4htn4_WOblNczKV7rz7JG6yfQANpOHcIubh_IUboqbhLSyg8&usqp=CAU')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('20', 'PBS', 'Sink', 'https://previews.123rf.com/images/iconisa/iconisa1710/iconisa171001916/87222545-plumber-service-tools-sink-vector-line-icon-sign-illustration-on-white-background-editable-strokes.jpg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('21', 'PBS', 'Pumps', 'https://previews.123rf.com/images/stockgiu/stockgiu1710/stockgiu171006843/88794587-line-pump-toilet-equipment-service-repair-vector-illustration.jpg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('22', 'PBS', 'Toilet', 'https://previews.123rf.com/images/unitonevector/unitonevector1904/unitonevector190401860/121210801-man-plumber-in-uniform-with-plunger-in-hand-toilet-bowl-bathroom-vector-illustration-toilet-cleaning.jpg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('23', 'PBS', 'Bathtub', 'https://previews.123rf.com/images/unitonevector/unitonevector1904/unitonevector190401897/123347605-bathtub-fixing-banner-cartoon-bathroom-home-interior-vector-illustration-professional-plumbing-servi.jpg')

INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('24', 'IT', 'Satellite TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3uzCURZscS3Fy7xXZuSu63eVmdTl1EjLBkevzUYfXMMdNqBmaqoELzDGEWSgP74HDx3Y&usqp=CAU')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('25', 'IT', 'Wifi', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Wifiservice.svg/800px-Wifiservice.svg.png')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('26', 'IT', 'Computers', 'https://images.all-free-download.com/images/graphiclarge/funny_computer_repair_service_elements_vector_572010.jpg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('27', 'IT', 'Home CCTV', 'https://i.pinimg.com/564x/9c/2b/42/9c2b425b1cb70553ae41614b2ebcd14e.jpg')

INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('28', 'CAR', 'Carwash', 'https://media.istockphoto.com/vectors/carwash-classic-car-design-vector-id1254591911')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('29', 'CAR', 'Engine Oil, Oil Filter', 'https://img.freepik.com/premium-vector/engine-oil-with-oil-filter-tire-isolated-white-background_258836-182.jpg?w=2000')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('30', 'CAR', 'Car Interior Cleaning', 'https://previews.123rf.com/images/kokandr/kokandr1409/kokandr140900056/31403016-car-interior-wash-and-clean.jpg')
INSERT INTO tblService
	(service_ID, category_ID, name , image)
VALUES
	('31', 'CAR', 'Car Baterry', 'https://previews.123rf.com/images/sabelskaya/sabelskaya1712/sabelskaya171200446/92148248-adult-man-mechanic-in-blue-uniform-in-car-service-set-one-person-holding-car-battery-charger-another.jpg')
GO
--b???ng nh??n vi??n

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Nguyen The Viet', '550422001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Tran Nhat Minh', '550422001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Tran Nguyen Dat Phu', '550422001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Trang Quoc Dat', '550422121235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Nguyen The Phong', '554122001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Nguyen Hoang Thai Quy', '594122111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Nguyen Le Thai Viet', '941230012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '1', 'Nguyen Thai Dat Trang', '599122001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Nguyen Trang Quoc', '000422001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Tran Nhat Minh Hai', '590421001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Nguyen Tran Phu', '000498001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Nguyen Tien Tai', '550422129640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Le The Phong', '000122001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Le Ton Nu Hoang', '114122111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Le Thai Nguyen', '943210012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '2', 'Tran Tien Trang', '000000001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '3', 'Nguyen Trang Quoc Phu', '001422001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '3', 'Nguyen Than hTra', '500421001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '3', 'Bui Nguyen Thanh Mai', '100498001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '3', 'Tran Phung Hoang Minh', '120422129640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '4', 'Le The Phong Dat', '000122000000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '4', 'Le Ton Nu', '114198111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '4', 'Le Thai Thi Nguyen', '003210012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '4', 'Tran Tien Trang', '000010001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '5', 'Tran Thi Thuy An', '300498001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '5', 'Nguyen Phan Hoang Vy', '210422129640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '5', 'Nguyen Thanh Thuy Truc', '870122000000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '6', 'Nguyen Ngoc Truc', '004198111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '6', 'Nguyen Quyet Chinh', '001230012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '6', 'Nguyen Anh Tuan', '000120001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '7', 'Tran Nhat Nam', '123120001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '7', 'Le Thi Ngoc Truc', '990120001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '7', 'Tran Thuy Tien', '800120001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '7', 'Do Phuong Thao', '060120001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '7', 'Tran Nguyen Hoang Phuc', '000123001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '8', 'Le Chi Minh', '670122000000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '8', 'Le Nguyen Diem Quynh', '004198222294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '9', 'Truong Nhat Tuyen', '001234512940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '9', 'Trinh Gia Huy', '000970001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '10', 'Le Kim Nguyen', '000870001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '10', 'Do Manh Huy', '000770001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homecleaning', '10', 'Nguyen Huu Duc', '000670001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '11', 'Nguyen The Hoang Long', '550543001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '11', 'Tran Hoang Phuc Long', '405522001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '11', 'Nguyen Tien Hoang', '550444441422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '11', 'Phong Quoc Dat', '761822121235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '11', 'Hoang Kieu Long', '554643201234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '12', 'Le Duc Thuan', '594122110000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '12', 'Nguyen Hoang Ton', '852360012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '12', 'Nguyen Thai Kim', '000122001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '12', 'Nguyen Trang Loan', '000564001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '12', 'Tran Nhat Hai', '220421001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '13', 'Doan Ngoc Han', '000948001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '13', 'Ngoc Tien', '550422946640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '13', 'Le Hoang Phong', '001122001234', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '13', 'Le Ton Nu Hue', '114112311294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('moveronline', '13', 'Ngo Tuan Tu', '043210012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Tran Tien Trang Hoang', '000010001295', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Nguyen Quoc Phu', '001422001334', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Nguyen Thanh Tuan Tu', '500461001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Nguyen Thanh Mai', '100498009422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Tran Hoang Minh', '120922129640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Le Phong Dat', '000122009000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Le Ton Nam', '114198191294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('electrician', '14', 'Le Thi Nguyen', '003910012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '15', 'Tran Tien Trang Anh', '000110001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '15', 'Tran Thi Thuy Diem', '310498001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '15', 'Nguyen Phan Vy', '210422729640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '15', 'Nguyen Thuy Truc', '870127000000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '16', 'Nguyen Ngoc Trang', '004178111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '16', 'Nguyen Quyet Tam', '001270012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('homeimprovement', '16', 'Nguyen Anh Tam', '000120701294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '17', 'Nguyen Quoc Phong', '011422001334', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '17', 'Nguyen Thanh Tu', '100461001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '18', 'Nguyen Tron gAnh', '110498009422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '18', 'Tran Hoang Man', '110922129640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '19', 'Le Phong Dien', '100122009000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '19', 'Le Tran Tinh', '014198191294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '20', 'Le Tran Tien', '001910012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '20', 'Tran Trong Anh', '050110001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '21', 'Tran Tien Tai', '320498001422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '21', 'Nguyen Phan Tuan Kiet', '210429729640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '22', 'Nguyen Truc Anh Kiet', '870927000000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '22', 'Nguyen Tuan Phong', '001178111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('getintouch', '23', 'Nguyen Tran Tam', '001670012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('plumbers', '23', 'Nguyen Anh Tam', '000125701294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '24', 'Le Ky Quoc', '011922001334', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '24', 'Nguyen Thanh Tung', '180461001235', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '24', 'Trang Tuan Dat', '110468009422', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '25', 'Nguyen Trong Toan', '109922127979', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '25', 'Doan Gia Bao', '100192009000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '25', 'Dang Hoang Viet', '064198191294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '25', 'Le The Khoi', '001914012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '25', 'Tran Trong Anh Tai', '050160001294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '26', 'Tran Tuan Tai', '320498001822', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '26', 'Nguyen Tuan Kiet', '210429929640', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '26', 'Nguyen Anh Kiet', '870927060000', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '27', 'Nguyen Tien Phong', '001176111294', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '27', 'Nguyen Tran Anh Tam', '001640012940', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('fptcompany', '27', 'Nguyen Thi Tam', '000125701594', 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=', 1)
GO

INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '28', 'Lee Chong Wei', '011922001330', 'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '28', 'Park Kim Son', '120461001575', 'https://www.pngitem.com/pimgs/m/576-5768840_cartoon-man-png-avatar-transparent-png.png', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '28', 'David Touliver', '110468009431', 'https://www.pennmedicine.org/-/media/images/miscellaneous/random%20generic%20photos/smiling_man_with_beard.ashx?mw=620&mh=408', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '28', 'Tran Thanh Hung', '109922120079', 'https://image.shutterstock.com/image-vector/cool-beard-man-vector-logo-260nw-1719020434.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '29', 'Nguyen Quang Dung', '100192123000', 'https://freesvg.org/img/myAvatar.png', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '29', 'Nguyen Truong Giang', '064192341294', 'https://images.vexels.com/media/users/3/145908/raw/52eabf633ca6414e60a7677b0b917d92-male-avatar-maker.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '29', 'Nguyen The Anh', '001914456940', 'https://as2.ftcdn.net/v2/jpg/02/23/50/73/1000_F_223507324_jKl7xbsaEdUjGr42WzQeSazKRighVDU4.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '30', 'Tran Cong Khoi', '111914456940', 'https://deadline.com/wp-content/uploads/2020/11/Stephen-Lang-Headshot-Matt-Sayles-e1605093774374.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '30', 'Le Quan Thanh', '001914123940', 'https://cdn.dribbble.com/users/1040983/screenshots/5807325/media/c3d495a1d644ae646190ee51a64607d5.png?compress=1&resize=400x300&vertical=top', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '30', 'Tran Cong Thanh', '101914456940', 'https://thumbs.dreamstime.com/b/happy-smiling-geek-hipster-beard-man-cool-avatar-geek-man-avatar-104871313.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '31', 'Le Duong Bao', '121914456940', 'https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector.png', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '31', 'Ngo Nhat Nam', '031914456940', 'https://images.assetsdelivery.com/compings_v2/yupiramos/yupiramos2004/yupiramos200436847.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '31', 'Nguyen Phuoc Thinh', '041914456940', 'https://static.vecteezy.com/system/resources/previews/004/476/164/original/young-man-avatar-character-icon-free-vector.jpg', 1)
INSERT INTO tblStaff
	(provider_ID,service_ID,name,id_card,avatar,status)
VALUES
	('michelin_car_service', '31', 'Nguyen Trong Dung', '051914456940', 'https://image.shutterstock.com/image-vector/isolated-avatar-afro-american-man-260nw-2012367269.jpg', 1)

--B???ng detail service
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '1', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '2', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '3', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '4', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '5', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '6', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '7', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '1', '8', 'Deep Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '9', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '10', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '11', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '12', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '13', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '14', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '15', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '2', '16', 'Sofa Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '3', '17', 'Exterior Cleaning', 15, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '3', '18', 'Exterior Cleaning', 15, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '3', '19', 'Exterior Cleaning', 15, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '3', '20', 'Exterior Cleaning', 15, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '4', '21', 'Mattress Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '4', '22', 'Mattress Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '4', '23', 'Mattress Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '4', '24', 'Mattress Cleaning', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '5', '25', 'Carpet Cleaning', 18, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '5', '26', 'Carpet Cleaning', 18, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '5', '27', 'Carpet Cleaning', 18, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '6', '28', 'Scrubs Cleaning', 22, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '6', '29', 'Scrubs Cleaning', 22, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '6', '30', 'Scrubs Cleaning', 22, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '7', '31', 'Window Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '7', '32', 'Window Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '7', '33', 'Window Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '7', '34', 'Window Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '7', '35', 'Window Cleaning', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '8', '36', 'Ozone Treatment', 48, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '8', '37', 'Ozone Treatment', 48, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '9', '38', 'Disinfection', 52, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '9', '39', 'Disinfection', 52, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '10', '40', 'Full Cleaning', 67, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '10', '41', 'Full Cleaning', 67, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homecleaning', '10', '42', 'Full Cleaning', 67, 'Get ready all the time. Helping you with the best service', 1)
GO

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '11', '43', 'Decluttering', 60, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '11', '44', 'Decluttering', 60, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '11', '45', 'Decluttering', 60, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '11', '46', 'Decluttering', 60, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '11', '47', 'Decluttering', 60, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '12', '48', 'Packing $ Unpacking', 10, 'Get ready all the time. Helping you with the best service', 1)
GO

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '12', '49', 'Packing $ Unpacking', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '12', '50', 'Packing $ Unpacking', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '22', '51', 'Packing $ Unpacking', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '12', '52', 'Packing $ Unpacking', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '13', '53', 'Transport Home', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '13', '54', 'Transport Home', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '13', '55', 'Transport Home', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '13', '56', 'Transport Home', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('moveronline', '13', '57', 'Transport Home', 20, 'Get ready all the time. Helping you with the best service', 1)
GO

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '58', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '59', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '60', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '61', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '62', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '63', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '64', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('electrician', '14', '65', 'Electrician', 10, 'Get ready all the time. Helping you with the best service', 1)
GO

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '15', '66', 'Curtain Decor', 8, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '15', '67', 'Curtain Decor', 8, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '15', '68', 'Curtain Decor', 8, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '15', '69', 'Curtain Decor', 8, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '16', '70', 'Paint & Wallpaper', 22, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '16', '71', 'Paint & Wallpaper', 22, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('homeimprovement', '16', '72', 'Paint & Wallpaper', 22, 'Get ready all the time. Helping you with the best service', 1)
GO

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '17', '73', 'Piping', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '17', '74', 'Piping', 11, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '18', '75', 'Filter', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '18', '76', 'Filter', 11, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '19', '77', 'Water Heater', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '19', '78', 'Water Heater', 11, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '20', '79', 'Sink', 9, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '20', '80', 'Sink', 8, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '21', '81', 'Pumps', 9, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '21', '82', 'Pumps', 8, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '22', '83', 'Toilet', 6, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '22', '84', 'Toilet', 6, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('getintouch', '23', '85', 'Bathtub', 12, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('plumbers', '23', '86', 'Bathtub', 14, 'Get ready all the time. Helping you with the best service', 1)
GO

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '24', '87', 'Satellite TV', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '24', '88', 'Satellite TV', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '24', '89', 'Satellite TV', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '25', '90', 'Wifi', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '25', '91', 'Wifi', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '25', '92', 'Wifi', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '25', '93', 'Wifi', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '25', '94', 'Wifi', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '26', '95', 'Computers', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '26', '96', 'Computers', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '26', '97', 'Computers', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '27', '98', 'Home CCTV', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '27', '99', 'Home CCTV', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('fptcompany', '27', '100', 'Home CCTV', 5, 'Get ready all the time. Helping you with the best service', 1)

INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '28', '101', 'Carwash', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '28', '102', 'Carwash', 11, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '28', '103', 'Carwash', 10, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '28', '104', 'Carwash', 13, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '29', '105', 'Engine Oil and Oil Filter', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '29', '106', 'Engine Oil and Oil Filter', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '29', '107', 'Engine Oil and Oil Filter', 20, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '30', '108', 'Car Interior Cleaning', 17, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '30', '109', 'Car Interior Cleaning', 17, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '30', '110', 'Car Interior Cleaning', 17, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '31', '111', 'Car Baterry', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '31', '112', 'Car Baterry', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '31', '113', 'Car Baterry', 5, 'Get ready all the time. Helping you with the best service', 1)
INSERT INTO tblServiceDetail
	(provider_ID, service_ID, staff_ID,name,price,description,status)
VALUES
	('michelin_car_service', '31', '114', 'Car Baterry', 5, 'Get ready all the time. Helping you with the best service', 1)


INSERT INTO tblShipper
	(username, password, name,phone,MRC, status, wallet)
VALUES
	('ebutler1', '12345678', 'Nguyen Van A', '0364613014' , '006358', 1, 0)
INSERT INTO tblShipper
	(username, password, name,phone,MRC, status, wallet)
VALUES
	('ebutler2', '12345678', 'Nguyen Anh Tuan', '0311648204' , '105358', 1, 0)
INSERT INTO tblShipper
	(username, password, name,phone,MRC, status, wallet)
VALUES
	('ebutler3', '12345678', 'Nguyen Thi Hong', '0944351304' , '006497', 1, 0)
INSERT INTO tblShipper
	(username, password, name,phone,MRC, status, wallet)
VALUES
	('ebutler4', '12345678', 'Nguyen Manh Quang', '0644315201' , '009213', 1, 0)
INSERT INTO tblShipper
	(username, password, name,phone,MRC, status, wallet)
VALUES
	('ebutler5', '12345678', 'Le Ba Hau', '0622942014' , '613497', 1, 0)



INSERT INTO tblCustomer
	(username, [password], role_ID, [phone], email, [name], gender, dob, avatar, point, [status])
VALUES
	('baobaobao', '1', 'CUS' , '0322654879', 'baobaobao@gmail.com', 'Doan Gia Bao', 1, '2022-02-02', '1.png' , 0, 1)

INSERT INTO tblCustomer
	(username, [password], role_ID, [phone], email, [name], gender, dob, avatar, point, [status])
VALUES
	('vietvietviet', '1', 'CUS' , '0322654879', 'vietviet@gmail.com', 'Dang Hoang Viet', 1, '2022-02-02', '1.png' , 0, 1)

INSERT INTO tblCustomer
	(username, [password], role_ID, [phone], email, [name], gender, dob, avatar, point, [status])
VALUES
	('toantoantoan', '1', 'CUS' , '0322654879', 'toantona@gmail.com', 'Nguyen Trong Toan', 1, '2022-02-02', '1.png' , 0, 1)

INSERT INTO tblCustomer
	(username, [password], role_ID, [phone], email, [name], gender, dob, avatar, point, [status])
VALUES
	('giang_cat_luong', '1', 'CUS' , '0322654879', 'gianggiang@gmail.com', 'Nguyen Trong Toan', 1, '2022-02-02', '1.png' , 0, 1)

INSERT INTO tblCustomer
	(username, [password], role_ID, [phone], email, [name], gender, dob, avatar, point, [status])
VALUES
	('nganngan1234', '1', 'CUS' , '0322654879', 'nganngan@gmail.com', 'Cao Kim Ngan', 1, '2022-02-02', '1.png' , 0, 1)


INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 107, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 107, N'Tv si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 107, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 107, N'C??ng ???????c', 2, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 107, N'Good', 4, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 106, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 106, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 106, N'M??? m???i mua cho, th??ch c???c!', 4, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 106, N'C??ng ???????c', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 106, N'Good', 4, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 105, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 105, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 105, N'M??? m???i mua cho, th??ch c???c!', 2, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 105, N'C??ng ???????c', 3, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 105, N'Good', 4, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 104, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 104, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 104, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 104, N'C??ng ???????c', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES	
	('nganngan1234' , 104, N'Good', 4, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 103, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 103, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 103, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 103, N'C??ng ???????c', 2, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 103, N'Good', 5, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 102, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 102, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 102, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 102, N'C??ng ???????c', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 102, N'Good', 5, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 101, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 101, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 101, N'M??? m???i mua cho, th??ch c???c!', 4, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 101, N'C??ng ???????c', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 101, N'Good', 4, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 100, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 100, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 100, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 100, N'C??ng ???????c', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 100, N'Good', 5, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 108, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 108, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 108, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 108, N'C??ng ???????c', 2, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 108, N'Good', 5, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 109, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 109, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 109, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 109, N'C??ng ???????c', 3, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 109, N'Good', 5, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 120, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 120, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 120, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 120, N'C??ng ???????c', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 120, N'Good', 5, 1)


/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 121, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 121, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 121, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 121, N'C??ng ???????c', 3, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 121, N'Good', 5, 1)

/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 122, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 5, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 122, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 122, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 122, N'C??ng ???????c', 3, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 122, N'Good', 5, 1)


/*---------------*/

INSERT INTO [tblReviewProduct]
	( [username], [product_id], [comment], [rating], [status])
VALUES
	('giang_cat_luong' , 123, N'I like it! I like it ! 10 ??i???m cho ch???t l?????ng.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('baobaobao' , 123, N'Si??u x???n! ?????c g?? c?? th??m ti???n ????? mua c??i th??? 2.', 4, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('vietvietviet' , 123, N'M??? m???i mua cho, th??ch c???c!', 5, 1)

INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('toantoantoan' , 123, N'C??ng ???????c', 3, 1)


INSERT INTO [tblReviewProduct]
	([username], [product_id], [comment], [rating], [status])
VALUES
	('nganngan1234' , 123, N'Good', 5, 1)

insert into tblAdminRole(role_ID, role_Name) values ('MA', 'Admin Master')
insert into tblAdminRole(role_ID, role_Name) values ('US', 'Admin User')
insert into tblAdminRole(role_ID, role_Name) values ('RE', 'Admin Revenue')

insert into tblAdmin(user_Name, password, role_ID, status) values('hieuMA', '1', 'MA', 1)
insert into tblAdmin(user_Name, password, role_ID, status) values('hieuRE', '1', 'RE', 1)
insert into tblAdmin(user_Name, password, role_ID, status) values('hieuUS', '1', 'US', 1)