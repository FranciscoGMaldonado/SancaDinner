package com.ifsp.edu.sanca_dinner.controller.order.request;

public record ChangeOrderItemRequest(
        Integer orderId,
        Integer orderItemId,
        String specification
) {}
