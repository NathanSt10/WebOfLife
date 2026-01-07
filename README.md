# Web of Life — VR Ecosystem Simulation

**Web of Life** is an immersive VR application designed to let users visualize, manipulate, and understand food webs in a dynamic 3D environment. Built for the **Meta Quest 2**, the project blends interactive gameplay with ecological education, allowing users to explore how predator–prey relationships shape the balance of an ecosystem.

Each species is represented as a sphere whose size reflects its population. Users can freely add, remove, grow, or shrink species to observe real-time changes across the web. The application uses the **Lotka–Volterra model** to simulate population dynamics, demonstrating how even small adjustments can cascade through an ecosystem.

By combining intuitive VR interactions with scientifically grounded simulations, *Web of Life* aims to make learning about ecology engaging, exploratory, and visually compelling.

---

## Features

- Fully interactive **3D food web** rendered in VR  
- Species represented as **population spheres** with animated animals inside  
- Real-time ecosystem simulation using the **Lotka–Volterra model**  
- Dynamic **predator–prey connections** visualized as threads between spheres  
- Intuitive VR interactions:
  - Grab species from a satchel  
  - Resize spheres using pinch/stretch gestures  
  - Add or remove species from the ecosystem  
- Responsive population changes across the web  
- Immersive forest-like environment  
- Designed for both **education and entertainment**

---

## Core Gameplay Loop

### 1. Entering the World
Users begin in a forest-themed VR environment. A floating info card displays basic controls, including grabbing spheres, placing them, and resizing them.

**Developer goals:** onboarding, clarity  
**User goals:** intuitive start, ease of learning  

---

### 2. Exploring the Satchel
A satchel on the user’s right side contains spheres representing different species. Hovering over a sphere reveals an info card with:
- Species name  
- Image  
- Diet  
- Predators  

**Developer goals:** education, visual clarity  
**User goals:** exploration, learning  

---

### 3. Adding Species to the Web
When a sphere is removed from the satchel, it enlarges for easier placement. Releasing it spawns animated animals inside, and a population number appears on the sphere.

**Developer goals:** intuitive interaction  
**User goals:** fun, hands-on experimentation  

---

### 4. Forming Connections
Adding multiple species creates visual threads between predator–prey pairs.
- Fox ↔ Sheep → connected  
- Fox ↔ Grass → no connection  

**Developer goals:** accurate ecological modeling  
**User goals:** understanding relationships  

---

### 5. Resizing Species
Pinching a sphere tints it blue, indicating active resizing.
- Pull hands apart → population increases  
- Push hands together → population decreases  

**Developer goals:** responsive controls  
**User goals:** tactile, satisfying interactions  

---

### 6. Real-Time Ecosystem Simulation
Population changes ripple through connected species using the Lotka–Volterra model:
- Increasing predators → prey populations decrease  
- Decreasing predators → prey populations increase  

**Developer goals:** scientific accuracy  
**User goals:** cause-and-effect learning  

---

### 7. Removing Species
Users can remove a species by placing its sphere back into the satchel. All connections disappear, and the species is treated as extinct.

**Developer goals:** flexibility  
**User goals:** experimentation  

---

### 8. Open-Ended Play
There is no win condition. Users can build, collapse, and rebuild ecosystems indefinitely.

**Developer goals:** replayability  
**User goals:** creativity, self-directed exploration  

---

## Minimum Viable Product (MVP)

The MVP consists of three core components:

### 1. Orb Mechanics
- Grab, place, and resize species spheres  
- Display population counts  
- Visualize predator–prey connections  

### 2. Numerical Simulation
- Implement the Lotka–Volterra (or similar) model  
- Update populations based on interactions  
- Ensure simulation responds to user actions  

### 3. Visual & Interaction Systems
- VR environment  
- Animated animals inside spheres  
- Info cards and UI elements  

This scope is appropriate for a four-person team, with each member contributing across mechanics, simulation, and visuals.

---

## Technical Challenges

### Interaction Challenges
- Smooth, intuitive two-hand pinch/stretch resizing  
- Natural-feeling sphere manipulation in VR  
- Stable physics and responsive controls  

### Simulation Challenges
- Real-time population updates  
- Clear visualization of predator–prey connections  
- Correct propagation of user-driven changes through the simulation  

These challenges require careful coordination between gameplay logic, physics, and UI/UX systems.

---

## Stretch Goals

Optional enhancements beyond the MVP:
- Environment that visually reacts to ecosystem health  
- More detailed animations inside spheres  
- Enhanced info cards with richer species data  
- Automatic sphere growth when removed from the satchel  
- Additional ecosystems (desert, tundra, ocean)  
- **Multiplayer mode** for the IEEE VR 3DUI Contest:
  - Cooperative shared ecosystem  
  - Web-sharing mechanics between players  

---

## Evaluation Criteria

The project is successful when all three core components function cohesively:

1. **Visual Component**
   - Spheres, connections, and animations render correctly  
   - Ecosystem changes are visually clear  

2. **Interaction Component**
   - Users can add, remove, resize, and manipulate species  
   - Controls feel intuitive and responsive  

3. **Simulation Component (Not complete)**
   - Population changes follow ecological rules  
   - Changes to one species affect others appropriately **(not complete)** 

A successful evaluation includes adding species, resizing populations, and observing accurate real-time changes across the food web.

---

## Project Structure

```text
WebOfLife/
├── Materials/              # Textures, UI elements
├── Models/                 # Models
├── Scripts/                # VR interactions, simulation logic, ecosystem manager
├── Scenes/                 # Unity scenes including main environment
└── SceneInstances/         # Instances of various scene components, used for manipulation
```

---

## Technologies Used

- **Godot** (VR development)  
- **Meta Quest 2** (target platform)  
- **GDScript** (gameplay and simulation logic)
