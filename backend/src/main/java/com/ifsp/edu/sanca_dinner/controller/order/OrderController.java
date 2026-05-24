package com.ifsp.edu.sanca_dinner.controller.order;

import com.ifsp.edu.sanca_dinner.application.order.use_cases.*;
import com.ifsp.edu.sanca_dinner.controller.order.request.CloseOrderRequest;
import com.ifsp.edu.sanca_dinner.controller.order.request.CreateOrderItemRequest;
import com.ifsp.edu.sanca_dinner.controller.order.request.CreateOrderRequest;
import com.ifsp.edu.sanca_dinner.controller.order.request.ProgressOrderItemRequest;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/orders")
@AllArgsConstructor
public class OrderController {

    private AddOrderItemUseCase addOrderItemUseCase;
    private CancelOrderItemUseCase cancelOrderItemUseCase; //Delete (/order_items)
    private ChangeOrderItemUseCase changeOrderItemUseCase; //Put
    private CloseOrderUseCase closeOrderUseCase;
    private CreateOrderUseCase createOrderUseCase;
    private GetAllActiveOrdersUseCase getAllActiveOrdersUseCase; //Get (/active
    private GetAllOrdersUseCase getAllOrdersUseCase; //Get
    private GetOrderUseCase getOrderUseCase; //Get (/{order_id}
    private ProgressOrderItemUseCase progressOrderItemUseCase;

    @PostMapping
    public ResponseEntity<OrderResponse> createOrder(@RequestBody CreateOrderRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(createOrderUseCase.execute(request));
    }

    @PostMapping("/order_items")
    public ResponseEntity<OrderResponse> addOrderItem(@RequestBody CreateOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(addOrderItemUseCase.execute(request));
    }

    @PostMapping("/close")
    public ResponseEntity<OrderResponse> closeOrder(@RequestBody CloseOrderRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(closeOrderUseCase.execute(request));
    }

    @PostMapping("/progress")
    public ResponseEntity<OrderResponse> closeOrder(@RequestBody ProgressOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(progressOrderItemUseCase.execute(request));
    }
}
