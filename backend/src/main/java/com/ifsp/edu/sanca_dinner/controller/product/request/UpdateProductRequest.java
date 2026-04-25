package com.ifsp.edu.sanca_dinner.controller.product.request;

import java.math.BigDecimal;

public record UpdateProductRequest(
        Integer productId,
        String name,
        BigDecimal price,
        String description
) {}
