module People.Update exposing (..)

import People.Http exposing (..)
import People.Types exposing (..)
import Navigation as Nav


updateDoctors : Msg -> List (Doctor Person) -> ( List (Doctor Person), Cmd Msg )
updateDoctors msg model =
    case msg of
        NewUrl url ->
            ( model, Nav.newUrl url )

        DelPerson id ->
            ( model, deleteDoctor id )

        DoctorDeleted _ ->
            ( model, getDoctors )

        DoctorsData (Ok doctors) ->
            ( doctors
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model, Nav.newUrl url )

        DelPerson id ->
            ( model, deletePerson "patients" id )

        PersonDeleted _ ->
            ( model, getPeople "patients" )

        PeopleData (Ok people) ->
            ( people, Cmd.none )

        PeopleData (Err err) ->
            let
                error =
                    Debug.log "PeopleData error: " err
            in
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
