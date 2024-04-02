package com.yoyak.yoyak.medicineSaved.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@Builder
@ToString
public class MedicineFromEnvelopeRemovalDto {

    private Long accountSeq;
    private Long medicineSeq;
    private Long envelopeSeq;
}
