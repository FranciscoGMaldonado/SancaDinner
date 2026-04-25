package com.ifsp.edu.sanca_dinner.domain.repository.product;

import com.ifsp.edu.sanca_dinner.domain.model.product.Product;

import java.util.List;
import java.util.Optional;

public interface ProductRepository {

    Optional<Product> findById(Integer id);
    Product save(Product product);
    List<Product> findAll();
    void deleteById(Integer id);

}
