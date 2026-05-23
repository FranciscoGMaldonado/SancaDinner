package com.ifsp.edu.sanca_dinner.application.order.use_cases;

import com.ifsp.edu.sanca_dinner.application.order.mapper.OrderMapper;
import com.ifsp.edu.sanca_dinner.controller.order.request.CreateOrderRequest;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.service.order.OrderService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class CreateOrderUseCase {

    private OrderService orderService;
    private OrderMapper orderMapper;

    public OrderResponse execute(CreateOrderRequest request){
        var newOrder = orderService.createOrder(request.customerName(), request.tableId());
        return orderMapper.orderToResponse(newOrder);
    }
}
