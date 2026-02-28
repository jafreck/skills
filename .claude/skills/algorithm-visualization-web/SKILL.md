````skill
---
name: algorithm-visualization-web
description: Build a lightweight web visualization for an algorithm with interactive controls and step-by-step playback.
---

# Create web algorithm visualizations

Generate a minimal web app that visualizes an algorithm interactively.

## Usage

Use this skill when asked to visualize an algorithm in a browser.

## Core requirements

- Implement algorithm logic correctly.
- Render state transitions visually in the browser.
- Provide controls: Start, Pause, Step, Reset.
- Allow speed control.
- Show current step/state summary.

## Steps

1. Define visualization state model:
   - Input data
   - Current index/pointers
   - Intermediate state snapshots
   - Completion status

2. Implement deterministic step function:
   - One call advances exactly one logical step.
   - Keep algorithm logic separate from rendering.

3. Build minimal UI:
   - Canvas or DOM/SVG visualization
   - Control panel with playback buttons
   - Status panel (step count, highlights, complexity note)

4. Add animation/playback loop:
   - Respect pause/resume
   - Use adjustable interval for speed

5. Add sample presets and input validation.

6. Verify behavior on edge cases (empty input, duplicates, sorted/reverse where relevant).

## Output expectations

- Runs locally in a browser.
- Code is simple and educational.
- Includes short usage instructions and algorithm explanation.

Prefer minimal dependencies unless the user requests a specific framework.

````