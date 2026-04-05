package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Table(name = "order_items")
@Getter
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    private String specification;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private OrderItemStatus orderItemStatus;

    protected OrderItem(){}

    public OrderItem(Product product, String specification) {
        setProduct(product);
        setSpecification(specification);
        this.orderItemStatus = OrderItemStatus.PENDING;
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
