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
	"explanation of some parameters (from super class comments and help of ChatGPT)
	strength: Set the force of attraction for the edges. A high value results in having nodes together.
		The default value is 1.0
	charge: Typically a negative value. E.g., -300.
		This is a repulsive force between nodes (like electric charge).
	length: the natural (desired) distance between connected nodes, eg. 50
	gravity: it is the force from nodes to move toward center.
		Higher value results in nodes clustered more tightly toward the center.
	friction: Simulates resistance or damping in motion — it slows down node movement over time.
		Usualy a value between 0 and 1. Higher value makes nodes slow down quickly and the layout stabilizes faster.
	theta: Theta coefficient from Barnes-Hut simulation. Value ranges on [0, 1].
		Performance is better with smaller values. 
		Very small values may not create enough force to give a good result"

	super reset.

	self
		initialLayout: RSCircleLayout new;
		strength: 5;
		length: 300;
		charge: -500;
		friction: 0.5
]
