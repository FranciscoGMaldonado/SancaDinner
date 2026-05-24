package com.ifsp.edu.sanca_dinner.domain.model.order;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItem;
import com.ifsp.edu.sanca_dinner.domain.model.order_item.OrderItemStatus;
import jakarta.persistence.*;
import lombok.Getter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

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
    @Column(name = "status")
    private OrderStatus orderStatus;

    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "order_id")
    private List<OrderItem> orderItems = new ArrayList<>();

    protected Order(){}

    public Order(String customerName, Integer tableNumber) {
        setCustomerName(customerName);
        setTableNumber(tableNumber);
        this.orderStatus = OrderStatus.ACTIVE;
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

    private OrderItem findOrderItemById(Integer orderItemId){
        return this.orderItems.stream().
                filter(item -> item.getId().equals(orderItemId)).
                findFirst().
                orElseThrow(() -> new DomainException("Item da comanda não encontrado."));
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
        if(this.orderStatus == OrderStatus.FINISHED) throw new DomainException("A comanda já foi finalizada.");
        orderItems.add(newOrderItem);
    }

    public void closeOrder(String review){
        if(review != null && review.length() > 100) throw new DomainException("A review não pode ser superior a 100 caracteres.");
        var nonFinishedOrderItem = orderItems.stream().
                filter(item -> item.getOrderItemStatus() != OrderItemStatus.DELIVERED && item.getOrderItemStatus() != OrderItemStatus.CANCELED).
                findAny();
        if(nonFinishedOrderItem.isPresent()) throw new DomainException("A comanda não pode ser finalizada se algum item ainda está pendente, ou não foi entregue.");
        this.review = review;
        this.orderStatus = OrderStatus.FINISHED;
    }

    public void changeOrderItem(Integer orderItemId, String newSpecification){
        var orderItem = findOrderItemById(orderItemId);
        if(orderItem.getOrderItemStatus() != OrderItemStatus.PENDING) throw new DomainException("Apenas é possivel alterar itens que estão pendentes.");
        orderItem.setSpecification(newSpecification);
    }

    public void cancelOrderItem(Integer orderItemId){
        var orderItem = findOrderItemById(orderItemId);
        orderItem.cancelOrderItem();
    }

    public void progressOrderItem(Integer orderItemId){
        var orderItem = findOrderItemById(orderItemId);
        orderItem.progressStatus();
    }

    public BigDecimal getTotal(){
        return this.orderItems.stream()
                .filter(item -> item.getOrderItemStatus() != OrderItemStatus.CANCELED)
                .map(OrderItem::getProductPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}