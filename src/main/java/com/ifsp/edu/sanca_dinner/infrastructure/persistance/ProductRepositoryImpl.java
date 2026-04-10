package com.ifsp.edu.sanca_dinner.infrastructure.persistance;

import com.ifsp.edu.sanca_dinner.domain.model.Product;
import com.ifsp.edu.sanca_dinner.domain.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class ProductRepositoryImpl implements ProductRepository {

    private final JpaProductRepository jpaRepository;

    @Override
    public Optional<Product> findById(Integer id) {
        return jpaRepository.findById(id);
    }

    @Override
    public Product save(Product product) {
        return jpaRepository.save(product);
    }

    @Override
    public List<Product> findAll() {
        return jpaRepository.findAll();
    }

}
