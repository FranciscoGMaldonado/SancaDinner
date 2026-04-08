package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import jakarta.persistence.*;
import lombok.Getter;

import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
@Getter
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private Integer productId;
    private BigDecimal productPrice;
    private String specification;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private OrderItemStatus orderItemStatus;

    protected OrderItem(){}

    public OrderItem(Integer productid, String specification, BigDecimal productPrice) {
        setProductId(productid);
        setSpecification(specification);
        setProductPrice(productPrice);
        this.orderItemStatus = OrderItemStatus.PENDING;
    }

    private void validateProductId(Integer productId){
        if(productId == null || productId <= 0) throw new DomainException("O ID do produto do item não pode ser nulo ou negativo.");
    }

    private void validateSpecification(String specification){
        if(specification != null && specification.isBlank()) throw new DomainException("A especificação não pode ser vazia.");
    }

    private void validatePrice(BigDecimal productPrice){
        if(productPrice == null || productPrice.compareTo(BigDecimal.ZERO) <= 0) throw new DomainException("O preço do produto não pode ser menor ou igual a zero, ou nulo.");
    }

    public void setProductId(Integer productId) {
        validateProductId(productId);
        this.productId = productId;
    }

    public void setSpecification(String specification) {
        validateSpecification(specification);
        this.specification = specification;
    }

    public void setProductPrice(BigDecimal productPrice) {
        validatePrice(productPrice);
        this.productPrice = productPrice;
    }
}
