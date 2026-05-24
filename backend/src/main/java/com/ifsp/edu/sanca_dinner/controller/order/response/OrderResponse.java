package com.ifsp.edu.sanca_dinner.controller.order.response;

import com.ifsp.edu.sanca_dinner.domain.model.order.OrderStatus;

import java.math.BigDecimal;
import java.util.List;

public record OrderResponse(
        Integer id,
        String customerName,
        Integer tableNumber,
        String review,
        OrderStatus orderStatus,
        BigDecimal total,
        List<OrderItemResponse> orderItems
) {}
