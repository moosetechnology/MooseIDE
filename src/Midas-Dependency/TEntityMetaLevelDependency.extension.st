Extension { #name : #TEntityMetaLevelDependency }

{ #category : #'*Midas-Dependency' }
TEntityMetaLevelDependency >> miTreeExtension [
	<inspectorPresentationOrder: 15 title: 'Tree'>
	^ MiTreeBrowser new
		selectEntity: self;
		yourself
]
