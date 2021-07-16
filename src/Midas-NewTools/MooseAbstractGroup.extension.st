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
MooseAbstractGroup >> details [
	^ String
		streamContents: [ :s | 
			| typeName |
			typeName := self entities commonSuperclass mooseDescription name.
			s
				print: self size;
				space.
			self
				ifEmpty: [ s << 'entities' ]
				ifNotEmpty: [ s
						<<
							(self size > 1
								ifTrue: [ typeName asEnglishPlural ]
								ifFalse: [ typeName ]) ] ]
]

{ #category : #'*Midas-NewTools' }
MooseAbstractGroup >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiAbstractGroupNavigationBrowser on: self
]
