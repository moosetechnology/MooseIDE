Extension { #name : #MooseObject }

{ #category : #'*Midas-NewTools' }
MooseObject >> miFameInspectorExtension [

	<inspectorPresentationOrder: 3 title: 'Fame'>
	^ MiFameExtension on: self
]

{ #category : #'*Midas-NewTools' }
MooseObject >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiNavigationBrowser on: self
]

{ #category : #'*Midas-NewTools' }
MooseObject >> miPropertiesInspectorExtension [

	<inspectorPresentationOrder: 2 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]
