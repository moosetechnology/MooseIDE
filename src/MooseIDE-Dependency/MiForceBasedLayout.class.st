"
A force based layout for Roassal with parameterstunned for ArchitecturalMap where the nodes
"
Class {
	#name : 'MiForceBasedLayout',
	#superclass : 'RSForceBasedLayout',
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'as yet unclassified' }
MiForceBasedLayout class >> layoutDescription [

	^ 'Arrange shapes boased on attraction/repulsion forces.'
]

{ #category : 'accessing' }
MiForceBasedLayout class >> layoutName [

	^ 'Force based'
]

{ #category : 'initialization' }
MiForceBasedLayout >> reset [
	"explanation of some parameters (according to ChatGPT)
	1. gravity
		Meaning: Controls how strongly nodes are pulled toward the center of the layout (like a gravitational force).
			Higher value → nodes cluster more tightly toward the center.
			Lower value → nodes spread out more, possibly drifting toward the edges.
	2. friction
		Meaning: Simulates resistance or damping in motion — it slows down node movement over time.
			Higher value → nodes slow down quickly and the layout stabilizes faster.
			Lower value → nodes move more freely and take longer to settle.
	3. theta
		Meaning: A precision parameter used in the Barnes-Hut approximation, which speeds up force calculations for large graphs.
			Lower value → more precise force calculation (but slower).
			Higher value → faster layout computation (but less accurate).
	4. strength
		Meaning: The spring strength or stiffness between connected nodes (links).
			Higher value → stronger pull between connected nodes, edges stay shorter.
			Lower value → weaker pull, connected nodes can drift farther apart.
	5. charge
		Meaning: Controls the repulsive force between nodes (like electric charge).
			Positive value → nodes repel each other (spread out).
			Negative value → nodes attract each other (cluster).
	6. length
		Meaning: Defines the natural (desired) distance between connected nodes — like the resting length of a spring.
			Higher value → connected nodes are positioned farther apart.
			Lower value → connected nodes are closer together."

	super reset.

	self
		initialLayout: RSCircleLayout new;
		strength: 5;
		length: 300;
		charge: -300
]
