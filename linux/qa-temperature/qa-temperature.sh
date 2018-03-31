#!/bin/sh

RRDTOOL=/usr/bin/rrdtool
DATABASE=/var/www/temper/qatemper.rrd
IMAGE_PATH=/var/www/temper
PERIOD=300
TEMP_MIN=12
TEMP_MAX=35
SENSOR="$(pcsensor | awk '{ print $4 }')"

DRAW_GRAPHIC() {

        # Определяем время, во сколько генерируется график
        NOW_DATE="$(echo $(date) | sed 's/\:/\\:/g')"

        # На основе параметра 2, переданного функции вычисляем какой комментарий написать
        case $2 in
        day)
                 TIME_TEXT="Past 24 hours"
                 ;;
        week)
                 TIME_TEXT="Past week"
                 ;;
        month)
                 TIME_TEXT="Past month"
                 ;;
        year)
                 TIME_TEXT="Past year"
                 ;;
        esac

        $RRDTOOL graph $IMAGE_PATH/$1 \
        -s -1$2 \
        -e now \
        -a PNG \
        -v 'Centigrade' \
        -t "QA Department - $TIME_TEXT" \
        --alt-autoscale \
        --x-grid MINUTE:30:HOUR:1:HOUR:3:0:%H:%M \
        -r \
        -E \
        -i \
        -R light \
        --zoom 1.2 \
        -w 500 \
        -h 180 \
        DEF:temperature=$DATABASE:temperature:AVERAGE \
        LINE2:temperature#33cc33:"Temperature near window\n" \
        AREA:temperature#33cc33 \
        COMMENT:"---------------------------------------------------------------------------------\n" \
        COMMENT:"       Min             Max             Average                  Current\n" \
        GPRINT:temperature:MIN:'      %2.1lf °C' \
        GPRINT:temperature:MAX:'      %2.1lf °C' \
        GPRINT:temperature:AVERAGE:'         %4.1lf °C' \
        GPRINT:temperature:LAST:'                %2.1lf °C\n' \
        COMMENT:"---------------------------------------------------------------------------------\n" \
        COMMENT:"$NOW_DATE\r"
}

if ! [ -f $DATABASE ]
        then
                $RRDTOOL create $DATABASE \
                --step $PERIOD \
                DS:temperature:GAUGE:600:0:60 \
                RRA:AVERAGE:0.5:1:576 \
                RRA:AVERAGE:0.5:6:672 \
                RRA:AVERAGE:0.5:24:732 \
                RRA:AVERAGE:0.5:144:1460
        fi

$RRDTOOL update $DATABASE N:$SENSOR
DRAW_GRAPHIC 'qatemper_d.png' 'day'