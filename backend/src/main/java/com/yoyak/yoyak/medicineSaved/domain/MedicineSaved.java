package com.yoyak.yoyak.medicineSaved.domain;

import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelop;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class MedicineSaved {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer seq;

    @JoinColumn(name = "account_seq")
    private Long accountSeq;

    @ManyToOne
    @JoinColumn(name = "medicine_envelop_seq", referencedColumnName = "seq")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private MedicineEnvelop medicineEnvelop;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "item_seq", referencedColumnName = "seq")
    private Medicine medicine;

    @Builder
    public MedicineSaved(Long accountSeq, MedicineEnvelop medicineEnvelop, Medicine medicine) {
        this.accountSeq = accountSeq;
        this.medicineEnvelop = medicineEnvelop;
        this.medicine = medicine;
    }
}
