Extension { #name : #FamixTSourceEntity }

{ #category : #'*MooseIDE-NewTools' }
FamixTSourceEntity >> miSourceInspectorExtension [

	<inspectorPresentationOrder: 3 title: 'SourceText'>
	^ MiSourceExtension on: self
]
