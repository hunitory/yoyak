package com.yoyak.yoyak.medicine.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Medicine {
    
    @Id
    @Column(name = "seq")
    private Long seq;

    @Column(name = "item_name", length = 500)
    private String itemName;

    @Column(name = "entp_name", length = 255)
    private String entpName;

    @Column(name = "img_path", length = 500)
    private String imgPath;

    @OneToOne(mappedBy = "medicine")
    @JsonManagedReference
    private MedicineDetail medicineDetail;
}
