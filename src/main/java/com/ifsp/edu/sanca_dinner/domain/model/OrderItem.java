package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.Getter;

import java.util.UUID;

@Getter
public class OrderItem {
    private Integer id;
    private Product product;
    private String specification;
    private OrderItemStatus orderItemStatus;

    public OrderItem(Integer id, Product product, OrderItemStatus orderItemStatus, String specification) {
        setProduct(product);
        setSpecification(specification);
        this.orderItemStatus = OrderItemStatus.PENDING;
        this.id = id;
    }

    private void validateProduct(Product product){
        if(product == null) throw new DomainException("O produto do item não pode ser nulo.");
    }

    private void validateSpecification(String specification){
        if(specification.isBlank()) throw new DomainException("A especificação não pode ser vazia.");
    }

    public void setProduct(Product product) {
        validateProduct(product);
        this.product = product;
    }

    public void setSpecification(String specification) {
        validateSpecification(specification);
        this.specification = specification;
    }
}
