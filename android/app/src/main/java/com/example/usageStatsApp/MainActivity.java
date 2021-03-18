package com.example.usageStatsApp;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


import android.app.usage.UsageEvents;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import static android.content.Context.BATTERY_SERVICE;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/battery";

    private static final String GETSTATS = "myFlutter/getstats";

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
          .setMethodCallHandler(
            (call, result) -> {
                // Note: this method is invoked on the main thread.
            if (call.method.equals("getBatteryLevel")) {
               int batteryLevel = getBatteryLevel();
                // if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
                //     getStatistics(1000);
                // }
               if (batteryLevel != -1) {
                 result.success(batteryLevel);
               } else {
                 result.error("UNAVAILABLE", "Battery level not available.", null);
               }
              } else {
                result.notImplemented();
              }
            }
          );
    }

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    UsageEvents getStatistics(long duration){
      UsageStatsManager usageStatsManager = (
              UsageStatsManager) getContext().getSystemService(getContext().USAGE_STATS_SERVICE);
      int interval = UsageStatsManager.INTERVAL_BEST;
      Calendar calendar = Calendar.getInstance();
      long endTime = calendar.getTimeInMillis();
      calendar.add(Calendar.DATE, -1);
//        long start = calendar.getTimeInMillis();
//        long end = System.currentTimeMillis();
        System.out.println("duration given is"+duration);
        LocalDate localDate = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            localDate = LocalDate.parse("2018-06-23");
            LocalDateTime startOfDay = localDate.atTime(LocalTime.MAX);
        }

        long currentTime = System.currentTimeMillis();
            UsageEvents usageEvents = usageStatsManager.queryEvents(currentTime,currentTime+40000);
            System.out.println(usageEvents.toString());
            return  usageEvents;
    }


    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }
}
