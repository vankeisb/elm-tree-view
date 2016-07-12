module TreeView.Messages exposing (..)

import TreeView.Models exposing (TreeNodeId)

import AnimationFrame
import Time exposing (Time)

type Msg
  = Expand TreeNodeId
  | Collapse TreeNodeId
  | Select TreeNodeId
  | Animate Time

subscriptions : Sub Msg
subscriptions =
  AnimationFrame.times Animate
