package com.yoyak.yoyak.medicine.domain;

import static com.querydsl.jpa.JPAExpressions.select;
import static com.yoyak.yoyak.medicine.domain.QMedicine.medicine;
import static com.yoyak.yoyak.medicineDetail.domain.QMedicineDetail.*;

import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicineDetail.domain.QMedicineDetail;
import jakarta.persistence.EntityManager;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public abstract class MedicineRepositoryImpl implements MedicineRepository{

    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    @Autowired
    public MedicineRepositoryImpl(EntityManager em) {
        this.em = em;
        this.queryFactory = new JPAQueryFactory(em);
    }

//    @Override
//    public List<MedicineDto> findByParameter(
//        @Param("drugShape") String drugShape,
//        @Param("colorClass") String colorClass,
//        @Param("formCodeName") String formCodeName,
//        @Param("line") String line
//    ){
//        return queryFactory.select(Projections.constructor(MedicineDto.class, medicine.seq, medicine.imgPath, medicine.itemName, medicine.entpName))
//            .from(medicineDetail)
//            .join(medicineDetail.medicine, medicine)
//            .where( drugShapeEq(drugShape),
//                colorClassEq(colorClass),
//                formCodeNameEq(formCodeName),
//                lineEq(line)
//            )
//            .fetch();
//    }

    private BooleanExpression drugShapeEq(String drugShape) {
        return drugShape != null ? medicineDetail.drugShape.eq(drugShape) : null;
    }

    private BooleanExpression colorClassEq(String colorClass) {
        return colorClass != null ? medicineDetail.colorClass1.eq(colorClass).or(medicineDetail.colorClass2.eq(colorClass)) : null;
    }

    private BooleanExpression formCodeNameEq(String formCodeName) {
        return formCodeName != null ? medicineDetail.formCodeName.like("%" + formCodeName + "%") : null;
    }

    private BooleanExpression lineEq(String line) {
        return line != null ? medicineDetail.lineFront.eq(line).or(medicineDetail.lineBack.eq(line)) : null;
    }

}
