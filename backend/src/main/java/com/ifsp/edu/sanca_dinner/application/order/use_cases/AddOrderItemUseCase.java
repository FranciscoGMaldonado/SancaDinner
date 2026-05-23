package com.ifsp.edu.sanca_dinner.application.order.use_cases;

import com.ifsp.edu.sanca_dinner.application.order.mapper.OrderMapper;
import com.ifsp.edu.sanca_dinner.controller.order.request.CreateOrderItemRequest;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.domain.service.order.OrderService;
import com.ifsp.edu.sanca_dinner.domain.service.product.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class AddOrderItemUseCase {

    private OrderService orderService;
    private ProductService productService;
    private OrderMapper orderMapper;

    public OrderResponse execute(CreateOrderItemRequest request){
        var order = orderService.addOrderItem(request.orderId(), request.productId(), request.specification(), productService.findProductById(request.productId()).getPrice());
        return orderMapper.orderToResponse(order);
    }
}
