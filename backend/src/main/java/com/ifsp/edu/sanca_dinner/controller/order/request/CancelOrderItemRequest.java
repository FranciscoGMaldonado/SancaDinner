package com.ifsp.edu.sanca_dinner.controller.order.request;

public record CancelOrderItemRequest(
        Integer orderId,
        Integer orderItemId
) {}
