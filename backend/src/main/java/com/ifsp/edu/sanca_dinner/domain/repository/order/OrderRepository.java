package com.ifsp.edu.sanca_dinner.domain.repository.order;

import com.ifsp.edu.sanca_dinner.domain.model.order.Order;

import java.util.List;
import java.util.Optional;

public interface OrderRepository {

    Optional<Order> findById(Integer id);
    Order save(Order order);
    List<Order> findAll();
    void deleteById(Order order);
}
