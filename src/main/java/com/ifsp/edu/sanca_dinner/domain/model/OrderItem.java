package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.Getter;

import java.util.UUID;

@Getter
public class OrderItem {
    private UUID id;
    private Product product;
    private String specification;
    private OrderStatus orderStatus;

    public OrderItem(UUID id, Product product, OrderStatus orderStatus, String specification) {
        setProduct(product);
        setSpecification(specification);
        this.orderStatus = OrderStatus.PENDING;
        this.id = id;
    }

    void validateProduct(Product product){
        if(product == null) throw new DomainException("O produto do item não pode ser nulo.");
    }

    void validateSpecification(String specification){
        if(specification == null || specification.isBlank()) throw new DomainException("A especificação não pode ser vazia ou nula.");
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
