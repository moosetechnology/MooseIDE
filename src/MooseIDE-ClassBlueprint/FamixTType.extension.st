Extension { #name : #FamixTType }

{ #category : #'*MooseIDE-ClassBlueprint' }
FamixTType >> miBlueprintInspectorExtension [

	<inspectorPresentationOrder: 10 title: 'Blueprint'>
	^ self blueprint asInspectorPresenter
]
