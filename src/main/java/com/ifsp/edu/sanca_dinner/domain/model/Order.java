package com.ifsp.edu.sanca_dinner.domain.model;

import java.util.ArrayList;
import java.util.UUID;

public class Order {
    private UUID id;
    private String customer;
    private Integer tableId;
    private String review;
    private ArrayList<OrderItem> orderItems;
    private OrderStatus orderStatus;

}
