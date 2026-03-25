package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.Getter;
import lombok.Setter;

@Getter
public class ProductInventory {
    private Product product;
    private Integer quantity;

    public ProductInventory(Product product, Integer quantity) {
        validateProduct(product);
        this.product = product;
        setQuantity(quantity);
    }

    private void validateProduct(Product product){
        if(product == null) throw new DomainException("O produto não pode ser nulo.");
    }

    private void validateQuantity(Integer quantity){
        if(quantity == null || quantity < 0) throw new DomainException("A quantidade não pode ser negativa ou nula.");
    }

    public void setQuantity(Integer quantity) {
        validateQuantity(quantity);
        this.quantity = quantity;
    }
}
