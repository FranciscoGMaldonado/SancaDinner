package com.ifsp.edu.sanca_dinner.controller.order.response;

import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItemStatus;
import java.math.BigDecimal;

public record OrderItemResponse(
        Integer id,
        Integer productId,
        String specification,
        BigDecimal productPrice,
        OrderItemStatus orderItemStatus
) {}
