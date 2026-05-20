package com.ifsp.edu.sanca_dinner.controller.product;

import com.ifsp.edu.sanca_dinner.application.product.mapper.ProductMapper;
import com.ifsp.edu.sanca_dinner.application.product.use_cases.CreateProductUseCase;
import com.ifsp.edu.sanca_dinner.application.product.use_cases.GetAllProductsUseCase;
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
    private CreateProductUseCase createProductUseCase;
    private GetAllProductsUseCase getAllProductsUseCase;

    @PostMapping
    public ResponseEntity<ProductResponse> create(@RequestBody CreateProductRequest request){
        return  ResponseEntity.status(HttpStatus.CREATED).body(createProductUseCase.execute(request));
    }

    @GetMapping
    public ResponseEntity<List<ProductResponse>> getAll(){
        return ResponseEntity.status(HttpStatus.OK).body(getAllProductsUseCase.execute());
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
