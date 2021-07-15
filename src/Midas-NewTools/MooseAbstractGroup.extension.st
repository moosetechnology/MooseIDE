Extension { #name : #MooseAbstractGroup }

{ #category : #'*Midas-NewTools' }
MooseAbstractGroup >> customNavigationItems [

	| result |
	result := OrderedCollection new.
	self metamodel allImplementingClasses
		select: [ :each | each inheritsFrom: MooseObject ]
		thenDo: [ :each | 
			(self allWithType: each) ifNotEmpty: [ :aGroup | 
				result add: each -> aGroup ] ].
	^ result
]

{ #category : #'*Midas-NewTools' }
MooseAbstractGroup >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiAbstractGroupNavigationBrowser on: self
]
