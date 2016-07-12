module TreeView.Updates exposing (update)

import TreeView.Models exposing (..)
import TreeView.Messages exposing (..)

import Style exposing (Animation)
import Style.Properties exposing (..)
import Time exposing (Time, second)

update : Msg -> TreeModel a -> ( TreeModel a, Cmd Msg )
update msg model =
  case msg of
    Expand nodeId ->
      List.map (expandCollapse nodeId True) model
        ! []

    Collapse nodeId ->
      List.map (expandCollapse nodeId False) model
        ! []

    Select nodeId ->
      List.map (select nodeId) model
        ! []

    Animate time ->
      -- let
      --   m = List.map (\n -> { n | style = Style.tick time n.style }) model
      -- in
      --   (m, Cmd.none)
      (model, Cmd.none)

select: TreeNodeId -> TreeNode a -> TreeNode a
select nodeId n =
  { n | selected = n.id == nodeId }
