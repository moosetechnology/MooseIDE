Extension { #name : #MooseModel }

{ #category : #'*Midas-NewTools' }
MooseModel >> miNavigationExtension [
	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]
