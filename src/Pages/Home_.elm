module Pages.Home_ exposing (Model, Msg, page)

import Debouncer.Basic as Debouncer exposing (Debouncer, fromSeconds, provideInput, settleWhenQuietFor, toDebouncer)
import Dict
import Gen.Params.Home_ exposing (Params)
import Gen.Route as Route
import Html exposing (Attribute, Html, button, div, h4, header, img, li, section, span, text, ul)
import Html.Attributes as Attr exposing (class)
import Html.Attributes.Aria exposing (ariaLabelledby)
import Html.Events as Events
import Html.Events.Extra.Wheel as Wheel
import Layout exposing (getLayoutIds, initLayout, layoutIds)
import Page
import Request
import Shared
import Utils.View exposing (customProp, materialIcon)
import View exposing (View)
import VitePluginHelper exposing (asset)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared _ =
    Page.element
        { init = init
        , update = update
        , view = view shared
        , subscriptions = subs
        }



-- INIT


type alias Model =
    { quietForOneSecond : Debouncer Msg Msg
    , pager : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { quietForOneSecond = manualDebouncer 0.25
      , pager = 0
      }
    , Cmd.none
    )


manualDebouncer : Float -> Debouncer Msg Msg
manualDebouncer time_ =
    Debouncer.manual
        |> settleWhenQuietFor (Just <| fromSeconds time_)
        |> toDebouncer


type Msg
    = OnWheel (Int -> Int -> Int)
    | MsgQuietForSomeTime (Debouncer.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnWheel f_ ->
            ( { model
                | pager =
                    f_ model.pager 1
                        |> clamp 0 (lengthPager model - 1)
              }
            , Cmd.none
            )

        MsgQuietForSomeTime subMsg ->
            let
                ( subModel, subCmd, emittedMsg ) =
                    Debouncer.update subMsg model.quietForOneSecond

                mappedCmd =
                    Cmd.map MsgQuietForSomeTime subCmd

                updatedModel =
                    { model | quietForOneSecond = subModel }
            in
            case emittedMsg of
                Just emitted ->
                    update emitted updatedModel
                        |> Tuple.mapSecond
                            (\cmd -> Cmd.batch [ cmd, mappedCmd ])

                Nothing ->
                    ( updatedModel, mappedCmd )



-- SUBS


subs : Model -> Sub Msg
subs _ =
    Sub.none



-- VIEW


pagerTrigger : Wheel.Event -> Msg
pagerTrigger wheelEvent =
    if wheelEvent.deltaY > 0 then
        OnWheel (+)

    else
        OnWheel (-)


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        getHeader =
            Dict.get (getLayoutIds 0) shared.elements.elements

        headerHeight =
            case getHeader of
                Just e_ ->
                    e_.element.height

                Nothing ->
                    65
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
                    [ pagerTrigger
                        >> Debouncer.provideInput
                        >> MsgQuietForSomeTime
                        |> Wheel.onWheel
                    ]
                , footerContent = (viewFooter shared).content
                , footerAttr = (viewFooter shared).attrs
                , sidebarAttrs =
                    { left = []
                    , right = [ customPropPager model False ]
                    }
                , sidebarContent =
                    { left = []
                    , right =
                        [ viewPager model ]
                    }
                , centerAttr = [ customPropPager model True ]
                , centerContent = viewCenter model
            }
    }


lengthPager : Model -> Int
lengthPager model =
    viewCenter model
        |> List.length


customPropPager : Model -> Bool -> Attribute Msg
customPropPager { pager } up =
    let
        goUp =
            if up then
                "-"

            else
                "+"
    in
    String.concat
        [ if pager == 0 then
            "0"

          else
            String.concat
                [ "calc("
                , goUp
                , String.fromInt pager
                , "00% "
                , goUp
                , " var(--gap_))"
                ]
        ]
        |> customProp "pager"


viewPager : Model -> Html Msg
viewPager model =
    span [ class "pager__ball" ] []
        |> List.repeat (lengthPager model)
        |> div [ class "pager", customPropPager model False ]


viewCenter : Model -> List (Html Msg)
viewCenter _ =
    [ section [ class "base-section--call", ariaLabelledby "call-label" ]
        [ header [ class "header" ]
            [ h4 [ class "header__title", Attr.id "call-label" ] [ text "Call" ] ]
        , div [ class "body" ]
            [ img
                [ class "body__img"
                , Attr.src <| asset "/assets/jitsi-semple.png"
                , Attr.alt "Jitise semple"
                ]
                []
            ]
        ]
    , section [ class "base-section--chat", ariaLabelledby "chat-label" ]
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


viewFooter : Shared.Model -> { attrs : List (Attribute Msg), content : List (Html Msg) }
viewFooter { elements } =
    let
        sidebarSize =
            Dict.get (getLayoutIds 1) elements.elements

        justSize =
            case sidebarSize of
                Just e_ ->
                    e_.element.width

                Nothing ->
                    44
    in
    { attrs =
        [ String.fromFloat justSize
            ++ "px"
            |> customProp "sidebar-left-width"
        ]
    , content =
        [ div [ class "hired-time-spend", Attr.title "Tempo restante do especialista" ]
            [ div [ class "hired-time-spend__bar" ]
                [ span [] [] ]
            , Html.i [ class "hired-time-spend__time-left" ] [ text "1h, 37min" ]
            ]
        , Html.small [ class "time" ] [ text "Terça, 26 de Julho de 2022 - 15:32" ]
        , Html.i [ class "online", Attr.title "Há 8 pessoas online. Sua internet não está estável" ]
            [ text "Current Online (8) ◦ ", materialIcon "" "wifi" ]
        ]
    }
