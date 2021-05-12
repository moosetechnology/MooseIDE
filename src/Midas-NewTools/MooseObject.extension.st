Extension { #name : #MooseObject }

{ #category : #'*Midas-NewTools' }
MooseObject >> miFameInspectorExtension [

	<inspectorPresentationOrder: 3 title: 'Fame'>
	^ MiFameExtension on: self
]
