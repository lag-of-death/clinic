module Visits.Update exposing (..)

import Visits.Requests exposing (..)
import Visits.Types exposing (..)
import Navigation as Nav
import Debug
import Visits.Helpers exposing (..)


updateNewVisit : NewVisitMsg -> NewVisitModel -> ( NewVisitModel, Cmd NewVisitMsg, NewVisitMsg )
updateNewVisit msg model =
    case msg of
        NoNewVisitOp ->
            ( model, Cmd.none, NoNewVisitOp )

        IncDoctors ->
            ( { model | numOfDoctors = model.numOfDoctors + 1 }, Cmd.none, NoNewVisitOp )

        DecDoctors ->
            ( { model | numOfDoctors = model.numOfDoctors - 1 }, Cmd.none, NoNewVisitOp )

        IncNurses ->
            ( { model | numOfNurses = model.numOfNurses + 1 }, Cmd.none, NoNewVisitOp )

        DecNurses ->
            ( { model | numOfNurses = model.numOfNurses - 1 }, Cmd.none, NoNewVisitOp )


updateVisits : VisitsMsg -> List Visit -> ( List Visit, Cmd VisitsMsg, VisitsMsg )
updateVisits msg model =
    case msg of
        NoVisitsOp ->
            ( model, Cmd.none, NoVisitsOp )

        NewVisitsUrl url ->
            ( model, Nav.newUrl url, NoVisitsOp )

        VisitsData (Ok visits) ->
            ( visits
            , Cmd.none
            , NoVisitsOp
            )

        VisitData (Err err) ->
            let
                debug =
                    Debug.log "visit err" err
            in
                ( model, Cmd.none, NoVisitsOp )

        VisitData (Ok visit) ->
            let
                debug =
                    Debug.log "visit" visit
            in
                ( addVisit model visit
                , Cmd.none
                , NoVisitsOp
                )

        VisitDeleted _ ->
            ( model, getVisits, NoVisitsOp )

        VisitsData (Err err) ->
            let
                error =
                    Debug.log "VisitsData error: " err
            in
                ( model, Cmd.none, NoVisitsOp )

        DelVisit id ->
            ( model, Cmd.none, ReallyDelVisit id )

        ReallyDelVisit id ->
            ( model, deleteVisit id, NoVisitsOp )
