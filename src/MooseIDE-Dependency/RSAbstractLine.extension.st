Extension { #name : #RSAbstractLine }

{ #category : #'*MooseIDE-Dependency' }
RSAbstractLine >> inspectOnMoose [
	| fromObject toObject list objectToInspect |
	fromObject := self model key. "an HNode"
	toObject := self model value. "an HNode"
	list := fromObject allRawModelDependenciesIn: toObject.
	list ifEmpty: [ self error: '' ].
	objectToInspect := list size = 1
		ifTrue: [ list first ]
		ifFalse: [ list ].
	MiInspectorBrowser inspect: objectToInspect.
]
