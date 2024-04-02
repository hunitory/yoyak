package com.yoyak.yoyak.medicine.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@ToString
public class MedicineSearchParametersDto {

    private String searchName;
    private String drugShape;
    private String colorClass;
    private String formCodeName;
    private String line;
}
