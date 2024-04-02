package com.yoyak.yoyak.medicine.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@ToString
@Builder
public class MedicineDto {

    private Long medicineSeq;
    private String imgPath;
    private String itemName;
    private String entpName;
}
