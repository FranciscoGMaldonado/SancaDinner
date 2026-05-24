package com.ifsp.edu.sanca_dinner.controller.order;

import com.ifsp.edu.sanca_dinner.application.order.use_cases.*;
import com.ifsp.edu.sanca_dinner.controller.order.request.*;
import com.ifsp.edu.sanca_dinner.controller.order.response.OrderResponse;
import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
        return ResponseEntity.status(HttpStatus.OK).body(closeOrderUseCase.execute(request));
    }

    @PostMapping("/order_items/progress")
    public ResponseEntity<OrderResponse> progressOrderItem(@RequestBody ProgressOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(progressOrderItemUseCase.execute(request));
    }

    @PutMapping("/order_items")
    public ResponseEntity<OrderResponse> changeOrderItem(@RequestBody ChangeOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(changeOrderItemUseCase.execute(request));
    }

    @GetMapping("/active")
    public ResponseEntity<List<OrderResponse>> getAllActiveOrders(){
        return ResponseEntity.status(HttpStatus.OK).body(getAllActiveOrdersUseCase.execute());
    }

    @GetMapping
    public ResponseEntity<List<OrderResponse>> getAllOrders(){
        return ResponseEntity.status(HttpStatus.OK).body(getAllOrdersUseCase.execute());
    }

    @GetMapping("/{order_id}")
    public ResponseEntity<OrderResponse> getOrder(@PathVariable Integer orderId){
        return ResponseEntity.status(HttpStatus.OK).body(getOrderUseCase.execute(orderId));
    }

    @DeleteMapping("/order_item")
    public ResponseEntity<OrderResponse> cancelOrderItem(CancelOrderItemRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(cancelOrderItemUseCase.execute(request));
    }
}
