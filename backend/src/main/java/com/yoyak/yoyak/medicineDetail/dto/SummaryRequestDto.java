package com.yoyak.yoyak.medicineDetail.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@ToString
public class SummaryRequestDto {

    private String itemName;
    private String atpn;
    private String efficacy;
    private String useMethod;
    private String depositMethod;
    private String sideEffect;
}
