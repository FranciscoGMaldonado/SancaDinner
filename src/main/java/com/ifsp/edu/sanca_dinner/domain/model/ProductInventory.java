package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.Getter;
import lombok.Setter;

@Getter
public class ProductInventory {
    private Product product;
    private Integer quantity;

    public ProductInventory(Product product, Integer quantity) {
        this.product = product;
    }

    private void validateQuantity(Integer quantity){
        if(quantity == null || quantity < 0) throw new DomainException("A quantidade não pode ser negativa ou nula.");
    }
}
