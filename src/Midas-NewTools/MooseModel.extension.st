Extension { #name : #MooseModel }

{ #category : #'*Midas-NewTools' }
MooseModel >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]
