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

{ #category : #'*Midas-NewTools' }
MooseEntity >> miPropertiesExtension [

	<inspectorPresentationOrder: 2 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]
