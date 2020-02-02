Extension { #name : #MooseModel }

{ #category : #'*Midas' }
MooseModel >> miNavigationExtension [
	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]
