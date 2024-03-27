package com.yoyak.yoyak.medicineDetail.domain;

import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicine.domain.MedicineRepository;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@AutoConfigureMockMvc
public class MongoTest {

    @Autowired
    @Mock
    private MedicineRepository medicineRepository;

    @Autowired
    @Mock
    private MedicineDetailRepository medicineDetailRepository;

    
    @Value("${cloud.aws.s3.prefix}")
    private String s3Prefix;

    @Test
    public void s3Test() {
        List<Medicine> medicineList = medicineRepository.findAll();
        Medicine medicine1 = medicineList.get(4270);
        String url = s3Prefix + medicine1.getImgPath();
        System.out.println("url = " + url);


    }

}
