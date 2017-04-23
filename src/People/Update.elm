module People.Update exposing (..)

import People.Http exposing (..)
import People.Types exposing (..)
import Navigation as Nav
import Task


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update whatPeople msg model =
    case msg of
        NewUrl url ->
            ( model, Nav.newUrl url )

        DelPerson id ->
            ( model, deletePerson whatPeople id )

        PersonDeleted _ ->
            ( model, getPeople whatPeople )

        PeopleData (Ok people) ->
            ( people, Cmd.none )

        PeopleData (Err err) ->
            let
                error =
                    Debug.log "PeopleData error: " err
            in
                ( model, Cmd.none )
