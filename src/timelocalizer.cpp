#include "timelocalizer.h"

TimeLocalizer::TimeLocalizer(QObject *parent) :
    QObject(parent)
{
    m_ianaId = QString();
    m_hoursOffset = 0;
    m_minutesOffset = 0;
    m_useIanaId = false;
    timezone = QTimeZone();
}

QDateTime TimeLocalizer::getTime()
{
    if(m_useIanaId) {
        if(timezone.isValid()) {
            QDateTime d = QDateTime::currentDateTime().toTimeZone(timezone);
            QDate convertedDate = QDate(d.date().year(), d.date().month(), d.date().day());
            QTime convertedTime = QTime(d.time().hour(), d.time().minute(), d.time().second()); //javascript automatically converts to current time zone
            QDateTime convertedDateTime = QDateTime(convertedDate, convertedTime);
            return convertedDateTime;
        }
    }
    else {
        QDateTime d = QDateTime::currentDateTime().toUTC().addSecs(60*60*m_hoursOffset + 60*m_minutesOffset);
        QDate convertedDate = QDate(d.date().year(), d.date().month(), d.date().day());
        QTime convertedTime = QTime(d.time().hour(), d.time().minute(), d.time().second()); //javascript automatically converts to current time zone
        QDateTime convertedDateTime = QDateTime(convertedDate, convertedTime);
        return convertedDateTime;
    }
}

QString TimeLocalizer::getTimeText()
{
    if(m_useIanaId) {
        if(timezone.isValid()) {
            QDateTime d = QDateTime::currentDateTime().toTimeZone(timezone);
            QDate convertedDate(d.date().year(), d.date().month(), d.date().day());
            QTime convertedTime(d.time().hour(), d.time().minute());
            QDateTime convertedDateTime = QDateTime(convertedDate, convertedTime);
            return "test";
        }
    }
    else {
        QDateTime time = QDateTime::currentDateTime().addSecs(60*60*m_hoursOffset + 60*m_minutesOffset);
        return time.toString();
    }
}

QString TimeLocalizer::ianaId()
{
    return m_ianaId;
}

void TimeLocalizer::setIanaId(const QString &ianaId)
{
    if(m_ianaId != ianaId) {
        m_ianaId = ianaId;
        timezone = QTimeZone(ianaId.toLocal8Bit());
        ianaIdChanged();
    }
}

int TimeLocalizer::hoursOffset()
{
    return m_hoursOffset;
}

void TimeLocalizer::setHoursOffset(const int &hoursOffset)
{
    if(m_hoursOffset != hoursOffset) {
        m_hoursOffset = hoursOffset;
        hoursOffsetChanged();
    }
}

int TimeLocalizer::minutesOffset()
{
    return m_minutesOffset;
}

void TimeLocalizer::setMinutesOffset(const int &minutesOffset)
{
    if(m_minutesOffset != minutesOffset) {
        m_minutesOffset = minutesOffset;
        minutesOffsetChanged();
    }
}

bool TimeLocalizer::useIanaId()
{
    return m_useIanaId;
}

void TimeLocalizer::setUseIanaId(const bool &useIanaId)
{
    if(m_useIanaId != useIanaId) {
        m_useIanaId = useIanaId;
        useIanaIdChanged();
    }
}

QString TimeLocalizer::getOffsetText()
{
    if(m_useIanaId) {
        //calculate from timezone
        int calculatedOffsetSeconds = timezone.offsetFromUtc(QDateTime::currentDateTime());
        int calculatedOffsetHours = calculatedOffsetSeconds/3600;
        QString hoursText = QString();
        if(calculatedOffsetHours > 0) {
            hoursText = "+" + QString::number(calculatedOffsetHours);
        } else {
            hoursText = QString::number(calculatedOffsetHours);
        }
        int calculatedOffsetMinutes = (calculatedOffsetSeconds - calculatedOffsetHours*3600)/60;
        QString minutesText = QString::number(abs(calculatedOffsetMinutes));
        if(calculatedOffsetHours == 0 && calculatedOffsetMinutes == 0) {
            return "";
        } else if(calculatedOffsetMinutes == 0) {
            return hoursText;
        } else {
            return hoursText + ":" + minutesText;
        }
    }
    else {
        QString hoursText = QString();
        if(m_hoursOffset > 0) {
            hoursText = "+" + QString::number(m_hoursOffset);
        } else {
            hoursText = QString::number(m_hoursOffset);
        }
        QString minutesText = QString::number(abs(m_minutesOffset));
        if(m_hoursOffset == 0 && m_minutesOffset == 0) {
            return "";
        } else if(m_minutesOffset == 0) {
            return hoursText;
        } else {
            return hoursText + ":" + minutesText;
        }
    }
}
