Class {
	#name : #MiButterflyMenuItem,
	#superclass : #HAbstractMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #public }
MiButterflyMenuItem class >> buildIn: aMenuMorph shape: aRoassalShape visualization: anHSimpleVisualizationBuilder [

	| items clazz |
	clazz := self classFor: aRoassalShape.
	items := clazz subclasses , { MiButterflyInspectMenuItem } collect:
		         #new.
	items := items groupedBy: [ :item | item group ].
	items keys sorted
		do: [ :key | 
			| group |
			group := (items at: key) sorted: [ :a :b | a order < b order ].
			group do: [ :item | 
				item
					shape: aRoassalShape;
					visualization: anHSimpleVisualizationBuilder;
					buildOn: aMenuMorph ] ]
		separatedBy: [ aMenuMorph addSeparator ]
]

{ #category : #public }
MiButterflyMenuItem class >> classFor: aRoassalShape [

	aRoassalShape isShape ifFalse: [ ^ MiButterflyCanvasMenuItem ].
	^ aRoassalShape isNode
		  ifTrue: [ 
			  (aRoassalShape canvas selectedShapes notEmpty and: [ 
				   aRoassalShape canvas selectedShapes includes: aRoassalShape ])
				  ifTrue: [ HGroupMenuItem ]
				  ifFalse: [ MiButterflyNodeMenuItem ] ]
		  ifFalse: [ HLineMenuItem ]
]
