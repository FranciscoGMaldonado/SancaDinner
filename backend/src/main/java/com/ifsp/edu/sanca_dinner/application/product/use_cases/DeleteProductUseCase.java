package com.ifsp.edu.sanca_dinner.application.product.use_cases;

import com.ifsp.edu.sanca_dinner.domain.service.product.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class DeleteProductUseCase {

    private ProductService productService;

    public void execute(Integer productId){
        productService.deleteProductById(productId);
    }
}
