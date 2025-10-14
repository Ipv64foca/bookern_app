-- Tables for the database bookern_app

CREATE TABLE boo_groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL, 
    group_description VARCHAR(255)
);

CREATE TABLE boo_users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_user_group INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    user_mail VARCHAR(150) NOT NULL,
    user_phone VARCHAR(255) NOT NULL,
    user_birthday DATE NULL,
    user_passw VARCHAR(255) NOT NULL,
    user_image VARCHAR(255) NULL,
    user_status ENUM('inactive', 'active', 'banned') NOT NULL,
    user_gender ENUM('male', 'female', 'other') NOT NULL,
    user_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_user_group) REFERENCES boo_groups (group_id),

    -- Uniques
    CONSTRAINT user_mail_unique UNIQUE (user_mail)
);

CREATE TABLE boo_storetypes (
    storetype_id INT AUTO_INCREMENT PRIMARY KEY,
    storetype_name VARCHAR(100) NOT NULL,
    storetype_description VARCHAR(255),
    storetype_icon VARCHAR(255),
    user_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE boo_stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_store_type INT NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    store_description VARCHAR(255) NOT NULL,
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
    FOREIGN KEY (fk_store_type) REFERENCES boo_storetypes (storetype_id),

    -- Uniques
    CONSTRAINT store_mail_unique UNIQUE (store_mail),

    -- Checks
    CONSTRAINT store_status CHECK (
        store_status = 0 OR
        store_status = 1 OR 
        store_status = 2
    )
);
CREATE TABLE boo_employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_employee_user INT NOT NULL,
    fk_employee_store INT NOT NULL, 
    employee_status INT NOT NULL,
    employee_hire_date DATE NOT NULL,
    employee_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_employee_user) REFERENCES boo_users (user_id),
    FOREIGN KEY (fk_employee_store) REFERENCES boo_stores (store_id),

    -- Checks
    CONSTRAINT c_employee_status CHECK (
        employee_status = 0 OR 
        employee_status = 1    
    )
);

CREATE TABLE boo_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_category_store INT NOT NULL, 
    category_name VARCHAR(100) NOT NULL,
    category_description VARCHAR(255) NOT NULL,
    category_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    category_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_category_store) REFERENCES boo_stores (store_id)    
);

CREATE TABLE boo_services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_service_store INT NOT NULL,
    fk_service_category INT NOT NULL,
    service_title VARCHAR(100) NOT NULL,
    service_price DECIMAL(10,2) NOT NULL,
    service_description VARCHAR(255) NOT NULL,
    service_duration INT NOT NULL,
    service_active INT NOT NULL,
    service_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    service_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_service_store) REFERENCES boo_stores (store_id),
    FOREIGN KEY (fk_service_category) REFERENCES boo_categories (category_id),
    
    -- Checks
    CONSTRAINT c_service_active CHECK (
        service_active = 0 OR 
        service_active = 1    
    )
);

CREATE TABLE boo_bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_booking_user INT NOT NULL, 
    fk_booking_store INT NOT NULL, 
    fk_booking_employee INT NOT NULL, 
    fk_booking_service INT NOT NULL, 
    booking_date DATE NOT NULL,
    booking_start_time TIME NOT NULL,
    booking_end_time TIME NOT NULL,
    booking_time TIME NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL,
    booking_notes VARCHAR(255),
    booking_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    booking_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_booking_user) REFERENCES boo_users (user_id),
    FOREIGN KEY (fk_booking_store) REFERENCES boo_stores (store_id),
    FOREIGN KEY (fk_booking_employee) REFERENCES boo_employees (employee_id),
    FOREIGN KEY (fk_booking_service) REFERENCES boo_services (service_id)
);

CREATE TABLE boo_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_schedule_store INT NOT NULL, 
    fk_schedule_employee INT NOT NULL, 
    schedule_date INT NOT NULL, 
    schedule_start_time TIME NOT NULL,
    schedule_end_time TIME NOT NULL,
    schedule_is_available INT NOT NULL,
    schedule_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    schedule_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_schedule_store) REFERENCES boo_stores (store_id),
    FOREIGN KEY (fk_schedule_employee) REFERENCES boo_employees (employee_id),

    -- Checks
    CONSTRAINT c_schedule_date CHECK (
        schedule_date BETWEEN 0 AND 6
    ),
    CONSTRAINT c_schedule_is_available CHECK ( 
        schedule_is_available = 0 OR 
        schedule_is_available = 1 
    )
);
CREATE TABLE boo_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_payment_user INT NOT NULL, 
    fk_payment_store INT NOT NULL, 
    fk_payment_booking INT NOT NULL, 
    payment_method ENUM('credit', 'online', 'cash') NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'paid', 'refunded') NOT NULL,
    payment_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    payment_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_payment_user) REFERENCES boo_users (user_id),
    FOREIGN KEY (fk_payment_store) REFERENCES boo_stores (store_id),
    FOREIGN KEY (fk_payment_booking) REFERENCES boo_bookings (booking_id)
);

CREATE TABLE boo_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_review_user INT NOT NULL, 
    fk_review_store INT NOT NULL, 
    fk_review_service INT NOT NULL, 
    review_rating INT NOT NULL,
    review_comment TEXT NULL,
    review_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    review_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_review_user) REFERENCES boo_users (user_id),
    FOREIGN KEY (fk_review_store) REFERENCES boo_stores (store_id),
    FOREIGN KEY (fk_review_service) REFERENCES boo_services (service_id),

    -- Checks
    CONSTRAINT c_review_rating CHECK (
        review_rating BETWEEN 1 AND 5
    )
);

CREATE TABLE boo_messages (
    messages_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_messages_user INT NOT NULL,
    fk_messages_booking INT NOT NULL,
    fk_messages_store INT NOT NULL, 
    messages_type ENUM('sms', 'email', 'whatsapp') NULL,
    messages_description VARCHAR(255) NOT NULL,
    messages_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    messages_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (fk_messages_user) REFERENCES boo_users (user_id),
    FOREIGN KEY (fk_messages_store) REFERENCES boo_stores (store_id),
    FOREIGN KEY (fk_messages_booking) REFERENCES boo_bookings (booking_id)
);