Extension { #name : #MooseEntity }

{ #category : #'*Midas-NewTools' }
MooseEntity >> miPropertiesExtension [
	<inspectorPresentationOrder: 1 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]
