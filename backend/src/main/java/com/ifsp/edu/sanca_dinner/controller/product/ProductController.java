package com.ifsp.edu.sanca_dinner.controller.product;

import com.ifsp.edu.sanca_dinner.application.product.use_cases.*;
import com.ifsp.edu.sanca_dinner.controller.product.request.CreateProductRequest;
import com.ifsp.edu.sanca_dinner.controller.product.request.UpdateProductRequest;
import com.ifsp.edu.sanca_dinner.controller.product.response.ProductResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
@AllArgsConstructor
public class ProductController {

    private CreateProductUseCase createProductUseCase;
    private GetAllProductsUseCase getAllProductsUseCase;
    private GetProductByIdUseCase getProductByIdUseCase;
    private UpdateProductUseCase updateProductUseCase;
    private DeleteProductUseCase deleteProductUseCase;

    @PreAuthorize("hasAnyRole('ADMIN')")
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
        return ResponseEntity.status(HttpStatus.OK).body(getProductByIdUseCase.execute(productId));
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @PutMapping
    public ResponseEntity<ProductResponse> updateProduct(@RequestBody UpdateProductRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(updateProductUseCase.execute(request));
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @DeleteMapping("/{productId}")
    public ResponseEntity<Void> deleteProductById(@PathVariable Integer productId){
        deleteProductUseCase.execute(productId);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
