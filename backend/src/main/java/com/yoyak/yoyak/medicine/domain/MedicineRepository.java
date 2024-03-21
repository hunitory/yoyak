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
            + " FROM Medicine m JOIN m.medicineDetail md "
            + "WHERE "
            + "  (COALESCE(:searchName, null) IS NULL OR m.itemName LIKE CONCAT('%', :searchName, '%')) AND "
            + "  (COALESCE(:drugShape, null) IS NULL OR md.drugShape = :drugShape) AND "
            + "  (COALESCE(:colorClass, null) IS NULL OR md.colorClass1 = :colorClass OR md.colorClass2 = :colorClass) AND "
            + "  (COALESCE(:formCodeName, null) IS NULL OR md.formCodeName = :formCodeName) AND "
            + "  (COALESCE(:line, null) IS NULL OR md.lineFront = :line OR md.lineBack = :line)")
    List<MedicineDto> findByParameters(
        @Param("searchName") String searchName,
        @Param("drugShape") String drugShape,
        @Param("colorClass") String colorClass,
        @Param("formCodeName") String formCodeName,
        @Param("line") String line);
}