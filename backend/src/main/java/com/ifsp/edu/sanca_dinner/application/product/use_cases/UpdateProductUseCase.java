package com.ifsp.edu.sanca_dinner.application.product.use_cases;

import com.ifsp.edu.sanca_dinner.application.product.mapper.ProductMapper;
import com.ifsp.edu.sanca_dinner.controller.product.request.UpdateProductRequest;
import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import com.ifsp.edu.sanca_dinner.domain.service.product.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class UpdateProductUseCase {

    private ProductService productService;
    private ProductMapper productMapper;

    public ProductResponse execute(UpdateProductRequest request){
        var updatedProduct = productService.changeProduct(request.productId(),request.name(),request.price(),request.description());
        return productMapper.productToResponse(updatedProduct);
    }
}
