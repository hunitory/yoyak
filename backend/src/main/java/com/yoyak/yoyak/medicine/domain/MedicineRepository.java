package com.yoyak.yoyak.medicine.domain;

import com.yoyak.yoyak.medicine.dto.MedicineDto;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface MedicineRepository extends JpaRepository<Medicine, Integer> {

    Optional<Medicine> findBySeq(Long Seq);

    @Query(
        "SELECT new com.yoyak.yoyak.medicine.dto.MedicineDto(m.seq, m.imgPath, m.itemName, m.entpName)"
            + " FROM MedicineDetail md JOIN md.medicine m "
            + "WHERE md.drugShape = :drugShape "
            + "AND (:colorClass IS NULL OR md.colorClass1 = :colorClass OR md.colorClass2 = :colorClass) "
            + "AND (:formCodeName IS NULL OR md.formCodeName LIKE CONCAT('%', :formCodeName, '%')) "
            + "AND (:line IS NULL OR md.lineFront = :line OR md.lineBack = :line)")
    List<MedicineDto> findByParameter(
        @Param("drugShape") String drugShape,
        @Param("colorClass") String colorClass,
        @Param("formCodeName") String formCodeName,
        @Param("line") String line
    );


}
