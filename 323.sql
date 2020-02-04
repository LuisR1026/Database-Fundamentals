DROP TABLE creditCard;
DROP TABLE privCustomer;
DROP TABLE corporation;
DROP TABLE payment;
DROP TABLE regCustomers;
DROP TABLE zipcode;
DROP TABLE dineIn;
DROP TABLE web;
DROP TABLE togo;
DROP TABLE orderSum;
DROP TABLE orders;
DROP TABLE customer;
DROP TABLE lineCookStation_Junction;
DROP TABLE station;
DROP TABLE lineCook;
DROP TABLE menuItemHeadChef_Junction;
DROP TABLE headChef;
DROP TABLE maitred;
DROP TABLE washer;
DROP TABLE sorter;
DROP TABLE dishwasher;
DROP TABLE tables;
DROP TABLE waitingStaff;
DROP TABLE mentorShip;
DROP TABLE sousChef;
DROP TABLE chef;
DROP TABLE rates;
DROP TABLE employee;
DROP TABLE benefitType;
DROP TABLE menuMUI_Junction;
DROP TABLE menuItem;
DROP TABLE categoryType;
DROP TABLE meatType;
DROP TABLE spiceType;
DROP TABLE menu;
DROP TABLE sizeType;
DROP TABLE paymentType;

CREATE TABLE paymentType(
    paymentType VARCHAR(20) NOT NULL,
CONSTRAINT paymentType_PK PRIMARY KEY(paymentType)
);

CREATE TABLE categoryType(
    categoryType VARCHAR(20) NOT NULL,
CONSTRAINT categoryType_pk PRIMARY KEY(categoryType)
);

CREATE TABLE spiceType(
    spiceType VARCHAR(20) NOT NULL,
CONSTRAINT spiceType_pk PRIMARY KEY(spiceType)
);

CREATE TABLE meatType(
    meatType VARCHAR(20) NOT NULL,
CONSTRAINT meatType_pk PRIMARY KEY(meatType)
);

CREATE TABLE sizeType(
    sizeType VARCHAR(20) NOT NULL,
CONSTRAINT sizeType_pk PRIMARY KEY(sizeType)
);

CREATE TABLE benefitType(
    benefitType VARCHAR(20) NOT NULL,
    benefitDes VARCHAR(80),
CONSTRAINT benefitType_PK PRIMARY KEY(benefitType)
);

CREATE TABLE zipcode(
    zip     VARCHAR(5) NOT NULL,
    city    VARCHAR(20),
    zState  VARCHAR(20),
CONSTRAINT zipcode_pk PRIMARY KEY (zip)
);

CREATE TABLE customer(
    customerID INT NOT NULL ,
    guestNum   INT,
CONSTRAINT customer_pk PRIMARY KEY(customerID)
);

CREATE TABLE employee(
    employeeID  INT NOT NULL,
    fName       VARCHAR(20),
    lName       VARCHAR(20),
    DOB         DATE,
    benefitType VARCHAR(20),
    shift       VARCHAR(10),
    managerID   INT,
CONSTRAINT employee_pk  PRIMARY KEY(employeeID),
CONSTRAINT employee_fk1 FOREIGN KEY(benefitType) REFERENCES benefitType(benefitType),
CONSTRAINT employee_fk2 FOREIGN KEY(managerID) REFERENCES employee(employeeID)
);

CREATE TABLE regCustomers(
    rCustomerID     INT NOT NULL,
    fname           VARCHAR(40),
    lname           VARCHAR(40),
    dateJoined      DATE,
    mimiBalance     DOUBLE,
    emailAddress    VARCHAR(40),
    snailAddress    VARCHAR(40),
    zipCode         VARCHAR(5),
CONSTRAINT regCustomer_pk  PRIMARY KEY(rCustomerID),
CONSTRAINT regCustomer_fk1 FOREIGN KEY(rCustomerID) REFERENCES customer(customerID),
CONSTRAINT regCustomer_fk2 FOREIGN KEY(zipCode) REFERENCES zipcode(zip)
);

CREATE TABLE privCustomer(
    pCustomerID INT NOT NULL,
CONSTRAINT privCustomer_pk PRIMARY KEY(pCustomerID),
CONSTRAINT privCustomer_fk FOREIGN KEY(pCustomerID) REFERENCES regCustomers(rCustomerID)
);

CREATE TABLE corporation(
    cpCustomerID INT NOT NULL,
    orgName      VARCHAR(40),
    corpName     VARCHAR(40),
    phone        VARCHAR(20),
CONSTRAINT corpCustomer_pk PRIMARY KEY(cpCustomerID),
CONSTRAINT corpCustomer_fk FOREIGN KEY(cpCustomerID) REFERENCES regCustomers(rCustomerID)
);

CREATE TABLE orders(
    orderID		 INT NOT NULL,
	oCustomerID  INT,
    orderDate    DATE,
    orderTime    TIME,
CONSTRAINT orders_pk PRIMARY KEY(orderID),
CONSTRAINT orders_fk FOREIGN KEY(oCustomerID) REFERENCES customer(customerID)
);

CREATE TABLE web(
    wOrderID     INT NOT NULL,
CONSTRAINT web_pk   PRIMARY KEY(wOrderID),
CONSTRAINT web_fk   FOREIGN KEY(wOrderID) REFERENCES orders(orderID)
);

CREATE TABLE togo(
    tgOrderID 	 INT NOT NULL,
    estPickup    VARCHAR(10),
    finishedTime VARCHAR(10),
CONSTRAINT togo_pk PRIMARY KEY(tgOrderID),
CONSTRAINT togo_fk FOREIGN KEY(tgOrderID) REFERENCES orders(orderID)
);

CREATE TABLE waitingStaff(
    wsEmployeeID        INT NOT NULL,
    tipIntakePercentage DOUBLE,
CONSTRAINT waitingStaff_pk  PRIMARY KEY (wsEmployeeID),
CONSTRAINT waitingStaff_fk1 FOREIGN KEY (wsEmployeeID) REFERENCES employee(employeeID)
);

CREATE TABLE tables(
  tableNum    INT NOT NULL,
  tEmployeeId INT,
CONSTRAINT tables_pk PRIMARY KEY (tableNum),
CONSTRAINT tables_ck UNIQUE(tEmployeeId),
CONSTRAINT tables_fk FOREIGN KEY (tEmployeeId) REFERENCES waitingStaff(wsEmployeeID)
);

CREATE TABLE dineIn(
  diOrderID     INT NOT NULL,
  guestSize     INT,
  diTableNum    INT,
CONSTRAINT dinIn_pk PRIMARY KEY (diOrderID),
CONSTRAINT dineIn_fk1 FOREIGN KEY (diOrderID) REFERENCES orders(orderID),
CONSTRAINT dineIn_fk2 FOREIGN KEY (diTableNum) REFERENCES tables(tableNum)
);

CREATE TABLE menuItem(
  menuItemID INT NOT NULL,
  menuName   VARCHAR(40),
  muCategory VARCHAR(20),
  muSpice    VARCHAR(20),
  muMeat     VARCHAR(20),
CONSTRAINT menuItem_pk  PRIMARY KEY(menuItemID),
CONSTRAINT menuItem_fk1 FOREIGN KEY(muCategory) REFERENCES categoryType(categoryType),
CONSTRAINT menuItem_fk2 FOREIGN KEY(muSpice) REFERENCES spiceType(spiceType),
CONSTRAINT menuItem_fk3 FOREIGN KEY(muMeat) REFERENCES meatType(meatType)
);

CREATE TABLE menu(
    menuID    INT NOT NULL,
    menuType  VARCHAR(20),
CONSTRAINT menu_pk PRIMARY KEY(menuID)
);

CREATE TABLE menuMUI_Junction(
    jMenuID     INT NOT NULL,
    jMenuItemID INT NOT NULL,
    price       DOUBLE,
    jSize       VARCHAR(20),
CONSTRAINT menuMUI_pk  PRIMARY KEY(jMenuID, jMenuItemID),
CONSTRAINT menuMUI_fk1 FOREIGN KEY(jMenuID) REFERENCES menu(menuID),
CONSTRAINT menuMUI_fk2 FOREIGN KEY(jMenuItemID) REFERENCES menuItem(menuItemID),
CONSTRAINT menuMUI_fk3 FOREIGN KEY(jSize) REFERENCES sizeType(sizeType)
);

CREATE TABLE orderSum(
	osOrderID      INT NOT NULL,
	osMenuID       INT NOT NULL,
	osMenuItemID   INT NOT NULL,
CONSTRAINT orderSum_pk  PRIMARY KEY(osOrderID, osMenuID, osMenuItemID),
CONSTRAINT orderSum_fk1 FOREIGN KEY(osOrderID) REFERENCES orders(orderID),
CONSTRAINT orderSum_fk2 FOREIGN KEY(osMenuID, osMenuItemID) REFERENCES menuMUI_Junction(jMenuID, jMenuItemID)
);


CREATE TABLE chef(
    cEmployeeID INT NOT NULL,
    experience  INT,
CONSTRAINT chef_pk  PRIMARY KEY (cEmployeeID),
CONSTRAINT chef_fk1 FOREIGN KEY (cEmployeeID) REFERENCES employee(employeeID)
);

CREATE TABLE headChef(
  hcEmployeeID INT NOT NULL,
CONSTRAINT headchef_pk PRIMARY KEY (hcEmployeeID),
CONSTRAINT headchef_fk FOREIGN KEY (hcEmployeeID) REFERENCES chef(cEmployeeID)
);

CREATE TABLE menuItemHeadChef_Junction(
  mihcMenuItemID  INT NOT NULL,
  mihcEmployeeID  INT NOT NULL,
CONSTRAINT mihc_pk  PRIMARY KEY (mihcMenuItemID,mihcEmployeeID),
CONSTRAINT mihc_fk1 FOREIGN KEY (mihcMenuItemID) REFERENCES menuItem(menuItemID),
CONSTRAINT mihc_fk2 FOREIGN KEY (mihcEmployeeID) REFERENCES headChef(hcEmployeeID)
);

CREATE TABLE lineCook(
    lcEmployeeID INT NOT NULL,
CONSTRAINT lnEmployee_pk  PRIMARY KEY(lcEmployeeID),
CONSTRAINT lnEmployee_fk1 FOREIGN KEY(lcEmployeeID) REFERENCES chef(cEmployeeID)
);

CREATE TABLE station(
	stationNum    INT NOT NULL,
CONSTRAINT station_pk PRIMARY KEY (stationNum)
);

CREATE TABLE lineCookStation_Junction(
	lcsEmployeeID INT NOT NULL,
	lcsStation INT NOT NULL,
CONSTRAINT lcsJunction_pk  PRIMARY KEY (lcsEmployeeID, lcsStation),
CONSTRAINT lcsJunction_fk1 FOREIGN KEY(lcsEmployeeID) REFERENCES lineCook(lcEmployeeID),
CONSTRAINT lcsJunction_fk2 FOREIGN KEY(lcsStation) REFERENCES station(stationNum)
);

CREATE TABLE sousChef(
    scEmployeeID    INT NOT NULL,
    menuExp         INT,
CONSTRAINT scEmployee_pk  PRIMARY KEY(scEmployeeID),
CONSTRAINT scEmployee_fk1 FOREIGN KEY(scEmployeeID) REFERENCES chef(cEmployeeID)
);

CREATE TABLE mentorShip(
	  scmEmployeeID INT NOT NULL,
    mentorshipID  INT NOT NULL,
    msMenuItemID  INT NOT NULL,
    startDate     DATE,
    endDate       DATE,
CONSTRAINT mentorShip_pk1 PRIMARY KEY(scmEmployeeID, mentorshipID),
CONSTRAINT mentorShip_fk1 FOREIGN KEY(scmEmployeeID) REFERENCES sousChef(scEmployeeID),
CONSTRAINT mentorShip_fk2 FOREIGN KEY(mentorshipID) REFERENCES sousChef(scEmployeeID),
CONSTRAINT mentorShip_fk3 FOREIGN KEY(msMenuItemID) REFERENCES menuItem(menuItemID)
);

CREATE TABLE dishwasher(
    dwEmployeeID INT NOT NULL,
    sinkStation  INT,
CONSTRAINT dishwasher_pk  PRIMARY KEY (dwEmployeeID),
CONSTRAINT dishwasher_fk1 FOREIGN KEY (dwEmployeeID) REFERENCES employee(employeeID)
);

CREATE TABLE sorter(
    sEmployeeID INT NOT NULL,
CONSTRAINT sorter_pk  PRIMARY KEY (sEmployeeID),
CONSTRAINT sorter_fk1 FOREIGN KEY (sEmployeeID) REFERENCES dishwasher(dwEmployeeID)
);

CREATE TABLE washer(
    wEmployeeID INT NOT NULL,
CONSTRAINT washer_pk  PRIMARY KEY (wEmployeeID),
CONSTRAINT washer_fk1 FOREIGN KEY (wEmployeeID) REFERENCES dishwasher(dwEmployeeID)
);

CREATE TABLE maitred(
    mEmployeeID INT NOT NULL,
CONSTRAINT maitred_pk  PRIMARY KEY (mEmployeeID),
CONSTRAINT maitred_fk1 FOREIGN KEY (mEmployeeID) REFERENCES employee(employeeID)
);

CREATE TABLE rates(
    rEmployeeID INT NOT NULL,
    rateType    VARCHAR(20),
    rateIncome  DOUBLE,
CONSTRAINT rates_pk PRIMARY KEY (rEmployeeID),
CONSTRAINT rates_fk FOREIGN KEY (rEmployeeID) REFERENCES employee(employeeID)
);

CREATE TABLE payment(
  pCustomerID INT NOT NULL,
  pOrderID    INT NOT NULL,
  pMenuID     INT NOT NULL,
  pMenuItemID INT NOT NULL,
  paymentType VARCHAR(20),
  priceSum    DOUBLE,
CONSTRAINT payment_pk  PRIMARY KEY (pCustomerID,pOrderID,pMenuID,pMenuItemID),
CONSTRAINT payment_fk1 FOREIGN KEY (pCustomerID) REFERENCES customer(customerID),
CONSTRAINT payment_fk2 FOREIGN KEY (pOrderID,pMenuID,pMenuItemID) REFERENCES orderSum(osOrderID,osMenuID,osMenuItemID)
);

CREATE TABLE creditCard(
    ccCustomerID     INT NOT NULL,
    ccOrderID        INT NOT NULL,
    ccMenuID         INT NOT NULL,
    ccMenuItemID     INT NOT NULL,
    feeTotal         DOUBLE,
CONSTRAINT creditCard_PK  PRIMARY KEY(ccCustomerID,ccOrderID,ccMenuID,ccMenuItemID),
CONSTRAINT creditCard_fk1 FOREIGN KEY(ccCustomerID,ccOrderID,ccMenuID,ccMenuItemID)REFERENCES payment(pCustomerID, pOrderID, pMenuID, pMenuItemID)
);


--benefitType
INSERT INTO benefitType(benefitType, benefitDes) VALUES
('Full', '401k, Full Medical Coverage, Extended Vacation'),
('Standard', 'Medical and Dental insurance, 2 week Vacation'),
('Disability', 'Full Medical Coverage, Handicap Parking'),
('Starter', 'Medical and Dental Coverage');

--employee
INSERT INTO employee(employeeID, fName, lName, DOB, benefitType, shift, managerID) VALUES
(001, 'Ken', 'Stebbing', '1996-07-23', 'Full', 'Morning', NULL),
(002, 'Moses', 'Won', '1998-02-06', 'Full', 'Evening', NULL),
(003, 'Celeste', 'Robles', '1997-05-11', 'Standard', 'Evening', 001),
(004, 'Alex', 'Ramirez', '1995-10-09', 'Standard', 'Morning', 002),
(005, 'Frank', 'Reynolds', '1980-04-15', 'Standard', 'Evening', 001),
(006, 'Jeffrey', 'Williams', '1996-05-18', 'Standard', 'Evening', 001),
(007, 'Kevyn', 'Esparza', '1980-08-01', 'Standard', 'Morning', 002),
(008, 'Joe', 'Montana', '1985-10-18', 'Standard', 'Morning', 002),
(009, 'Alice', 'Sanders', '1992-12-05', 'Standard', 'Evening', 001),
(010, 'Mary', 'Frances', '1990-11-25', 'Standard', 'Morning', 002),
(011, 'Leslie', 'Herrera', '1986-01-19', 'Disability', 'Evening', 001),
(012, 'Joshua', 'Lopez', '1983-06-04', 'Standard', 'Morning', 002),
(013, 'Frank', 'Nguyen ', '1989-09-22', 'Standard', 'Evening', 001),
(014, 'Shawn', 'Tung', '1994-03-24', 'Standard', 'Evening', 001),
(015, 'Aaron', 'Rodgers', '1994-04-16', 'Standard', 'Morning', 002),
(016, 'Jamie', 'Johnson', '1984-12-08', 'Starter', 'Evening', 001),
(017, 'Jaime', 'Felix', '1984-01-01', 'Standard', 'Morning', 002),
(018, 'Charlie', 'Kelly', '1999-02-28', 'Starter', 'Morning', 002),
(019, 'Anthony', 'Lim', '1993-05-13', 'Standard', 'Evening', 001),
(020, 'Maria', 'Lu', '1997-07-04', 'Standard', 'Evening', 001),
(021, 'Julia', 'Tran', '1963-02-14', 'Standard', 'Evening', 001),
(022, 'Amy', 'Wang', '2000-01-27', 'Starter', 'Morning', 002),
(023, 'Ruben', 'Morales', '1991-10-27', 'Standard', 'Morning', 002),
(024, 'John', 'Soon', '1992-05-11', 'Standard', 'Evening', 001),
(025, 'Kylie', 'Salas', '1988-06-03', 'Standard', 'Morning', 002),
(026, 'Edwin', 'Gonzalez', '1987-09-19', 'Standard', 'Evening', 001),
(027, 'Erick', 'Smith', '1982-11-04', 'Starter', 'Morning', 002),
(028, 'Hugo', 'Simpson', '1981-05-15', 'Starter', 'Evening', 001),
(029, 'Lorena', 'Herrera', '1996-06-13', 'Starter', 'Evening', 001),
(030, 'Patty', 'Prieta', '1993-08-18', 'Disability', 'Morning', 002),
(031, 'Stacy', 'Kim', '1998-11-28', 'Starter', 'Evening', 001),
(032, 'Leah', 'Huang', '1976-09-17', 'Standard', 'Evening', 001),
(033, 'Billy', 'Lee', '1979-04-04', 'Standard', 'Evening', 001),
(034, 'Alfonso', 'Curiel', '1960-06-10', 'Disability', 'Morning', 002),
(035, 'Nathon', 'Zagal', '1998-02-06', 'Standard', 'Evening', 001),
(036, 'Emily', 'Rodgers', '1998-03-16', 'Standard', 'Morning', 002),
(037, 'Jerry', 'Kramer', '1998-10-03', 'Standard', 'Evening', 001),
(038, 'George', 'Bennes', '1998-09-09', 'Starter', 'Evening', 001),
(039, 'Cosmo', 'Seinfeld', '1998-07-17', 'Standard', 'Evening', 001),
(040, 'Elaine', 'Costanza', '1996-06-07', 'Standard', 'Morning', 002),
(041, 'Hal', 'White', '1992-04-01', 'Standard', 'Evening', 001),
(042, 'Louis', 'Wickerman', '1994-02-03', 'Disability', 'Evening', 001),
(043, 'Malcolm', 'Middleman', '1995-02-11', 'Standard', 'Morning', 002),
(044, 'Reese','Spoon', '1998-11-11', 'Standard', 'Evening', 001),
(045, 'Frances', 'Park', '1989-05-16', 'Starter', 'Morning', 002),
(046, 'Avery', 'Song', '1985-01-08', 'Standard', 'Evening', 001),
(047, 'Dennis', 'Weston', '1993-04-17', 'Disability', 'Evening', 001),
(048, 'Dennis', 'Marquez', '2000-05-21', 'Starter', 'Morning', 002),
(049, 'Deandra', 'Zimmerman', '2001-03-26', 'Starter', 'Evening', 001),
(050, 'Mac', 'Donald', '2000-10-03', 'Starter', 'Morning', 002),
(051, 'Luis', 'Mendoza', '1990-07-22', 'Standard', 'Evening', 002),
(052, 'Irvin', 'Flores', '1992-04-16', 'Standard', 'Morning', 001),
(053, 'Jaemin', 'Kim', '1994-09-05', 'Starter', 'Evening', 002),
(054, 'Saul', 'Mendoza', '1990-08-26', 'Standard', 'Evening', 002),
(055, 'Ken', 'Knight', '1990-11-11', 'Standard', 'Morning', 001),
(056, 'Rick', 'Cobian', '1998-10-02', 'Starter', 'Morning', 002),
(057, 'Jamie', 'Jonchoi', '1990-12-04', 'Standard', 'Evening', 002),
(058, 'Oliver', 'Pena', '1999-02-18', 'Starter', 'Evening', 001),
(059, 'Sharon', 'Ahn', '1990-10-17', 'Standard', 'Morning', 002),
(060, 'Amy', 'Yu', '1992-05-04', 'Standard', 'Evening', 001);

--customers
INSERT INTO customer (customerID, guestNum) VALUES
(200, 2),
(201, 14),
(202, 4),
(203, 5),
(204, 2),
(205, 5),
(206, 6),
(207, 4),
(208, 1),
(209, 3),
(210, 4),
(211, 7),
(212, 2),
(213, 9),
(214, 2),
(215, 7),
(216, 1),
(217, 3),
(218, 8),
(219, 4),
(220, 1),
(221, 3),
(222, 4),
(223, 3),
(224, 20),
(225, 5),
(226, 5),
(227, 2),
(228, 10),
(229, 12),
(230, 4),
(231, 1),
(232, 5),
(233, 9),
(234, 3),
(235, 4),
(236, 13),
(237, 2),
(238, 4),
(239, 5),
(240, 9),
(241, 6),
(242, 22),
(243, 4),
(244, 3),
(245, 4),
(246, 4),
(247, 5),
(248, 1),
(249, 2),
(250, 6),
(251, 2),
(252, 4),
(253, 5),
(254,1),
(255,5);
--zipcode
INSERT INTO zipcode (zip, city, zState) VALUES
('90831', 'Long Beach', 'CA'),
('90813', 'Long Beach', 'CA'),
('90755', 'Signal Hill', 'CA'),
('90815', 'Los Altos', 'CA'),
('90713', 'Lakewood', 'CA'),
('90703', 'Cerritos', 'CA'),
('90505','Torrance','CA'),
('10278', 'New York', 'NY'),
('90024', 'Westwood', 'CA'),
('90028','Hollywood', 'CA'),
('90029', 'Griffith Park', 'CA'),
('90044', 'Athens', 'CA'),
('90048', 'West Beverly','CA'),
('90057', 'Westlake', 'CA'),
('90075', 'Los Angeles', 'CA'),
('90213', 'Beverly Hills', 'CA'),
('90224', 'Compton', 'CA'),
('90239', 'Downey', 'CA'),
('90248', 'Gardena', 'CA'),
('90251', 'Hawthrone', 'CA'),
('90254', 'Hermosa Beach', 'CA'),
('90260', 'Lawndale', 'CA'),
('90264', 'Malibu', 'CA'),
('90307', 'Inglewood', 'CA'),
('90401', 'Santa Monica', 'CA'),
('90604', 'Whittier', 'CA'),
('90630', 'Cypress', 'CA'),
('90637', 'La Mirada', 'CA'),
('90652', 'Norwalk', 'CA'),
('90702', 'Artesia','CA'),
('90707','Bellflower', 'CA'),
('90734', 'San Pedro', 'CA'),
('90749', 'Carson', 'CA'),
('91006', 'Arcadia', 'CA'),
('91104', 'Pasadena', 'CA');

--regCustomers
INSERT INTO regCustomers (rCustomerID, fname, lname, dateJoined, mimiBalance, emailAddress, snailAddress, zipCode) VALUES
(200, 'Sharlene', 'Dunne', '2019-09-02', 20.23, 'sharleneDunne123@gmail.com', '3433 Hydro Lane','90831'),
(201, 'James', 'Smith', '2019-01-31', 2.73, 'smithjames31@gmail.com', '1090 Pine Cone ','90831'),
(202, 'Zhang', 'Wei', '2019-02-22', 150.01, 'WeiZhangZhang@gmail.com', '2030 Calle Mayor Street','90505'),
(203, 'Michael', 'Garza', '2019-05-13', 77.77, 'garzatheGreatyay@gmail.com', '943 Martin Street','90713'),
(204, 'Angie', 'Doo', '2019-06-24', 54.45, 'doodooangiedoodoo@gmail.com', '818 Fourth Lane','90815'),
(205, 'Amy', 'Le', '2017-01-01', 10.00, 'leamy321@hotmail.com', '12 Candy Cane Lane', '90505'),
(206, 'Esther', 'Morty', '2018-03-20', 99.03, 'mortyrmorty00@aol.com', '43 Power Str', '91104'),
(207, 'John', 'Luu', '2017-07-30', 32.00,'littleluu98@gmail.com', '1293 Martin Luther Street', '90734'),
(208, 'Kimberly', 'Berlick', '2018-11-11', 301.19, 'kimfrombeverly@gmail.com', '43 Rich Lane','90213'),
(209, 'Ashley', 'Munz', '2017-01-31', 25.00, 'ashleymunz232@naver.com', '2232 Wang Street', '91006'),
(210, 'Jessica', 'Alba', '2017-02-02', 129.84, 'jessicaalba@mail.com', '902 InTune Bvd', '90637'),
(211, 'Louis', 'Martinez', '2019-07-29', 120.22, 'louismartiz1025@gmail.com', '213 Hello World','90713'),
(212, 'Gary', 'Vee','2017-02-17', 48.09, 'garyvee@work1.com', '342 Entrepe Street', '90251'),
(213, 'Justin', 'Escalona', '2017-03-21', 82.39, 'escalano.business@inquries.com', '1211 Hollywood Street', '90048'),
(214, 'Dallas', 'Green', '2018-08-24', 242.22, 'dayoldhate@gmail.com', '435 Uni drive','90703'),
(215, 'Jennifer', 'Stitson', '2017-04-10', 0.33, 'stitsonjen@yahoo.com', '1234 Stitson Drive', '90307'),
(216, 'Ben', 'Simmons', '2017-04-22', 36.10, 'bigbenkid@yahoo.com', '839 Union Street','90264'),
(217, 'Joel', 'Embiid', '2017-05-05', 129.28, 'joelembiddd@sixers.com', '849 Power Down Ave','90307'),
(218, 'Tobias', 'Harris', '2017-05-12', 95.60, 'tobiasharris@aol.com', '2302 Anza Ave','90048'),
(219, 'Danny', 'Green', '2017-05-19', 1.24, 'greendanny12@yahoo.com', '9103 Apple Street','90307'),
(220, 'Al', 'Holford', '2017-05-29', 53.18, 'holfordthegreat@gmail.com', '3842 Android Lane','90248'),
(221, 'CJ', 'McCollum', '2017-06-07', 4.83, 'mccollumsmail@gmail.com', '950 DaBaby Blvd','90251'),
(222, 'Russell', 'Westbrook', '2017-06-30', 16.64, 'westbrookbeastbrook@yahoo.com', '423 Axelrod Road','10278'),
(223, 'James', 'Harden', '2017-07-04', 479.13, 'hardenstepback@nba.com', '58212 Desiree Ave','90307'),
(224, 'Javale', 'McGee', '2017-07-17', 48.20, 'mcgeejavale00@blockallday.com', '4319 Highway Road','90734'),
(225, 'Kyle', 'Kuzma', '2017-07-30', 72.02, 'kylekuzma0@isuckrn.com', '912 Picing Street','91006'),
(226, 'Ja', 'Morant', '2017-08-04', 6.78, 'jamorantrook99@rookieoftheyear.com', '1294 Customer rd','91104'),
(227, 'Zion', 'Williamson', '2017-08-04', 11.11, 'zioninjuredwilliamson@gaol.com', '5593 World Hello','90749'),
(228, 'Kyle', 'Lowry', '2017-08-04', 59.01, 'kyleraplowry74@raptors.com', '5840 Google','90734'),
(229, 'Pascal', 'Siakam', '2017-08-11', 57.57, 'pascalsiakam57@mip.com', '782 Microsoft','90707'),
(230, 'Marvin', 'Bagley', '2017-08-25', 924.18, 'bagleymarvin003@gmail.com', '294 Bing','90702'),
(231, 'Jessica', 'Shin', '2017-09-21', 40.11, 'jessicashin012@gmail.com', '129 Hersheys ','90652'),
(232, 'Emma', 'Sooner', '2017-09-30', 85.46, 'soonerthanlater@emma.com', '954 Shabu Lane','90637'),
(233, 'Kylie', 'Takashi', '2017-10-10', 43.26, 'taksashikylie131@aol.com', '793 InNOut Street','90630'),
(234, 'Kimberly', 'Kim', '2017-11-25', 5.79, 'kimberlykim@kims.com', '853012 Chop Suevy','90604'),
(235, 'Gloria', 'Jackson', '2017-11-26', 18.53, 'jackgloria@sons.com', '2332 Jackson Ave','90401'),
(236, 'Paige', 'Mongie', '2017-12-01', 92.54, 'paigemongie12@matsumoto.com', '1243 Furniture Land','90307'),
(237, 'Samantha', 'Samson', '2017-12-05', 66.62, 'ssss22124@yahoo.com', '431 Chocolate Ave','90264'),
(238, 'Willy', 'Wonka', '2017-12-12', 50.32, 'charliefactory@willywonka.com', '124 Licorice Street','90260'),
(239, 'Meghan', 'Topple', '2017-12-27', 37.98, 'topplemeghan124@cal.com', '1090 Ascii Code','90254'),
(240, 'Grace', 'Hazle', '2017-12-30', 73.52, 'hazzlegrace@aol.com', '1090 Level Ish','90251'),
(241, 'Kawhi', 'Legend', '2018-01-26', 1000.00, 'kawhilegend@clippers.com', '149 Lakers Ave','90028'),
(242, 'Paul', 'George', '2018-02-01',56.87, 'pg13@clippers.com', '382 Bucks Land','90029'),
(243, 'Lou', 'William', '2018-03-20', 51.08, 'louwilliam@google.com', '674 Pacers Street','90044'),
(244, 'Montrel', 'Harrel', '2018-04-20', 19.91, 'harrelmontrel224@yahoo.com', '37811 Heats Blvd','90048'),
(245, 'Chris', 'Paul', '2018-05-21', 4.04, 'chrispaul@okc.com', '492 Blazers Street','90057'),
(246, 'Paul', 'Walker', '2018-06-09', 3.67, 'paulwalker52d@seeyouagain.com', '823 Magic Land','90075'),
(247, 'Angela', 'Jackie', '2017-07-04', 200.20, 'angelajackiejackie@jackson.com', '432 Nuggets Street','90213'),
(248, 'Brandon', 'Tran', '2017-08-01', 5.21, 'brandontran96@gmail.com', '234 Kings Ave','90224'),
(249, 'Victor', 'Oladip', '2017-09-04', 49.10, 'vicoladip@pacers.com', '569 Raptors Street','90239'),
(250, 'Lamar', 'Beckham', '2017-11-11', 75.23, 'beckhamlamar@ravens.com', '14920 Sixers','90248'),
(251, 'Tom', 'Brady', '2018-04-18',553.23, 'tombradygoat23@patriots.com', '532 Goat Street', '90024'),
(252, 'King', 'James', '2019-11-30', 184.64,'kingjamesinqueries@lakers.com', '524 Living Legend Ave', '90028'),
(253, 'Dwight', 'Howard','2019-04-24', 384.51,'howarddwight@beachpoint.com', '2042 Hedging Lane', '90831'),
(254, 'Jacob', 'John', '2019-12-02', 400.00, 'garzad123@gmail.com', '3333 dedro Lane','90831'),
(255, 'James', 'Smith', '2019-01-21', 2.69, 'garzaj31@gmail.com', '1496 Pone Cine ','90028');

--private customers
INSERT INTO privCustomer(pCustomerID) VALUES
(200),
(202),
(203),
(204),
(205),
(206),
(207),
(208),
(209),
(210),
(212),
(214),
(216),
(217),
(219),
(220),
(221),
(222),
(223),
(225),
(226),
(227),
(230),
(231),
(232),
(234),
(235),
(237),
(238),
(239),
(241),
(243),
(244),
(245),
(246),
(247),
(248),
(249),
(250),
(251),
(252),
(253),
(254),
(255);
--corporation
INSERT INTO corporation (cpCustomerID, orgName, corpName, phone) VALUES
(201, 'Sales','Beach Point', '310-801-8430'),
(211, 'HR','Harbor Regional','310-920-6772'),
(213, 'Marketing', 'VaynerMedia', '310-413-1293'),
(215, 'IT', 'Beach Point', '310-801-8412'),
(218, 'IT', 'WeWorks', '562-144-1093'),
(224, 'Operations', 'Uber', '481-489-1294'),
(229, 'Finance', 'Plantonia', '394-492-3810'),
(233, 'Sales','Goldman Sachs', '519-591-4582'),
(236, 'Sales', 'Chase Corporation', '310-904-3911'),
(240, 'Marketing','SDMedia', '213-481-4911'),
(242, 'HR', 'LA Fit','626-489-9431'),
(248,'Sales', 'LA Fit','626-382-9431'),
(249,'Operations', 'WeWorks','310-382-3802'),
(250,'Sales', 'LA Fit','562-804-4802'),
(251,'Finance', 'Beach Point','424-902-1032'),
(252,'Operations', 'Harbor Regional','310-562-1009'),
(253,'IT', 'Platonia','363-109-3890'),
(254, 'Finance','Peach Boint', '311-801-8430'),
(255, 'Marketing','Rarbor Hegional','312-920-6772');


--categoryType
INSERT INTO categoryType(categoryType) VALUES
('Appetizers'),
('Soup'),
('Meat Entree'),
('Chow Mein'),
('Egg Foo Young'),
('Chop Suey');

--spiceType
INSERT INTO spiceType(spiceType) VALUES
('Mild'),
('Tangy'),
('Piquant'),
('Hot'),
('Oh My God');

--meatType
INSERT INTO meatType(meatType) VALUES
('Chef Special'),
('Pork'),
('Chicken'),
('Beef'),
('Seafood'),
('Vegetable');


--menu item
INSERT INTO menuItem(menuItemID, menuName, muCategory, muSpice, muMeat) VALUES
(400,'Egg Flower Soup', 'Soup', 'Mild', 'Chicken'),
(401,'Hot & Sour Soup', 'Soup', 'Hot', 'Vegetable'),
(402,'Wonton Soup', 'Soup', 'Tangy', 'Vegetable'),
(403,'Pork Noddle Soup', 'Soup', 'Piquant', 'Pork'),
(404,'Beef Noodle Soup', 'Soup', 'Tangy', 'Beef'),
(405,'Orange Chicken', 'Meat Entree', 'Tangy', 'Chicken'),
(406,'Chicken with Nuts', 'Meat Entree', 'Tangy', 'Chicken'),
(407,'Moo Goo Gai Pan', 'Meat Entree', 'Hot', 'Chicken'),
(408,'Szechwan Chicken', 'Meat Entree', 'Oh My God', 'Chicken'),
(409,'Sesame Chicken', 'Meat Entree', 'Piquant', 'Chicken'),
(410,'Sweet & Sour Chicken', 'Meat Entree', 'Mild', 'Chicken'),
(411,'Lemon Chicken', 'Meat Entree', 'Mild', 'Chicken'),
(412,'Teriyaki Chicken', 'Meat Entree', 'Mild', 'Chicken'),
(413,'Beef with Broccoli', 'Meat Entree', 'Tangy', 'Beef'),
(414,'Szechwan Beef', 'Meat Entree', 'Oh My God', 'Beef'),
(415,'Mongolian Beef', 'Meat Entree', 'Hot', 'Beef'),
(416,'Beef with Garlic Sauce', 'Meat Entree', 'Mild', 'Beef'),
(417,'Black Pepper Beef', 'Meat Entree', 'Tangy', 'Beef'),
(418,'Kung Pao Beef', 'Meat Entree', 'Tangy', 'Beef'),
(419,'Thai Beef', 'Meat Entree', 'Hot', 'Beef'),
(420,'Sweet & Sour Pork', 'Meat Entree', 'Mild', 'Pork'),
(421,'Pork with Vegetables', 'Meat Entree', 'Mild', 'Pork'),
(422,'Yu Sing Shredded Pork', 'Meat Entree', 'Tangy', 'Pork'),
(423,'Twice Cooked Porked', 'Meat Entree', 'Mild', 'Pork'),
(424,'Assorted Vegetables', 'Meat Entree', 'Tangy', 'Vegetable'),
(425,'Broccoli with Garlic Sauce', 'Meat Entree', 'Mild', 'Vegetable'),
(426,'Kung Pao Vegetable', 'Meat Entree', 'Piquant', 'Vegetable'),
(427,'Tofu with Vegetables', 'Meat Entree', 'Mild', 'Vegetable'),
(428,'Egg Plant in Hot Garlic Sauce', 'Meat Entree', 'Hot', 'Vegetable'),
(429,'Cashew Nut Shrimp', 'Meat Entree', 'Mild', 'Seafood'),
(430,'Kung Pao Shrimp', 'Meat Entree', 'Hot', 'Seafood'),
(431,'Sweet & Sour Shrimp', 'Meat Entree', 'Mild', 'Seafood'),
(432,'Snow Hill Shrimp', 'Meat Entree', 'Mild', 'Seafood'),
(433,'Fish Fillet with Vegetables', 'Meat Entree', 'Mild', 'Seafood'),
(434,'Fish Fillet with Sweet& Sour Sauce', 'Meat Entree', 'Mild', 'Seafood'),
(435,'Fish Fillet with Black Bean Sauce', 'Meat Entree', 'Oh My God', 'Seafood'),
(436,'Chicken Egg Fu Young', 'Egg Foo Young', 'Mild', 'Chicken'),
(437,'Beef Egg Fu Young', 'Egg Foo Young', 'Tangy', 'Beef'),
(438,'Hot Garlic Egg Fu Young', 'Egg Foo Young', 'Piquant', 'Vegetable'),
(439,'Spicy Pork Egg Fu Young', 'Egg Foo Young', 'Oh My God', 'Pork'),
(440,'Chow Mein', 'Chow Mein', 'Mild', 'Chicken'),
(441,'Szechwan Pork Chow Mein', 'Chow Mein', 'Oh My God', 'Pork'),
(442,'Beef Chow Mein', 'Chow Mein', 'Mild', 'Beef'),
(443,'Peper Chicken Chow Mein', 'Chow Mein', 'Piquant', 'Chicken'),
(444,'Chow Mein', 'Chow Mein', 'Tangy', 'Vegetable'),
(445,'Chop Suey', 'Chop Suey', 'Mild', 'Pork'),
(446,'Hot Garlic Beef Chop Suey', 'Chop Suey', 'Oh My God', 'Beef'),
(447,'Pepper Shrimp Chop Suey', 'Chop Suey', 'Piquant', 'Seafood'),
(448,'Lemon Chicken Chop Suey', 'Chop Suey', 'Mild', 'Chicken'),
(449,'Eggplant Chop Suey', 'Chop Suey', 'Piquant', 'Vegetable'),
(450,'Chefs Special', 'Meat Entree', 'Hot', 'Chef Special'),
(451,'Chinese Pancake', 'Meat Entree', 'Piquant', 'Chef Special'),
(452,'Dumplings', 'Meat Entree', 'Mild', 'Chef Special'),
(453,'Fried Rice','Meat Entree', 'Mild', 'Chef Special'),
(454,'Tacos con Aros', 'Meat Entree', 'Hot', 'Chef Special'),
(455,'"Real" Lobster', 'Meat Entree', 'Piquant', 'Chef Special');

--Menu
INSERT INTO menu(menuID, menuType) VALUES
(501, 'Evening'),
(502, 'Lunch'),
(503, 'Sunday Brunch Buffet'),
(504, 'Children');

--Rates
INSERT INTO rates(rEmployeeID, rateType, rateIncome) VALUES
(001, 'Salary', 56320.67),
(002, 'Salary', 54789.33),
(003, 'Hourly', 18.50),
(004, 'Hourly', 19.35),
(005, 'Hourly', 17.89),
(006, 'Hourly', 17.50),
(007, 'Hourly', 18.50),
(008, 'Hourly', 19.50),
(009, 'Hourly', 19.15),
(010, 'Hourly', 18.50),
(011, 'Hourly', 16.50),
(012, 'Hourly', 18.50),
(013, 'Hourly', 19.75),
(014, 'Hourly', 18.50),
(015, 'Hourly', 18.50),
(016, 'Hourly', 13.75),
(017, 'Hourly', 18.50),
(018, 'Hourly', 12.88),
(019, 'Hourly', 19.50),
(020, 'Hourly', 17.89),
(021, 'Hourly', 18.50),
(022, 'Hourly', 12.80),
(023, 'Hourly', 20.50),
(024, 'Hourly', 18.50),
(025, 'Hourly', 18.50),
(026, 'Hourly', 18.50),
(027, 'Hourly', 13.65),
(028, 'Hourly', 14.00),
(029, 'Hourly', 13.15),
(030, 'Hourly', 18.50),
(031, 'Hourly', 13.25),
(032, 'Hourly', 18.35),
(033, 'Hourly', 18.50),
(034, 'Hourly', 19.55),
(035, 'Hourly', 18.50),
(036, 'Hourly', 21.50),
(037, 'Hourly', 18.50),
(038, 'Hourly', 12.66),
(039, 'Hourly', 18.50),
(040, 'Hourly', 18.50),
(041, 'Hourly', 18.50),
(042, 'Hourly', 20.50),
(043, 'Hourly', 21.29),
(044, 'Hourly', 18.50),
(045, 'Hourly', 13.75),
(046, 'Hourly', 19.15),
(047, 'Hourly', 18.00),
(048, 'Hourly', 12.90),
(049, 'Hourly', 13.80),
(050, 'Hourly', 16.45),
(051, 'Hourly', 17.75),
(052, 'Hourly', 22.84),
(053, 'Hourly', 21.10),
(054, 'Hourly', 19.62),
(055, 'Hourly', 18.73),
(056, 'Hourly', 17.71),
(057, 'Hourly', 18.65),
(058, 'Hourly', 20.96),
(059, 'Hourly', 19.24),
(060, 'Hourly', 17.64);

INSERT INTO sizeType(sizeType)VALUES
('Small'),
('Large');

INSERT INTO menuMUI_Junction(jMenuID, jMenuItemID, price, jSize)VALUES
--Evening
(501,400, 5.99,'Small'),
(501,401, 4.99,'Small'),
(501,402, 6.99,'Small'),
(501,403, 8.99,'Small'),
(501,404, 8.99,'Small'),
(501,405, 11.99,'Large'),
(501,406, 10.99,'Large'),
(501,407, 13.99,'Large'),
(501,408, 12.99,'Large'),
(501,409, 10.99,'Large'),
(501,410, 11.99,'Large'),
(501,411, 12.99,'Large'),
(501,412, 12.99,'Large'),
(501,413, 9.99,'Large'),
(501,414, 10.99,'Large'),
(501,415, 13.99,'Large'),
(501,416, 11.99,'Large'),
(501,417, 10.99,'Large'),
(501,418, 13.99,'Large'),
(501,419, 5.99,'Large'),
(501,420, 5.99,'Large'),
(501,421, 5.99,'Large'),
(501,422, 5.99,'Large'),
(501,423, 5.99,'Large'),
(501,424, 5.99,'Large'),
(501,425, 5.99,'Large'),
(501,426, 5.99,'Large'),
(501,427, 5.99,'Large'),
(501,428, 5.99,'Large'),
(501,429, 5.99,'Large'),
(501,430, 5.99,'Large'),
(501,431, 5.99,'Large'),
(501,432, 5.99,'Large'),
(501,433, 5.99,'Large'),
(501,434, 5.99,'Large'),
(501,435, 5.99,'Large'),
(501,436, 5.99,'Large'),
(501,437, 5.99,'Large'),
(501,438, 5.99,'Large'),
(501,439, 5.99,'Large'),
(501,440, 5.99,'Large'),
(501,441, 5.99,'Large'),
(501,442, 5.99,'Large'),
(501,443, 5.99,'Large'),
(501,444, 5.99,'Large'),
(501,445, 5.99,'Large'),
(501,446, 5.99,'Large'),
(501,447, 5.99,'Large'),
(501,448, 5.99,'Large'),
(501,449, 5.99,'Large'),
(501,450, 5.99,'Large'),
(501,451, 5.99,'Large'),
(501,452, 5.99,'Large'),
(501,453, 5.99,'Large'),
(501,454, 5.99,'Large'),
(501,455, 5.99,'Large'),
--Lunch
(502,400, 5.99,'Large'),
(502,401, 4.99,'Small'),
(502,402, 6.99,'Small'),
(502,403, 8.99,'Small'),
(502,404, 8.99,'Small'),
(502,405, 11.99,'Large'),
(502,406, 10.99,'Large'),
(502,407, 13.99,'Large'),
(502,408, 12.99,'Large'),
(502,409, 10.99,'Large'),
(502,410, 11.99,'Large'),
(502,411, 12.99,'Large'),
(502,412, 12.99,'Large'),
(502,413, 9.99,'Large'),
(502,414, 10.99,'Large'),
(502,415, 13.99,'Large'),
(502,416, 11.99,'Large'),
(502,417, 10.99,'Large'),
(502,418, 13.99,'Large'),
(502,419, 5.99,'Large'),
(502,420, 5.99,'Large'),
(502,421, 5.99,'Large'),
(502,422, 5.99,'Large'),
(502,423, 5.99,'Large'),
(502,424, 5.99,'Large'),
(502,425, 5.99,'Large'),
(502,426, 5.99,'Large'),
(502,427, 5.99,'Large'),
--Brunch
(503,400, 5.99,'Large'),
(503,401, 4.99,'Small'),
(503,402, 6.99,'Small'),
(503,403, 8.99,'Small'),
(503,404, 8.99,'Small'),
(503,405, 11.99,'Large'),
(503,406, 10.99,'Large'),
(503,407, 13.99,'Large'),
(503,408, 12.99,'Large'),
(503,409, 10.99,'Large'),
(503,410, 11.99,'Large'),
(503,411, 12.99,'Large'),
(503,444, 5.99,'Large'),
(503,445, 5.99,'Large'),
(503,446, 5.99,'Large'),
(503,447, 5.99,'Large'),
(503,448, 5.99,'Large'),
(503,449, 5.99,'Large'),
(503,450, 5.99,'Large'),
(503,451, 5.99,'Large'),
(503,452, 5.99,'Large'),
(503,453, 5.99,'Large'),
(503,454, 5.99,'Large'),
(503,455, 5.99,'Large'),
--Children
(504,404, 8.99,'Small'),
(504,405, 11.99,'Small'),
(504,406, 10.99,'Small'),
(504,407, 13.99,'Small'),
(504,408, 12.99,'Small'),
(504,409, 10.99,'Small'),
(504,410, 11.99,'Small'),
(504,411, 12.99,'Small'),
(504,412, 12.99,'Small'),
(504,413, 9.99,'Small'),
(504,414, 10.99,'Small'),
(504,415, 13.99,'Small'),
(504,416, 11.99,'Small');

--orders
INSERT INTO orders(orderID, oCustomerID, orderDate, orderTime) VALUES
(601,200, '2019-11-23', '09:00:00'),
(602,201, '2019-11-25', '12:15:00'),
(603,202, '2019-11-29', '17:00:00'),
(604,203, '2019-12-01', '10:00:00'),
(605,204, '2019-12-01', '19:10:00'),
(606,205, '2019-11-24', '17:00:00'),
(607,206, '2019-12-01', '17:00:00'),
(608,207, '2019-11-23', '16:05:30'),
(609,208, '2019-12-01', '17:00:00'),
(610,209, '2019-12-01', '10:00:00'),
(611,210, '2019-11-25', '17:00:00'),
(612,211, '2019-11-29', '17:00:00'),
(613,212, '2019-11-26', '10:00:00'),
(614,213, '2019-11-24', '19:10:00'),
(615,214, '2019-12-01', '17:00:00'),
(616,215, '2019-11-23', '10:00:00'),
(617,216, '2019-12-01', '12:15:00'),
(618,217, '2019-12-01', '18:30:00'),
(619,218, '2019-11-25', '17:00:00'),
(620,219, '2019-11-26', '17:00:00'),
(621,220, '2019-11-29', '10:00:00'),
(622,221, '2019-11-24', '17:00:00'),
(623,222, '2019-12-01', '17:00:00'),
(624,223, '2019-12-01', '09:30:00'),
(625,224, '2019-11-23', '09:30:00'),
(626,225, '2019-12-01', '12:15:00'),
(627,226, '2019-11-25', '19:10:00'),
(628,227, '2019-12-01', '18:30:00'),
(629,228, '2019-11-26', '10:00:00'),
(630,229, '2019-11-29', '10:00:00'),
(631,230, '2019-11-24', '18:30:00'),
(632,231, '2019-12-01', '17:00:00'),
(633,232, '2019-11-23', '17:00:00'),
(634,233, '2019-12-01', '09:30:00'),
(635,234, '2019-11-25', '12:15:00'),
(636,235, '2019-12-01', '17:00:00'),
(637,236, '2019-11-26', '10:00:00'),
(638,237, '2019-12-01', '10:00:00'),
(639,238, '2019-11-23', '10:00:00'),
(640,239, '2019-11-24', '17:00:00'),
(641,240, '2019-11-29', '18:30:00'),
(642,241, '2019-11-29', '19:10:00'),
(643,242, '2019-11-25', '12:15:00'),
(644,243, '2019-11-23', '09:30:00'),
(645,244, '2019-11-26', '09:30:00'),
(646,245, '2019-12-01', '17:00:00'),
(647,246, '2019-12-01', '09:30:00'),
(648,247, '2019-11-24', '10:00:00'),
(649,248, '2019-12-01', '10:00:00'),
(650,249, '2019-11-29', '17:00:00'),
(651,250, '2019-11-25', '17:00:00'),
(652,251, '2019-11-26', '18:30:00'),
(653,252, '2019-11-23', '12:15:00'),
(654,253, '2019-12-01', '19:10:00'),
(655,201, '2019-04-14', '18:17:00'),
(656,211, '2019-07-25', '10:18:00'),
(657,213, '2019-01-13', '13:14:00'),
(658,213, '2019-03-28', '15:13:00'),
(659,215, '2019-11-16', '16:11:00'),
(660,215, '2019-03-02', '09:14:00'),
(661,218, '2019-04-27', '11:18:00'),
(662,224, '2019-03-30', '12:13:00'),
(663,229, '2019-11-04', '18:15:00'),
(664,229, '2019-08-16', '21:17:00'),
(665,229, '2019-06-22', '17:11:00'),
(666,233, '2019-07-15', '10:17:00'),
(667,236, '2019-10-23', '13:12:00'),
(668,240, '2019-04-08', '15:17:00'),
(669,242, '2019-06-06', '19:12:00'),
(670,242, '2019-02-11', '12:26:00'),
(671,220, '2019-10-26', '19:04:00'),
(672,221, '2019-12-13', '12:23:00'),
(673,221, '2019-02-11', '17:06:00'),
(674,226, '2019-10-26', '10:24:00'),
(675,226, '2019-05-17', '11:17:00'),
(676,226, '2019-09-07', '14:15:00'),
(677,226, '2019-03-24', '16:22:00');

--web
INSERT INTO web(wOrderID)VALUES
(618),
(619),
(620),
(621),
(622),
(623),
(624),
(625),
(626),
(627),
(628),
(629),
(630),
(631),
(632),
(633),
(634),
(635),
(636),
(637),
(638),
(639),
(671),
(672),
(673),
(674),
(675),
(676),
(677);


--togo
INSERT INTO togo(tgOrderID, estPickup, finishedTime) VALUES
(601,'09:00:00', '09:15:00'),
(602,'09:20:00', '09:35:10'),
(603,'09:56:00', '10:11:00'),
(604,'11:00:00', '11:18:00'),
(605,'11:23:00', '11:40:00'),
(606,'12:15:00', '12:39:00'),
(607,'12:18:00', '12:30:00'),
(608,'12:25:00', '12:44:00'),
(609,'12:27:00', '12:40:00'),
(610,'13:00:00', '13:30:00'),
(611,'13:12:00', '13:28:00'),
(612,'13:25:00', '13:45:00'),
(613,'15:32:00', '15:47:00'),
(614,'15:40:00', '16:00:00'),
(615,'20:10:00', '20:30:00'),
(616,'20:19:00', '20:34:00'),
(617,'21:40:00', '21:55:00'),
(655,'18:23:00', '18:39:00'),
(656,'10:30:00', '10:44:00'),
(657,'13:18:00', '13:30:00'),
(658,'15:25:00', '15:44:00'),
(659,'16:12:00', '16:30:00'),
(660,'09:20:00', '09:30:00'),
(661,'11:12:00', '11:28:00'),
(662,'12:25:00', '12:45:00'),
(663,'18:32:00', '18:47:00'),
(664,'21:40:00', '21:25:00'),
(665,'17:20:00', '17:19:00'),
(666,'10:30:00', '10:25:00'),
(667,'13:40:00', '13:35:00'),
(668,'15:20:00', '15:19:00'),
(669,'19:25:00', '19:35:00'),
(670,'12:29:00', '12:43:00');

--maitred
INSERT INTO maitred(mEmployeeID) VALUES
(004),
(010),
(025),
(039),
(044),
(047);

--dish washer
INSERT INTO dishwasher(dwEmployeeID, sinkStation) VALUES
(006,2),
(036,2),
(046,2),
(038,2),
(030,2),
(029,1),
(049,1),
(011,1);

--sorter
INSERT INTO sorter(sEmployeeID) VALUES
(029),
(049),
(011);

--washer
INSERT INTO washer(wEmployeeID) VALUES
(006),
(030),
(036),
(046),
(038);

--waitingStaff
INSERT INTO waitingStaff(wsEmployeeID,tipIntakePercentage) VALUES
(007, 0.25),
(008, 0.25),
(014, 0.25),
(015, 0.25),
(019, 0.25),
(020, 0.25),
(023, 0.25),
(024, 0.25),
(026, 0.25),
(033, 0.25),
(037, 0.25),
(040, 0.25),
(043, 0.25),
(034, 0.35),
(042, 0.35),
(016, 0.15),
(022, 0.15),
(027, 0.15),
(028, 0.15),
(045, 0.15),
(048, 0.15),
(050, 0.15);

--chef
INSERT INTO chef(cEmployeeID, experience) VALUES
(001, 12.0),
(002, 12.0),
(003, 2.0),
(005, 7.25),
(009, 4.2),
(012, 1.5),
(013, 7.15),
(017, 4.75),
(018, 0.5),
(021, 7.4),
(031, 0.25),
(032, 3.5),
(035, 8.5),
(041, 4.2),
(051, 8.6),
(052, 9.6),
(053, 3.6),
(054, 2.6),
(055, 5.6),
(056, 3.6),
(057, 1.6),
(058, 7.6),
(059, 8.6),
(060, 3.6);

--line cook
INSERT INTO lineCook(lcEmployeeID) VALUES
(003),
(009),
(012),
(018),
(021),
(031),
(032),
(041);

--station
INSERT INTO station(stationNum) VALUES
(91),
(92),
(93),
(94),
(95),
(96),
(97),
(98);

--lineCookStationJunction
INSERT INTO lineCookStation_Junction(lcsEmployeeID, lcsStation) VALUES
(003,91),
(003,98),
(009,92),
(012,93),
(012,97),
(018,97),
(021,94),
(031,91),
(031,98),
(032,95),
(041,96);

--head chef
INSERT INTO headChef(hcEmployeeID) VALUES
(001),
(002);

--recipes
INSERT INTO menuItemHeadChef_Junction(mihcMenuItemID, mihcEmployeeID) VALUES
(400,002),
(401,001),
(402,001),
(403,002),
(404,002),
(405,002),
(406,002),
(407,001),
(408,001),
(409,001),
(410,001),
(411,001),
(412,002),
(413,002),
(414,002),
(415,002),
(416,002),
(417,002),
(418,001),
(419,001),
(420,001),
(421,002),
(422,001),
(423,001),
(424,001),
(425,001),
(426,002),
(427,002),
(428,002),
(429,001),
(430,001),
(431,001),
(432,002),
(433,002),
(434,001),
(435,001),
(436,002),
(437,001),
(438,001),
(439,001),
(440,001),
(441,001),
(442,002),
(443,002),
(444,002),
(445,001),
(446,001),
(447,001),
(448,001),
(449,001),
(450,001),
(451,001),
(452,002),
(453,002),
(454,001),
(455,001);

--sous chef
INSERT INTO sousChef(scEmployeeID, menuExp) VALUES
(005,3.5),
(013,5.2),
(017,3.5),
(035,6.3),--m
(051,6.9),--m
(052,8.3),--m
(053,3.0),
(054,1.3),
(055,3.8),
(056,2.1),
(057,1.4),
(058,3.2),
(059,4.7),--m
(060,1.2);

--mentorship
INSERT INTO mentorShip(scmEmployeeID, mentorshipID, msMenuItemID, startDate, endDate) VALUES
(005,035, 419,'2019-01-13', '2019-02-18'),
(013,035, 419,'2018-02-25', '2018-03-30'),
(017,035, 419,'2019-03-27', '2019-04-13'),
(035,035, 419,'2017-05-12', '2017-05-29'),
(059,035, 419,'2018-04-23', '2018-04-25'),
(060,035, 419,'2019-08-12', '2018-08-13'),

(005,051, 446,'2019-04-19', '2019-05-13'),
(013,051, 446,'2019-06-10', '2019-06-14'),
(051,051, 446,'2016-09-13', '2016-09-30'),
(053,051, 446,'2019-10-14', '2019-10-26'),
(054,051, 446,'2018-11-23', '2018-12-30'),
(058,051, 446,'2018-02-03', '2018-03-18'),
(060,051, 446,'2018-03-22', '2018-03-26'),

(005,052, 427,'2019-05-19', '2019-05-30'),
(013,052, 427,'2018-06-05', '2018-06-29'),
(017,052, 427,'2019-09-19', '2019-10-12'),
(051,052, 427,'2015-12-25', '2016-01-22'),
(052,052, 427,'2014-08-18', '2014-08-31'),
(055,052, 427,'2019-03-13', '2019-03-15'),
(056,052, 427,'2017-06-04', '2017-06-20'),
(057,052, 427,'2014-12-23', '2015-01-15'),
(060,052, 427,'2016-06-08', '2016-06-18'),

(059,059, 435,'2015-03-21', '2015-03-24'),
(005,059, 435,'2019-01-13', '2019-02-18'),
(051,059, 435,'2019-02-13', '2019-02-22'),
(053,059, 435,'2018-02-25', '2018-03-30'),
(017,059, 435,'2019-03-27', '2019-04-13'),
(013,059, 435,'2017-05-12', '2017-05-29'),
(060,059, 435,'2018-04-23', '2018-04-25');



--payment type
INSERT INTO paymentType(paymentType) VALUES
('Debit'),
('Cash'),
('Mimi Balance'),
('Credit');

--tables
INSERT INTO tables(tableNum, tEmployeeId) VALUES
(1, 007),
(2, 008),
(3, 014),
(4, 015),
(5, 019),
(6, 020),
(7, 023),
(8, 024),
(9, 026),
(10, 033),
(11, 037),
(12, 040),
(13, 043),
(14, 050),
(15, 048);


--dine in
INSERT INTO dineIn(diOrderID, guestSize, diTableNum) VALUES
(640, 3, 1),
(641, 6, 2),
(642, 4, 3),
(643, 4, 4),
(644, 7, 5),
(645, 5, 6),
(646, 3, 7),
(647, 2, 8),
(648, 12, 9),
(649, 8, 10),
(650, 7, 11),
(651, 5, 12),
(652, 1, 13),
(653, 3, 14),
(654, 5, 15);

--order sum
INSERT INTO orderSum(osOrderID, osMenuID, osMenuItemID) VALUES
(601,501,400),
(602,501,401),
(603,501,402),
(604,501,403),
(605,501,404),
(606,501,405),
(607,501,406),
(608,501,407),
(609,501,408),
(610,501,409),
(611,501,410),
(612,501,411),
(613,501,412),
(614,501,413),
(615,501,414),
(616,501,416),
(617,501,417),
(618,501,418),
(619,501,419),
(620,501,420),
(621,501,421),
(622,501,422),
(623,502,410),
(624,502,411),
(625,502,412),
(626,502,413),
(627,502,414),
(628,502,415),
(629,502,416),
(630,502,417),
(631,502,418),
(632,502,419),
(633,502,420),
(634,503,444),
(635,503,445),
(636,503,446),
(637,503,447),
(638,503,448),
(639,503,449),
(640,503,450),
(641,503,451),
(642,503,452),
(643,503,453),
(644,503,454),
(645,503,455),
(646,503,411),
(647,504,404),
(648,504,405),
(649,504,406),
(650,504,407),
(651,504,408),
(652,504,409),
(653,504,410),
(654,504,416),
(655,501,410),
(656,501,410),
(657,501,410),
(658,502,418),
(659,502,418),
(660,502,418),
(661,502,418),
(662,502,418),
(663,502,419),
(664,502,419),
(665,502,419),
(666,502,420),
(667,502,420),
(668,502,420),
(669,502,420),
(670,502,420),
(671,504,410),
(672,504,410),
(673,504,410),
(674,504,416),
(675,504,416),
(676,504,416),
(677,504,416);



--payment
INSERT INTO payment(pCustomerID, pOrderID, pMenuID, pMenuItemID, paymentType, priceSum)VALUES
(200,601,501,400,'Debit',19.39),
(201,602,501,401,'Cash',220.83),
(202,603,501,402,'Mimi Balance',19.39),
(203,604,501,403,'Debit',7.85),
(204,605,501,404,'Credit',25.67),
(205,606,501,405,'Credit',67.43),
(206,607,501,406,'Mimi Balance',30.56),
(207,608,501,407,'Credit',73.34),
(208,609,501,408,'Debit',131.67),
(209,610,501,409,'Cash',67.23),
(210,611,501,410,'Cash',17.45),
(211,612,501,411,'Debit',128.34),
(212,613,501,412,'Mimi Balance',34.10),
(213,614,501,413,'Cash',141.88),
(214,615,501,414,'Debit',117.20),
(215,616,501,416,'Debit',150.29),
(216,617,501,417,'Debit',18.44),
(217,618,501,418,'Cash',2.00),
(218,619,501,419,'Credit',100.28),
(219,620,501,420,'Mimi Balance',89.88),
(220,621,501,421,'Credit',15.97),
(221,622,501,422,'Credit',40.21),
(222,623,502,410,'Debit',167.83),
(223,624,502,411,'Debit',500.10),
(224,625,502,412,'Cash',177.02),
(225,626,502,413,'Debit',31.44),
(226,627,502,414,'Debit',98.42),
(227,628,502,415,'Cash',69.69),
(228,629,502,416,'Credit',132.76),
(229,630,502,417,'Debit',421.70),
(230,631,502,418,'Credit',54.12),
(231,632,502,419,'Credit',37.94),
(232,633,502,420,'Credit',83.75),
(233,634,503,444,'Cash',325.25),
(234,635,503,445,'Debit',75.42),
(235,636,503,446,'Mimi Balance',14.57),
(236,637,503,447,'Credit',176.43),
(237,638,503,448,'Debit',16.04),
(238,639,503,449,'Cash',17.76),
(239,640,503,450,'Debit',6.66),
(240,641,503,451,'Credit',101.46),
(241,642,503,452,'Mimi Balance',31.02),
(242,643,503,453,'Debit',248.21),
(243,644,503,454,'Cash',7.11),
(244,645,503,455,'Debit',10.26),
(245,646,503,411,'Credit',54.19),
(246,647,504,404,'Credit',60.45),
(247,648,504,405,'Credit',71.03),
(248,649,504,406,'Debit',552.79),
(249,650,504,407,'Cash',289.72),
(250,651,504,408,'Credit',182.94),
(251,652,504,409,'Mimi Balance',113.23),
(252,653,504,410,'Debit',117.92),
(253,654,504,416,'Mimi Balance',149.19);

--credit card
INSERT INTO creditCard(ccCustomerID, ccOrderID, ccMenuID, ccMenuItemID, feeTotal) VALUES
(204,605,501,404,34.65),
(205,606,501,405,88.03),
(207,608,501,407,99.01),
(218,619,501,419,131.33),
(220,621,501,421,21.56),
(221,622,501,422,54.28),
(228,629,502,416,179.23),
(230,631,502,418,73.06),
(231,632,502,419,51.22),
(232,633,502,420,113.06),
(236,637,503,447,22.18),
(240,641,503,451,136.97),
(245,646,503,411,73.16),
(246,647,504,404,81.61),
(247,648,504,405,95.89),
(250,651,504,408,112.04);




