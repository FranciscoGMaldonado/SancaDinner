package com.ifsp.edu.sanca_dinner.controller.order;

import com.ifsp.edu.sanca_dinner.application.order.use_cases.*;
import com.ifsp.edu.sanca_dinner.controller.order.request.*;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
@AllArgsConstructor
public class OrderController {

    private AddOrderItemUseCase addOrderItemUseCase;
    private CancelOrderItemUseCase cancelOrderItemUseCase; //Delete (/order_items)
    private ChangeOrderItemUseCase changeOrderItemUseCase;
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

    @PostMapping("/order_items/progress")
    public ResponseEntity<OrderResponse> closeOrder(@RequestBody ProgressOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(progressOrderItemUseCase.execute(request));
    }

    @PutMapping("/order_items")
    public ResponseEntity<OrderResponse> changeOrderItem(@RequestBody ChangeOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(changeOrderItemUseCase.execute(request));
    }
}
