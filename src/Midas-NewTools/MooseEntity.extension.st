Extension { #name : #MooseEntity }

{ #category : #'*Midas-NewTools' }
MooseEntity >> miPropertiesExtension [

	<inspectorPresentationOrder: 2 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]
