Extension { #name : 'FamixTSourceEntity' }

{ #category : '*MooseIDE-Famix' }
FamixTSourceEntity >> inspectionSource: aBuilder [

	<inspectorPresentationOrder: 3 title: 'SourceText'>

	| rendererModel rendererView |
	rendererModel := MiSourceTextRendererModel new.

	rendererView := aBuilder instantiate: MiSourceTextSpecRenderer on: rendererModel.

	rendererModel renderTextFor: self.
	^rendererView 
]

{ #category : '*MooseIDE-Famix' }
FamixTSourceEntity >> sourceCodeBoundingEntity [

	^self
]
