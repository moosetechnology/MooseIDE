"
This class is temporary. It will be removed once its features are included in the superclass in Spec.
"
Class {
	#name : #MiFilteringSelectableListPresenter,
	#superclass : #SpFilteringSelectableListPresenter,
	#instVars : [
		'onActivation',
		'onDeactivation'
	],
	#category : #'Midas-Export'
}

{ #category : #private }
MiFilteringSelectableListPresenter >> listColumns [

	| column |
	column := SpCompositeTableColumn new.
	column addColumn: (selectColumn := SpCheckBoxTableColumn new
			                 evaluated: [ :anObject | 
				                 selectedItems includes: anObject ];
			                 onActivation: [ :anObject | 
				                 selectedItems add: anObject.
				                 self onActivation ifNotNil: [ :valuable | 
						                 valuable cull: anObject ] ];
			                 onDeactivation: [ :anObject | 
				                 selectedItems remove: anObject.
				                 self onDeactivation ifNotNil: [ :valuable | 
						                 valuable cull: anObject ] ];
			                 beNotExpandable).
	displayIconBlock ifNotNil: [ 
		column addColumn:
			(SpImageTableColumn evaluated: displayIconBlock) beNotExpandable ].
	column addColumn: (SpStringTableColumn evaluated: self display).

	^ { column }
]

{ #category : #api }
MiFilteringSelectableListPresenter >> onActivation [

	^ onActivation
]

{ #category : #api }
MiFilteringSelectableListPresenter >> onActivation: aBlock [

	onActivation := aBlock
]

{ #category : #accessing }
MiFilteringSelectableListPresenter >> onDeactivation [

	^ onDeactivation
]

{ #category : #accessing }
MiFilteringSelectableListPresenter >> onDeactivation: anObject [

	onDeactivation := anObject
]

{ #category : #private }
MiFilteringSelectableListPresenter >> toggleSelection [

	| selectedItem |
	selectedItem := listPresenter selectedItem.
	(selectedItems includes: selectedItem)
		ifTrue: [ 
			selectedItems remove: selectedItem.
			self onDeactivation ifNotNil: [ :valuable | 
				valuable cull: selectedItem ] ]
		ifFalse: [ 
			selectedItems add: selectedItem.
			self onActivation ifNotNil: [ :valuable | 
				valuable cull: selectedItem ] ].
	listPresenter refresh
]
