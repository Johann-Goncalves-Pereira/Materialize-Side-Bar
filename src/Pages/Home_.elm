module Pages.Home_ exposing (Model, Msg, page)

import Browser.Dom as Dom
import Components.Svg as SVG exposing (Logo(..))
import Dict exposing (Dict)
import Gen.Params.Home_ exposing (Params)
import Gen.Route as Route
import Html exposing (Html, a, button, div, h1, h2, h4, h5, header, img, li, section, span, text, ul)
import Html.Attributes as Attr exposing (class, href, id, rel, tabindex, target)
import Html.Attributes.Aria exposing (ariaLabel, ariaLabelledby)
import Html.Events.Extra.Wheel as Wheel
import Layout exposing (headerId, initLayout)
import Page
import Request
import Shared
import Svg exposing (desc)
import Utils.View exposing (customProp, materialIcon)
import View exposing (View)
import VitePluginHelper exposing (asset)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.sandbox
        { init = init
        , update = update
        , view = view shared
        }



-- INIT


type alias Model =
    { pager : Int }


init : Model
init =
    { pager = 0 }



-- UPDATE


type WheelY
    = Up
    | Down


type Msg
    = OnWheel WheelY


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnWheel side ->
            if
                model.pager
                    >= List.length (viewCenter model)
                    + 1
                    || model.pager
                    <= -1
            then
                model

            else
                case side of
                    Up ->
                        { pager = model.pager - 1 }

                    Down ->
                        { pager = model.pager + 1 }



-- SUBS
-- VIEW


pagerTrigger : Wheel.Event -> Msg
pagerTrigger wheelEvent =
    if wheelEvent.deltaY > 0 then
        OnWheel Up

    else
        OnWheel Down


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        getHeader =
            Dict.get headerId shared.elements.elements

        headerHeight =
            case getHeader of
                Just e_ ->
                    e_.element.height

                Nothing ->
                    0
    in
    { title = "Revex - Home"
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.Home_
                , rootAttr =
                    [ String.fromFloat headerHeight
                        ++ "px"
                        |> customProp "header-height"
                    ]
                , mainAttrs =
                    [ Wheel.onWheel pagerTrigger ]
                , mainContent = viewPage model
            }
    }


viewPage : Model -> List (Html Msg)
viewPage model =
    [ div [ class "sidebar-left" ]
        [ ul [ class "list" ] <|
            List.map
                (\x ->
                    li [ class "list__item" ]
                        [ button [ class "list__button" ] [ materialIcon "" x ] ]
                )
                [ "app_registration", "token", "diamond", "compost" ]
        ]
    , div [ class "base-center" ] <| viewCenter model
    , div [ class "sidebar-right" ] [ viewPager model ]
    ]


viewPager : Model -> Html Msg
viewPager model =
    let
        length =
            (viewCenter model |> List.length)
                - 1
                |> List.range 0
    in
    List.indexedMap
        (\i _ ->
            span
                [ Attr.classList
                    [ ( "pager__ball", True )
                    , ( "pager__ball--current"
                      , model.pager == i
                      )
                    ]
                ]
                []
        )
        length
        |> div [ class "pager" ]


viewCenter : Model -> List (Html Msg)
viewCenter _ =
    [ section [ class "base-section-call", ariaLabelledby "call-label" ]
        [ header [ class "header" ]
            [ h4 [ class "header__title", Attr.id "call-label" ] [ text "section" ] ]
        , div [ class "body" ]
            [ img
                [ class "body__img"
                , Attr.src <| asset "/assets/jitsi-semple.png"
                , Attr.alt "Jitise semple"
                ]
                []
            ]
        ]
    , section [ class "base-section-chat", ariaLabelledby "chat-label" ]
        [ header [ class "header" ]
            [ h4 [ class "header__title", Attr.id "chat-label" ] [ text "chat" ] ]
        , div [ class "body" ]
            [ img
                [ class "body__img"
                , Attr.src <| asset "/assets/jitsi-semple.png"
                , Attr.alt "Jitise semple"
                ]
                []
            ]
        ]
    ]
