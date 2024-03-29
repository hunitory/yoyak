package com.yoyak.yoyak.medicineEnvelop.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class MedicineSummaryDto {

    private Long medicineSeq;
    private String itemName;
    private String imgPath;

    public MedicineSummaryDto(Long medicineSeq, String itemName, String imgPath) {
        this.medicineSeq = medicineSeq;
        this.itemName = itemName;
        this.imgPath = imgPath;
    }
}
