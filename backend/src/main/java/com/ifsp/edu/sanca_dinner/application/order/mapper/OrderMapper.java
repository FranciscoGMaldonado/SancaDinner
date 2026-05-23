package com.ifsp.edu.sanca_dinner.application.order.mapper;

import com.ifsp.edu.sanca_dinner.controller.order.response.OrderItemResponse;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItem;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@NoArgsConstructor
public class OrderMapper {

    public OrderResponse orderToResponse(Order order){
        return new OrderResponse(
                order.getId(),
                order.getCustomerName(),
                order.getTableNumber(),
                order.getReview(),
                order.getOrderStatus(),
                order.getTotal(),
                order.getOrderItems().stream().map(this::orderItemToResponse).toList()
        );
    }

    public OrderItemResponse orderItemToResponse(OrderItem orderItem){
        return new OrderItemResponse(
                orderItem.getId(),
                orderItem.getProductId(),
                orderItem.getSpecification(),
                orderItem.getProductPrice(),
                orderItem.getOrderItemStatus()
        );
    }
}
