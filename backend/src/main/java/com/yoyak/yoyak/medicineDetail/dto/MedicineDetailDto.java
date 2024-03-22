package com.yoyak.yoyak.medicineDetail.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class MedicineDetailDto {

    Long medicineSeq;
    String imagePath;
    String itemName;
    String entpName;
    String efficacy;
    String useMethod;
    String depositMethod;
    String atpnWarn;
    String atpn;
    String sideEffect;
    String summary;
}
