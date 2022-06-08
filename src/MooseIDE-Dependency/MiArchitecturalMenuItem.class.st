"
Base class for architectural map menu items.
"
Class {
	#name : #MiArchitecturalMenuItem,
	#superclass : #HAbstractMenuItem,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #public }
MiArchitecturalMenuItem class >> buildIn: aMenuMorph shape: aRoassalShape visualization: anHSimpleVisualizationBuilder [

	| items clazz |
	clazz := self classFor: aRoassalShape.
	clazz ifNil: [ ^ self ].
	items := MiArchitecturalNodeMenuItem subclasses , clazz subclasses
	         , { MiArchitecturalInspectorMenuItem } collect: #new.
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
