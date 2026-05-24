package com.ifsp.edu.sanca_dinner.controller.order.request;

public record CreateOrderRequest(
    String customerName,
    Integer tableId
) {}
