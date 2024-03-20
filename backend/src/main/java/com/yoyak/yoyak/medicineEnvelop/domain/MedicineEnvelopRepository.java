package com.yoyak.yoyak.medicineEnvelop.domain;

import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopDto;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineSummaryDto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface MedicineEnvelopRepository extends JpaRepository<MedicineEnvelop, Long> {

    @Query(
        "SELECT new com.yoyak.yoyak.medicineEnvelop.dto.MedicineSummaryDto(m.medicine.seq, m.medicine.itemName, m.medicine.imgPath) "
            + "FROM MedicineSaved m WHERE m.medicineEnvelop.seq = :medicineEnvelopSeq")
    List<MedicineSummaryDto> findMedicineSummaryByEnvelopSeq(Long medicineEnvelopSeq);

    /*
        @Query(
            "SELECT new com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopDto(m.seq, m.name, m.color, a.seq, a.nickname) "
                + "FROM MedicineEnvelop m "
                + "JOIN m.account a "
                + "WHERE a.seq = :userSeq")
        */
/*
    @Query("SELECT new com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopDto(" +
        "m.seq, m.name, m.color, a.seq, a.nickname, " +
        "CASE WHEN ms.seq IS NOT NULL THEN true ELSE false END) " +
        "FROM MedicineEnvelop m " +
        "JOIN m.account a " +
        "LEFT JOIN m.medicinesSavedList ms " +
        "WITH ms.medicine IS NOT NULL " +
        "WHERE a.seq = :userSeq")
        */
    @Query("SELECT new com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopDto("
        + "m.seq, m.name, m.color, a.seq, a.nickname, "
        + "     (SELECT CASE WHEN COUNT(ms) > 0 THEN true ELSE false END "
        + "         FROM MedicineSaved ms "
        + "         WHERE ms.medicine.seq = :itemSeq AND ms.medicineEnvelop.seq = m.seq"
        + "     )) "
        + "FROM MedicineEnvelop m "
        + "JOIN m.account a "
        + "WHERE a.seq = :userSeq")
    List<MedicineEnvelopDto> findMedicineEnvelopByAccountSeq(Long userSeq, Long itemSeq);
}
