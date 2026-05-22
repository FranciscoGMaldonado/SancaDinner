package com.ifsp.edu.sanca_dinner.domain.service.order;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItem;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItemStatus;
import com.ifsp.edu.sanca_dinner.domain.repository.order.OrderRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@AllArgsConstructor
public class OrderService {

    private OrderRepository orderRepository;

    private Order findOrderByIdWrapper(Integer orderId){
        return orderRepository.findById(orderId).orElseThrow(() -> new DomainException("Comanda não encontrada."));
    }

    public Order createOrder(String customerName, Integer tableNumber){
        var newOrder = new Order(customerName, tableNumber);
        return orderRepository.save(newOrder);
    }

    public Order addOrderItem(Integer orderId, Integer productId, String specification, BigDecimal productPrice){
        var order = findOrderByIdWrapper(orderId);
        order.addOrderItem(new OrderItem(productId, specification, productPrice));
        return orderRepository.save(order);
    }

    public Order changeOrderItem(Integer orderId, Integer orderItemId, String newSpecification){
        var order = findOrderByIdWrapper(orderId);
        var orderItem = order.getOrderItems().stream().
                filter(item -> item.getId().equals(orderItemId)).
                findFirst().
                orElseThrow(() -> new DomainException("Item da comanda não encontrado."));
        if(orderItem.getOrderItemStatus() != OrderItemStatus.PENDING) throw new DomainException("Apenas é possivel alterar itens que estão pendentes.");
        orderItem.setSpecification(newSpecification);
        return orderRepository.save(order);
    }
}
