"
Base class for distribution map menu.
"
Class {
	#name : #MiDMMenuItem,
	#superclass : #HAbstractMenuItem,
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #public }
MiDMMenuItem class >> buildIn: aMenuMorph shape: aRoassalShape visualization: anHSimpleVisualizationBuilder [
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
MiDMMenuItem class >> classFor: aRoassalShape [
	aRoassalShape isShape
		ifFalse: [ ^ self ].
	^ aRoassalShape isNode
		ifTrue: [ 
			MiDMNodeMenuItem ]
		ifFalse: [ self ]
		
]
