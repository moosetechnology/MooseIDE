Extension { #name : #TEntityMetaLevelDependency }

{ #category : #'*Midas-Dependency' }
TEntityMetaLevelDependency >> miTreeExtension [
	<inspectorPresentationOrder: 0 title: 'Tree'>
	^ MiTreeBrowser new
		selectEntity: self;
		yourself
]
