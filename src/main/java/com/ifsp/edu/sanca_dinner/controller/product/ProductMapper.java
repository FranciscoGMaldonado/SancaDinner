package com.ifsp.edu.sanca_dinner.controller.product;

import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import com.ifsp.edu.sanca_dinner.domain.model.product.Product;
import lombok.NoArgsConstructor;

@NoArgsConstructor
public class ProductMapper {

    public ProductResponse productToResponse(Product product){
        return new ProductResponse(product.getId(), product.getName(), product.getPrice(), product.getDescription());
    }
}
