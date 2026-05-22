package com.ifsp.edu.sanca_dinner.domain.service.order;

import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import com.ifsp.edu.sanca_dinner.domain.repository.order.OrderRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class OrderService {

    private OrderRepository orderRepository;

    public Order createOrder(String customerName, Integer tableNumber){
        var newOrder = new Order(customerName, tableNumber);
        return orderRepository.save(newOrder);
    }
}
