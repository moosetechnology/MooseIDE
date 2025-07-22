Extension { #name : 'FamixTType' }

{ #category : '*MooseIDE-ClassBlueprint' }
FamixTType >> miInspectionBlueprint: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Blueprint'>
	^ self blueprint buildInspectorPresenter: aBuilder
]
