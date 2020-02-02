Extension { #name : #MooseAbstractGroup }

{ #category : #'*Midas' }
MooseAbstractGroup >> miNavigationExtension [
	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiAbstractGroupNavigationBrowser on: self
]
