package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.Getter;

import java.util.ArrayList;
import java.util.UUID;

@Getter
public class Order {
    private UUID id;
    private String customer;
    private Integer tableId;
    private String review;
    private ArrayList<OrderItem> orderItems;
    private OrderStatus orderStatus;

    public Order(UUID id, String customer, Integer tableId) {
        setCustomer(customer);
        setTableId(tableId);
        this.id = id;
        this.orderStatus = OrderStatus.ACTIVE;
        this.orderItems = new ArrayList<>();
    }

    private void validateCustomer(String customer){
        if(customer == null || customer.isBlank()) throw new DomainException("O nome do cliente não pode ser vazio ou nulo.");
    }

    private void validateTableId(Integer tableId){
        if(tableId == null || tableId < 0) throw new DomainException("O número da mesa não pode ser nulo ou menor que zero.");
    }

    private void validateReview(String review){
        if(review == null || review.isBlank()) throw new DomainException("A review não pode ser vaiza ou nula.");
    }

    public void setCustomer(String customer) {
        validateCustomer(customer);
        this.customer = customer;
    }

    public void setTableId(Integer tableId) {
        validateTableId(tableId);
        this.tableId = tableId;
    }

    public void setReview(String review) {
        validateReview(review);
        this.review = review;
    }
}
