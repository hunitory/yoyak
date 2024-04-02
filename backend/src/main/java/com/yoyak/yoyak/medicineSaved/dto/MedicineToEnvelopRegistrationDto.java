package com.yoyak.yoyak.medicineSaved.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@Builder
@ToString
public class MedicineToEnvelopRegistrationDto {

    private Long accountSeq;
    private Long medicineSeq;
    private Long envelopeSeq;
}
