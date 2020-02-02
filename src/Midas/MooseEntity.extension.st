Extension { #name : #MooseEntity }

{ #category : #'*Midas' }
MooseEntity >> miRawInspectExtension [
	<inspectorPresentationOrder: 0 title: 'Moose Properties'>
	^ MiPropertyBrowser on: self
]
