package com.wajhat.aldeen

import android.content.Context
import androidx.glance.*
import androidx.glance.action.actionStartActivity
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.*
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.color.ColorProvider
import android.graphics.Color
import androidx.glance.appwidget.cornerRadius
import es.antonborri.home_widget.HomeWidgetPlugin

class IslamicGlanceWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = HomeWidgetPlugin.getData(context)
        val prayerName = prefs.getString("next_prayer_name", "العشاء") ?: "العشاء"
        val prayerTime = prefs.getString("next_prayer_time", "00:00") ?: "00:00"
        val countdown = prefs.getString("prayer_countdown", "0د") ?: "0د"
        val hijriDate = prefs.getString("hijri_date", "") ?: ""
        val verse = prefs.getString("current_verse", "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ") ?: ""
        val dhikr = prefs.getString("current_dhikr", "") ?: ""
        val batteryLevel = prefs.getInt("battery_level", 100)
        val yearProgress = prefs.getFloat("year_progress", 0f)
        val gregorianDate = prefs.getString("gregorian_date", "") ?: ""
        val dayName = prefs.getString("day_name", "") ?: ""
        val currentTime = prefs.getString("current_time", "") ?: ""

        provideContent {
            Box(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(ColorProvider(Color.parseColor("#0B0C10")))
                    .padding(8.dp)
            ) {
                Column(
                    modifier = GlanceModifier.fillMaxSize(),
                    verticalAlignment = Alignment.Top,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    // Day & Gregorian Date Card
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .background(ColorProvider(Color.parseColor("#1F2833")))
                            .cornerRadius(24)
                            .padding(12.dp)
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Text(
                                text = dayName,
                                style = TextStyle(
                                    color = ColorProvider(Color.parseColor("#C9A84C")),
                                    fontSize = 22.sp
                                )
                            )
                            Text(
                                text = currentTime,
                                style = TextStyle(
                                    color = ColorProvider(Color.WHITE),
                                    fontSize = 32.sp
                                )
                            )
                            Text(
                                text = gregorianDate,
                                style = TextStyle(
                                    color = ColorProvider(Color.parseColor("#EAEAEA")),
                                    fontSize = 13.sp
                                )
                            )
                        }
                    }

                    Spacer(modifier = GlanceModifier.height(8.dp))

                    // Hijri Date Card
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .background(ColorProvider(Color.parseColor("#1A331E")))
                            .cornerRadius(24)
                            .padding(12.dp)
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = GlanceModifier.fillMaxWidth()
                        ) {
                            Text(
                                text = hijriDate,
                                style = TextStyle(
                                    color = ColorProvider(Color.WHITE),
                                    fontSize = 20.sp
                                )
                            )
                        }
                    }

                    Spacer(modifier = GlanceModifier.height(8.dp))

                    // Prayer Times Card
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .background(ColorProvider(Color.parseColor("#0B1D33")))
                            .cornerRadius(24)
                            .padding(12.dp)
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Text(
                                text = prayerName,
                                style = TextStyle(
                                    color = ColorProvider(Color.parseColor("#C9A84C")),
                                    fontSize = 18.sp
                                )
                            )
                            Text(
                                text = prayerTime,
                                style = TextStyle(
                                    color = ColorProvider(Color.WHITE),
                                    fontSize = 28.sp
                                )
                            )
                            Text(
                                text = "متبقي $countdown",
                                style = TextStyle(
                                    color = ColorProvider(Color.parseColor("#EAEAEA")),
                                    fontSize = 13.sp
                                )
                            )
                        }
                    }

                    Spacer(modifier = GlanceModifier.height(8.dp))

                    // Verse Card
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .background(ColorProvider(Color.parseColor("#142416")))
                            .cornerRadius(24)
                            .padding(12.dp)
                    ) {
                        Text(
                            text = "﴿ $verse ﴾",
                            style = TextStyle(
                                color = ColorProvider(Color.WHITE),
                                fontSize = 16.sp
                            ),
                            maxLines = 3
                        )
                    }

                    Spacer(modifier = GlanceModifier.height(8.dp))

                    // Dhikr Card
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .background(ColorProvider(Color.parseColor("#2C3539")))
                            .cornerRadius(24)
                            .padding(12.dp)
                    ) {
                        Text(
                            text = dhikr,
                            style = TextStyle(
                                color = ColorProvider(Color.parseColor("#EAEAEA")),
                                fontSize = 14.sp
                            ),
                            maxLines = 3
                        )
                    }

                    Spacer(modifier = GlanceModifier.height(8.dp))

                    // Stats Card
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .background(ColorProvider(Color.parseColor("#1F2833")))
                            .cornerRadius(24)
                            .padding(12.dp)
                    ) {
                        Row(
                            modifier = GlanceModifier.fillMaxWidth(),
                            horizontalAlignment = Alignment.CenterHorizontally,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                text = "البطارية $batteryLevel%",
                                style = TextStyle(
                                    color = ColorProvider(Color.parseColor("#C9A84C")),
                                    fontSize = 13.sp
                                )
                            )
                            Spacer(modifier = GlanceModifier.width(16.dp))
                            Text(
                                text = "السنة ${(yearProgress * 100).toInt()}%",
                                style = TextStyle(
                                    color = ColorProvider(Color.parseColor("#EAEAEA")),
                                    fontSize = 13.sp
                                )
                            )
                        }
                    }
                }
            }
        }
    }
}
