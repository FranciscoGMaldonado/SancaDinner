package com.ifsp.edu.sanca_dinner.domain.service;

import com.ifsp.edu.sanca_dinner.domain.model.product.Product;
import com.ifsp.edu.sanca_dinner.domain.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class ProductService {

    private ProductRepository productRepository;

    public Product addProduct(String name, BigDecimal price, String description){
        Product newProduct = new Product(null,name, price, description);
        return productRepository.save(newProduct);
    }

    public Optional<Product> findProductById(Integer id){
        return productRepository.findById(id);
    }

    public Product changeProduct(Integer id,String name, BigDecimal price, String description){
        Product product = productRepository.findById(id).orElseThrow();
        product.setName(name);
        product.setPrice(price);
        product.setDescription(description);
        return productRepository.save(product);
    }

    public List<Product> getAllProducts(){
        return productRepository.findAll();
    }

    public void deleteProductById(Integer id){
        productRepository.deleteById(id);
    }
}
