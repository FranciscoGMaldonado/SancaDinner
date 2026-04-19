package com.ifsp.edu.sanca_dinner.controller.product.response;

import java.math.BigDecimal;

public record ProductResponse(
        Integer id,
        String name,
        BigDecimal price,
        String description
) {}