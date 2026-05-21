package com.ifsp.edu.sanca_dinner.application.product.use_cases;

import com.ifsp.edu.sanca_dinner.application.product.mapper.ProductMapper;
import com.ifsp.edu.sanca_dinner.controller.product.request.CreateProductRequest;
import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import com.ifsp.edu.sanca_dinner.domain.service.product.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class CreateProductUseCase {

    private ProductService productService;
    private ProductMapper productMapper;

    public ProductResponse execute(CreateProductRequest request){
        var newProduct = productService.addProduct(request.name(), request.price(), request.description());
        return productMapper.productToResponse(newProduct);
    }
}
