module People.Update exposing
    ( Msg(..)
    , updateEntity
    )

import Browser
import Browser.Navigation as Nav
import Http
import Json.Decode
import People.Requests exposing (del, get)


type Msg e
    = NewEntityUrl String
    | EntitiesData (Result Http.Error (List e))
    | EntityData (Result Http.Error e)
    | DelEntity Int
    | ReallyDeleteEntity Int
    | EntityDeleted (Result Http.Error ())
    | NoOp



--updateEntity :
--    Msg a
--    -> List a
--    -> String
--    -> Json.Decode.Decoder (List e)
--    -> (List a -> a -> List a)
--    -> ( List a, Cmd (Msg e), Msg e1 )


updateEntity key msg model entitiesName decodeEntities doSth =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoOp )

        NewEntityUrl url ->
            ----------------
            ( model, Nav.pushUrl key url, NoOp )

        EntityDeleted _ ->
            ( model, get entitiesName decodeEntities EntitiesData, NoOp )

        EntitiesData (Ok nurses) ->
            ( nurses
            , Cmd.none
            , NoOp
            )

        EntitiesData (Err _) ->
            ( model, Cmd.none, NoOp )

        EntityData (Ok entity) ->
            ( doSth model entity
            , Cmd.none
            , NoOp
            )

        EntityData (Err _) ->
            ( model, Cmd.none, NoOp )

        DelEntity id ->
            ( model, Cmd.none, ReallyDeleteEntity id )

        ReallyDeleteEntity id ->
            ( model, del id EntityDeleted entitiesName, NoOp )
