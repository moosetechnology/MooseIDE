Extension { #name : #MooseEntity }

{ #category : #'*Midas' }
MooseEntity >> isMooseEntity [
	^ true
]

{ #category : #'*Midas' }
MooseEntity >> miFameExtension [
	<inspectorPresentationOrder: 2 title: 'Fame'>
	^ MiFameExtension on: self
]

{ #category : #'*Midas' }
MooseEntity >> miNavigationExtension [
	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiNavigationBrowser on: self
]

{ #category : #'*Midas' }
MooseEntity >> miPropertiesExtension [
	<inspectorPresentationOrder: 1 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]
