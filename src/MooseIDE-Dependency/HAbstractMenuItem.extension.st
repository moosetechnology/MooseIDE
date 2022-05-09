Extension { #name : #HAbstractMenuItem }

{ #category : #'*MooseIDE-Dependency' }
HAbstractMenuItem class >> buildForMooseIn: aMenuMorph shape: aRoassalShape visualization: anHSimpleVisualizationBuilder [
	| items clazz |
	clazz := self classFor: aRoassalShape.
	items := clazz subclasses, { MiInspectorMenuItem } collect: #new.
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
