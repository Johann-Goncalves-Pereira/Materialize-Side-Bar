module Utils.View exposing (..)

import Html exposing (Attribute, Html, span, text)
import Html.Attributes exposing (attribute, class)


customProps : List { prop : String, value : String } -> Attribute msg
customProps listProps =
    List.foldl
        (\{ prop, value } result ->
            String.concat [ result, "--", prop, ":", value, ";" ]
        )
        ""
        listProps
        |> attribute "style"


customProp : String -> String -> Attribute msg
customProp prop value =
    customProps [ { prop = prop, value = value } ]



materialIcon : String -> String -> Html msg
materialIcon className iconName =
    span
        [ class <| "material-symbols-rounded " ++ className
        ]
        [ text iconName ]
