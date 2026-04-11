package com.ifsp.edu.sanca_dinner.infrastructure.persistance;

import com.ifsp.edu.sanca_dinner.domain.model.product.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JpaProductRepository extends JpaRepository<Product, Integer> {

}
