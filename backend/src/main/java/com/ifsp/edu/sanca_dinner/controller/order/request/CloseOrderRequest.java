package com.ifsp.edu.sanca_dinner.controller.order.request;

public record CloseOrderRequest(
        Integer orderId,
        String review
) {}
