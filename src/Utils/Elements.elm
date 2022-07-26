module Utils.Elements exposing (Model, Msg, init, subscriptions, update)

import Browser.Dom as Dom
import Browser.Events exposing (onResize)
import Dict exposing (Dict)
import Layout exposing (headerId)
import Task


type alias Model =
    { elements : Dict String Dom.Element
    }


init : ( Model, Cmd Msg )
init =
    ( { elements = Dict.empty
      }
    , getElements elementsIds
    )


getElements : List String -> Cmd Msg
getElements =
    List.map
        (\elementId_ ->
            Dom.getElement elementId_
                |> Task.attempt (GotElements elementId_)
        )
        >> Cmd.batch


type Msg
    = GotElements String (Result Dom.Error Dom.Element)
    | GetAgain


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotElements id_ result_ ->
            case result_ of
                Ok e_ ->
                    let
                        scene_ =
                            { width = e_.scene.width
                            , height = e_.scene.height
                            }

                        viewport_ =
                            { x = e_.viewport.x
                            , y = e_.viewport.y
                            , width = e_.viewport.width
                            , height = e_.viewport.height
                            }

                        element_ =
                            { x = e_.element.x
                            , y = e_.element.y
                            , width = e_.element.width
                            , height = e_.element.height
                            }

                        elementInfo =
                            { scene = scene_
                            , viewport = viewport_
                            , element = element_
                            }
                    in
                    ( { model
                        | elements =
                            Dict.insert id_
                                elementInfo
                                model.elements
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        GetAgain ->
            ( model, getElements elementsIds )


subscriptions : Sub Msg
subscriptions =
    onResize <| \_ _ -> GetAgain


elementsIds : List String
elementsIds =
    [ headerId ]
