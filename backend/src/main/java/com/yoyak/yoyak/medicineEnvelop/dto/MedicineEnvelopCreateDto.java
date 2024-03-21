package com.yoyak.yoyak.medicineEnvelop.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Builder
@Setter
@Getter
@ToString
public class MedicineEnvelopCreateDto {

    private Long accountSeq;
    private String name;
    private String color;
}
