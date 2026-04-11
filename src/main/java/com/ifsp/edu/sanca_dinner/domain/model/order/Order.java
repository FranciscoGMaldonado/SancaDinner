package com.ifsp.edu.sanca_dinner.domain.model.order;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItem;
import jakarta.persistence.*;
import lombok.Getter;

import java.util.ArrayList;

@Entity
@Table(name = "orders")
@Getter
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String customerName;

    private Integer tableNumber;

    private String review;

    @Enumerated(EnumType.STRING)
    private OrderStatus orderStatus;

    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "order_id")
    private ArrayList<OrderItem> orderItems;

    protected Order(){}

    public Order(String customerName, Integer tableNumber) {
        setCustomerName(customerName);
        setTableNumber(tableNumber);
        this.orderStatus = OrderStatus.ACTIVE;
        this.orderItems = new ArrayList<>();
    }

    private void validateCustomerName(String customerName){
        if(customerName == null || customerName.isBlank()) throw new DomainException("O nome do cliente não pode ser vazio ou nulo.");
    }

    private void validateTableNumber(Integer tableNumber){
        if(tableNumber == null || tableNumber < 0) throw new DomainException("O número da mesa não pode ser nulo ou menor que zero.");
    }

    private void validateReview(String review){
        if(review == null || review.isBlank()) throw new DomainException("A review não pode ser vaiza ou nula.");
    }

    public void setCustomerName(String customerName) {
        validateCustomerName(customerName);
        this.customerName = customerName;
    }

    public void setTableNumber(Integer tableNumber) {
        validateTableNumber(tableNumber);
        this.tableNumber = tableNumber;
    }

    public void setReview(String review) {
        validateReview(review);
        this.review = review;
    }

    public void addOrderItem(OrderItem newOrderItem){
        if(newOrderItem == null) throw new DomainException("O item adicionado a comanda não pode ser nulo.");
        orderItems.add(newOrderItem);
    }

    public void closeOrder(String review){
        if(review != null && review.length() > 100) throw new DomainException("A review não pode ser superior a 100 caracteres.");
        this.review = review;
        this.orderStatus = OrderStatus.FINISHED;
    }
}
