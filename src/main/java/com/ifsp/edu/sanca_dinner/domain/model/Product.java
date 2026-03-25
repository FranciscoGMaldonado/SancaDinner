package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.Getter;
import java.math.BigDecimal;

@Getter
public class Product {

    private Long id;
    private String name;
    private BigDecimal price;
    private String description;

    public Product(Long id, String name, BigDecimal price, String description) {
        this.id = id;
        setName(name);
        setPrice(price);
        setDescription(description);
    }

    private void validateName(String name){
        if(name == null || name.isBlank()) throw new DomainException("O nome do produto não pode ser vazio ou nulo.");
    }

    private void validatePrice(BigDecimal price){
        if(price == null || price.compareTo(BigDecimal.ZERO) <= 0) throw new DomainException("O preço do produto não pode ser menor ou igual a zero, ou nulo.");
    }

    private void validateDescription(String description){
        if(description == null || description.isBlank()) throw new DomainException("A descrição do produto não pode ser vazia ou nula.");
    }

    public void setName(String name) {
        validateName(name);
        this.name = name;
    }

    public void setPrice(BigDecimal price) {
        validatePrice(price);
        this.price = price;
    }

    public void setDescription(String description) {
        validateDescription(description);
        this.description = description;
    }
}



