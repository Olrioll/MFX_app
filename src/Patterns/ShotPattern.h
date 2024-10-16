#pragma once

#include "Pattern.h"

class ShotPattern : public Pattern
{
    Q_OBJECT
    QSM_READONLY_VAR_PROPERTY_WDEFAULT( qulonglong, shotTime, ShotTime, 0 )

public:
    explicit ShotPattern( QObject* parent = nullptr );
    explicit ShotPattern( const QVariantMap& properties, QObject* parent = nullptr );

public:
    void makeName() override;
    Q_INVOKABLE QVariantMap getProperties() const override;
    void setProperties( const QVariantMap& properties ) override;
};