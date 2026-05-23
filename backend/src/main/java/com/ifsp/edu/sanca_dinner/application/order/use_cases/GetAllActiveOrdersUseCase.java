package com.ifsp.edu.sanca_dinner.application.order.use_cases;

import com.ifsp.edu.sanca_dinner.application.order.mapper.OrderMapper;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.model.order.OrderStatus;
import com.ifsp.edu.sanca_dinner.domain.service.order.OrderService;

import java.util.List;

public class GetAllActiveOrdersUseCase {

    private OrderService orderService;
    private OrderMapper orderMapper;

    public List<OrderResponse> execute(){
        var orders = orderService.findAllOrdersByStatus(OrderStatus.ACTIVE);
        return orders.stream().map(orderMapper::orderToResponse).toList();
    }
}
