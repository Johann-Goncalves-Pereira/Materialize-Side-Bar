module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    )

import Json.Decode as Decode
import Request exposing (Request)
import Utils.Elements as Elements


type alias Flags =
    Decode.Value


type alias Model =
    { elements : Elements.Model }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    let
        ( element_, elementCmd_ ) =
            Elements.init
    in
    ( { elements = element_ }
    , Cmd.map ElementMsg elementCmd_
    )


type Msg
    = ElementMsg Elements.Msg


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        ElementMsg msg_ ->
            let
                ( elements_, elementCmd_ ) =
                    Elements.update msg_ model.elements
            in
            ( { model | elements = elements_ }
            , Cmd.map ElementMsg elementCmd_
            )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.map ElementMsg Elements.subscriptions
