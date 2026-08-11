package dev.fluttercommunity.flutter_health_connect.converters

import java.time.Instant
import java.time.ZoneOffset

internal object TimeConverters {
    fun toInstant(millis: Long): Instant = Instant.ofEpochMilli(millis)

    fun toEpochMillis(instant: Instant): Long = instant.toEpochMilli()

    fun zoneOffsetSeconds(offset: ZoneOffset?): Int? = offset?.totalSeconds

    fun zoneOffsetFromSeconds(seconds: Int?): ZoneOffset? =
        seconds?.let { ZoneOffset.ofTotalSeconds(it) }

    fun systemZoneOffset(instant: Instant): ZoneOffset =
        ZoneOffset.systemDefault().rules.getOffset(instant)
}
