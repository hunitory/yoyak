package com.yoyak.yoyak.medicine.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class MedicineFullTextDto {

    @JsonProperty("seq")
    private Long medicineSeq;

    @JsonProperty("img_path")
    private String imgPath;

    @JsonProperty("item_name")
    private String itemName;

    @JsonProperty("entp_name")
    private String entpName;

    @JsonProperty("atpn")
    private String atpn;

    @JsonProperty("atpn_warn")
    private String atpnWarn;

    @JsonProperty("chat")
    private String chat;

    @JsonProperty("class_name")
    private String className;

    @JsonProperty("color_class1")
    private String colorClass1;

    @JsonProperty("color_class2")
    private String colorClass2;

    @JsonProperty("deposit_method")
    private String depositMethod;

    @JsonProperty("drug_shape")
    private String drugShape;

    @JsonProperty("efficacy")
    private String efficacy;

    @JsonProperty("etc_otc_name")
    private String etcOtcName;

    @JsonProperty("form_code_name")
    private String formCodeName;

    @JsonProperty("line_back")
    private String lineBack;

    @JsonProperty("line_front")
    private String lineFront;

    @JsonProperty("print_back")
    private String printBack;

    @JsonProperty("print_front")
    private String printFront;

    @JsonProperty("side_effect")
    private String sideEffect;

    @JsonProperty("use_method")
    private String useMethod;
}
