package com.ifsp.edu.sanca_dinner.controller.order.request;

public record ProgressOrderItemRequest(
        Integer orderId,
        Integer orderItemId
) { }
