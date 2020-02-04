--Queries 
--a 
SELECT c1.rcustomerID, c1.fName, c1.lName, c1.emailaddress, c1.snailaddress, c1.zipcode, 'Private' AS "Customer Type"
FROM regCustomers c1 INNER JOIN privCustomer p ON c1.rcustomerID = p.pcustomerID
UNION 
SELECT c2.rcustomerID, c2.fName, c2.lName, c2.emailaddress, c2.snailaddress, c2.zipcode, 'Corporation'
FROM regCustomers c2 INNER JOIN corporation co ON c2.rcustomerID = co.cpCustomerID;

--b
SELECT c.customerID, SUM(p.priceSum)
FROM customer c INNER JOIN payment p ON c.CUSTOMERID = p.PCUSTOMERID
                INNER JOIN orders o ON c.customerID = o.oCustomerID
WHERE year(o.orderDate) >= year( NOW() ) - 2
GROUP BY c.customerID
LIMIT 3;

--c
SELECT s.SCEMPLOYEEID, e.FNAME, e.LNAME, group_concat(DISTINCT mi.menuName) AS menu_item, count(distinct mi.menuItemID) as total
FROM sousChef  s INNER JOIN employee e ON s.SCEMPLOYEEID = e.EMPLOYEEID
                 INNER JOIN mentorShip m ON m.SCMEMPLOYEEID = s.SCEMPLOYEEID
                 INNER JOIN menuItem mi ON mi.MENUITEMID = m.MSMENUITEMID
GROUP BY s.SCEMPLOYEEID, e.FNAME, e.LNAME
HAVING count(mi.menuItemID) >= 3
ORDER BY count(mi.menuItemID) DESC;

--d
SELECT  e1.FNAME AS "Chef 2 Last Name", 
                e1.LNAME AS "Chef 2 Last Name", 
                e2.FNAME AS "Chef 2 Last Name", 
                e2.LNAME AS "Chef 2 Last Name", 
           count( mi1.MENUNAME) AS "Menu Item"
FROM mentorship m1 INNER JOIN souschef sc1
                        ON m1.SCMEMPLOYEEID = sc1.SCEMPLOYEEID
                  INNER JOIN menuItem mi1 
                        ON mi1.MENUITEMID = m1.MSMENUITEMID
                  INNER JOIN mentorship m2 
                        ON m2.MSMENUITEMID = m1.MSMENUITEMID
                  INNER JOIN souschef sc2 
                        ON sc2.SCEMPLOYEEID = m2.SCMEMPLOYEEID
                  INNER JOIN employee e1 
                        ON e1.EMPLOYEEID = sc1.SCEMPLOYEEID
                  INNER JOIN employee e2 
                        ON e2.EMPLOYEEID = sc2.SCEMPLOYEEID
WHERE sc2.SCEMPLOYEEID < sc1.SCEMPLOYEEID
GROUP BY e1.FNAME, e1.lName, e2.fName, e2.lName
HAVING count( mi1.MENUNAME) >= 3 ;

--e 
SELECT menuname, COUNT(orderID) AS "Ordered" 
FROM menuItem mi
NATURAL JOIN menu
INNER JOIN orderSum ON mi.menuitemid = orderSum.osmenuitemid
INNER JOIN orders ON orderSum.osorderid = orders.orderid
WHERE menutype = 'Children'
GROUP BY menuname
ORDER BY COUNT(orderID) DESC 
LIMIT 3;

--f
SELECT DISTINCT mi.MENUNAME,o.orderTime,e.FNAME, e.LNAME,e.shift
FROM orders o INNER JOIN orderSum os 
                ON o.ORDERID = os.OSORDERID
              INNER JOIN menuItem mi 
                ON mi.MENUITEMID = os.OSMENUITEMID
              INNER JOIN mentorship m 
                ON m.MSMENUITEMID = mi.MENUITEMID
              INNER JOIN employee e 
                ON e.SHIFT = 'Evening'
              INNER JOIN sousChef sc 
                ON e.EMPLOYEEID = sc.SCEMPLOYEEID
WHERE o.ORDERTIME >= '15:00:00' AND o.ORDERTIME < '22:00:00'
                                AND m.SCMEMPLOYEEID != e.EMPLOYEEID
UNION 
SELECT DISTINCT mi1.MENUNAME,o1.orderTime,e1.FNAME, e1.LNAME,e1.shift
FROM orders o1 INNER JOIN orderSum os1 
                ON o1.ORDERID = os1.OSORDERID
              INNER JOIN menuItem mi1 
                ON mi1.MENUITEMID = os1.OSMENUITEMID
              INNER JOIN mentorship m1 
                ON m1.MSMENUITEMID = mi1.MENUITEMID
              INNER JOIN employee e1 
                ON e1.SHIFT = 'Morning'
              INNER JOIN sousChef sc1 
                ON e1.EMPLOYEEID = sc1.SCEMPLOYEEID
WHERE o1.ORDERTIME > '08:00:00' AND o1.ORDERTIME < '15:00:00'
                                AND m1.SCMEMPLOYEEID != e1.EMPLOYEEID;
--g 
SELECT fName, lName, mimiBalance
FROM regCustomers
ORDER BY mimiBalance DESC;

--h
SELECT rc.rcustomerID,rc.fname, rc.lname, SUM(p.priceSum) as "Total Spent"
FROM regCustomers rc INNER JOIN payment p ON rc.rCUSTOMERID = p.PCUSTOMERID
GROUP BY rc.rCUSTOMERID, rc.fname, rc.lname
ORDER BY SUM(p.priceSum)DESC;

--i 
SELECT    rc.FNAME AS "First Name", 
          rc.LNAME AS "Last Name", 
month(o.ORDERDATE) AS "Month", 
year(o.ORDERDATE)  AS "Year", 
count(orderDate)   AS "Number of Visits"
FROM regCustomers rc LEFT OUTER JOIN orders o
                    ON o.OCUSTOMERID = rc.RCUSTOMERID
GROUP BY rc.FNAME, rc.LNAME, month(o.ORDERDATE), year(o.ORDERDATE)
ORDER BY count(orderDate) DESC;

--j
SELECT c.rcustomerID, SUM(p.priceSum)
FROM regCustomers c INNER JOIN payment p ON c.RCUSTOMERID = p.pCustomerID 
                    INNER JOIN orders o  ON o.OCUSTOMERID = c.RCUSTOMERID
                    WHERE year(o.ORDERDATE) >= year( NOW() ) -1
GROUP BY c.RcustomerID
ORDER BY sum(p.priceSum) DESC
LIMIT 3;

--k 
SELECT MMJ.JMENUITEMID, mi.MENUNAME, sum(MMJ.price)
FROM menuMUI_Junction MMJ INNER JOIN orderSum os 
                            ON os.OSMENUITEMID = MMJ.JMENUITEMID
                          INNER JOIN menuItem mi 
                            ON mi.MENUITEMID = MMJ.JMENUITEMID
                          INNER JOIN orders o 
                            ON o.ORDERID = os.OSORDERID
                                WHERE year(o.ORDERDATE) >= year(NOW()) - 1
GROUP BY MMJ.JMENUITEMID, mi.MENUNAME
ORDER BY sum(MMJ.price) DESC
Limit 5;

--l
SELECT DISTINCT mentorshipid, fname, lname, menuname FROM mentorship
NATURAL JOIN menuitem JOIN  employee ON employee.employeeid = mentorship.mentorshipid
WHERE mentorshipid = (SELECT mentorshipid FROM mentorship GROUP BY mentorshipid HAVING COUNT(mentorshipid) =
(SELECT MAX(y.amount) FROM (SELECT COUNT(mentorshipid) AS amount FROM mentorship GROUP BY mentorshipid) y) );

--m
SELECT mi.MENUITEMID, mi.MENUNAME, count(sc.SCEMPLOYEEID)
FROM sousChef sc INNER JOIN employee e 
                    ON e.EMPLOYEEID = sc.SCEMPLOYEEID
                 INNER JOIN mentorShip m 
                    ON m.SCMEMPLOYEEID = sc.SCEMPLOYEEID
                 INNER JOIN menuItem mi 
                        ON mi.MENUITEMID = m.MSMENUITEMID  
GROUP BY mi.MENUITEMID, mi.MENUNAME 
ORDER BY count(sc.SCEMPLOYEEID) ASC
LIMIT 3;

--n
SELECT rc.FNAME, rc.LNAME
FROM regcustomers rc INNER JOIN privCustomer pc 
                        ON rc.RCUSTOMERID = pc.PCUSTOMERID
                     INNER JOIN corporation c 
                        ON c.CPCUSTOMERID = rc.RCUSTOMERID;

--o 
SELECT mI.menuItemID,mI.menuName,mI.muCategory,mI.muSpice,mI.muMeat, mMJ.price
FROM menuMUI_Junction mMJ
INNER JOIN menuItem mI on mMJ.jMenuItemID = mI.menuItemID
GROUP BY  mI.menuItemID,mI.menuName,mI.muCategory,mI.muSpice,mI.muMeat, mMJ.price;

--p
--Shows how every Sous Chef has at least 1 year of experience
SELECT e.FNAME, e.LNAME, 'SousChef' as "Title", sc.MENUEXP as "Years of Experience"
FROM SOUSCHEF sc INNER JOIN employee e 
                    ON e.EMPLOYEEID = sc.SCEMPLOYEEID;

/** Business Rule # 4: Catering orders to corporations must exceed $100*/
SELECT o.ORDERID, c.CORPNAME, p.PRICESUM
FROM orders o INNER JOIN corporation c 
                ON o.OCUSTOMERID = c.CPCUSTOMERID
              INNER JOIN payment p
                ON p.porderID = o.ORDERID;

--list out every eat inorder what were charged with a manditory gratituity and --used a credit card
SELECT di.guestSize, p.paymentType, cC.feeTotal
FROM dineIn di
INNER JOIN orders o on di.diOrderID = o.orderID
INNER JOIN orderSum oS on o.orderID = oS.osOrderID
INNER JOIN payment p on oS.osOrderID = p.pOrderID and oS.osMenuID = p.pMenuID and oS.osMenuItemID = p.pMenuItemID
INNER JOIN creditCard cC on p.pCustomerID = cC.ccCustomerID and p.pOrderID = cC.ccOrderID and p.pMenuID = cC.ccMenuID and p.pMenuItemID = cC.ccMenuItemID
WHERE di.guestSize > 4 AND p.paymentType = 'Credit';


