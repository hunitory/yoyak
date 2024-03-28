package com.yoyak.yoyak.util.server;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api2/test")
public class ServerController {

    @Value("${serverInfo}")
    private String serverInfo;
    @Value("${dbInfo}")
    private String dbInfo;
    @Value("${server.env}")
    private String env;
    private Integer visitedCount = 0;

    @GetMapping("/info")
    public ResponseEntity<Map<String, String>> getServerInfo() {
        visitedCount++;

        Map<String, String> info = new HashMap<>();
        info.put("serverInfo:", serverInfo);
        info.put("visitedCount:", visitedCount.toString());
        info.put("dbInfo", dbInfo);
        info.put("env:", env);

        return ResponseEntity.ok(info);
    }

    @GetMapping("/env")
    public String getEnv() {
        return env;
    }
}
