module Main exposing (main)

import Html exposing (..)
import Html.App as App
import TreeView.Models exposing (TreeModel, initialStyle)
import TreeView.Views exposing (view)
import TreeView.Messages exposing (Msg)
import TreeView.Updates exposing (update)

type alias MyUserData =
  { prop: String }

subscriptions : TreeModel MyUserData -> Sub Msg
subscriptions model =
    Sub.none

initialModel : TreeModel MyUserData
initialModel =
  [
    { id="1", name="root", expanded=False, selected=False, parent=Nothing, userData= { prop="Foo" }, style=initialStyle },
    { id="2", name="child1", expanded=False, selected=False, parent=Just "1", userData= { prop="Foo" }, style=initialStyle },
    { id="3", name="child2", expanded=False, selected=False, parent=Just "1", userData= { prop="Foo" }, style=initialStyle },
    { id="4", name="child11", expanded=False, selected=False, parent=Just "2", userData= { prop="Foo" }, style=initialStyle },
    { id="5", name="child12", expanded=False, selected=False, parent=Just "2", userData= { prop="Foo" }, style=initialStyle },
    { id="6", name="child21", expanded=False, selected=False, parent=Just "3", userData= { prop="Foo" }, style=initialStyle }
  ]

init: (TreeModel MyUserData, Cmd Msg)
init =
  ( initialModel, Cmd.none )

main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
