module Visits.Update exposing (..)

import Visits.Requests exposing (..)
import Visits.Types exposing (..)
import Navigation as Nav


updateVisits : VisitsMsg -> List Visit -> ( List Visit, Cmd VisitsMsg )
updateVisits msg model =
    case msg of
        NewVisitsUrl url ->
            ( model, Nav.newUrl url )

        VisitsData (Ok visits) ->
            ( visits
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
