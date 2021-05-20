Extension { #name : #MooseAbstractGroup }

{ #category : #'*Midas-NewTools' }
MooseAbstractGroup >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiAbstractGroupNavigationBrowser on: self
]
