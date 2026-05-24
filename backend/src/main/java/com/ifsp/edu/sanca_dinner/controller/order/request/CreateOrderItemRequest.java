package com.ifsp.edu.sanca_dinner.controller.order.request;

public record CreateOrderItemRequest(
        Integer orderId,
        Integer productId,
        String specification
) {}
