package com.ifsp.edu.sanca_dinner.infrastructure.persistance.order;

import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JpaOrderRepository extends JpaRepository<Order, Integer> {
}
