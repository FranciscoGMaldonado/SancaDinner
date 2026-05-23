package com.ifsp.edu.sanca_dinner.domain.service.order;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItem;
import com.ifsp.edu.sanca_dinner.domain.repository.order.OrderRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@AllArgsConstructor
public class OrderService {

    private OrderRepository orderRepository;

    private Order findOrderById(Integer orderId){
        return orderRepository.findById(orderId).orElseThrow(() -> new DomainException("Comanda não encontrada."));
    }

    public Order createOrder(String customerName, Integer tableNumber){
        var newOrder = new Order(customerName, tableNumber);
        return orderRepository.save(newOrder);
    }

    public Order addOrderItem(Integer orderId, Integer productId, String specification, BigDecimal productPrice){
        var order = findOrderById(orderId);
        order.addOrderItem(new OrderItem(productId, specification, productPrice));
        return orderRepository.save(order);
    }

    public Order changeOrderItem(Integer orderId, Integer orderItemId, String newSpecification){
        var order = findOrderById(orderId);
        order.changeOrderItem(orderItemId, newSpecification);
        return orderRepository.save(order);
    }

    public Order cancelOrderItem(Integer orderId, Integer orderItemId){
        var order = findOrderById(orderId);
        order.cancelOrderItem(orderItemId);
        return orderRepository.save(order);
    }

    public Order progressOrderItem(Integer orderId, Integer orderItemId){
        var order = findOrderById(orderId);
        order.progressOrderItem(orderItemId);
        return orderRepository.save(order);
    }

    public Order closeOrder(Integer orderId, String review){
        var order = findOrderById(orderId);
        order.closeOrder(review);
        return orderRepository.save(order);
    }
}
