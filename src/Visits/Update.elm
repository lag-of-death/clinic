module Visits.Update exposing (..)

import Visits.Requests exposing (..)
import Visits.Types exposing (..)
import Navigation as Nav
import Debug
import Visits.Helpers exposing (..)


updateNewVisit : NewVisitMsg -> NewVisitModel -> ( NewVisitModel, Cmd NewVisitMsg )
updateNewVisit msg model =
    case msg of
        IncDoctors ->
            ( { model | numOfDoctors = model.numOfDoctors + 1 }, Cmd.none )

        DecDoctors ->
            ( { model | numOfDoctors = model.numOfDoctors - 1 }, Cmd.none )

        IncNurses ->
            ( { model | numOfNurses = model.numOfNurses + 1 }, Cmd.none )

        DecNurses ->
            ( { model | numOfNurses = model.numOfNurses - 1 }, Cmd.none )


updateVisits : VisitsMsg -> List Visit -> ( List Visit, Cmd VisitsMsg )
updateVisits msg model =
    case msg of
        NewVisitsUrl url ->
            ( model, Nav.newUrl url )

        VisitsData (Ok visits) ->
            ( visits
            , Cmd.none
            )

        VisitData (Err err) ->
            let
                debug =
                    Debug.log "visit err" err
            in
                ( model, Cmd.none )

        VisitData (Ok visit) ->
            let
                debug =
                    Debug.log "visit" visit
            in
                ( addVisit model visit
                , Cmd.none
                )

        VisitDeleted _ ->
            ( model, getVisits )

        VisitsData (Err err) ->
            let
                error =
                    Debug.log "VisitsData error: " err
            in
                ( model, Cmd.none )

        DelVisit id ->
            ( model, deleteVisit id )
