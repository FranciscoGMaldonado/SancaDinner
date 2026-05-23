package com.ifsp.edu.sanca_dinner.controller.order;

import com.ifsp.edu.sanca_dinner.application.order.use_cases.*;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/orders")
@AllArgsConstructor
public class OrderController {

    private AddOrderItemUseCase addOrderItemUseCase;
    private CancelOrderItemUseCase cancelOrderItemUseCase;
    private ChangeOrderItemUseCase changeOrderItemUseCase;
    private CloseOrderUseCase closeOrderUseCase;
    private CreateOrderUseCase createOrderUseCase;
    private GetAllActiveOrdersUseCase getAllActiveOrdersUseCase;
    private GetAllOrdersUseCase getAllOrdersUseCase;
    private GetOrderUseCase getOrderUseCase;
    private ProgressOrderItemUseCase progressOrderItemUseCase;
}
