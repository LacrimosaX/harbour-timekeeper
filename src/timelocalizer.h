#ifndef TIMELOCALIZER_H
#define TIMELOCALIZER_H

#include <QObject>
#include <QDateTime>
#include <QTimeZone>
#include <QDebug>

class TimeLocalizer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ianaId READ ianaId WRITE setIanaId NOTIFY ianaIdChanged)
    Q_PROPERTY(int hoursOffset READ hoursOffset WRITE setHoursOffset NOTIFY hoursOffsetChanged)
    Q_PROPERTY(int minutesOffset READ minutesOffset WRITE setMinutesOffset NOTIFY minutesOffsetChanged)
    Q_PROPERTY(bool useIanaId READ useIanaId WRITE setUseIanaId NOTIFY useIanaIdChanged)

public:
    explicit TimeLocalizer(QObject *parent = 0);
    Q_INVOKABLE QDateTime getTime();
    Q_INVOKABLE QString getTimeText();
    QString ianaId();
    void setIanaId(const QString &ianaId);
    int hoursOffset();
    void setHoursOffset(const int &hoursOffset);
    int minutesOffset();
    void setMinutesOffset(const int &minutesOffset);
    bool useIanaId();
    void setUseIanaId(const bool &useIanaId);
    Q_INVOKABLE QString getOffsetText();

signals:
    void ianaIdChanged();
    void hoursOffsetChanged();
    void minutesOffsetChanged();
    void useIanaIdChanged();
    void offsetTextChanged();

private:
    QString m_ianaId;
    int m_hoursOffset;
    int m_minutesOffset;
    bool m_useIanaId;
    QTimeZone timezone;

public slots:

};

#endif // TIMELOCALIZER_H
