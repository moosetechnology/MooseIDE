Class {
	#name : #MiButterflyMapModel,
	#superclass : #Object,
	#instVars : [
		'currentEntity',
		'level',
		'incomings',
		'outgoings'
	],
	#category : #'MooseIDE-ButterflyMap'
}

{ #category : #accessing }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> incomings [

	^ incomings
]

{ #category : #'as yet unclassified' }
MiButterflyMapModel >> incomingsFor: anEntity [

	^ (anEntity queryAll: #in)
		  collect: [ :assoc | assoc source ]
		  as: OrderedCollection
]

{ #category : #'as yet unclassified' }
MiButterflyMapModel >> incomingsForLevel: aLevel [

	incomings size >= aLevel ifTrue: [ ^ incomings at: aLevel ].
	incomings size + 1 to: aLevel do: [ :lvl | 
		lvl = 1
			ifTrue: [ incomings add: (self incomingsFor: self currentEntity) ]
			ifFalse: [ 
				(incomings at: lvl - 1)
					flatCollect: [ :e | self incomingsFor: e ]
					as: OrderedCollection ] ]
]

{ #category : #initialization }
MiButterflyMapModel >> initialize [

	super initialize.
	level := 1.
	incomings := OrderedCollection new.
	outgoings := OrderedCollection new
]

{ #category : #accessing }
MiButterflyMapModel >> level [

	^ level
]

{ #category : #accessing }
MiButterflyMapModel >> level: anObject [

	level := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> outgoings [

	^ outgoings
]
