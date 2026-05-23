package com.ifsp.edu.sanca_dinner.application.order.use_cases;

import com.ifsp.edu.sanca_dinner.application.order.mapper.OrderMapper;
import com.ifsp.edu.sanca_dinner.controller.order.request.ChangeOrderItemRequest;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.service.order.OrderService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class ChangeOrderItemUseCase {

    private OrderService orderService;
    private OrderMapper orderMapper;

    public OrderResponse execute(ChangeOrderItemRequest request){
        var order = orderService.changeOrderItem(request.orderId(), request.orderItemId(), request.specification());
        return orderMapper.orderToResponse(order);
    }
}
