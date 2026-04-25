package com.ifsp.edu.sanca_dinner.domain.service.product;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import com.ifsp.edu.sanca_dinner.domain.model.product.Product;
import com.ifsp.edu.sanca_dinner.domain.repository.product.ProductRepository;
import lombok.AllArgsConstructor;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@AllArgsConstructor
public class ProductService {

    private ProductRepository productRepository;

    public Product addProduct(String name, BigDecimal price, String description){
        Product newProduct = new Product(null,name, price, description);
        return productRepository.save(newProduct);
    }

    public Product findProductById(Integer id){
        Product product = productRepository.findById(id).orElseThrow(() -> new DomainException("Produto não encontrado."));
        return product;
    }

    public Product changeProduct(Integer id,String name, BigDecimal price, String description){
        Product product = productRepository.findById(id).orElseThrow(() -> new DomainException("Produto não encontrado."));

        if(name != null) product.setName(name);
        if(price != null) product.setPrice(price);
        if(description != null) product.setDescription(description);
        return productRepository.save(product);
    }

    public List<Product> getAllProducts(){
        return productRepository.findAll();
    }

    public void deleteProductById(Integer id){
        productRepository.findById(id).orElseThrow(() -> new DomainException("Produto não encontrado."));
        productRepository.deleteById(id);
    }
}
