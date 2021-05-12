Extension { #name : #MooseEntity }

{ #category : #'*Midas-NewTools' }
MooseEntity >> miFameExtension [
	<inspectorPresentationOrder: 2 title: 'Fame'>
	^ MiFameExtension on: self
]

{ #category : #'*Midas-NewTools' }
MooseEntity >> miNavigationExtension [
	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiNavigationBrowser on: self
]
