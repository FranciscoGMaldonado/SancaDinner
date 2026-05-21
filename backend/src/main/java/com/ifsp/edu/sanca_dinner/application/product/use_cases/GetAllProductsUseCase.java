package com.ifsp.edu.sanca_dinner.application.product.use_cases;

import com.ifsp.edu.sanca_dinner.application.product.mapper.ProductMapper;
import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import com.ifsp.edu.sanca_dinner.domain.service.product.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@AllArgsConstructor
public class GetAllProductsUseCase {

    private ProductService productService;
    private ProductMapper productMapper;

    public List<ProductResponse> execute(){
        var products = productService.getAllProducts();
        return  products.stream()
                .map(productMapper::productToResponse)
                .collect(Collectors.toList());
    }
}
