module Visits.Update exposing (..)

import Visits.Requests exposing (..)
import Visits.Types exposing (..)
import Navigation as Nav
import Debug


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
                ( if List.isEmpty model then
                    [ visit ]
                  else
                    List.map
                        (\oldVisit ->
                            if oldVisit.id == visit.id then
                                visit
                            else
                                oldVisit
                        )
                        model
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
