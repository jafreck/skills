````skill
---
name: architecture-diagram-generator
description: Generate architecture diagrams from system context using Mermaid, with optional C4-style views.
---

# Generate architecture diagrams

Create clear architecture diagrams from repository and system descriptions.

## Usage

Use this skill when asked to create or update architecture diagrams, service maps, or data-flow diagrams.

## Diagram types

- System context
- Container/service architecture
- Data flow
- Sequence flow for key request paths
- Deployment topology

## Steps

1. Gather architecture inputs:
   - Components/services
   - External dependencies
   - Data stores and queues
   - Key request and event flows
   - Trust boundaries

2. Choose minimal diagram set needed for the ask.

3. Generate Mermaid diagrams with readable labels and directional edges.

4. Validate clarity:
   - No ambiguous node names
   - Flows are directional and labeled
   - Security/trust boundaries are explicit where relevant

5. Output:
   - Mermaid source blocks
   - Short legend/assumptions section

## C4 guidance (optional)

If asked for C4, provide:
- Level 1: Context
- Level 2: Containers
- Level 3: Components (only for requested subsystem)

Keep diagrams simple, accurate, and directly tied to known context.

````