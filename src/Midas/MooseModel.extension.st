Extension { #name : #MooseModel }

{ #category : #'*Midas' }
MooseModel >> miNavigationExtension [
	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]
