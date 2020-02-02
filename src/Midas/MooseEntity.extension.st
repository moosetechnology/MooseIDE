Extension { #name : #MooseEntity }

{ #category : #'*Midas' }
MooseEntity >> mfRawInspectExtension [
	<inspectorPresentationOrder: 0 title: 'Moose Raw'>
	^ MF2RawInspection on: self
]

{ #category : #'*Midas' }
MooseEntity >> miRawInspectExtension [
	<inspectorPresentationOrder: 0 title: 'Moose Raw'>
	^ MiRawInspection on: self
]
