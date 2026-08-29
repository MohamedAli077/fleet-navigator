# Fleet Navigator

https://github.com/MohamedAli077/fleet-ops-live

========================================================

FEATURE 6 — DISRUPTION SIMULATION

========================================================

Implement a real disruption simulation workflow.

Operator should be able to create a simulated disruption.

Inputs:

- route

- disruption type

- severity

- start time

- duration

- description

Example:

Route 522

Road blockage

High severity

08:15

30 minutes

When activated:

1. Identify affected route.

2. Identify affected trips.

3. Identify affected buses.

4. Identify affected crew.

5. Mark affected operational state appropriately.

6. Identify available replacement resources.

7. Attempt recovery.

8. Update scheduling state.

9. Update timeline.

10. Update map.

11. Update dashboard/analytics.

Do not merely display a red badge saying "disrupted".

The disruption must actually affect the simulation.

========================================================

FEATURE 7 — WHAT-IF SIMULATION

========================================================

Implement a true scenario simulation.

A What-If scenario MUST NOT immediately modify the actual operational schedule.

Workflow:

CURRENT OPERATIONAL STATE

        ↓

CREATE SCENARIO COPY

        ↓

APPLY HYPOTHETICAL CHANGE

        ↓

RUN ASSIGNMENT / RECOVERY LOGIC

        ↓

CALCULATE IMPACT

        ↓

SHOW COMPARISON

        ↓

OPTIONALLY APPLY SCENARIO

Examples:

"What if 10 buses become unavailable?"

"What if Route 522 is blocked for 30 minutes?"

"What if 3 crew members are unavailable?"

"What if demand increases during peak hours?"

The system should report measurable effects such as:

- affected trips

- affected routes

- buses unavailable

- crew shortage

- uncovered trips

- replacement buses required

- schedule conflicts

- utilization change

IMPORTANT:

Do not invent numerical results.

Calculate them from the scenario state.

Provide:

BASELINE

vs.

SCENARIO

comparison.

There should also be an explicit:

"Apply Scenario"

action.

Until the user applies it, the real schedule/database state must remain unchanged.

========================================================

FEATURE 8 — AUTOMATIC RESOURCE ASSIGNMENT

========================================================

Implement actual automatic resource assignment.

For every scheduled trip:

1. Identify candidate buses.

2. Remove unavailable buses.

3. Remove maintenance/retired/inactive buses.

4. Check depot/resource constraints.

5. Identify candidate crew.

6. Remove unavailable/off-duty/inactive crew.

7. Check timing conflicts.

8. Check overlapping assignments.

9. Generate feasible combinations.

10. Select the best feasible assignment.

At minimum, ensure:

- no bus is assigned to overlapping trips

- no crew member is assigned to overlapping trips

- inactive buses are never assigned

- retired buses are never assigned

- unavailable crew is never assigned

The assignment logic should be implemented as actual backend/business logic.

Do NOT fake it with frontend selection only.

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/87d8188a-42ec-43e9-be07-e4a4a9f65b33).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
