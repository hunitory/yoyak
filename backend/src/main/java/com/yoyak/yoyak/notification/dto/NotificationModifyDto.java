package com.yoyak.yoyak.notification.dto;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationModifyDto {

    private Long notiSeq;
    private String name;
    private LocalDate startDate;
    private LocalDate endDate;
    private List<DayOfWeek> period;
    private List<LocalTime> time;
}
