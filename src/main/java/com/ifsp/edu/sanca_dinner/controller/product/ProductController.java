package com.ifsp.edu.sanca_dinner.controller.product;

import com.ifsp.edu.sanca_dinner.controller.product.request.CreateProductRequest;
import com.ifsp.edu.sanca_dinner.controller.product.request.UpdateProductRequest;
import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import com.ifsp.edu.sanca_dinner.domain.service.product.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/products")
@AllArgsConstructor
public class ProductController {

    private ProductService productService;
    private ProductMapper productMapper;

    @PostMapping
    public ResponseEntity<ProductResponse> create(@RequestBody CreateProductRequest request){
        var newProduct = productService.addProduct(request.name(), request.price(), request.description());
        var response = productMapper.productToResponse(newProduct);
        return  ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping
    public ResponseEntity<List<ProductResponse>> getAll(){
        var products = productService.getAllProducts();
        var response = products.stream()
                .map(productMapper::productToResponse)
                .collect(Collectors.toList());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @GetMapping("/{productId}")
    public ResponseEntity<ProductResponse> getById(@PathVariable Integer productId){
        var product = productService.findProductById(productId);
        var response = productMapper.productToResponse(product);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PutMapping
    public ResponseEntity<ProductResponse> updateProduct(@RequestBody UpdateProductRequest request){
        var updatedProduct = productService.changeProduct(request.productId(),request.name(),request.price(),request.description());
        var response = productMapper.productToResponse(updatedProduct);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @DeleteMapping("/{productId}")
    public ResponseEntity<Void> deleteProductById(@PathVariable Integer productId){
        productService.deleteProductById(productId);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
