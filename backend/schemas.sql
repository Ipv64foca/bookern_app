-- Tables for the database bookern_app

CREATE TABLE boo_groups (
    group_id SERIAL PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL, --Client, Employee,Admin
    group_description VARCHAR(255)
)

CREATE TABLE boo_users (
    user_code SERIAL PRIMARY KEY,
    user_group INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    user_mail VARCHAR(150) NOT NULL,
    user_phone VARCHAR(255) NOT NULL,
    user_passw VARCHAR(255) NOT NULL,
    user_image VARCHAR(255) NULL,
    user_status INT NOT NULL,
    user_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT fk_user_group FOREIGN KEY (user_group) REFERENCES bo_groups (group_id),
    CONSTRAINT user_mail_unique UNIQUE (user_mail),
    CONSTRAINT user_status CHECK (
        user_status = 0 OR -- 0 = inactive
        user_status = 1 OR -- 1 = active
        user_status = 2    -- 2 = banned
        )
);

CREATE TABLE boo_stores (
    store_code SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_address VARCHAR(255) NOT NULL,
    store_city VARCHAR(100) NOT NULL,
    store_state VARCHAR(100) NOT NULL,
    store_zip VARCHAR(100) NOT NULL,
    store_phone VARCHAR(255) NOT NULL,
    store_mail VARCHAR(150) NOT NULL,
    
    store_image VARCHAR(255) NULL,
    store_status INT NOT NULL,
    store_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    store_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT store_status CHECK (
        store_status = 0 OR -- 0 = inactive
        store_status = 1 OR -- 1 = active
        store_status = 2    -- 2 = banned
    )
);