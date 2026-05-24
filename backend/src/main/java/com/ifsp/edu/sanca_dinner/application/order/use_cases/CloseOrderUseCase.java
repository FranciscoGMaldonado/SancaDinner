package com.ifsp.edu.sanca_dinner.application.order.use_cases;

import com.ifsp.edu.sanca_dinner.application.order.mapper.OrderMapper;
import com.ifsp.edu.sanca_dinner.controller.order.request.CloseOrderRequest;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.service.order.OrderService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class CloseOrderUseCase {

    private OrderService orderService;
    private OrderMapper orderMapper;

    public OrderResponse execute(CloseOrderRequest request){
        var order = orderService.closeOrder(request.orderId(), request.review());
        return orderMapper.orderToResponse(order);
    }
}
