Extension { #name : #MooseObject }

{ #category : #'*Midas-NewTools' }
MooseObject >> miPropertiesInspectorExtension [

	<inspectorPresentationOrder: 2 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]
