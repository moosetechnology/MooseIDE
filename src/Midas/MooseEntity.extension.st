Extension { #name : #MooseEntity }

{ #category : #'*Midas' }
MooseEntity >> miRawInspectExtension [
	<inspectorPresentationOrder: 0 title: 'Moose Raw'>
	^ MiRawInspection on: self
]
