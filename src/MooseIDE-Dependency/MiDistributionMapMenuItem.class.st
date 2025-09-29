"
Base class for distribution map menu.
"
Class {
	#name : #MiDistributionMapMenuItem,
	#superclass : #HAbstractMenuItem,
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #public }
MiDistributionMapMenuItem class >> buildIn: aMenuMorph shape: aRoassalShape visualization: anHSimpleVisualizationBuilder [
	| items clazz |
	clazz := self classFor: aRoassalShape.
	items := clazz subclasses collect: #new.
	items := items groupedBy: [ :item | item group ].
	items keys sorted do: [ :key | | group |
		group := (items at: key) sorted: [ :a :b | a order < b order ].
		group do: [ :item | 
			item
				shape: aRoassalShape;
				visualization: anHSimpleVisualizationBuilder;
				buildOn: aMenuMorph ]
		] separatedBy: [ aMenuMorph addSeparator ].
	
]

{ #category : #public }
MiDistributionMapMenuItem class >> classFor: aRoassalShape [
	aRoassalShape isShape
		ifFalse: [ ^ self ].
	^ aRoassalShape isNode
		ifTrue: [ 
			MiDistributionMapNodeMenuItem ]
		ifFalse: [ self ]
		
]
