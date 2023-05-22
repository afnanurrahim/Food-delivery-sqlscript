CREATE TABLE Users (
	user_id INT NOT NULL,
	Name VARCHAR2(255) NOT NULL,
	Email VARCHAR2(255) NOT NULL,
	constraint USERS_PK PRIMARY KEY (user_id));

CREATE sequence USERS_USER_ID_SEQ;

CREATE trigger BI_USERS_USER_ID
  before insert on Users
  for each row
begin
  select USERS_USER_ID_SEQ.nextval into :NEW.user_id from dual;
end;

/
CREATE TABLE Restaurants (
	restaurant_id INT NOT NULL,
	Name VARCHAR2(255) UNIQUE NOT NULL,
	cuisine VARCHAR2(255) NOT NULL,
	constraint RESTAURANTS_PK PRIMARY KEY (restaurant_id));

CREATE sequence RESTAURANTS_RESTAURANT_ID_SEQ;

CREATE trigger BI_RESTAURANTS_RESTAURANT_ID
  before insert on Restaurants
  for each row
begin
  select RESTAURANTS_RESTAURANT_ID_SEQ.nextval into :NEW.restaurant_id from dual;
end;

/
CREATE TABLE Food (
	food_id INT NOT NULL,
	Food_name VARCHAR2(255) UNIQUE NOT NULL,
	veg_only BLOB NOT NULL DEFAULT 0,
	constraint FOOD_PK PRIMARY KEY (food_id));

CREATE sequence FOOD_FOOD_ID_SEQ;

CREATE trigger BI_FOOD_FOOD_ID
  before insert on Food
  for each row
begin
  select FOOD_FOOD_ID_SEQ.nextval into :NEW.food_id from dual;
end;

/
CREATE TABLE Menu (
	menu_id INT NOT NULL,
	restaurant_id INT NOT NULL,
	food_id INT NOT NULL,
	constraint MENU_PK PRIMARY KEY (menu_id));

CREATE sequence MENU_MENU_ID_SEQ;

CREATE trigger BI_MENU_MENU_ID
  before insert on Menu
  for each row
begin
  select MENU_MENU_ID_SEQ.nextval into :NEW.menu_id from dual;
end;

/
CREATE TABLE Orders (
	order_id INT NOT NULL,
	user_id INT NOT NULL,
	restaurant_id INT NOT NULL,
	amount INT NOT NULL,
	order_date DATE NOT NULL,
	partner_id INT NOT NULL,
	delivery_time TIMESTAMP NOT NULL,
	delivery_rating INT NOT NULL DEFAULT 5,
	restaurant_rating INT NOT NULL,
	constraint ORDERS_PK PRIMARY KEY (order_id),
	constraint delivery_rating_ck check(delivery_rating between 1 and 5)
	constraint restaurant_rating_ck check(restaurant_rating between 1 and 5));

CREATE sequence ORDERS_ORDER_ID_SEQ;

CREATE trigger BI_ORDERS_ORDER_ID
  before insert on Orders
  for each row
begin
  select ORDERS_ORDER_ID_SEQ.nextval into :NEW.order_id from dual;
end;

/
CREATE TABLE Delivery_partner (
	partner_id INT NOT NULL,
	partner_name VARCHAR2(255) NOT NULL,
	constraint DELIVERY_PARTNER_PK PRIMARY KEY (partner_id));

CREATE sequence DELIVERY_PARTNER_PARTNER_ID_SEQ;

CREATE trigger BI_DELIVERY_PARTNER_PARTNER_ID
  before insert on Delivery_partner
  for each row
begin
  select DELIVERY_PARTNER_PARTNER_ID_SEQ.nextval into :NEW.partner_id from dual;
end;

/
CREATE TABLE Order_details (
	order_id INT NOT NULL,
	food_id INT NOT NULL);


/



ALTER TABLE Menu ADD CONSTRAINT Menu_fk0 FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id);
ALTER TABLE Menu ADD CONSTRAINT Menu_fk1 FOREIGN KEY (food_id) REFERENCES Food(food_id);

ALTER TABLE Orders ADD CONSTRAINT Orders_fk0 FOREIGN KEY (user_id) REFERENCES Users(user_id);
ALTER TABLE Orders ADD CONSTRAINT Orders_fk1 FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id);
ALTER TABLE Orders ADD CONSTRAINT Orders_fk2 FOREIGN KEY (partner_id) REFERENCES Delivery_partner(partner_id);


ALTER TABLE Order_details ADD CONSTRAINT Order_details_fk0 FOREIGN KEY (order_id) REFERENCES Orders(order_id);
ALTER TABLE Order_details ADD CONSTRAINT Order_details_fk1 FOREIGN KEY (food_id) REFERENCES Food(food_id);

