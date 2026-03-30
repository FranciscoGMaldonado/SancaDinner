CREATE TABLE users (
    id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email    TEXT    NOT NULL,
    password TEXT    NOT NULL,
    role     TEXT    NOT NULL
);

CREATE TABLE products (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT          NOT NULL,
    price       NUMERIC(10,2) NOT NULL,
    quantity    INTEGER       NOT NULL,
    description TEXT          NOT NULL
);

CREATE TABLE orders (
    id            INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name TEXT      NOT NULL,
    table_number  INTEGER   NOT NULL,
    status        TEXT      NOT NULL,
    review        TEXT,
    ts_start      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    ts_end        TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE order_items (
    id            INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id      INTEGER   NOT NULL,
    product_id    INTEGER   NOT NULL,
    specification TEXT,
    status        TEXT      NOT NULL,
    quantity      INTEGER   NOT NULL,
    ts_start      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    ts_end        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
