package com.yoyak.yoyak.medicineEnvelop.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.medicineSaved.domain.MedicineSaved;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@ToString
public class MedicineEnvelop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @Column(name = "name")
    private String name;

    @Column(name = "color")
    private String color;

    @ManyToOne
    @JoinColumn(name = "account_seq", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonBackReference
    private Account account;

    @OneToMany(mappedBy = "medicineEnvelop")
    private List<MedicineSaved> medicinesSavedList;

    @Builder
    public MedicineEnvelop(String name, String color, Account account) {
        this.name = name;
        this.color = color;
        this.account = account;
    }
}
