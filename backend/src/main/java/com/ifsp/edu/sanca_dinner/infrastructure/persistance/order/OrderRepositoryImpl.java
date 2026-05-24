package com.ifsp.edu.sanca_dinner.infrastructure.persistance.order;

import com.ifsp.edu.sanca_dinner.domain.model.order.Order;
import com.ifsp.edu.sanca_dinner.domain.model.order.OrderStatus;
import com.ifsp.edu.sanca_dinner.domain.repository.order.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class OrderRepositoryImpl implements OrderRepository {

    private final JpaOrderRepository jpaRepository;

    @Override
    public Optional<Order> findById(Integer id) { return jpaRepository.findById(id); }

    @Override
    public Order save(Order order) { return jpaRepository.save(order); }

    @Override
    public List<Order> findAll() { return jpaRepository.findAll(); }

    @Override
    public List<Order> findByOrderStatus(OrderStatus orderStatus) { return jpaRepository.findByOrderStatus(orderStatus);}

    @Override
    public void deleteById(Integer id) { jpaRepository.deleteById(id); }
}
