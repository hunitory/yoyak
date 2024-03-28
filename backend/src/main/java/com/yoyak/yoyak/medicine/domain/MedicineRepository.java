package com.yoyak.yoyak.medicine.domain;

import com.yoyak.yoyak.medicine.dto.MedicineDto;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface MedicineRepository extends JpaRepository<Medicine, Long> {

    Optional<Medicine> findBySeq(Long seq);

    @Query(
        "SELECT new com.yoyak.yoyak.medicine.dto.MedicineDto(m.seq, m.imgPath, m.itemName, m.entpName)"
            + " FROM Medicine m JOIN m.medicineDetail md "
            + "WHERE "
            + "  (COALESCE(:searchName, null) IS NULL OR m.itemName LIKE CONCAT('%', :searchName, '%')) AND "
            + "  (COALESCE(:drugShape, null) IS NULL OR md.drugShape = :drugShape) AND "
            + "  (COALESCE(:colorClass, null) IS NULL OR md.colorClass1 = :colorClass OR md.colorClass2 = :colorClass) AND "
            + "  (COALESCE(:formCodeName, null) IS NULL OR ("
            + "     (:formCodeName = '정제류'   AND md.formCodeName IN ('필름코팅정', '나정', '당의정', '장용성필름코팅정', '장용성당의정', '추어블정(저작정)', '다층정', '서방성필름코팅정', '서방정', '장용정', '발포정', '유핵정', '질정', '트로키제')) OR "
            + "     (:formCodeName = '경질캡슐' AND md.formCodeName IN ('경질캡슐제|산제', '경질캡슐제|과립제', '경질캡슐제|정제', '젤라틴코팅성경질캡슐제')) OR "
            + "     (:formCodeName = '연질캡슐' AND md.formCodeName IN ('연질캡슐제|현탁상', '연질캡슐제|액상', '장용성필름코팅캡슐제')) OR "
            + "     (:formCodeName = '기타' AND md.formCodeName IN ('장용성캡슐제|펠렛', '장용성캡슐제|정제', '껌제', '서방성캡슐제|펠렛', '지지체가있는첩부제', '구강붕해필름'))"
            + "  )) AND "
            + "  (COALESCE(:line, null) IS NULL OR md.lineFront = :line OR md.lineBack = :line)")
    List<MedicineDto> findByParameters(
        @Param("searchName") String searchName,
        @Param("drugShape") String drugShape,
        @Param("colorClass") String colorClass,
        @Param("formCodeName") String formCodeName,
        @Param("line") String line);
}