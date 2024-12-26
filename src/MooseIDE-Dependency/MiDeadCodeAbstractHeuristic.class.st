"
An abstract class for heurisitcs identifying dead behavioural entities

An heurisitc can try to identifiy dead entities or identify not-dead entities (refuting dead entities)
In the first case, #isDead: = true means the entity is dead, = false means 'undecided'
In the second case, #isDead: = false means the entity is not dead, = true means 'undecided'


A heurisitc has:
- a name
- a description
- #isDead: method that accept an entity and answers a boolean
- #refuteDead: true if the heuristic tries to prove that an entity is dead
"
Class {
	#name : #MiDeadCodeAbstractHeuristic,
	#superclass : #Object,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #testing }
MiDeadCodeAbstractHeuristic class >> isAbstract [

	^self name includesSubstring: 'Abstract'
]

{ #category : #accessing }
MiDeadCodeAbstractHeuristic >> description [

	self subclassResponsibility 
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> isAbstract [

	^ self class isAbstract
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> isDead: aTMethod [

	self subclassResponsibility 
]

{ #category : #accessing }
MiDeadCodeAbstractHeuristic >> name [

	self subclassResponsibility 
]

{ #category : #accessing }
MiDeadCodeAbstractHeuristic >> refuteDead [
	"if true, the heuristic tries to _refute_ a method is dead (or assert it is not dead)
	 if false, the heuristic tries to _assert_ a method is dead"

	^false
]
