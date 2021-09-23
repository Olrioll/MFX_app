#include "WaveformWidget.h"

#include <QPainter>
#include <QPainterPath>
#include <QTime>
#include <QSGFlatColorMaterial>
#include <QSurfaceFormat>
#include <QOpenGLContext>


AudioTrackRepresentation WaveformWidget::_track;

#ifdef USEOPENGL
WaveformWidget::WaveformWidget(QQuickItem* parent) : QQuickItem(parent) /*, _track(this)*/
  #else
WaveformWidget::WaveformWidget(QQuickItem* parent) : QQuickPaintedItem(parent) /*, _track(this)*/
  #endif
{
#ifdef USEOPENGL
    setFlag(ItemHasContents);
#endif

    setAntialiasing(true);

    connect(&_track, &AudioTrackRepresentation::trackDownloaded, [this]()
    {
        const auto playerSamples = static_cast<size_t>(std::floor(
                                                           static_cast<long double>(_player.duration()) * _track.getSampleRate()));
        if (playerSamples > _track.samplesCount())
        {
            if (playerSamples > 2000)
                _track.addSilent(playerSamples - _track.samplesCount());
        }

        _ratio = static_cast<float>(_track.samplesCount()) / static_cast<float>(_player.duration());
        emit channelAudioChanged(_track.isStereo());
        emit trackDownloaded();
    });

    connect(&_track, &AudioTrackRepresentation::isHourTime, this, &WaveformWidget::setHourTimer);

    _player.setNotifyInterval(10);
    connect(&_player, &QMediaPlayer::positionChanged, [this](qint64 pos1)
    {
        //        qDebug()<<(QTime(0, 0).addMSecs(pos1).toString("hh:mm:ss.zzz"));
        //        qDebug()<<"time: "<<_player.bufferStatus()<<_player.position();
        emit timerValueChanged((QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz")).chopped(1));
        const quint64 pos = _player.position() / 10; // the least meaningful time interval is 10 ms
        static quint64 prevPos;
        if (prevPos == pos)
        {
            // our time signals should't repeat
            return;
        }
        const quint64 diff = pos - prevPos;
        if ((diff > 0) && (diff < 10))
        {
            // in case no more than 100 ms was skipped
            for (quint64 i = prevPos; i < pos; i++)
            {
                emit positionChanged(10 * i);
                // generate missing signals to ensure our time is consistent and ticks every 10 ms
            }
        }
        prevPos = pos;
    });

    //changind to QMediaPlayer::positionChanged
    //    connect(&_valueForPositionTimer, &QTimer::timeout, [this]()
    //    {

    //        qDebug()<<"time: "<<_player.bufferStatus()<<_player.position();
    //        emit timerValueChanged((QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz")).chopped(1));
    //        quint64 pos = _player.position() / 10; // the least meaningful time interval is 10 ms
    //        static quint64 prevPos;
    //        if(prevPos == pos) { // our time signals should't repeat
    //            return;
    //        }
    //        quint64 diff = pos - prevPos;
    //        if((diff > 0) && (diff < 10)) { // in case no more than 100 ms was skipped
    //            for(quint64 i = prevPos; i < pos; i++) {
    //                emit positionChanged(10 * i); // generate missing signals to ensure our time is consistent and ticks every 10 ms
    //            }
    //        }
    //        prevPos = pos;
    //    });

    //    connect(&_player,&QMediaPlayer::stateChanged,[this](QMediaPlayer::State state){

    //        if(state == QMediaPlayer::PlayingState){
    //            if( !_valueForPositionTimer.isActive())
    //                _valueForPositionTimer.start(10);
    //        }
    //    });
}


#ifdef USEOPENGL
QSGNode* WaveformWidget::updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData)
{
    if (!oldNode)
    {
        oldNode = new QSGNode;
        auto childNode = new QSGGeometryNode;
        auto geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 0);
        geometry->setDrawingMode(QSGGeometry::DrawTriangleStrip);
        childNode->setGeometry(geometry);
        auto material = new QSGFlatColorMaterial;
        material->setColor(QColor(QStringLiteral("#88bbbbbb")));
        childNode->setMaterial(material);
        childNode->setFlags(QSGNode::OwnsMaterial | QSGNode::OwnsGeometry);

        auto childNode1 = new QSGGeometryNode;
        auto geometry1 = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 0);
        geometry1->setDrawingMode(QSGGeometry::DrawTriangleStrip);
        childNode1->setGeometry(geometry1);
        auto material1 = new QSGFlatColorMaterial;
        material1->setColor(QColor(QStringLiteral("#bbbbbb")));
        childNode1->setMaterial(material1);
        childNode1->setFlags(QSGNode::OwnsMaterial | QSGNode::OwnsGeometry);
        oldNode->appendChildNode(childNode);
        oldNode->appendChildNode(childNode1);
    }

    if (m_max - m_min == 0)
        return oldNode;

    const double paintWidth = boundingRect().width();

    double framesPerPixel = static_cast<double>(m_max - m_min) / paintWidth;

    if (paintWidth < 4 || std::isnan(paintWidth) || paintWidth > 5000 || framesPerPixel < 1.0)
        return oldNode;

    auto geometry = dynamic_cast<QSGGeometryNode*>(oldNode->childAtIndex(0))->geometry();
    auto geometry1 = dynamic_cast<QSGGeometryNode*>(oldNode->childAtIndex(1))->geometry();

    static int oldAllocated = 0;

    if (_track.isStereo() && _isStereoMode)
    {
        const int allocGeo = static_cast<int>(paintWidth) * 4;
        if (oldAllocated != allocGeo)
        {
            geometry->allocate(allocGeo);
            geometry1->allocate(allocGeo);
            oldAllocated = allocGeo;
        }
    }
    else
    {
        const int allocGeo = static_cast<int>(paintWidth) * 2;
        if (oldAllocated != allocGeo)
        {
            geometry->allocate(allocGeo);
            geometry1->allocate(allocGeo);
            oldAllocated = allocGeo;
        }
    }

    float maxAmplitude = static_cast<float>(_track.maxAmplitude()) - _track.minAmplitude();


    if (_track.isStereo())
    {
        auto recalculate = [&]()
        {
            if (m_displayMaxes.size() < static_cast<size_t>(paintWidth) || m_displayMinsR.size() < static_cast<size_t>(paintWidth))
            {
                const size_t nSize = static_cast<size_t>(paintWidth) + 100;
                m_displayMins.resize(nSize);
                m_displayMaxes.resize(nSize);
                m_displayMinsR.resize(nSize);
                m_displayMaxesR.resize(nSize);
                m_rms.resize(nSize);
                m_rmsR.resize(nSize);
            }

            _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], paintWidth,
                    framesPerPixel, &m_rms[0]);
            _track.m_channels[1].calculateWaveForm(m_min, &m_displayMinsR[0], &m_displayMaxesR[0], paintWidth,
                    framesPerPixel, &m_rmsR[0]);
        };

        if (framesPerPixel == m_framesPerPixel)
        {
            if (m_min > m_oldMin)
            {
                int m = (m_min - m_oldMin) / framesPerPixel;
                int pw = paintWidth - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[0], &m_displayMins[m], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[0], &m_displayMaxes[m], pw * sizeof(qint16));
                    memmove(&m_displayMinsR[0], &m_displayMinsR[m], pw * sizeof(qint16));
                    memmove(&m_displayMaxesR[0], &m_displayMaxesR[m], pw * sizeof(qint16));
                    memmove(&m_rms[0], &m_rms[m], pw * sizeof(float));
                    memmove(&m_rmsR[0], &m_rmsR[m], pw * sizeof(float));

                    _track.m_channels[0].calculateWaveForm(m_max - m, &m_displayMins[pw], &m_displayMaxes[pw], m,
                                                           framesPerPixel, &m_rms[pw]);
                    _track.m_channels[1].calculateWaveForm(m_max - m, &m_displayMinsR[pw], &m_displayMaxesR[pw], m,
                                                           framesPerPixel, &m_rmsR[pw]);
                }
                else recalculate();
            }
            else if (m_oldMin > m_min)
            {
                int m = (m_oldMin - m_min) / framesPerPixel;
                int pw = static_cast<int>(paintWidth) - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[m], &m_displayMins[0], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[m], &m_displayMaxes[0], pw * sizeof(qint16));
                    memmove(&m_displayMinsR[m], &m_displayMinsR[0], pw * sizeof(qint16));
                    memmove(&m_displayMaxesR[m], &m_displayMaxesR[0], pw * sizeof(qint16));
                    memmove(&m_rms[m], &m_rms[0], pw * sizeof(float));
                    memmove(&m_rmsR[m], &m_rmsR[0], pw * sizeof(float));

                    _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], m,
                            framesPerPixel, &m_rms[0]);
                    _track.m_channels[1].calculateWaveForm(m_min, &m_displayMinsR[0], &m_displayMaxesR[0], m,
                            framesPerPixel, &m_rmsR[0]);
                }
                else recalculate();
            }
            else recalculate();
        }
        else recalculate();


        if (_isStereoMode)
        {
            const float bheight4 = boundingRect().height() / 4;
            const float bheight2 = boundingRect().height() / 2;
            const float maxHeight = boundingRect().height();
            const float _val = static_cast<double>(maxHeight) / maxAmplitude;
            float scaleFactor = 0.6f;
            QSGGeometry::Point2D* topCurvePoints = geometry->vertexDataAsPoint2D();
            QSGGeometry::Point2D* topCurvePoints1 = geometry1->vertexDataAsPoint2D();

            int j = 0;
            for (int i = 0; i < static_cast<int>(paintWidth); i++, j += 2)
            {
                float t = i / static_cast<float>(paintWidth - 1.0);
                const float x = (t * paintWidth);

                float yTop = _val * (_track.maxAmplitude() - m_displayMins[i]);
                float yBottom = _val * (_track.maxAmplitude() - m_displayMaxes[i]);

                {
                    yTop += (bheight2 - yTop) * scaleFactor - bheight4;
                    yBottom += (bheight2 - yBottom) * scaleFactor - bheight4;

                    const float distance = yTop - yBottom;
                    if (distance < 1.2f)
                    {
                        float addAmt = ((1.2f - distance) * 0.5f);
                        yBottom -= addAmt;
                        yTop += addAmt;
                    }

                    topCurvePoints[j].set(x, yTop);
                    topCurvePoints[j + 1].set(x, yBottom);

                    const float average = m_rms[i];
                    const float height = average / maxAmplitude * maxHeight;
                    float y1 = (maxHeight - height) * 0.5f;
                    float y2 = y1 + height;
                    y1 += (bheight2 - y1) * scaleFactor - bheight4;
                    y2 += (bheight2 - y2) * scaleFactor - bheight4;
                    topCurvePoints1[j].set(x, y1);
                    topCurvePoints1[j + 1].set(x, y2);
                }
            }

            for (int i = static_cast<int>(paintWidth) - 1; i >= 0; --i, j += 2)
            {
                float t = i / static_cast<float>(paintWidth - 1.0);
                const float x = (t * paintWidth);

                float yTop = _val * (static_cast<double>(_track.maxAmplitude()) - m_displayMinsR[i]);
                float yBottom = _val * (static_cast<double>(_track.maxAmplitude()) - m_displayMaxesR[i]);

                yTop += (bheight2 - yTop) * scaleFactor + bheight4;
                yBottom += (bheight2 - yBottom) * scaleFactor + bheight4;

                const float distance = yTop - yBottom;
                if (distance < 1.2f)
                {
                    float addAmt = ((1.2f - distance) * 0.5f);
                    yBottom -= addAmt;
                    yTop += addAmt;
                }

                topCurvePoints[j].set(x, yTop);
                topCurvePoints[j + 1].set(x, yBottom);

                const float average = m_rmsR[i];
                const float height = average / maxAmplitude * maxHeight;
                float y1 = (maxHeight - height) * 0.5f;
                float y2 = y1 + height;

                y1 += (bheight2 - y1) * scaleFactor + bheight4;
                y2 += (bheight2 - y2) * scaleFactor + bheight4;

                topCurvePoints1[j].set(x, y1);
                topCurvePoints1[j + 1].set(x, y2);
            }
        }
        else
        {
            const float maxHeight = boundingRect().height();

            const float _val = maxHeight / maxAmplitude;
            QSGGeometry::Point2D* topCurvePoints = geometry->vertexDataAsPoint2D();
            QSGGeometry::Point2D* topCurvePoints1 = geometry1->vertexDataAsPoint2D();


            for (size_t i = 0, j = 0; i < static_cast<int>(paintWidth); i++, j += 2)
            {
                float t = i / static_cast<float>(paintWidth - 1.0);
                const float x = (t * paintWidth);

                float yTop = _val * (_track.maxAmplitude() - (m_displayMins[i] + m_displayMinsR[i]) * 0.5);
                float yBottom = _val * (_track.maxAmplitude() - (m_displayMaxes[i] + m_displayMaxesR[i]) * 0.5);
                const float distance = yTop - yBottom;
                if (distance < 1.2f)
                {
                    float addAmt = ((1.2f - distance) * 0.5f);
                    yBottom -= addAmt;
                    yTop += addAmt;
                }


                topCurvePoints[j].set(x, yTop);
                topCurvePoints[j + 1].set(x, yBottom);

                const float average = (m_rms[i] + m_rmsR[i]) * 0.5f;
                const float height = average / maxAmplitude * maxHeight;
                const float y1 = (maxHeight - height) * 0.5f;
                const float y2 = y1 + height;


                topCurvePoints1[j].set(x, y1);
                topCurvePoints1[j + 1].set(x, y2);
            }
        }

        m_framesPerPixel = framesPerPixel;
        m_oldMax = m_max;
        m_oldMin = m_min;
    }
    else
    {
        auto recalculate = [&]()
        {
            if (m_displayMaxes.size() < paintWidth)
            {
                m_displayMins.resize(paintWidth + 100);
                m_displayMaxes.resize(paintWidth + 100);
                m_rms.resize(paintWidth + 100);
            }
            _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], paintWidth,
                    framesPerPixel, &m_rms[0]);
        };


        if (framesPerPixel == m_framesPerPixel)
        {
            if (m_min > m_oldMin)
            {
                int m = (m_min - m_oldMin) / framesPerPixel;
                int pw = paintWidth - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[0], &m_displayMins[m], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[0], &m_displayMaxes[m], pw * sizeof(qint16));
                    memmove(&m_rms[0], &m_rms[m], pw * sizeof(float));

                    _track.m_channels[0].calculateWaveForm(m_max - m, &m_displayMins[pw], &m_displayMaxes[pw], m,
                                                           framesPerPixel, &m_rms[pw]);
                }
                else recalculate();
            }
            else if (m_oldMin > m_min)
            {
                int m = (m_oldMin - m_min) / framesPerPixel;
                int pw = paintWidth - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[m], &m_displayMins[0], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[m], &m_displayMaxes[0], pw * sizeof(qint16));
                    memmove(&m_rms[m], &m_rms[0], pw * sizeof(float));
                    _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], m,
                            framesPerPixel, &m_rms[0]);
                }
                else recalculate();
            }
            else recalculate();
        }
        else recalculate();

        const int maxHeight = boundingRect().height();
        QSGGeometry::Point2D* topCurvePoints = geometry->vertexDataAsPoint2D();
        QSGGeometry::Point2D* topCurvePoints1 = geometry1->vertexDataAsPoint2D();
        const float _val = maxHeight / maxAmplitude;

        for (int i = 0, j = 0; i < static_cast<int>(paintWidth); i++, j += 2)
        {
            float t = i / static_cast<float>(paintWidth - 1.0);
            const float x = (t * paintWidth);
            float yTop = _val * (_track.maxAmplitude() - m_displayMins[i]);
            float yBottom = _val * (_track.maxAmplitude() - m_displayMaxes[i]);
            const float distance = yTop - yBottom;

            if (distance < 1.2f)
            {
                float addAmt = ((1.2f - distance) * 0.5f);
                yBottom -= addAmt;
                yTop += addAmt;
            }

            topCurvePoints[j].set(x, yTop);
            topCurvePoints[j + 1].set(x, yBottom);

            const float average = m_rms[i];
            const float height = average / maxAmplitude * maxHeight;
            const float y1 = (maxHeight - height) * 0.5f;
            const float y2 = y1 + height;
            topCurvePoints1[j].set(x, y1);
            topCurvePoints1[j + 1].set(x, y2);
        }

        m_framesPerPixel = framesPerPixel;
        m_oldMax = m_max;
        m_oldMin = m_min;
    }

    oldNode->childAtIndex(0)->markDirty(QSGNode::DirtyGeometry);
    oldNode->childAtIndex(1)->markDirty(QSGNode::DirtyGeometry);
    //    oldNode->markDirty(QSGNode::DirtyGeometry);


    return oldNode;
}


#else
void WaveformWidget::paint(QPainter* painter)
{
    if (m_max - m_min == 0)
        return;

    const QBrush brush1(QColor(QStringLiteral("#646464")));
    const QBrush brush2(QColor(QStringLiteral("#bbbbbb")));
    const QPen pen(brush1, 1.3f, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
    const QPen pen2(brush2, 0.8f, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);

    painter->setRenderHints(QPainter::Antialiasing);


    const double paintWidth = boundingRect().width();
    float maxAmplitude = _track.maxAmplitude() - _track.minAmplitude();
    double framesPerPixel = static_cast<double>(m_max - m_min) / paintWidth;

    if (paintWidth < 4 || isnan(paintWidth) || paintWidth > 5000 || framesPerPixel < 1.f)
        return;

    if (_track.isStereo())
    {
        auto recalculate = [&]()
        {
            if (m_displayMaxes.size() < paintWidth || m_displayMinsR.size() < paintWidth)
            {
                const size_t nSize = (int)paintWidth + 100;
                m_displayMins.resize(nSize);
                m_displayMaxes.resize(nSize);
                m_displayMinsR.resize(nSize);
                m_displayMaxesR.resize(nSize);
                m_rms.resize(nSize);
                m_rmsR.resize(nSize);
            }

            _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], paintWidth,
                    framesPerPixel, &m_rms[0]);
            _track.m_channels[1].calculateWaveForm(m_min, &m_displayMinsR[0], &m_displayMaxesR[0], paintWidth,
                    framesPerPixel, &m_rmsR[0]);
        };

        if (framesPerPixel == m_framesPerPixel)
        {
            if (m_min > m_oldMin)
            {
                int m = (m_min - m_oldMin) / framesPerPixel;
                int pw = paintWidth - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[0], &m_displayMins[m], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[0], &m_displayMaxes[m], pw * sizeof(qint16));
                    memmove(&m_displayMinsR[0], &m_displayMinsR[m], pw * sizeof(qint16));
                    memmove(&m_displayMaxesR[0], &m_displayMaxesR[m], pw * sizeof(qint16));
                    memmove(&m_rms[0], &m_rms[m], pw * sizeof(float));
                    memmove(&m_rmsR[0], &m_rmsR[m], pw * sizeof(float));

                    _track.m_channels[0].calculateWaveForm(m_max - m, &m_displayMins[pw], &m_displayMaxes[pw], m,
                                                           framesPerPixel, &m_rms[pw]);
                    _track.m_channels[1].calculateWaveForm(m_max - m, &m_displayMinsR[pw], &m_displayMaxesR[pw], m,
                                                           framesPerPixel, &m_rmsR[pw]);
                }
                else recalculate();
            }
            else if (m_oldMin > m_min)
            {
                int m = (m_oldMin - m_min) / framesPerPixel;
                int pw = static_cast<int>(paintWidth) - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[m], &m_displayMins[0], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[m], &m_displayMaxes[0], pw * sizeof(qint16));
                    memmove(&m_displayMinsR[m], &m_displayMinsR[0], pw * sizeof(qint16));
                    memmove(&m_displayMaxesR[m], &m_displayMaxesR[0], pw * sizeof(qint16));
                    memmove(&m_rms[m], &m_rms[0], pw * sizeof(float));
                    memmove(&m_rmsR[m], &m_rmsR[0], pw * sizeof(float));

                    _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], m,
                            framesPerPixel, &m_rms[0]);
                    _track.m_channels[1].calculateWaveForm(m_min, &m_displayMinsR[0], &m_displayMaxesR[0], m,
                            framesPerPixel, &m_rmsR[0]);
                }
                else recalculate();
            }
            else recalculate();
        }
        else recalculate();


        if (_isStereoMode)
        {
            const auto bheight4 = boundingRect().height() / 4;
            const auto bheight2 = boundingRect().height() / 2;
            const auto maxHeight = boundingRect().height();
            const auto val = static_cast<double>(maxHeight) / maxAmplitude;
            const float scaleFactor = 0.6f;
            for (int i = 0; i < paintWidth; i++)
            {
                float t = i / static_cast<float>(paintWidth - 1.0);
                const float x = (t * paintWidth);

                float yTop = val * (_track.maxAmplitude() - m_displayMaxes[i]);
                float yBottom = val * (_track.maxAmplitude() - m_displayMins[i]);

                {
                    yTop += (bheight2 - yTop) * scaleFactor - bheight4;
                    yBottom += (bheight2 - yBottom) * scaleFactor - bheight4;

                    const auto distance = yBottom - yTop;
                    if (distance < 1.2)
                    {
                        auto addAmt = ((1.2 - distance) * 0.5);
                        yBottom += addAmt;
                        yTop -= addAmt;
                    }

                    painter->setPen(pen);
                    const QLineF line(x, yTop, x, yBottom);
                    painter->drawLine(line);

                    const float average = m_rms[i];
                    const float height = average / maxAmplitude * maxHeight;
                    auto y1 = (maxHeight - height) * 0.5f;
                    auto y2 = y1 + height;
                    y1 += (bheight2 - y1) * scaleFactor - bheight4;
                    y2 += (bheight2 - y2) * scaleFactor - bheight4;
                    painter->setPen(pen2);
                    const QLineF line2(x, y1, x, y2);
                    painter->drawLine(line2);
                }

                {
                    yTop = val * (static_cast<double>(_track.maxAmplitude()) - m_displayMaxesR[i]);
                    yBottom = val * (static_cast<double>(_track.maxAmplitude()) - m_displayMinsR[i]);

                    yTop += (bheight2 - yTop) * scaleFactor + bheight4;
                    yBottom += (bheight2 - yBottom) * scaleFactor + bheight4;

                    const auto distance = yBottom - yTop;
                    if (distance < 1.2)
                    {
                        auto addAmt = ((1.2 - distance) * 0.5);
                        yBottom += addAmt;
                        yTop -= addAmt;
                    }

                    painter->setPen(pen);
                    const QLineF line(x, yTop, x, yBottom);
                    painter->drawLine(line);

                    const float average = m_rmsR[i];
                    const float height = average / maxAmplitude * maxHeight;
                    auto y1 = (maxHeight - height) * 0.5f;
                    auto y2 = y1 + height;

                    y1 += (bheight2 - y1) * scaleFactor + bheight4;
                    y2 += (bheight2 - y2) * scaleFactor + bheight4;

                    painter->setPen(pen2);
                    const QLineF line2(x, y1, x, y2);
                    painter->drawLine(line2);
                }
            }
        }
        else
        {
            const auto maxHeight = boundingRect().height();

            const float val = maxHeight / maxAmplitude;
            for (size_t i = 0; i < paintWidth; i++)
            {
                float t = i / static_cast<float>(paintWidth - 1.0);
                const float x = (t * paintWidth);

                float yTop = val * (_track.maxAmplitude() - (m_displayMaxes[i] + m_displayMaxesR[i]) * 0.5);
                float yBottom = val * (_track.maxAmplitude() - (m_displayMins[i] + m_displayMinsR[i]) * 0.5);
                auto distance = yBottom - yTop;
                if (distance < 1.2)
                {
                    auto addAmt = ((1.2 - distance) * 0.5);
                    yBottom += addAmt;
                    yTop -= addAmt;
                }

                painter->setPen(pen);
                const QLineF line(x, yTop, x, yBottom);
                painter->drawLine(line);

                const float average = (m_rms[i] + m_rmsR[i]) * 0.5f;
                const float height = average / maxAmplitude * maxHeight;
                const auto y1 = (maxHeight - height) * 0.5f;
                const auto y2 = y1 + height;

                painter->setPen(pen2);
                const QLineF line2(x, y1, x, y2);
                painter->drawLine(line2);
            }
        }

        m_framesPerPixel = framesPerPixel;
        m_oldMax = m_max;
        m_oldMin = m_min;
    }
    else
    {
        auto recalculate = [&]()
        {
            if (m_displayMaxes.size() < paintWidth)
            {
                const size_t nSize = (int)paintWidth + 100;
                m_displayMins.resize(nSize);
                m_displayMaxes.resize(nSize);
                m_rms.resize(nSize);
            }
            _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], paintWidth,
                    framesPerPixel, &m_rms[0]);
        };


        if (framesPerPixel == m_framesPerPixel)
        {
            if (m_min > m_oldMin)
            {
                int m = (m_min - m_oldMin) / framesPerPixel;
                int pw = paintWidth - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[0], &m_displayMins[m], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[0], &m_displayMaxes[m], pw * sizeof(qint16));
                    memmove(&m_rms[0], &m_rms[m], pw * sizeof(float));
                    _track.m_channels[0].calculateWaveForm(m_max - m, &m_displayMins[pw], &m_displayMaxes[pw], m,
                                                           framesPerPixel, &m_rms[pw]);
                }
                else recalculate();
            }
            else if (m_oldMin > m_min)
            {
                int m = static_cast<double>(m_oldMin - m_min) / framesPerPixel;
                int pw = paintWidth - m;
                if (m > 0 && pw > 0)
                {
                    memmove(&m_displayMins[m], &m_displayMins[0], pw * sizeof(qint16));
                    memmove(&m_displayMaxes[m], &m_displayMaxes[0], pw * sizeof(qint16));
                    memmove(&m_rms[m], &m_rms[0], pw * sizeof(float));
                    _track.m_channels[0].calculateWaveForm(m_min, &m_displayMins[0], &m_displayMaxes[0], m,
                            framesPerPixel, &m_rms[0]);
                }
                else recalculate();
            }
            else recalculate();
        }
        else recalculate();

        const auto maxHeight = boundingRect().height();
        const auto val = maxHeight / maxAmplitude;
        for (size_t i = 0; i < paintWidth; i++)
        {
            float t = i / static_cast<float>(paintWidth - 1.0);
            const float x = (t * paintWidth);

            float yTop = val * (_track.maxAmplitude() - m_displayMaxes[i]);
            float yBottom = val * (_track.maxAmplitude() - m_displayMins[i]);
            auto distance = yBottom - yTop;
            if (distance < 1.2)
            {
                auto addAmt = ((1.2 - distance) * 0.5);
                yBottom += addAmt;
                yTop -= addAmt;
            }


            painter->setPen(pen);
            const QLineF line(x, yTop, x, yBottom);
            painter->drawLine(line);


            const float average = m_rms[i];
            const float height = average / maxAmplitude * maxHeight;
            const auto y1 = (maxHeight - height) * 0.5f;
            const auto y2 = y1 + height;


            painter->setPen(pen2);
            const QLineF line2(x, y1, x, y2);
            painter->drawLine(line2);
        }
        m_framesPerPixel = framesPerPixel;
        m_oldMax = m_max;
        m_oldMin = m_min;
    }
}

#endif

qint64 WaveformWidget::max() const
{
    return m_max / _ratio;
}

qint64 WaveformWidget::min() const
{
    return m_min / _ratio;
}

qint64 WaveformWidget::maxSample() const
{
    return m_max;
}

qint64 WaveformWidget::minSample() const
{
    return m_min;
}

float WaveformWidget::ratio() const
{
    return _ratio;
}

QString WaveformWidget::maxString() const
{
    return QTime(0, 0).addMSecs(m_max / _ratio).toString("mm:ss");
}

QString WaveformWidget::minString() const
{
    return QTime(0, 0).addMSecs(m_min / _ratio).toString("mm:ss");
}

QString WaveformWidget::positionString(const qint64 pos, QString format) const
{
    if (m_isMoreHour)
        if (!format.startsWith("hh:"))
            format.prepend("hh:");

    return QTime(0, 0).addMSecs(pos).toString(format);
}

float WaveformWidget::scaleFactor() const
{
    return m_scaleFactor;
}


void WaveformWidget::setAudioTrackFile(QString fileName)
{
    _audioTrackFile = fileName;
    _player.setMedia(QUrl::fromLocalFile(fileName));
    _track.loadFile(_audioTrackFile);
    //     emit trackDownloaded();
}

qint64 WaveformWidget::duration() const
{
    return _player.duration();
}

qint64 WaveformWidget::sampleCount()
{
    return _track.samplesCount();
}

void WaveformWidget::setMax(const float maxMsec)
{
    const size_t tmp = maxMsec * _ratio + 1;
    if (m_max == tmp)
        return;


    if (tmp <= _track.samplesCount())
        m_max = tmp;
    else
        m_max = _track.samplesCount();

    update();
    emit maxChanged(m_max);
}

void WaveformWidget::setMin(const float minMsec)
{
    const size_t tmp = static_cast<double>(minMsec) * _ratio + 1;
    if (m_min == tmp)
        return;

    if (minMsec > 0)
        m_min = tmp;
    else
        m_min = 0;

    update();
    emit minChanged(m_min);
}

void WaveformWidget::setMinMax(const float minMsec, const float maxMsec)
{
    const size_t tmp = static_cast<double>(minMsec) * _ratio + 1;
    const size_t tmp2 = static_cast<double>(maxMsec) * _ratio + 1;


    if (m_min == tmp && m_max == tmp2)
        return;


    if (minMsec > 0)
        m_min = tmp;
    else
        m_min = 0;

    if (tmp2 <= _track.samplesCount())
        m_max = tmp2;
    else
        m_max = _track.samplesCount();

    update();
    emit minChanged(m_max);
    emit maxChanged(m_max);
}

void WaveformWidget::setMaxSample(const qint64 max)
{
    if (m_max == max)
        return;

    if(max <= _track.samplesCount())
        m_max = max;
    else
        m_max = _track.samplesCount() - 1;

    update();
    emit maxChanged(m_max);
}

void WaveformWidget::setMinSample(const qint64 min)
{
    if (m_min == min)
        return;

    if(min > 0)
        m_min = min;
    else
        m_min = 0;

    update();
    emit minChanged(m_min);
}

void WaveformWidget::setPlayerPosition(const qint64 pos)
{
    _player.setPosition(pos);
}

qint64 WaveformWidget::playerPosition() const
{
   return _player.position();
}

void WaveformWidget::setVolume(const int value)
{
    _player.setVolume(value);
}

void WaveformWidget::setStereoMode(const bool state)
{
    if(_track.isStereo() != false)
    {
        _isStereoMode = state;
        m_oldMin = 11;
        m_oldMax = 2;
        update();
    }
}

void WaveformWidget::moveVisibleRange(const qint64 pos)
{
    const qint64 tempMin = m_min + pos * _ratio;
    const qint64 tempMax = m_max + pos * _ratio;

    if(tempMin > 0 && tempMax < _track.samplesCount())
    {
        m_min = tempMin;
        m_max = tempMax;
        emit minChanged(m_min);
        emit maxChanged(m_max);
        update();
    }
}

void WaveformWidget::showAll()
{
    m_min = 0;
    m_max = _track.samplesCount();
    emit minChanged(m_min);
    emit maxChanged(m_max);
    update();
}

void WaveformWidget::setscaleFactor(const float scaleFactor)
{
    m_scaleFactor = scaleFactor;
    update();
    emit scaleFactorChanged(m_scaleFactor);
}

void WaveformWidget::setHourTimer(const bool isMoreThanHour) { m_isMoreHour = isMoreThanHour; }

void WaveformWidget::play()
{
    //    _valueForPositionTimer.start(10);
    _player.play();
}

void WaveformWidget::pause()
{
    //    _valueForPositionTimer.stop();
    _player.pause();
}

void WaveformWidget::stop()
{
    //    _valueForPositionTimer.stop();
    _player.stop();
    emit timerValueChanged((QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz")).chopped(1));
    emit positionChanged(_player.position());
}
