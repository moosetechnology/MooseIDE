Extension { #name : #TEntityMetaLevelDependency }

{ #category : #'*Midas-Dependency' }
TEntityMetaLevelDependency >> miTreeExtension [
	<inspectorPresentationOrder: -75 title: 'Tree'>
	^ MiTreeBrowser new selectEntity: self
]
