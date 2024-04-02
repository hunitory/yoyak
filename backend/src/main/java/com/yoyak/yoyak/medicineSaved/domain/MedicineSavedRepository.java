package com.yoyak.yoyak.medicineSaved.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface MedicineSavedRepository extends JpaRepository<MedicineSaved, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM MedicineSaved ms WHERE ms.medicineEnvelop.seq = :envelopSeq AND ms.medicine.seq = :itemSeq")
    void deleteByMedicineEnvelopSeqAndMedicineSeq(Long envelopSeq, Long itemSeq);

}
