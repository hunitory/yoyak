package com.yoyak.yoyak.medicineDetail.domain;


import com.fasterxml.jackson.annotation.JsonBackReference;
import com.yoyak.yoyak.medicine.domain.Medicine;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "medicine_detail")
public class MedicineDetail {


    @Id
    private Long seq;

    @Column(name = "efficacy", columnDefinition = "TEXT")
    private String efficacy;

    @Column(name = "use_method", columnDefinition = "TEXT")
    private String useMethod;

    @Column(name = "deposit_method", columnDefinition = "TEXT")
    private String depositMethod;

    @Column(name = "atpn_warn", columnDefinition = "TEXT")
    private String atpnWarn;

    @Column(name = "atpn", columnDefinition = "TEXT")
    private String atpn;

    @Column(name = "side_effect", columnDefinition = "TEXT")
    private String sideEffect;

    @Column(name = "chat", length = 255)
    private String chat;

    @Column(name = "print_front", length = 255)
    private String printFront;

    @Column(name = "print_back", length = 255)
    private String printBack;

    @Column(name = "drug_shape", length = 255)
    private String drugShape;

    @Column(name = "color_class1", length = 255)
    private String colorClass1;

    @Column(name = "color_class2", length = 255)
    private String colorClass2;

    @Column(name = "line_front", length = 255)
    private String lineFront;

    @Column(name = "line_back", length = 255)
    private String lineBack;

    @Column(name = "class_name", length = 255)
    private String className;

    @Column(name = "etc_otc_name", length = 255)
    private String etcOtcName;

    @Column(name = "form_code_name", length = 255)
    private String formCodeName;

    @Column(name = "summary", columnDefinition = "TEXT")
    private String summary;

    @OneToOne
    @MapsId
    @JoinColumn(name = "seq")
    @JsonBackReference
    private Medicine medicine;
}
