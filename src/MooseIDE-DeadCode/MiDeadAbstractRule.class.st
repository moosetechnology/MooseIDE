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
	#name : 'MiDeadAbstractRule',
	#superclass : 'Object',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadAbstractRule class >> isAbstract [

	^self name beginsWith: 'MiDeadAbstract'
]

{ #category : 'accessing' }
MiDeadAbstractRule >> deadCodeModel: aBrowserModel [
	"do nothing by default if a rule need this, it should store the model"
]

{ #category : 'accessing' }
MiDeadAbstractRule >> description [

	^(self refuteDead
		ifTrue: [ '[Refute a method is dead]' , String cr ]
		ifFalse: [ '' ])
	,
	self class comment
]

{ #category : 'accessing' }
MiDeadAbstractRule >> heuristics [

	^#()
]

{ #category : 'testing' }
MiDeadAbstractRule >> isAbstract [

	^ self class isAbstract
]

{ #category : 'testing' }
MiDeadAbstractRule >> isDead: aTMethod [

	^self refuteDead
		ifTrue: [ (self notDead: aTMethod) not ]
		ifFalse: [ self subclassResponsibility ]
]

{ #category : 'accessing' }
MiDeadAbstractRule >> name [

	^self selectedByDefault
		ifTrue: [ '[Default] ' ]
		ifFalse: [ '' ]
]

{ #category : 'testing' }
MiDeadAbstractRule >> notDead: aTMethod [

	self subclassResponsibility 
]

{ #category : 'accessing' }
MiDeadAbstractRule >> refuteDead [
	"if true, the heuristic tries to _refute_ a method is dead (or assert it is not dead)
	 if false, the heuristic tries to _assert_ a method is dead"

	^true
]

{ #category : 'accessing' }
MiDeadAbstractRule >> ruleGroup [
	"by default a rule is not grouped (therefore in its own group)"

	^self
]

{ #category : 'testing' }
MiDeadAbstractRule >> selectedByDefault [
	"Whether the heuristic is selected in the DeadCodeBrowser by default"

	^false
]

{ #category : 'actions' }
MiDeadAbstractRule >> whenChosen [

	"defaults to returning self"
]
