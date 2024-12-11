PRAGMA foreign_keys=ON;
.headers ON
.mode columns


CREATE TABLE Person(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    phone_number INTEGER,
    email TEXT
);

CREATE TABLE Owner(
    id INTEGER PRIMARY KEY,
    adress TEXT
);

CREATE TABLE Trainer(
    id INTEGER PRIMARY KEY
);

CREATE TABLE Caretaker(
    id INTEGER PRIMARY KEY
);

CREATE TABLE Feedback(
    id INTEGER PRIMARY KEY,
    owner INTEGER REFERENCES Owner,
    rating INTEGER,
    observations TEXT,
    date_of_feedback TEXT NOT NULL,
    CONSTRAINT rating_vef CHECK(rating>=0 AND rating<=5 OR rating IS NULL)
);

CREATE TABLE Reservation(
    id INTEGER PRIMARY KEY,
    owner INTEGER REFERENCES Owner,
    trainer INTEGER REFERENCES Trainer,
    caretaker INTEGER REFERENCES Caretaker,
    room INTEGER REFERENCES Room,
    dog INTEGER REFERENCES Dog,
    payment INTEGER REFERENCES Payment,
    date_in TEXT,
    date_out TEXT,
    status TEXT,
    cost INTEGER,
    CONSTRAINT dates CHECK(date_out IS NOT NULL OR strftime(date_out)>strftime(date_time)),
    CONSTRAINT sta_levels CHECK(status IN {'active','cancelled','finished'}),
    CONSTRAINT cost_vef CHECK(cost>0)
);

CREATE TABLE Dog(
    id INTEGER PRIMARY KEY,
    owner INTEGER REFERENCES Owner,
    name TEXT,
    age INTEGER,
    size TEXT,
    CONSTRAINT dog_age CHECK(age>=0),
    CONSTRAINT size_levels CHECK(size IN{'small','medium','large'})
);

CREATE TABLE Meals(
    id INTEGER PRIMARY KEY,
    dog INTEGER REFERENCES Dog,
    type_of_dog_food TEXT,
    quantity INTEGER,
    time INTEGER,
    observations TEXT,
    CONSTRAINT quant_vef CHECK(quantity>=0),
    CONSTRAINT time_vef CHECK(time>=1 AND time<=24)
);

CREATE TABLE Room(
    number INTEGER PRIMARY KEY,
    capacity INTEGER,
    state TEXT,
    CONSTRAINT room_vef CHECK(number>0),
    CONSTRAINT capacity_vef CHECK(capacity>0),
    CONSTRAINT room_state_levels CHECK(state IN{'free','occupied','cleaning'})
);

CREATE TABLE Payment(
    id INTEGER PRIMARY KEY,
    value INTEGER,
    method_of_payment TEXT,
    status_of_payment TEXT,
    CONSTRAINT value_vef CHECK(value>0),
    CONSTRAINT status_pay_level CHECK(status_of_payment IN{'payed','not payed'}),
    CONSTRAINT method_pay_level CHECK(method_of_payment IN{'cash','card','check'}),
);

CREATE TABLE Additional_Services(
    service_type TEXT PRIMARY KEY,
    price INTEGER,
    CONSTRAINT service_levels CHECK(service_type IN{'bath','training','walk'}),
    CONSTRAINT price_vef CHECK(price>0)
);

CREATE TABLE Reservation_add(
    PRIMARY KEY(reservation,add_Services),
    reservation INTEGER REFERENCES Reservation,
    add_Services INTEGER REFERENCES Additional_Services,
    quantity INTEGER,
    unitary_cost INTEGER,
    CONSTRAINT quant_add_vef CHECK(quantity>0),
    CONSTRAINT unitary_vef CHECK(unitary_cost>0)
);