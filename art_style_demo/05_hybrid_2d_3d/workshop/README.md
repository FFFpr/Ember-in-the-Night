# Workshop — hybrid 2D + 3D

## Goal

First-person bench view: 2D room, **3D anvil/forge tools** as the focus.

## Required set dressing

- 2D: walls, shelves, far props, window
- 3D: forge mouth and/or anvil (+ optional hammer)
- Shared mood: warm forge light on both sides of the hybrid

## Implementation sketch

- Lock both the 2D camera and the 3D SubViewport camera.
- Scale the 3D cluster so it sits on the 2D bench perspective line.
- Prefer one light story (forge key) to hide compositing seams.
