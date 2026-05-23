package com.ifsp.edu.sanca_dinner.infrastructure.persistance.order;

import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import com.ifsp.edu.sanca_dinner.domain.model.order.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JpaOrderRepository extends JpaRepository<Order, Integer> {
    List<Order> findByOrderStatus(OrderStatus orderStatus);
}
