# GraphFlow — Interactive Graph Dependency Analyzer

GraphFlow is a working, DSA-first web application for modeling directed dependencies between software components. It is designed as an intermediate-level portfolio project: the graph algorithms are implemented in the project source instead of being delegated to a graph library.

## Features

- Interactive graph editor with draggable nodes and directed weighted edges
- Add components (service, client, database, queue), mark components healthy/failed, and remove nodes
- BFS, DFS, Dijkstra shortest path, topological sorting, directed cycle detection, and reverse-dependency failure impact analysis
- Step-by-step execution trace and complexity explanation
- Graph metrics and component inventory
- Import/export graph JSON
- Automatic browser-local persistence with `localStorage`
- Responsive dark dashboard; no API keys, database server, Docker, or cloud account required

## Requirements

- Node.js 18.18+ (Node 20 LTS recommended)
- npm

## Run locally

```bash
cd GraphFlow
npm install
npm run dev
```

Open the local URL printed by Vite (usually `http://localhost:5173`).

To make a production build:

```bash
npm run build
npm run preview
```

## Quick start

1. Open the app; a sample service graph is loaded automatically.
2. Click any node to select it. Drag nodes to rearrange the graph.
3. Use **Add node** to add a component.
4. Use **Connect components** under Quick actions (or the edge icon above the graph). Click the source node and then the target node to create a directed edge.
5. Choose an algorithm in Algorithm Lab and press **Run algorithm**.
6. Use Previous / Next step to walk through the execution trace. Nodes/edges included in the result are highlighted.
7. Export the graph to JSON to back it up or share it; import a compatible JSON file to restore it.

## Algorithm behavior and complexity

| Algorithm | Behavior | Complexity |
|---|---|---|
| BFS | Visits reachable nodes breadth-first from a start node | `O(V + E)` |
| DFS | Visits reachable nodes depth-first from a start node | `O(V + E)` |
| Dijkstra | Finds a minimum-weight path between selected nodes | This implementation: `O(V² + E)`; use a min-heap to achieve `O((V + E) log V)` |
| Topological sort | Kahn's algorithm; reports when not all nodes can be ordered | `O(V + E)` |
| Cycle detection | DFS coloring and back-edge detection in a directed graph | `O(V + E)` |
| Failure impact | Traverses reverse dependency edges to find components that depend on the failed component | `O(V + E)` |

`V` is the number of nodes and `E` the number of edges. Dijkstra rejects negative edge weights because its correctness depends on nonnegative weights. Topological sorting only produces a complete ordering for a directed acyclic graph (DAG).

### Edge direction convention

An edge `A → B` means **A depends on B / A calls B** in this app's service map. Failure-impact analysis follows reverse edges from the failed component to find callers/dependents that may be affected. Topological order is the graph's standard edge order; depending on whether you interpret edges as “depends on” or “must run before,” reverse the displayed order for a deployment plan.

## Project structure

```text
GraphFlow/
├── public/
├── src/
│   ├── engine/
│   │   └── graph.ts       # Graph types, validation, all DSA algorithms
│   ├── styles.css         # Responsive dark UI
│   ├── App.tsx            # Dashboard, editor, algorithm controls
│   └── main.tsx           # React entry point
├── docs/
│   ├── API_DESIGN.md      # Proposed API for a future backend
│   ├── TEST_PLAN.md       # Manual and algorithm test cases
│   └── DATABASE_SCHEMA.sql
├── index.html
├── package.json
├── tsconfig.json
├── tsconfig.node.json
└── vite.config.ts
```

## Current scope / honest limitations

This is a fully usable local-first MVP. Graph data is stored in the current browser's local storage; it is not synced across devices and there is no multi-user login or hosted database. The frontend is intentionally self-contained so it can be run and demonstrated without cloud credentials. The docs folder contains a proposed PostgreSQL schema and REST API design for a future Spring Boot backend; these are design artifacts, not a backend that is already connected.

## Suggested interview walkthrough

1. Explain why an adjacency list is appropriate for sparse dependency graphs.
2. Demonstrate BFS and DFS on the sample graph and discuss reachability.
3. Show Dijkstra's distance relaxation and explain why negative weights are unsupported.
4. Add a dependency cycle and show topological sort fail to order all nodes.
5. Mark a component as failed and explain the reverse-graph traversal used by impact analysis.
6. Discuss the distinction between algorithm complexity and the UI's graph-layout rendering cost.
