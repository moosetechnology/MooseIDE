Extension { #name : #MooseAbstractGroup }

{ #category : #'*Midas-NewTools' }
MooseAbstractGroup >> miNavigationExtension [
	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiAbstractGroupNavigationBrowser on: self
]
