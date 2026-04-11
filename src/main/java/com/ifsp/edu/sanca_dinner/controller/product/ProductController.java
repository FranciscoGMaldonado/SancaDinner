package com.ifsp.edu.sanca_dinner.controller.product;

import com.ifsp.edu.sanca_dinner.controller.product.request.CreateProductRequest;
import com.ifsp.edu.sanca_dinner.domain.model.product.Product;
import com.ifsp.edu.sanca_dinner.domain.service.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/products")
@AllArgsConstructor
public class ProductController {

    private ProductService productService;

    @PostMapping
    public ResponseEntity<Product> create(@RequestBody CreateProductRequest request){
        var newProduct = productService.addProduct(request.name(), request.price(), request.description());
        return  ResponseEntity.status(HttpStatus.CREATED).body(newProduct);
    }

}
