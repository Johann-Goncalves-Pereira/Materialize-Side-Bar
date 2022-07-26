module Layout exposing (Model, headerId, initLayout, viewLayout)

import Components.Svg as ElmSvg
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, button, div, header, img, input, li, main_, nav, span, text, ul)
import Html.Attributes as Attr exposing (class, classList, href, id, tabindex)
import Regex
import String exposing (right)
import Utils.View exposing (materialIcon)



-- Model


type alias Model msg =
    { route : Route
    , rootAttr : List (Attribute msg)
    , mainContent : List (Html msg)
    , mainAttrs : List (Attribute msg)
    , pager : Int
    , centerContent : List (Html msg)
    , centerAttr : List (Attribute msg)
    , sidebarContent : { left : List (Html msg), right : List (Html msg) }
    , sidebarAttrs : { left : List (Attribute msg), right : List (Attribute msg) }
    }


type alias Link =
    { routeStatic : Route
    , routeReceived : Route
    , routeName : String
    }


initLayout : Model msg
initLayout =
    { route = Route.Home_
    , rootAttr = []
    , mainContent = []
    , mainAttrs = []
    , pager = 0
    , centerContent = []
    , centerAttr = []
    , sidebarContent = { left = [], right = [] }
    , sidebarAttrs = { left = [], right = [] }
    }


defaultLink : Link
defaultLink =
    { routeStatic = Route.Home_
    , routeReceived = Route.Home_
    , routeName = ""
    }



-- Structure


isRoute : Route -> Route -> Bool
isRoute route compare =
    case ( route, compare ) of
        ( Route.Home_, Route.Home_ ) ->
            True

        _ ->
            False


routeName : Route -> String
routeName route =
    let
        strRoute : String
        strRoute =
            Route.toHref route

        getLength =
            String.length strRoute

        getFirstCharacter =
            String.dropRight (getLength - 2) strRoute
                |> String.toUpper
                |> String.dropLeft 1
    in
    if route == Route.Home_ then
        "Home"

    else
        getFirstCharacter
            ++ String.replace "/" " - " (String.dropLeft 2 strRoute)


userReplace : String -> (Regex.Match -> String) -> String -> String
userReplace userRegex replacer string =
    case Regex.fromString userRegex of
        Nothing ->
            string

        Just regex ->
            Regex.replace regex replacer string


classBuilder : String -> String
classBuilder string =
    userReplace "[ ]" (\_ -> "-") string
        |> String.toLower



-- View


viewLayout : Model msg -> List (Html msg)
viewLayout model =
    let
        mainClass : Attribute msg
        mainClass =
            class <| "root__main main--" ++ classBuilder (routeName model.route)
    in
    [ div
        ([ id "root"
         , classList
            [ ( "root", True )
            , ( "root--" ++ classBuilder (routeName model.route), True )
            ]
         ]
            ++ model.rootAttr
        )
        [ viewHeader model
        , main_ (mainClass :: model.mainAttrs)
            ([ div (class "sidebar-left" :: model.sidebarAttrs.left)
                ([ viewBorderLines
                 , ul [ class "list" ] <|
                    List.map
                        (\x ->
                            li [ class "list__item" ]
                                [ button [ class "list__button" ] [ materialIcon "" x ] ]
                        )
                        [ "app_registration", "token", "diamond", "compost" ]
                 ]
                    ++ model.sidebarContent.left
                )
             , div
                (class "base-center" :: model.centerAttr)
                [ div [ class "base-center__wrapper" ] model.centerContent ]
             , div (class "sidebar-right" :: model.sidebarAttrs.right)
                (viewBorderLines :: model.sidebarContent.right)
             ]
                ++ model.mainContent
            )
        ]
    ]


viewBorderLines : Html msg
viewBorderLines =
    div [ class "border-lines" ]
        [ span [ class "border-lines__top" ] []
        , span [ class "border-lines__bottom" ] []
        ]


headerId : String
headerId =
    "root__header"


viewHeader : Model msg -> Html msg
viewHeader model =
    header [ class "root__header", Attr.id headerId ]
        [ a [ class "logo" ]
            [ ElmSvg.materialize "logo__icon"
            ]
        , nav [ class "nav" ]
            [ button [ class "nav__menu", tabindex 0 ] [ materialIcon "" "menu" ]
            , viewHeaderLinks model [ Route.Home_ ]
            ]
        , div [ class "search" ]
            [ input
                [ class "search__input"
                , Attr.type_ "text"
                , Attr.tabindex 0
                , Attr.placeholder "Search for something"
                ]
                []
            , materialIcon "search__icon" "search"
            ]
        , button [ class "notification" ]
            [ materialIcon "" "notifications"
            ]
        , button
            [ class "profile"
            ]
            [ img
                [ class "profile__img"
                , Attr.src "https://picsum.photos/200"
                , Attr.alt "Profile Photo"
                ]
                []
            ]
        ]


viewHeaderLinks : Model msg -> List Route -> Html msg
viewHeaderLinks model links =
    List.map
        (\staticRoute ->
            viewLink
                { defaultLink
                    | routeName = routeName staticRoute
                    , routeStatic = staticRoute
                    , routeReceived = model.route
                }
        )
        links
        |> ul [ class "list" ]


viewLink : Link -> Html msg
viewLink model =
    li [ class "list__item" ]
        [ a
            [ classList
                [ ( "list__item__link", True )
                , ( "list__item__link--current-page"
                  , isRoute model.routeReceived model.routeStatic
                  )
                ]
            , tabindex 0
            , href <| Route.toHref model.routeStatic
            ]
            [ text model.routeName ]
        ]
