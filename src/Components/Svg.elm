module Components.Svg exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes as SvgAttr


materialize : String -> Html msg
materialize class_ =
    svg
        [ SvgAttr.width "341"
        , SvgAttr.height "174"
        , SvgAttr.viewBox "0 0 255 130"
        , SvgAttr.fill "none"
        , SvgAttr.class class_
        ]
        [ path
            [ SvgAttr.fillRule "evenodd"
            , SvgAttr.clipRule "evenodd"
            , SvgAttr.d "M88.6012 82.9318L169.218 2.22533C172.181 -0.741778 176.987 -0.741778 179.95 2.22533L213.401 35.7135C216.365 38.6806 216.365 43.4912 213.401 46.4583L132.785 127.165C129.821 130.132 125.016 130.132 122.052 127.165L88.6012 93.6766C85.6374 90.7095 85.6374 85.8989 88.6012 82.9318ZM226.846 49.2888C223.883 46.3228 219.079 46.3228 216.115 49.2888L177.296 88.1489H247.342C254.105 88.1489 257.489 79.9635 252.708 75.1769L226.846 49.2888ZM124.649 41.0959L79.8722 85.9227C78.4477 87.344 76.5178 88.141 74.5066 88.1387H7.61466C0.852606 88.1387 -2.53222 79.9534 2.24903 75.1668L75.1062 2.22828C76.5295 0.803142 78.46 0.0024884 80.4731 0.0024884C82.4861 0.0024884 84.4166 0.803142 85.84 2.22828L124.649 41.0959Z"
            , SvgAttr.fill "#03F4DC"
            ]
            []
        ]
