package com.ifsp.edu.sanca_dinner.application.order.use_cases;

import com.ifsp.edu.sanca_dinner.application.order.mapper.OrderMapper;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.service.order.OrderService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@AllArgsConstructor
public class GetAllOrdersUseCase {

    private OrderService orderService;
    private OrderMapper orderMapper;

    public List<OrderResponse> execute(){
        var orders = orderService.findAllOrders();
        return orders.stream().map(orderMapper::orderToResponse).toList();
    }
}
