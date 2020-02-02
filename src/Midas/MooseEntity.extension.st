Extension { #name : #MooseEntity }

{ #category : #'*Midas' }
MooseEntity >> miFameExtension [
	<inspectorPresentationOrder: 0 title: 'Fame'>
	^ MiFameBrowser on: self
]

{ #category : #'*Midas' }
MooseEntity >> miNavigationExtension [
	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiNavigationBrowser on: self
]

{ #category : #'*Midas' }
MooseEntity >> miPropertiesExtension [
	<inspectorPresentationOrder: 0 title: 'Moose Properties'>
	^ MiPropertyBrowser on: self
]
